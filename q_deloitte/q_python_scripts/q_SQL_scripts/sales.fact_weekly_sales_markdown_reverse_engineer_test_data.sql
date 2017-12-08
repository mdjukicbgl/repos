
  , FOREIGN KEY (dim_date_id)         REFERENCES conformed.dim_date (dim_date_id)
  , FOREIGN KEY (dim_retailer_id)     REFERENCES conformed.dim_retailer (dim_retailer_id)
  , FOREIGN KEY (dim_product_id)      REFERENCES conformed.dim_product (dim_product_id)
  , FOREIGN KEY (dim_geography_id)    REFERENCES conformed.dim_geography (dim_geography_id)
  , FOREIGN KEY (dim_currency_id)     REFERENCES conformed.dim_currency (dim_currency_id)
  , FOREIGN KEY (dim_seasonality_id)  REFERENCES conformed.dim_seasonality (dim_seasonality_id)
  , FOREIGN KEY (dim_junk_id)         REFERENCES sales.dim_junk (dim_junk_id)
  , FOREIGN KEY (dim_price_status_id) REFERENCES markdown.dim_price_status (dim_price_status_id)
  , FOREIGN KEY (dim_channel_id)      REFERENCES conformed.dim_channel (dim_channel_id)

select top 11 sls.dim_product_id
     , dte.calendar_date
	 , ret.retailer_bkey
	 , prd.product_bkey
     , geo.geography_bkey
	 , curr.iso_currency_code
	 , seas.seasonality_bkey
	 , junk.batch_id
	 , dps.price_status_bkey
	 , chan.channel_bkey
	 
 from sales.fact_weekly_sales_basic sls
left join conformed.dim_date dte
       on dte.dim_date_id = sls.dim_date_id
left join conformed.dim_retailer ret
       on ret.dim_retailer_id = sls.dim_retailer_id
left join conformed.dim_product prd
       on prd.dim_product_id = sls.dim_product_id
left join conformed.dim_geography geo
       on geo.dim_geography_id = sls.dim_geography_id
left join conformed.dim_currency curr
       on curr.dim_currency_id = sls.dim_currency_id
left join conformed.dim_seasonality seas
       on seas.dim_seasonality_id = sls.dim_seasonality_id
left join sales.dim_junk junk 
       on junk.dim_junk_id = sls.dim_junk_id
left join markdown.dim_price_status dps
       on dps.dim_price_status_id = sls.dim_price_status_id
left join conformed.dim_channel chan
       on chan.dim_channel_id = sls.dim_channel_id
	   
;


select top 11 *
  from conformed.dim_currency
  --from markdown.dim_price_status
  order by 1

;

select dim_geography_id
  from conformed.dim_geography
  group by dim_geography_id
order by dim_geography_id
;

select top 111 dim_geography_id
  from sales.fact_weekly_sales_basic
group by dim_geography_id
order by dim_geography_id
;


---------------------------------------------------------------------------------------------------
-- re-populate data from channel_repeat table
---------------------------------------------------------------------------------------------------
insert into conformed.dim_channel
(
       dim_retailer_id
     , channel_bkey
	 , channel_name
	 , channel_description
	 , channel_code
	 )
select dim_retailer_id
     , channel_bkey
	 , channel_name
	 , channel_description
	 , channel_code
 from mdj.conformed_dim_channel_repeat
;

---------------------------------------------------------------------------------------------------
-- re-populate data from channel_repeat table
---------------------------------------------------------------------------------------------------

select count(*) 
  --from conformed.dim_channel
   from mdj.conformed_dim_channel_repeat 
;

-- truncate table conformed.dim_channel

insert into conformed.dim_channel
(
	  dim_retailer_id
	, channel_bkey
	, channel_name
	, channel_description
	, channel_code
	)
select 
	  dim_retailer_id
	, channel_bkey
	, channel_name
	, channel_description
	, channel_code
 from mdj.conformed_dim_channel_repeat 
;

---------------------------------------------------------------------------------------------------
-- re-populate data from product_repeat table
---------------------------------------------------------------------------------------------------

select count(*)
  from conformed.dim_product
;


--truncate table conformed.dim_product

insert into  conformed.dim_product
(
	  batch_id
	, dim_retailer_id
	, product_bkey
	, effective_start_date_time
	, effective_end_date_time
	, product_name
	, product_description
	, product_sku_code
	, product_size
	, product_colour_code
	, product_colour
	, product_gender
	, product_age_group
	, brand_name
	, supplier_name
	, product_status
	)
select 	batch_id
	, dim_retailer_id
	, product_bkey
	, effective_start_date_time
	, effective_end_date_time
	, product_name
	, product_description
	, product_sku_code
	, product_size
	, product_colour_code
	, product_colour
	, product_gender
	, product_age_group
	, brand_name
	, supplier_name
	, product_status
from mdj.conformed_dim_product_repeat
;

---------
