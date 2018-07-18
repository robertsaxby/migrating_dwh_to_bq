-- customer_account
SELECT
  ca. ca_id,
  ca. ca_b_id,
  ca. ca_name,
  ca. ca_tax_st,
  ca. ca_bal, 
  cu. c_tax_id,
  cu. c_l_name,
  cu. c_f_name,
  cu. c_m_name,
  cu. c_gndr,
  cu. c_tier,
  cu. c_dob,
  cu. c_ctry_1,
  cu. c_area_1,
  cu. c_local_1,
  cu. c_ext_1,
  cu. c_ctry_2,
  cu. c_area_2,
  cu. c_local_2,
  cu. c_ext_2,
  cu. c_ctry_3,
  cu. c_local_3,
  cu. c_ext_3,
  cu. c_email_1,
  cu. c_email_2,
  cu. ad_line1,
  cu. ad_line2,
  cu. ad_ctry,
  cu. zc_town,
  cu. zc_div,
  cu.st_name,
  cast('{{params.created_date}}' as date) as created_date
FROM
  `da304_staging_uc2.customer_account` ca,
  (
  SELECT
    cu.*,
    addr.*,
    st.st_name
  FROM
    `da304_staging_uc2.customer` cu,
    ( --address
    SELECT
      a.*,
      b.zc_town,
      b.zc_div
    FROM
      `da304_staging_uc2.address` a,
      `da304_staging_uc2.zip_code` b
    WHERE
      a.ad_zc_code = b.zc_code) addr,
    `da304_staging_uc2.status_type` st
  WHERE
    cu.c_ad_id = addr.ad_id
    AND cu.c_st_id = st.st_id ) cu
WHERE
  ca.ca_c_id = cu.c_id
