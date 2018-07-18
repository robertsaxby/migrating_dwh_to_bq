#!/bin/bash
declare -a tables=("account_permission" 
"address" 
"broker " 
"cash_transaction" 
"charge " 
"commission_rate" 
"company" 
"company_competitor" 
"customer" 
"customer_account" 
"customer_taxrate" 
"daily_market" 
"exchange" 
"financial" 
"holding" 
"holding_history" 
"holding_summary" 
"industry" 
"last_trade" 
"news_item" 
"news_xref" 
"sector" 
"security" 
"settlement" 
"status_type" 
"taxrate" 
"trade" 
"trade_history" 
"trade_request" 
"trade_type" 
"watch_item" 
"watch_list" 
"zip_code")
                 
		
#loop
for table in ${tables[@]}
do
	echo ${table}
	`bq show --schema --format=prettyjson da304_uc2.${table} > ./schema/${table}.json`
	`bq mkdef --noautodetect --source_format=CSV gs://da304_staging_uc2/${table}.txt ./schema/${table}.json > ./schema/${table}_schema`
	`ex -sc '%s/\"fieldDelimiter\": \"\,\"/\"fieldDelimiter\": \"|\"/g|x' schema/${table}_schema`
	echo `bq mk --external_table_definition=./schema/${table}_schema da304_staging_uc2.${table}`
done

