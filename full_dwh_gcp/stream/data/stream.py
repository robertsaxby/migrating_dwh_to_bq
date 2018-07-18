import sys
from time import sleep
from google.cloud import bigquery
from datetime import timedelta
import time
from datetime import date

SCHEMA = [
            bigquery.SchemaField('t_id', 'INT64', mode='REQUIRED'),
            bigquery.SchemaField('t_dts', 'STRING'),
            bigquery.SchemaField('t_st_id', 'STRING'),
            bigquery.SchemaField('t_tt_id', 'STRING'),
            bigquery.SchemaField('t_is_cash', 'INT64'),
            bigquery.SchemaField('t_s_symb', 'STRING'),
            bigquery.SchemaField('t_qty', 'INT64'),
            bigquery.SchemaField('t_bid_price', 'FLOAT64'),
            bigquery.SchemaField('t_ca_id', 'INT64'),
            bigquery.SchemaField('t_exec_name', 'STRING'),
            bigquery.SchemaField('t_trade_price', 'FLOAT64'),
            bigquery.SchemaField('t_chrg', 'FLOAT64'),
            bigquery.SchemaField('t_comm', 'FLOAT64'),
            bigquery.SchemaField('t_tax', 'FLOAT64'),
            bigquery.SchemaField('t_lifo', 'INT64'),
            bigquery.SchemaField('t_d_day', 'DATE')


]
dataset_id = 'da304_streaming'
table_id = 'trade'

def client():
    return bigquery.Client()


def getTable():
    bigquery_client = bigquery.Client()

    # Prepares a reference to the new dataset
    dataset_ref = bigquery_client.dataset(dataset_id)
    table_ref = dataset_ref.table(table_id) 
    table = bigquery_client.get_table(table_ref) 

    return table

def readfile(f,dt):
    table = getTable()
    assert table.table_id == table_id
    one_day = timedelta(days=1)

    while(True):
        file = open(f, "r")
        lines = file.readlines()
	rows_to_insert = []
        rowcount=0
        for line in lines:
            row=line.split("|")
	    row.append(dt)
	    rows_to_insert.append(row)
            
	    if rowcount >= 1000 :
                errors = client().insert_rows(table, rows_to_insert)  # API request
                if errors != []:
                    print (errors[0])
                sleep(5) # Time in seconds.
                rowcount=0
                rows_to_insert=[]

            rowcount+=1
        file.close()
        dt = dt+one_day
        if dt > date.today():
            dt = date.today()



if __name__ == "__main__":
    dt = date.today()
    delta = timedelta(days=7)
    dt = dt-delta
    print(dt)
    readfile(sys.argv[1], dt)
