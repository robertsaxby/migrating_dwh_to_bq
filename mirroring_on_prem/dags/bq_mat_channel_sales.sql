
        with ssr as
		 (select s_store_id,
            d_date,
		        sum(sales_price) as sales,
		        sum(profit) as profit,
		        sum(return_amt) as returns,
		        sum(net_loss) as profit_loss
		 from
		  ( select  ss_store_sk as store_sk,
		            d_date,
		            ss_ext_sales_price as sales_price,
		            ss_net_profit as profit,
		            cast(0 as FLOAT64) as return_amt,
		            cast(0 as FLOAT64) as net_loss
		    from `da304.Store_sales`
		    union all
		    select sr_store_sk as store_sk,
		           d_date,
		           cast(0 as FLOAT64) as sales_price,
		           cast(0 as FLOAT64) as profit,
		           sr_return_amt as return_amt,
		           sr_net_loss as net_loss
		    from `da304.Store_returns`
		   ) salesreturns,
		     `da304.Store`
		 where 
		        d_date between cast('{{params.date_start}}' as date)
		                  and DATE_ADD(cast('{{params.date_start}}' as date), INTERVAL 14 DAY)
		       and store_sk = s_store_sk
		 group by s_store_id,d_date)
		 ,
		 csr as
		 (select cp_catalog_page_id,
            d_date,
		        sum(sales_price) as sales,
		        sum(profit) as profit,
		        sum(return_amt) as returns,
		        sum(net_loss) as profit_loss
		 from
		  ( select  cs_catalog_page_sk as page_sk,
		            d_date,
		            cs_ext_sales_price as sales_price,
		            cs_net_profit as profit,
		            cast(0 as FLOAT64) as return_amt,
		            cast(0 as FLOAT64) as net_loss
		    from `da304.Catalog_sales`
		    union all
		    select cr_catalog_page_sk as page_sk,
		           d_date,
		           cast(0 as FLOAT64) as sales_price,
		           cast(0 as FLOAT64) as profit,
		           cr_return_amount as return_amt,
		           cr_net_loss as net_loss
		    from `da304.Catalog_returns`
		   ) salesreturns,
		     `da304.Catalog_page`
		 where  d_date between cast('{{params.date_start}}' as date)
		                  and DATE_ADD(cast('{{params.date_start}}'as date), INTERVAL 14 DAY)
		       and page_sk = cp_catalog_page_sk
		 group by cp_catalog_page_id,d_date)
		 ,
		 wsr as
		 (select web_site_id,
            d_date,
		        sum(sales_price) as sales,
		        sum(profit) as profit,
		        sum(return_amt) as returns,
		        sum(net_loss) as profit_loss
		 from
		  ( select  ws_web_site_sk as wsr_web_site_sk,
                d_date,
		            ws_ext_sales_price as sales_price,
		            ws_net_profit as profit,
		            cast(0 as FLOAT64) as return_amt,
		            cast(0 as FLOAT64) as net_loss
		    from `da304.Web_sales`
		    union all
		    select ws_web_site_sk as wsr_web_site_sk,
		           wr.d_date,
		           cast(0 as FLOAT64) as sales_price,
		           cast(0 as FLOAT64) as profit,
		           wr_return_amt as return_amt,
		           wr_net_loss as net_loss
		    from `da304.Web_returns` wr left outer join `da304.Web_sales` on
		         ( wr_item_sk = ws_item_sk
		           and wr_order_number = ws_order_number)
		   ) salesreturns,
		     `da304.Web_site` 
		 where  salesreturns.d_date between cast('{{params.date_start}}' as date)
		                  and DATE_ADD(cast('{{params.date_start}}' as date), INTERVAL 14 DAY)
		       and wsr_web_site_sk = web_site_sk
		 group by web_site_id,d_date)
     
		  select  channel
		        , id
            , date
		        , sum(sales) as sales
		        , sum(returns) as returns
		        , sum(profit) as profit
		 from
		 (select 'store channel' as channel
            ,d_date as date
		        , CONCAT('store', CAST(s_store_id as string)) as id
		        , sales
		        , returns
		        , (profit - profit_loss) as profit
		 from ssr
		 union all
		 select 'catalog channel' as channel
		        , d_date as date
            , CONCAT('catalog_page', CAST(cp_catalog_page_id as string)) as id
		        , sales
		        , returns
		        , (profit - profit_loss) as profit
		 from csr
		 union all
		 select 'web channel' as channel
            ,d_date as date
		        , CONCAT('web_site', CAST(web_site_id as string)) as id
		        , sales
		        , returns
		        , (profit - profit_loss) as profit
		 from  wsr
		 ) x
		 group by rollup (channel, id, date)
     having channel IS NOT NULL and id IS NOT NULL
		 order by channel
		         ,id
		 limit 100;






  