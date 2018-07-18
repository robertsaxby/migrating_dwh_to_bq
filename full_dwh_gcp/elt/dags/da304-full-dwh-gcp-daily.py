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
# [END composer_simple_operators]

# [START composer_simple_define_dag]
BQ_DATASET_NAME=models.Variable.get('bq_dataset_uc2')
job_run_date = models.Variable.get('job_run_date_uc2')
trade_table = BQ_DATASET_NAME + '.'+ models.Variable.get('bq_trade_table');
broker_table = BQ_DATASET_NAME + '.'+ models.Variable.get('bq_broker_table');
customer_account_table = BQ_DATASET_NAME + '.'+ models.Variable.get('bq_cust_account_table');
security_table  = BQ_DATASET_NAME + '.'+ models.Variable.get('bq_security_table');
company_table = BQ_DATASET_NAME + '.'+ models.Variable.get('bq_company_table');
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

with models.DAG(
        'da304_full_dwh_daily_gcp',
        default_args=default_dag_args,
        catchup=False) as dag:
    # [END composer_simple_define_dag]
    # [START composer_simple_operators]
    def greeting():
        print('Starting ELT ' + Date.today())

    # An instance of an operator is called a task. In this case, the
    # hello_python task calls the "greeting" Python function.
    """
    gcs_to_bq_call_center = GoogleCloudStorageToBigQueryOperator(
      task_id='gcs_to_bq',
      bucket='da304-raw',
      source_objects=['call_center_1*.dat'],
      source_format = 'CSV',
      field_delimiter = '|',
      quote_character = '',
      skip_leading_rows = 1,
      create_disposition = 'CREATE_IF_NEEDED',
      write_disposition = 'WRITE_TRUNCATE',
      destination_project_dataset_table='{0}.Call_center'
      .format(BQ_DATASET_NAME),
      )
      """
    create_security_table= BigQueryOperator(
        task_id='security_elt',
        bql='query/security.sql',
        params={"created_date":"{0}".format(job_run_date)},
        use_legacy_sql=False,
        write_disposition='WRITE_TRUNCATE',
        destination_dataset_table=security_table,
        time_partitioning={"field":"created_date","type":"DAY"})
    
    create_company_table= BigQueryOperator(
        task_id='company_elt',
        bql='query/company.sql',
        params={"created_date":"{0}".format(job_run_date)},
        use_legacy_sql=False,
        write_disposition='WRITE_TRUNCATE',
        destination_dataset_table=company_table,
        time_partitioning={"field":"created_date","type":"DAY"})

    create_broker_table= BigQueryOperator(
        task_id='broker_elt',
        bql='query/broker.sql',
        params={"created_date":"{0}".format(job_run_date)},
        use_legacy_sql=False,
        write_disposition='WRITE_TRUNCATE',
        destination_dataset_table=broker_table,
        time_partitioning={"field":"created_date","type":"DAY"})
    
    create_customer_account_table= BigQueryOperator(
        task_id='customer_account_elt',
        bql='query/customer_account.sql',
        params={"created_date":"{0}".format(job_run_date)},
        use_legacy_sql=False,
        write_disposition='WRITE_TRUNCATE',
        destination_dataset_table=customer_account_table,
        time_partitioning={"field":"created_date","type":"DAY"})

    create_security_table= BigQueryOperator(
        task_id='trade_elt',
        bql='query/trade.sql',
        params={"created_date":"{0}".format(job_run_date)},
        use_legacy_sql=False,
        write_disposition='WRITE_TRUNCATE',
        destination_dataset_table=trade_table,
        time_partitioning={"field":"created_date", "type":"DAY"})

    # [END composer_simple_relationships]
# [END composer_simple]
