#!/bin/bash
declare -a tables=('Store_sales' 'Web_sales' 'Catalog_sales' 'Store_returns' 'Catalog_returns' 'Web_returns')

DATE=2018-06-01
table=${1}
for i in {0..62}
do
           NEXT_DATE=$(date +%Y-%m-%d -d "$DATE + $i day")

bq query --q --destination_table tobedeleted.${table}_${i} --use_legacy_sql=false --parameter=FTIMESTAMP:DATE:"${NEXT_DATE}" << EOF
SELECT * FROM da304.${table} WHERE d_date = @FTIMESTAMP
EOF
bq extract --destination_format=CSV --field_delimiter='|'  tobedeleted.${table}_${i} gs://da304-staging/${NEXT_DATE}/${table}.csv
done
