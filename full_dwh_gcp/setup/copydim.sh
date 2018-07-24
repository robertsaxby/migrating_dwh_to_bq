#bq mk --dataset clbridge-analytics:da304
#bq mk --dataset clbridge-analytics:da304_staging

DATE=2018-06-01

for i in {0..62}
do
       NEXT_DATE=$(date +%Y-%m-%d -d "$DATE + $i day")
          `gsutil cp gs://da304_staging_uc2/2018-07-18/*.txt  gs://da304_staging_uc2/${NEXT_DATE}`
      done
