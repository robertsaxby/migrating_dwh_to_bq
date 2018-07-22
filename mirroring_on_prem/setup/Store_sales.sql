CREATE OR REPLACE TABLE da304.Store_sales(
ss_sold_date_sk INT64, 
ss_sold_time_sk INT64, 
ss_item_sk INT64, 
ss_customer_sk INT64, 
ss_cdemo_sk INT64, 
ss_hdemo_sk INT64, 
ss_addr_sk INT64, 
ss_store_sk INT64,
ss_promo_sk INT64,
ss_ticket_number INT64,
ss_quantity INT64,
ss_wholesale_cost FLOAT64,
ss_list_price FLOAT64,
ss_sales_price FLOAT64,
ss_ext_discount_amt FLOAT64,
ss_ext_sales_price FLOAT64,
ss_ext_wholesale_cost FLOAT64,
ss_ext_list_price FLOAT64,
ss_ext_tax FLOAT64,
ss_coupon_amt FLOAT64,
ss_net_paid FLOAT64,
ss_net_paid_inc_tax FLOAT64,
ss_net_profit FLOAT64,
d_date DATE,
d_year INT64
)
PARTITION BY d_date

