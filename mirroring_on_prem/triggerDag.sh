
DATE=2018-07-01

for i in {0..22}
do
       NEXT_DATE=$(date +%Y-%m-%d -d "$DATE + $i day")
(`gcloud beta composer environments run da304-composer --location us-central1 variables -- --set job_run_date ${NEXT_DATE}` ; `gcloud beta composer environments run da304-composer \
    --location us-central1 trigger_dag -- da304_temp` )

done
