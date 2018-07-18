--security

  SELECT
  sec.*,
  ex.ex_name,
  ex.ex_num_symb,
  ex.ex_open,
  ex.ex_close,
  ex.ex_desc,
  ex.ad_line1,
  ex.ad_line2,
  ex.ad_ctry,
  ex.zc_town,
  ex.zc_div,
  st.st_name,
  cast('{{params.created_date}}' as date) as created_date
FROM
  `da304_staging_uc2.security` sec,
  
  ( --exchange
  SELECT
    e.*,
    addr.*
  FROM
    `da304_staging_uc2.exchange` e,
    ( --address
    SELECT
      a.*,
      b.zc_town,
      b.zc_div
    FROM
      `da304_staging_uc2.address` a,
      `da304_staging_uc2.zip_code` b
    WHERE
      a.ad_zc_code = b.zc_code) addr
  WHERE
    e.ex_ad_id=ad_id ) ex,
  `da304_staging_uc2.company` co,
  `da304_staging_uc2.status_type` st
WHERE
  sec.s_co_id = co.co_id
  AND sec.s_ex_id = ex.ex_id
  AND sec.s_st_id = st.st_id
