bq query --use_legacy_sql=False << "EOF"
update `clbridge-analytics.da304_streaming.trade` set t_comm = 45.07 where t_d_day = "2018-07-09" and t_ca_id=43000000031
EOF

bq query --use_legacy_sql=False << "EOF"
select t_id, t_comm, t_ca_id from `clbridge-analytics.da304_streaming.trade` where t_d_day = "2018-07-09" and t_ca_id=43000000031
EOF
