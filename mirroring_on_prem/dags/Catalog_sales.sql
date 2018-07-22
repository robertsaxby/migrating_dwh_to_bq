select s.* from `da304_staging.Catalog_sales` s where s.d_date= cast('{{params.partition_date}}' as date)
