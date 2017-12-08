------------------------------------------------------------
-- fact_daily_price.....
------------------------------------------------------------
INSERT INTO sales.fact_daily_price
(
      batch_id
    , dim_retailer_id
    , dim_date_id
    , dim_product_id
    , dim_geography_id
    , dim_channel_id
    , dim_seasonality_id
    , dim_price_status_id
    , dim_currency_id
    , system_price
    , selling_price
    , original_selling_price
    , previous_selling_price
)
SELECT
      ##BATCH_ID## AS batch_id
    , ret.dim_retailer_id
    , dte.dim_date_id
    , COALESCE(prd.dim_product_id, CAST(ret.dim_retailer_id       AS BIGINT)  * -1)
    , COALESCE(geo.dim_geography_id, CAST(ret.dim_retailer_id     AS INTEGER) * -1)
    , COALESCE(chan.dim_channel_id, CAST(ret.dim_retailer_id      AS INTEGER) * -1)
    , COALESCE(seas.dim_seasonality_id, CAST(ret.dim_retailer_id  AS INTEGER) * -1)
    , COALESCE(stat.dim_status_id, CAST(ret.dim_retailer_id       AS INTEGER) * -1)
    , COALESCE(curr.dim_currency_id, CAST(ret.dim_retailer_id     AS INTEGER) * -1)    
    , system_price
    , selling_price
    , original_selling_price
    , NULL AS previous_selling_price
FROM
    stage.price_changes_measures mdpc

LEFT OUTER JOIN
        conformed.dim_date dte
     ON
        dte.calendar_date          = mdpc.reporting_date

LEFT OUTER JOIN 
        conformed.dim_date_fiscal fisc
     ON 
        fisc.dim_date_id           = dte.dim_date_id
    AND fisc.dim_retailer_id       = mdpc.dim_retailer_id

LEFT OUTER JOIN
        conformed.dim_retailer ret
     ON
        ret.dim_retailer_id        = mdpc.dim_retailer_id

LEFT OUTER JOIN
        conformed.dim_product prd
     ON
        prd.product_bkey1          = mdpc.product_bkey1
    AND prd.product_bkey2          = ISNULL( mdpc.product_bkey2, '' )
    AND prd.product_bkey3          = ISNULL( mdpc.product_bkey3, '' )
    AND prd.product_bkey4          = ISNULL( mdpc.product_bkey4, '' )
    AND prd.dim_retailer_id        = ret.dim_retailer_id    

LEFT OUTER JOIN
        conformed.dim_geography geo
     ON
        geo.location_bkey          = mdpc.location_bkey
    AND geo.dim_retailer_id        = ret.dim_retailer_id

LEFT OUTER JOIN
        conformed.dim_channel chan
     ON
        chan.channel_bkey          = mdpc.channel_bkey
    AND chan.dim_retailer_id       = ret.dim_retailer_id

LEFT OUTER JOIN 
        conformed.dim_seasonality seas
     ON 
        seas.year_seasonality_bkey = mdpc.year_seasonality_bkey
    AND seas.dim_retailer_id       = ret.dim_retailer_id


LEFT OUTER JOIN 
        conformed.dim_status stat
     ON 
        stat.status_bkey           = mdpc.price_status_bkey
    AND stat.status_type_bkey      = 2 

LEFT OUTER JOIN
        conformed.dim_currency curr
     ON
        curr.iso_currency_code     = mdpc.iso_currency_code

WHERE
    reporting_date_period_type     = 1
;
