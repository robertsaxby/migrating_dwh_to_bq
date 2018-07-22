"""An example DAG demonstrating simple Apache Airflow operators."""

# [START composer_simple]
from __future__ import print_function

# [START composer_simple_define_dag]
import datetime
import random

from airflow import models
# [END composer_simple_define_dag]
# [START composer_simple_operators]
from airflow.operators import bash_operator
from airflow.operators import python_operator
from airflow.operators.dummy_operator import DummyOperator
from datetime import timedelta
from airflow.contrib.operators.bigquery_operator import BigQueryOperator
from airflow.contrib.operators.gcs_to_bq import GoogleCloudStorageToBigQueryOperator
from airflow.operators.bash_operator import BashOperator
# [END composer_simple_operators]

# [START composer_simple_define_dag]
BQ_DATASET_NAME=models.Variable.get('bq_dataset')
BQ_STAGING_DATASET_NAME=models.Variable.get('bq_dataset_uc1_staging')
job_run_date = models.Variable.get('job_run_date')
loadDimension = models.Variable.get('load_dimension')
bq_channel_sales_table = '{0}.{1}${2}'.format(BQ_DATASET_NAME,models.Variable.get('bq_channel_sales_table'),job_run_date.replace('-',''))
default_dag_args = {
    # The start_date describes when a DAG is valid / can be run. Set this to a
    # fixed point in time rather than dynamically, since it is evaluated every
    # time a DAG is parsed. See:
    # https://airflow.apache.org/faq.html#what-s-the-deal-with-start-date
    'start_date': datetime.datetime(2018, 7, 30),
    'retry_delay': timedelta(minutes=5),
    'schedule_interval': 'None'

}

# Define a DAG (directed acyclic graph) of tasks.
# Any task you create within the context manager is automatically added to the
# DAG object.
#'Call_center','Catalog','Catalog_page','Catalog_returns','Catalog_sales','Customer','Customer_address','Customer_demographics','Date_dim',
#			'Household_demographics','Income_band','Inventory','Item','Promotion','Reason','Ship_mode','Store','Store_returns','Store_sales','Time_dim',
#			'Warehouse','Web_page','Web_returns','Web_sales','Web_site,' ]

tables=['Date_dim','Store_sales','Store_returns','Store','Catalog_sales','Catalog_returns','Catalog_page','Web_sales','Web_site','Web_returns' ] 
#tables=['account_permission']

dag_daily = models.DAG(
               'da304_materialize_tables',
               default_args=default_dag_args,
               catchup=False)

def deleteStagingTablesTask(table):
    return BigQueryOperator(
            task_id='delete_{0}'.format(table),
            bql = '''
                DROP TABLE IF EXISTS {{params.table}}
            ''',
            params={"table":"{0}.{1}".format(BQ_STAGING_DATASET_NAME,table)},
            use_legacy_sql=False,
            dag=dag_daily)


def createDimensionStagingDagTasks() :
    def createTaskHelper(table):
        
            return GoogleCloudStorageToBigQueryOperator(
                task_id = 'create_staging_{0}'.format(table),
                field_delimiter = '|',
                schema_object = 'schema/{0}.json'.format(table),
                source_objects = ['{0}/{1}.dat'.format('dimension',table.lower())],
                bucket = 'da304-staging',
                destination_project_dataset_table = "{0}.{1}".format(BQ_STAGING_DATASET_NAME,table),
                external_table = True,
                dag=dag_daily)

    complete_dim_stage= DummyOperator(
                        task_id="Complete_dim_staging",
                        dag=dag_daily)
     
    tables=['Store','Catalog_page','Date_dim','Web_site']
    for table in tables:
            deleteStagingTablesTask(table) >> createTaskHelper(table) >> materializeDimensionTables(table) >> complete_dim_stage

    return complete_dim_stage



def createFactStagingTables():
    def createTaskHelper(table):
           return GoogleCloudStorageToBigQueryOperator(
                task_id = 'create_staging_{0}'.format(table),
                skip_leading_rows=1,
                field_delimiter = '|',
                schema_object = 'schema/{0}.json'.format(table),
                source_objects = ['{0}/{1}.csv'.format(job_run_date,table)],
                bucket = 'da304-staging',
                destination_project_dataset_table = "{0}.{1}".format(BQ_STAGING_DATASET_NAME,table),
                external_table = True,
                dag=dag_daily)

    tables=['Store_sales','Store_returns','Catalog_sales','Catalog_returns','Web_sales','Web_returns' ]
    complete_fact_stage= DummyOperator(
                        task_id="Complete_Fact_Staging",
                        dag=dag_daily)

    for table in tables:
            deleteStagingTablesTask(table) >> createTaskHelper(table) >> materializeFactTables(table) >> complete_fact_stage

    return complete_fact_stage


def materializeDimensionTables(table):
    def createTaskHelper(table):
            return BigQueryOperator(
                task_id='materialize__{0}'.format(table),
                bql='{0}.sql'.format(table),
                use_legacy_sql=False,
                write_disposition="WRITE_TRUNCATE",
                destination_dataset_table='{0}.{1}'.format(BQ_DATASET_NAME,table),
                dag=dag_daily)

    return createTaskHelper(table) 





def materializeFactTables(table):
    def createTaskHelper(table):
            return BigQueryOperator(
                task_id='materialize_{0}'.format(table),
                bql='{0}.sql'.format(table),
                params={"partition_date":"{0}".format(job_run_date)},
                use_legacy_sql=False,
                write_disposition="WRITE_TRUNCATE",
                destination_dataset_table='{0}.{1}${2}'.format(BQ_DATASET_NAME,table,job_run_date.replace('-','')),
                dag=dag_daily)

    return createTaskHelper(table)



materialize_q1 = BigQueryOperator(
        task_id='calculate_sales_by_channel',
        bql='bq_mat_channel_sales.sql',
        params={"date_start":"{0}".format(job_run_date)},
        use_legacy_sql=False,
        write_disposition='WRITE_TRUNCATE',
        destination_dataset_table=bq_channel_sales_table,
        dag=dag_daily)

if loadDimension == 'yes': 
    createDimensionStagingDagTasks() >> createFactStagingTables() >> materialize_q1
else:
    createFactStagingTables() >> materialize_q1
