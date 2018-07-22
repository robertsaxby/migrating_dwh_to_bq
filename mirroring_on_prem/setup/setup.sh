#bq mk --dataset clbridge-analytics:da304
#bq mk --dataset clbridge-analytics:da304_staging

DATE=2018-06-01

for i in {0..62}
do
       NEXT_DATE=$(date +%Y-%m-%d -d "$DATE + $i day")
          echo "$NEXT_DATE"
          `mkdir /tmp/${NEXT_DATE}`
          `touch /tmp/${NEXT_DATE}/.tmp`
          `gsutil cp -R /tmp/${NEXT_DATE} gs://da304-staging`
      done
