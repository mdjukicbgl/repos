INSERT INTO sales.fact_weekly_sales
(
    batch_id,
    dim_date_id,
    dim_retailer_id,
    dim_product_id,
    dim_geography_id,
    dim_currency_id,
    dim_seasonality_id,
    dim_price_status_id, 
    dim_channel_id,
    dim_product_status_id, 
    gross_margin,
    sales_value,
    sales_quantity,
    local_tax_rate,
    sales_cost,
    markdown_sales_value,
    markdown_sales_quantity,
    promotion_sales_value,
    promotion_sales_quantity,
    retailer_markdown_cost
)
SELECT
          ##BATCH_ID## AS batch_id
        , dte.dim_date_id
        , ret.dim_retailer_id
        , coalesce(prd.dim_product_id, cast(ret.dim_retailer_id         AS BIGINT) * -1 )
        , coalesce(geo.dim_geography_id, cast(ret.dim_retailer_id       AS INTEGER) * -1)
        , coalesce(curr.dim_currency_id, cast(ret.dim_retailer_id       AS SMALLINT) * -1)
        , coalesce(seas.dim_seasonality_id, cast(ret.dim_retailer_id    AS INTEGER) * -1 )
        , coalesce(stat.dim_status_id, cast(ret.dim_retailer_id         AS SMALLINT) * -1 )
        , coalesce(chan.dim_channel_id, cast(ret.dim_retailer_id        AS INTEGER) * -1)
        , coalesce(stat.dim_status_id, cast(ret.dim_retailer_id         AS INTEGER) * -1)  
        , gross_margin
        , sales_value
        , sales_quantity
        , local_tax_rate
        , sales_cost
        , markdown_sales_value
        , markdown_sales_quantity
        , promotion_sales_value
        , promotion_sales_quantity
        , retailer_markdown_cost

           FROM
                stage.sales_measures slsm

LEFT OUTER JOIN 
                conformed.dim_date dte
             ON 
                dte.calendar_date       = slsm.reporting_date

LEFT OUTER JOIN 
                conformed.dim_date_fiscal fisc
             ON 
                fisc.dim_date_id        = dte.dim_date_id
            AND fisc.dim_retailer_id    = slsm.dim_retailer_id

LEFT OUTER JOIN 
                conformed.dim_retailer ret
             ON 
                ret.dim_retailer_id     = slsm.dim_retailer_id

LEFT OUTER JOIN 
                conformed.dim_product prd
             ON 
                prd.product_bkey1       = slsm.product_bkey1
            AND prd.product_bkey2       = isnull( slsm.product_bkey2, '' )
            AND prd.product_bkey3       = isnull( slsm.product_bkey3, '' )
            AND prd.product_bkey4       = isnull( slsm.product_bkey4, '' )
            AND prd.dim_retailer_id     = ret.dim_retailer_id

LEFT OUTER JOIN 
                conformed.dim_geography geo
             ON geo.location_bkey       = slsm.location_bkey
            AND geo.dim_retailer_id     = ret.dim_retailer_id

LEFT OUTER JOIN 
                conformed.dim_currency curr
             ON curr.iso_currency_code  = slsm.iso_currency_code

LEFT OUTER JOIN 
                conformed.dim_seasonality seas
             ON seas.year_seasonality_bkey = slsm.year_seasonality_bkey
            AND seas.dim_retailer_id       = ret.dim_retailer_id

LEFT OUTER JOIN 
                conformed.dim_status stat
             ON stat.status_bkey        = slsm.price_status_bkey
            AND stat.status_type_bkey   = 2 
             
LEFT OUTER JOIN 
                conformed.dim_channel chan
             ON chan.channel_bkey       = slsm.channel_bkey
            AND chan.dim_retailer_id    = ret.dim_retailer_id

          WHERE 
                reporting_date_period_type = 2
;
