create table da304_uc2.trade(
      t_id INT64,
      t_dts TIMESTAMP,
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
      st_name STRING,
      tt_name STRING,
      tt_is_sell INT64,
      tt_is_mrkt INT64
      )
      partition by DATE(t_dts)
