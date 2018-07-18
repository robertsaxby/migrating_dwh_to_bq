bq mk --dataset clbridge-analytics:da304_uc2

bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.account_permission (
  ap_ca_id INT64 NOT NULL,
  ap_acl STRING NOT NULL,
  ap_tax_id STRING NOT NULL,
  ap_l_name STRING NOT NULL,
  ap_f_name STRING NOT NULL
  
)'


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.customer (
  c_id INT64 NOT NULL,
  c_tax_id STRING NOT NULL,
  c_st_id STRING NOT NULL,
  c_l_name STRING NOT NULL,
  c_f_name STRING NOT NULL,
  c_m_name STRING,
  c_gndr STRING,
  c_tier INT64 NOT NULL,
  c_dob DATE NOT NULL,
  c_ad_id INT64 NOT NULL,
  c_ctry_1 STRING,
  c_area_1 STRING,
  c_local_1 STRING,
  c_ext_1 STRING,
  c_ctry_2 STRING,
  c_area_2 STRING,
  c_local_2 STRING,
  c_ext_2 STRING,
  c_ctry_3 STRING,
  c_area_3 STRING,
  c_local_3 STRING,
  c_ext_3 STRING,
  c_email_1 STRING,
  c_email_2 STRING
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.customer_account (
  ca_id INT64 NOT NULL,
  ca_b_id INT64 NOT NULL,
  ca_c_id INT64 NOT NULL,
  ca_name STRING,
  ca_tax_st INT64 NOT NULL,
  ca_bal FLOAT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.customer_taxrate (
  cx_tx_id STRING NOT NULL,
  cx_c_id INT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.holding (
  h_t_id INT64 NOT NULL,
  h_ca_id INT64 NOT NULL,
  h_s_symb INT64 NOT NULL,
  h_dts DATETIME NOT NULL,
  h_price FLOAT64 NOT NULL,
  h_qty INT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.holding_history (
  hh_h_t_id INT64 NOT NULL,
  hh_t_id INT64 NOT NULL,
  hh_before_qty INT64 NOT NULL,
  hh_after_qty INT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.holding_summary (
  hs_ca_id INT64 NOT NULL,
  hs_s_symb INT64 NOT NULL,
  hs_qty INT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.watch_item (
  wi_wl_id INT64 NOT NULL,
  wi_s_symb INT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.watch_list (
  wl_id INT64 NOT NULL,
  wl_c_id INT64 NOT NULL
  
)' 





bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.broker (
  b_id INT64 NOT NULL,
  b_st_id STRING NOT NULL,
  b_name STRING NOT NULL,
  b_num_trades INT64 NOT NULL,
  b_comm_total FLOAT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.cash_transaction (
  ct_t_id INT64 NOT NULL,
  ct_dts DATETIME NOT NULL,
  ct_amt FLOAT64 NOT NULL,
  ct_name STRING
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.charge (
  ch_tt_id STRING NOT NULL,
  ch_c_tier INT64 NOT NULL,
  ch_chrg FLOAT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.commission_rate (
  cr_c_tier INT64 NOT NULL,
  cr_tt_id STRING NOT NULL,
  cr_ex_id STRING NOT NULL,
  cr_from_qty INT64 NOT NULL,
  cr_to_qty INT64 NOT NULL,
  cr_rate FLOAT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.settlement (
  se_t_id INT64 NOT NULL,
  se_cash_type STRING NOT NULL,
  se_cash_due_date DATE NOT NULL,
  se_amt FLOAT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.trade (
  t_id INT64 NOT NULL,
  t_dts DATETIME NOT NULL,
  t_st_id STRING NOT NULL,
  t_tt_id STRING NOT NULL,
  t_is_cash INT64 NOT NULL,
  t_s_symb INT64 NOT NULL,
  t_qty INT64 NOT NULL,
  t_bid_price FLOAT64 NOT NULL,
  t_ca_id INT64 NOT NULL,
  t_exec_name STRING NOT NULL,
  t_trade_price FLOAT64,
  t_chrg FLOAT64 NOT NULL,
  t_comm FLOAT64 NOT NULL,
  t_tax FLOAT64 NOT NULL,
  t_lifo INT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.trade_history (
  th_t_id INT64 NOT NULL,
  th_dts DATETIME NOT NULL,
  th_st_id STRING NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.trade_request (
  tr_t_id INT64 NOT NULL,
  tr_tt_id STRING NOT NULL,
  tr_s_symb INT64 NOT NULL,
  tr_qty INT64 NOT NULL,
  tr_bid_price FLOAT64 NOT NULL,
  tr_b_id INT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.trade_type (
  tt_id STRING NOT NULL,
  tt_name STRING NOT NULL,
  tt_is_sell INT64 NOT NULL,
  tt_is_mrkt INT64 NOT NULL
  
)' 






bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.company (
  co_id INT64 NOT NULL,
  co_st_id STRING NOT NULL,
  co_name STRING NOT NULL,
  co_in_id STRING NOT NULL,
  co_sp_rate STRING NOT NULL,
  co_ceo STRING NOT NULL,
  co_ad_id INT64 NOT NULL,
  co_desc STRING NOT NULL,
  co_open_date DATE NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.company_competitor (
  cp_co_id INT64 NOT NULL,
  cp_comp_co_id INT64 NOT NULL,
  cp_in_id STRING NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.daily_market (
  dm_date DATE NOT NULL,
  dm_s_symb INT64 NOT NULL,
  dm_close FLOAT64 NOT NULL,
  dm_high FLOAT64 NOT NULL,
  dm_low FLOAT64 NOT NULL,
  dm_vol INT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.exchange (
  ex_id STRING NOT NULL,
  ex_name STRING NOT NULL,
  ex_num_symb INT64 NOT NULL,
  ex_open INT64 NOT NULL,
  ex_close INT64 NOT NULL,
  ex_desc STRING,
  ex_ad_id INT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.financial (
  fi_co_id INT64 NOT NULL,
  fi_year INT64 NOT NULL,
  fi_qtr INT64 NOT NULL,
  fi_qtr_start_date DATE NOT NULL,
  fi_revenue FLOAT64 NOT NULL,
  fi_net_earn FLOAT64 NOT NULL,
  fi_basic_eps FLOAT64 NOT NULL,
  fi_dilut_eps FLOAT64 NOT NULL,
  fi_margin FLOAT64 NOT NULL,
  fi_inventory FLOAT64 NOT NULL,
  fi_assets FLOAT64 NOT NULL,
  fi_liability FLOAT64 NOT NULL,
  fi_out_basic INT64 NOT NULL,
  fi_out_dilut INT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.industry (
  in_id STRING NOT NULL,
  in_name STRING NOT NULL,
  in_sc_id STRING NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.last_trade (
  lt_s_symb INT64 NOT NULL,
  lt_dts DATETIME NOT NULL,
  lt_price FLOAT64 NOT NULL,
  lt_open_price FLOAT64 NOT NULL,
  lt_vol INT64 NOT NULL
  
)' 






bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.news_item (
  ni_id INT64 NOT NULL,
  ni_headline STRING NOT NULL,
  ni_summary STRING NOT NULL,
  ni_item STRING NOT NULL,
  ni_dts DATETIME NOT NULL,
  ni_source STRING NOT NULL,
  ni_author STRING
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.news_xref (
  nx_ni_id INT64 NOT NULL,
  nx_co_id INT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.sector (
  sc_id STRING NOT NULL,
  sc_name STRING NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.security (
  s_symb STRING NOT NULL,
  s_issue STRING NOT NULL,
  s_st_id STRING NOT NULL,
  s_name STRING NOT NULL,
  s_ex_id STRING NOT NULL,
  s_co_id INT64 NOT NULL,
  s_num_out INT64 NOT NULL,
  s_start_date DATE NOT NULL,
  s_exch_date DATE NOT NULL,
  s_pe FLOAT64 NOT NULL,
  s_52wk_high FLOAT64 NOT NULL,
  s_52wk_high_date DATE NOT NULL,
  s_52wk_low FLOAT64 NOT NULL,
  s_52wk_low_date DATE NOT NULL,
  s_dividend FLOAT64 NOT NULL,
  s_yield FLOAT64 NOT NULL
  
)' 






bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.address (
  ad_id INT64 NOT NULL,
  ad_line1 STRING,
  ad_line2 STRING,
  ad_zc_code STRING NOT NULL,
  ad_ctry STRING
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.status_type (
  st_id STRING NOT NULL,
  st_name INT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.taxrate (
  tx_id STRING NOT NULL,
  tx_name STRING NOT NULL,
  tx_rate FLOAT64 NOT NULL
  
)' 


bq query --nouse_legacy_sql ' 
 CREATE OR REPLACE TABLE da304_uc2.zip_code (
  zc_code STRING NOT NULL,
  zc_town STRING NOT NULL,
  zc_div STRING NOT NULL
  
)' 

