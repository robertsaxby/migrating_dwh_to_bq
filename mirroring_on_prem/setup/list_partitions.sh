bq query --use_legacy_sql=true << "EOF"
SELECT * FROM [clbridge-analytics:da304.Store_sales$__PARTITIONS_SUMMARY__]
EOF
bq query --use_legacy_sql=true << "EOF"
SELECT * FROM [clbridge-analytics:da304.Store_returns$__PARTITIONS_SUMMARY__]
EOF
bq query --use_legacy_sql=true << "EOF"
SELECT * FROM [clbridge-analytics:da304.Catalog_sales$__PARTITIONS_SUMMARY__]
EOF
bq query --use_legacy_sql=true << "EOF"
SELECT * FROM [clbridge-analytics:da304.Catalog_returns$__PARTITIONS_SUMMARY__]
EOF
bq query --use_legacy_sql=true << "EOF"
SELECT * FROM [clbridge-analytics:da304.Web_sales$__PARTITIONS_SUMMARY__]
EOF
bq query --use_legacy_sql=true << "EOF"
SELECT * FROM [clbridge-analytics:da304.Web_returns$__PARTITIONS_SUMMARY__]
EOF
