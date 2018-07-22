files=`ls *.sql`
for f in ${files}
do
    bq query --nouse_legacy_sql "`cat ${f}`"
done
