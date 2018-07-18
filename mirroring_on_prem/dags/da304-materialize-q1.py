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
BQ_DATASET_NAME=models.Variable.get('bq_dataset')
job_run_date = models.Variable.get('job_run_date')
bq_channel_sales_table = BQ_DATASET_NAME + '.'+ models.Variable.get('bq_channel_sales_table');
default_dag_args = {
    # The start_date describes when a DAG is valid / can be run. Set this to a
    # fixed point in time rather than dynamically, since it is evaluated every
    # time a DAG is parsed. See:
    # https://airflow.apache.org/faq.html#what-s-the-deal-with-start-date
    'start_date': datetime.datetime(2018, 7, 1),
    'retry_delay': timedelta(minutes=5),
    'schedule_interval': 'None'

}

# Define a DAG (directed acyclic graph) of tasks.
# Any task you create within the context manager is automatically added to the
# DAG object.
#'Call_center','Catalog','Catalog_page','Catalog_returns','Catalog_sales','Customer','Customer_address','Customer_demographics','Date_dim',
#			'Household_demographics','Income_band','Inventory','Item','Promotion','Reason','Ship_mode','Store','Store_returns','Store_sales','Time_dim',
#			'Warehouse','Web_page','Web_returns','Web_sales','Web_site,' ]

with models.DAG(
        'da304_materialize_query',
        default_args=default_dag_args) as dag:
    # [END composer_simple_define_dag]
    # [START composer_simple_operators]
    def greeting():
        print('Starting Load')

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
    materialize_q1 = BigQueryOperator(
        task_id='materialize_channel_sales',
        bql='bq_mat_channel_sales.sql',
        params={"date_start":"{0}".format(job_run_date)},
        use_legacy_sql=False,
        write_disposition='WRITE_TRUNCATE',
        destination_dataset_table=bq_channel_sales_table)
    materialize_q1
    # [END composer_simple_relationships]
# [END composer_simple]
