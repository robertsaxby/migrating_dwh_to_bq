#!/bin/bash
bq query --use_legacy_sql=False << "EOF"
SELECT t_ca_id , t_comm FROM `clbridge-analytics.da304_streaming.trade`
where t_d_day= "2018-07-09" and t_ca_id=43000000031
EOF
