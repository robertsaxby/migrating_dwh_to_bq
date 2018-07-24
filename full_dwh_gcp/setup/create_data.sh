#!/bin/bash
DATE=2018-06-01
table=${1}
for i in {0..62}
do
           NEXT_DATE=$(date +%Y-%m-%d -d "$DATE + $i day")
           bq query --use_legacy_sql=false  "DROP TABLE IF EXISTS tobedeleted_uc2.${table}_${i}"

bq query --q --destination_table tobedeleted_uc2.${table}_${i} --use_legacy_sql=false --parameter=FTIMESTAMP:DATE:"${NEXT_DATE}" << EOF
SELECT * FROM tobedeleted_uc2.trade2018 WHERE date(t_dts) = @FTIMESTAMP
EOF
bq extract --destination_format=CSV --field_delimiter='|'  tobedeleted_uc2.${table}_${i} gs://da304_staging_uc2/facts/${NEXT_DATE}/${table}.txt
done
