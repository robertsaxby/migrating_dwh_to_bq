CREATE OR REPLACE TABLE da304.Catalog_returns(
cr_returned_date_sk INT64,
cr_returned_time_sk INT64,
cr_item_sk INT64,
cr_refunded_customer_sk INT64,
cr_refunded_cdemo_sk INT64, 
cr_refunded_hdemo_sk INT64, 
cr_refunded_addr_sk INT64, 
cr_returning_customer_sk INT64,
cr_returning_cdemo_sk INT64, 
cr_returning_hdemo_sk INT64, 
cr_returning_addr_sk INT64, 
cr_call_center_sk INT64, 
cr_catalog_page_sk INT64,
cr_ship_mode_sk INT64, 
cr_warehouse_sk INT64, 
cr_reason_sk INT64, 
cr_order_number INT64,
cr_return_quantity INT64,
cr_return_amount FLOAT64,
cr_return_tax FLOAT64,
cr_return_amt_inc_tax FLOAT64,
cr_fee FLOAT64,
cr_return_ship_cost FLOAT64,
cr_refunded_cash FLOAT64,
cr_reversed_charge FLOAT64,
cr_store_credit FLOAT64,
cr_net_loss FLOAT64,
d_date DATE,
d_year INT64
)
PARTITION BY d_date
