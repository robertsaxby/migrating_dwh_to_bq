  -- Trade

  SELECT
  t_id,
  t_dts,
  t_is_cash,
  t_s_symb,
  t_qty,
  t_bid_price,
  t_ca_id,
  t_exec_name,
  t_trade_price,
  t_chrg,
  t_comm,
  t_tax,
  t_lifo,
  st.st_name,
  tt.tt_name,
  tt.tt_is_sell,
  tt.tt_is_mrkt,
  cast('{{params.created_date}}' as date) as created_date
FROM
  `da304_staging_uc2.trade`
left join   `da304_staging_uc2.status_type` st on  t_st_id = st.st_id
left join   `da304_staging_uc2.trade_type` tt on t_tt_id = tt.tt_id
  
