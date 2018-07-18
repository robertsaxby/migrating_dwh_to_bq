bq query --use_legacy_sql=true << "EOF"
SELECT
  *
FROM
[clbridge-analytics:da304_streaming.trade$__PARTITIONS_SUMMARY__]
EOF
