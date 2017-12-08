INSERT INTO sales.fact_weekly_stock
(
      batch_id
    , dim_date_id
    , dim_product_id
    , dim_geography_id
    , dim_retailer_id
    , dim_currency_id
    , stock_value
    , stock_quantity
    , stock_cost
    , cost_price
    , future_commitment_stock_value
    , future_commitment_stock_quantity
    , future_commitment_stock_cost
    , intake_stock_value
    , intake_stock_quantity
    , intake_stock_cost
    , transit_stock_value
    , transit_stock_quantity
    , transit_stock_cost
)
SELECT
      ##BATCH_ID## AS batch_id
    , dte.dim_date_id
    , COALESCE(prd.dim_product_id, CAST(ret.dim_retailer_id AS   bigint)   * -1 )
    , COALESCE(geo.dim_geography_id, CAST(ret.dim_retailer_id AS INTEGER)  * -1)
    , ret.dim_retailer_id
    , COALESCE(curr.dim_currency_id, CAST(ret.dim_retailer_id AS SMALLINT) * -1)
    , stock_value
    , stock_quantity
    , stock_cost
    , cost_price
    , future_commitment_stock_value
    , future_commitment_stock_quantity
    , future_commitment_stock_cost
    , intake_stock_value
    , intake_stock_quantity
    , intake_stock_cost
    , transit_stock_value
    , transit_stock_quantity
    , transit_stock_cost
FROM
    stage.stock_measures stkm

LEFT OUTER JOIN 
        conformed.dim_date dte
     ON 
        dte.calendar_date       = stkm.reporting_date

LEFT OUTER JOIN 
        conformed.dim_date_fiscal fisc
     ON 
        fisc.dim_date_id        = dte.dim_date_id
    AND fisc.dim_retailer_id    = stkm.dim_retailer_id

LEFT OUTER JOIN
        conformed.dim_retailer ret
     ON
        ret.dim_retailer_id     = stkm.dim_retailer_id

LEFT OUTER JOIN
        conformed.dim_product prd
     ON
        prd.product_bkey1       = stkm.product_bkey1
    AND prd.product_bkey2       = ISNULL( stkm.product_bkey2, '' )
    AND prd.product_bkey3       = ISNULL( stkm.product_bkey3, '' )
    AND prd.product_bkey4       = ISNULL( stkm.product_bkey4, '' )
    AND prd.dim_retailer_id     = ret.dim_retailer_id

LEFT OUTER JOIN
        conformed.dim_geography geo
     ON 
        geo.location_bkey       = stkm.location_bkey
    AND geo.dim_retailer_id     = ret.dim_retailer_id

LEFT OUTER JOIN
        conformed.dim_currency curr
     ON
        curr.iso_currency_code  = stkm.iso_currency_code

WHERE
    reporting_date_period_type  = 2
;