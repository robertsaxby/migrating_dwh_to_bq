bq query --use_legacy_sql=false '
CREATE or REPLACE TABLE da304_streaming.trade (
  t_id INT64,
  t_dts STRING,
  t_st_id STRING,
  t_tt_id STRING,
  t_is_cash INT64,
  t_s_symb STRING, 
  t_qty INT64,
  t_bid_price FLOAT64,
  t_ca_id INT64,
  t_exec_name STRING,
  t_trade_price FLOAT64,
  t_chrg FLOAT64,
  t_comm FLOAT64,
  t_tax FLOAT64,
  t_lifo INT64,
  t_d_day DATE
      ) 
PARTITION BY t_d_day '
