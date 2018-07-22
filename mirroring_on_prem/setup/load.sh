#!/bin/bash
declare -a tables=("Catalog_returns" "Catalog_sales" "Store_returns" "Store_sales" "Web_returns" "Web_sales" )
#loop
DATE=2018-06-01
for table in ${tables[@]}
do
    uris='gs://da304-staging/${NEXT_DATE}/${table}.csv'
    for i in {1..62}
    do
       NEXT_DATE=$(date +%Y-%m-%d -d "$DATE + $i day")
#	`bq show --schema --format=prettyjson da304.${table} > ${table}.json`
        uris+=",gs://da304-staging/${NEXT_DATE}/${table}.csv"
    done
    echo ${uris}
        `bq mkdef --noautodetect --source_format=CSV ${uris} ./schema/${table}.json > schema/${table}_schema`
	`ex -sc '%s/\"fieldDelimiter\": \"\,\"/\"fieldDelimiter\": \"|\"/g|x' schema/${table}_schema`
	`ex -sc '%s/\"skipLeadingRows\": 0/\"skipLeadingRows\": 1/g|x' schema/${table}_schema`
        echo `bq mk --external_table_definition=./schema/${table}_schema da304_staging.${table}`
    
done

