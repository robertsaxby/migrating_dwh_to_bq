select s.* from `da304_staging.Web_returns` s where s.d_date= cast('{{params.partition_date}}' as date)
