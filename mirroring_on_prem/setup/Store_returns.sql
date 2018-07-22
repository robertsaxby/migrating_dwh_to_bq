CREATE OR REPLACE TABLE da304.Store_returns(
sr_returned_date_sk INT64,
sr_return_time_sk INT64,
sr_item_sk INT64,
sr_customer_sk INT64,
sr_cdemo_sk INT64,
sr_hdemo_sk INT64,
sr_addr_sk INT64,
sr_store_sk INT64,
sr_reason_sk INT64,
sr_ticket_number INT64,
sr_return_quantity INT64,
sr_return_amt FLOAT64,
sr_return_tax FLOAT64,
sr_return_amt_inc_tax FLOAT64,
sr_fee FLOAT64,
sr_return_ship_cost FLOAT64,
sr_refunded_cash FLOAT64,
sr_reversed_charge FLOAT64,
sr_store_credit FLOAT64,
sr_net_loss FLOAT64,
d_date DATE,
d_year INT64
)
PARTITION BY d_date

