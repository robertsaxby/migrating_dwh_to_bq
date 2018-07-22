#!/bin/bash
declare -a tables=("Call_center" "Catalog" "Catalog_page" "Catalog_returns" "Catalog_sales" "Customer" "Customer_address" "Customer_demographics" "Date_dim" 
                       "Household_demographics" "Income_band" "Inventory" "Item" "Promotion" "Reason" "Ship_mode" "Store" "Store_returns" "Store_sales" "Time_dim" 
		       "Warehouse" "Web_page" "Web_returns" "Web_sales" "Web_site")
#loop
for table in ${tables[@]}
do
	echo ${table}
	`bq show --schema --format=prettyjson da304.${table} > ${table}.json`
	`bq mkdef --noautodetect --source_format=CSV gs://da304-staging/${table,,}.dat ./schema/${table}.json > schema/${table}_schema`
	`ex -sc '%s/\"fieldDelimiter\": \"\,\"/\"fieldDelimiter\": \"|\"/g|x' schema/${table}_schema`
	echo `bq mk --external_table_definition=./schema/${table}_schema da304_staging.${table}`
done

