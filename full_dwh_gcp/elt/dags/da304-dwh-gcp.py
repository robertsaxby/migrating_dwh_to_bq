"""An example DAG demonstrating simple Apache Airflow operators."""

# [START composer_simple]
from __future__ import print_function

# [START composer_simple_define_dag]
import datetime

from airflow import models
# [END composer_simple_define_dag]
# [START composer_simple_operators]
from airflow.operators import bash_operator
from airflow.operators import python_operator
from datetime import timedelta
from airflow.contrib.operators.bigquery_operator import BigQueryOperator
from airflow.contrib.operators.gcs_to_bq import GoogleCloudStorageToBigQueryOperator
from airflow.operators.bash_operator import BashOperator
from airflow.operators.dummy_operator import DummyOperator
# [END composer_simple_operators]

# [START composer_simple_define_dag]
BQ_DATASET_NAME=models.Variable.get('bq_dataset_uc2')
BQ_DATASET_NAME_STAGING = models.Variable.get('bq_dataset_uc2_staging')
partition_date = models.Variable.get('partition_date')

trade_table = '{0}.{1}${2}'.format(BQ_DATASET_NAME,  models.Variable.get('bq_trade_table'),partition_date.replace('-',''))
broker_table = '{0}.{1}${2}'.format(BQ_DATASET_NAME, models.Variable.get('bq_broker_table'),partition_date.replace('-',''))
customer_account_table = '{0}.{1}${2}'.format(BQ_DATASET_NAME, models.Variable.get('bq_cust_account_table'),partition_date.replace('-',''))
security_table  = '{0}.{1}${2}'.format(BQ_DATASET_NAME,models.Variable.get('bq_security_table'),partition_date.replace('-',''))
company_table = '{0}.{1}${2}'.format(BQ_DATASET_NAME,models.Variable.get('bq_company_table'),partition_date.replace('-',''))
default_dag_args = {
    # The start_date describes when a DAG is valid / can be run. Set this to a
    # fixed point in time rather than dynamically, since it is evaluated every
    # time a DAG is parsed. See:
    # https://airflow.apache.org/faq.html#what-s-the-deal-with-start-date
    'start_date': datetime.datetime(2018, 7, 17),
    'retry_delay': timedelta(minutes=5),
    'schedule_interval' : 'None'

}

# Define a DAG (directed acyclic graph) of tasks.
# Any task you create within the context manager is automatically added to the
# DAG object.
#tables=['account_permission','address','broker','cash_transaction','charge','commission_rate','company','company_competitor','customer','customer_account','customer_taxrate','daily_market','exchange','financial','holding','holding_history','holding_summary','industry','last_trade','news_item','news_xref','sector','security','settlement','status_type','taxrate','trade','trade_history','trade_request','trade_type','watch_item','watch_list','zip_code']

tables=['customer_account','security','status_type','trade_type','broker','customer','address','company','exchange','industry','sector','zip_code' ]
#tables=['account_permission']

dag_daily = models.DAG(
              'da304_dwh_gcp',
               default_args=default_dag_args,
               catchup=False)

def deleteStagingTablesTask(table):
    return BigQueryOperator(
            task_id='delete_{0}'.format(table),
            bql = '''
                DROP TABLE IF EXISTS {{params.table}}
            ''',
            params={"table":"{0}.{1}".format(BQ_DATASET_NAME_STAGING,table)},
            use_legacy_sql=False,
            dag=dag_daily)

def createStagingDagTasks(table) :
     return GoogleCloudStorageToBigQueryOperator(
            task_id = 'create_staging_{0}'.format(table),
            skip_leading_rows= 1 if table =='trade' else 0,
            field_delimiter = '|',
            schema_object = 'schema/{0}.json'.format(table),
            source_objects = ['{0}/{1}/{2}.txt'.format('facts' if table=='trade' else 'dimension',partition_date,table)],
            bucket = 'da304_staging_uc2',
            destination_project_dataset_table = BQ_DATASET_NAME_STAGING + '.' + table,
            external_table = True,
            dag=dag_daily)


create_security_table= BigQueryOperator(
        task_id='security_elt',
        bql='query/security.sql',
        params={"created_date":"{0}".format(partition_date)},
        use_legacy_sql=False,
        write_disposition='WRITE_TRUNCATE',
        destination_dataset_table=security_table,
        dag=dag_daily)
    
create_company_table= BigQueryOperator(
        task_id='company_elt',
        bql='query/company.sql',
        params={"created_date":"{0}".format(partition_date)},
        use_legacy_sql=False,
        write_disposition='WRITE_TRUNCATE',
        destination_dataset_table=company_table,
        dag=dag_daily)

create_broker_table= BigQueryOperator(
        task_id='broker_elt',
        bql='query/broker.sql',
        params={"created_date":"{0}".format(partition_date)},
        use_legacy_sql=False,
        write_disposition='WRITE_TRUNCATE',
        destination_dataset_table=broker_table,
        dag=dag_daily)
    
create_customer_account_table= BigQueryOperator(
        task_id='customer_account_elt',
        bql='query/customer_account.sql',
        params={"created_date":"{0}".format(partition_date)},
        use_legacy_sql=False,
        write_disposition='WRITE_TRUNCATE',
        destination_dataset_table=customer_account_table,
        dag=dag_daily)

create_trade_table = BigQueryOperator(
        task_id='trade_elt',
        bql='query/trade.sql',
        params={"created_date":"{0}".format(partition_date)},
        use_legacy_sql=False,
        write_disposition='WRITE_TRUNCATE',
        destination_dataset_table=trade_table,
        dag=dag_daily)

complete = DummyOperator(
               task_id="complete_materialization",
               dag=dag_daily)

complete_dim = DummyOperator(
               task_id="complete_dim_staging",
               dag=dag_daily)
complete_dim_mat = DummyOperator(
               task_id="complete_dim_materialization",
               dag=dag_daily)
              
for table in tables:
        deleteStagingTablesTask(table) >> createStagingDagTasks(table) >> complete_dim

complete_dim >> create_security_table >> complete_dim_mat
complete_dim >> create_broker_table >> complete_dim_mat
complete_dim >> create_customer_account_table >> complete_dim_mat
complete_dim >> create_company_table >>complete_dim_mat

complete_dim_mat >> deleteStagingTablesTask('trade') >> createStagingDagTasks('trade') >> create_trade_table >> complete

    # [END composer_simple_relationships]
# [END composer_simple]
