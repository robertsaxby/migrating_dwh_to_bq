echo " Rollback data in BQ snapshot "
#1
bq query --use_legacy_sql=False << "EOF"
SELECT t_comm, t_s_symb FROM  `clbridge-analytics.da304_streaming.trade`
FOR SYSTEM TIME AS OF 
TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 40 MINUTE)
WHERE  t_d_day = "2018-07-09" AND t_ca_id=43000000031
EOF

read -p " Updating errorneous rows from BQ snapshot .. Press any key to continue... " -n1 -s

#2
bq query --use_legacy_sql=False \
    --destination_table clbridge-analytics:da304_streaming.trade_snapshot \
    --replace  << "EOF"
      SELECT t_id, t_comm
      FROM `clbridge-analytics.da304_streaming.trade` FOR SYSTEM TIME AS OF TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 40 MINUTE)
      WHERE
      t_d_day = "2018-07-09" AND t_ca_id=43000000031
EOF
if [ $? = 0 ]; then
    bq query --nouse_legacy_sql << "EOF"
    UPDATE
      `clbridge-analytics.da304_streaming.trade` a
      SET
        t_comm = b.t_comm
      FROM
      `clbridge-analytics.da304_streaming.trade_snapshot` b
        WHERE a.t_id=b.t_id and a.t_d_day = DATE("2018-07-09")
EOF
else
    echo " update failed .. terminating"
    exit 1
fi


read -p " After the update.  Press any key to continue... " -n1 -s

#3
bq query --use_legacy_sql=False << "EOF"
SELECT t_id, t_comm, t_s_symb FROM  `clbridge-analytics.da304_streaming.trade`
WHERE t_d_day = "2018-07-09" AND t_ca_id=43000000031
EOF

read -p " Now for the correct update. Press any key to continue... " -n1 -s

#4

bq query --use_legacy_sql=False << "EOF"
UPDATE `clbridge-analytics.da304_streaming.trade`
SET t_comm = 45.07
WHERE t_d_day = "2018-07-09" AND t_ca_id=43000000031 AND t_s_symb="ANDW"
EOF


#5
bq query --use_legacy_sql=False << "EOF"
SELECT t_comm, t_s_symb, t_ca_id FROM  `clbridge-analytics.da304_streaming.trade`
WHERE t_d_day = "2018-07-09" AND t_ca_id=43000000031 AND t_s_symb="ANDW"
EOF

