bq query --use_legacy_sql=true << "EOF"
SELECT
  *
FROM
[clbridge-analytics:da304_uc2.trade$__PARTITIONS_SUMMARY__]
EOF

bq query --use_legacy_sql=true << "EOF"
SELECT
  *
FROM
[clbridge-analytics:da304_uc2.company$__PARTITIONS_SUMMARY__]
EOF
