INSERT INTO markdown.fact_weekly_sales_markdown
(
          batch_id
        , dim_date_id
        , dim_retailer_id
        , dim_product_id
        , dim_geography_id
        , dim_currency_id
        , dim_seasonality_id
        , dim_junk_id
        , dim_price_status_id
        , dim_channel_id
        , gross_margin
        , markdown_price
        , markdown_cost
        , cost_price
        , system_price
        , selling_price
        , original_selling_price
        , optimisation_original_selling_price
        , provided_selling_price
        , provided_original_selling_price
        , optimisation_selling_price
        , local_tax_rate
        , sales_value
        , sales_quantity
        , store_stock_value
        , store_stock_quantity
        , depot_stock_value
        , depot_stock_quantity
        , clearance_sales_value
        , clearance_sales_quantity
        , promotion_sales_value
        , promotion_sales_quantity
        , store_stock_value_no_negatives
        , store_stock_quantity_no_negatives
        , intake_plus_future_commitment_quantity
        , intake_plus_future_commitment_value
        , total_stock_value
        , total_stock_quantity
)
SELECT
          ##BATCH_ID## AS batch_id
        , dte.dim_date_id
        , ret.dim_retailer_id
        , coalesce(prd.dim_product_id, cast(ret.dim_retailer_id as bigint) * -1 )
        , coalesce(geo.dim_geography_id, cast(ret.dim_retailer_id as integer) * -1)
        , coalesce(curr.dim_currency_id, cast(ret.dim_retailer_id as smallint) * -1)
        , coalesce(seas.dim_seasonality_id, cast(ret.dim_retailer_id as integer) * -1 )
        , coalesce(junk.batch_id, cast(ret.dim_retailer_id as smallint) * -1)
        , coalesce(dps.dim_price_status_id, cast(ret.dim_retailer_id as smallint) * -1 )
        , coalesce(chan.dim_channel_id, cast(ret.dim_retailer_id as integer) * -1)  
        , gross_margin
        , markdown_price
        , markdown_cost
        , cost_price
        , system_price
        , selling_price
        , original_selling_price
        , optimisation_original_selling_price
        , provided_selling_price
        , provided_original_selling_price
        , optimisation_selling_price
        , local_tax_rate
        , sales_value
        , sales_quantity
        , store_stock_value
        , store_stock_quantity
        , depot_stock_value
        , depot_stock_quantity
        , clearance_sales_value
        , clearance_sales_quantity
        , promotion_sales_value
        , promotion_sales_quantity
        , store_stock_value_no_negatives
        , store_stock_quantity_no_negatives
        , intake_plus_future_commitment_quantity
        , intake_plus_future_commitment_value
        , total_stock_value
        , total_stock_quantity
FROM
                stage.markdown_measures mdn
left outer join 
                conformed.dim_date dte
             on dte.calendar_date = mdn.calendar_date
left outer join 
                conformed.dim_retailer ret
             on ret.retailer_bkey = mdn.retailer_bkey
left outer join 
                conformed.dim_product prd
             on prd.product_bkey = mdn.product_bkey
left outer join 
                conformed.dim_geography geo
             on geo.geography_bkey  = mdn.geography_bkey
            and geo.dim_retailer_id = ret.dim_retailer_id
left outer join 
                conformed.dim_currency curr
             on curr.iso_currency_code = mdn.currency_bkey
left outer join 
                conformed.dim_seasonality seas
             on seas.seasonality_bkey = mdn.seasonality_bkey
            and seas.dim_retailer_id  = ret.dim_retailer_id
left outer join 
                sales.dim_junk junk
             on junk.batch_id = mdn.junk_bkey
left outer join 
                markdown.dim_status dps
             on dps.status_bkey       = mdn.price_status_bkey
            and dps.status_type_bkey  = 2 
            and dps.dim_retailer_id   = ret.dim_retailer_id 
left outer join 
                conformed.dim_channel chan
             on chan.channel_bkey = mdn.channel_bkey
            and chan.dim_retailer_id = ret.dim_retailer_id
;
