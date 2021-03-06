CREATE OR REPLACE TABLE da304.Web_returns(
wr_returned_date_sk INT64,
wr_returned_time_sk INT64,
wr_item_sk INT64,
wr_refunded_customer_sk INT64,
wr_refunded_cdemo_sk INT64,
wr_refunded_hdemo_sk INT64,
wr_refunded_addr_sk INT64,
wr_returning_customer_sk INT64,
wr_returning_cdemo_sk INT64,
wr_returning_hdemo_sk INT64,
wr_returning_addr_sk INT64,
wr_web_page_sk INT64,
wr_reason_sk INT64,
wr_order_number INT64,
wr_return_quantity INT64,
wr_return_amt FLOAT64,
wr_return_tax FLOAT64,
wr_return_amt_inc_tax FLOAT64,
wr_fee FLOAT64,
wr_return_ship_cost FLOAT64,
wr_refunded_cash FLOAT64,
wr_reversed_charge FLOAT64,
wr_account_credit FLOAT64,
wr_net_loss FLOAT64,
d_date DATE,
d_year INT64
)
PARTITION BY d_date
