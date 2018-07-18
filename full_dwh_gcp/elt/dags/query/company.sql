 --company
SELECT
  co.co_id,
  co.co_name,
  co.co_sp_rate,
  co.co_ceo,
  co.co_desc,
  co.co_open_date,
  ind.in_name,
  ind.sc_name,
  st.st_name,
  addr.ad_line1,
  addr.ad_line2,
  addr.zc_town,
  addr.zc_div,
  addr.ad_ctry,
  cast('{{params.created_date}}' as date) as created_date
FROM
  `da304_staging_uc2.company` co,
  --industry
  (
  SELECT
    ind.*,
    sc.*
  FROM
    `da304_staging_uc2.industry` ind,
    `da304_staging_uc2.sector` sc
  WHERE
    ind.in_sc_id=sc.sc_id ) ind,
  `da304_staging_uc2.status_type` st,
  (
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
  co.co_ad_id = addr.ad_id AND
  co.co_in_id = ind.in_id AND
  co.co_st_id = st.st_id
