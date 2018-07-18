--Broker

  SELECT
  br.b_id,
  br.b_name,
  br.b_num_trades,
  br.b_comm_total,
  st.st_name,
  cast('{{params.created_date}}' as date) as created_date
FROM
  `da304_staging_uc2.broker` br,
  `da304_staging_uc2.status_type` st
WHERE
  br.b_st_id = st.st_id
