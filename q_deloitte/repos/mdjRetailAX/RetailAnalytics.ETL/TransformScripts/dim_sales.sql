
DROP TABLE IF EXISTS temp_fact_weekly_sales_initial;

CREATE TEMP TABLE temp_fact_weekly_sales_initial
(
    dim_date_id
  , dim_retailer_id
  , dim_product_id
  , dim_geography_id
  , dim_currency_id
  , dim_seasonality_id
  , dim_price_status_id
  , dim_channel_id
  , stock_value
  , stock_quantity
  , scanned_margin
  , combined_sales_value
  , combined_sales_quantity
  , clearance_sales_value
  , clearance_sales_quantity
  , promotion_sales_value
  , promotion_sales_quantity
  , retail_price
  , selling_price
)
DISTKEY(dim_date_id)
INTERLEAVED SORTKEY( dim_date_id, dim_product_id, dim_geography_id, dim_currency_id, dim_seasonality_id, dim_price_status_id, dim_channel_id  )
AS

SELECT  dd.dim_date_id               as dim_date_id,
        sa.dim_retailer_id           as dim_retailer_id,
        dp.dim_product_id            as dim_product_id, 
        dg.dim_geography_id          as dim_geography_id,
        dc.dim_currency_id           as dim_currency_id,
        ds.dim_seasonality_id        as dim_seasonality_id,
        ps.dim_price_status_id       as dim_price_status_id,
        ch.dim_channel_id            as dim_channel_id,
        sa.stock_value               as stock_value,
        sa.stock_quantity            as stock_quantity,
        sa.scanned_margin            as scanned_margin,
        sa.sales_value               as combined_sales_value,
        sa.sales_quantity            as combined_sales_quantity,
        sa.clearance_sales_value     as clearance_sales_value,
        sa.clearance_sales_quantity  as clearance_sales_quantity,
        sa.promotion_sales_value     as promotion_sales_value,
        sa.promotion_sales_quantity  as promotion_sales_quantity,
        sa.system_price              as retail_price,
        sa.selling_price             as selling_price
FROM    stage.sales                   sa
JOIN    conformed.dim_date            dd   ON  cast( sa.reporting_date as date) = dd.calendar_date
JOIN    conformed.dim_product         dp   ON dp.product_bkey = sa.product_key1 + '|' + isnull( sa.product_key2, '' ) + '|' + isnull( sa.product_key3, '' ) + '|' + isnull( sa.product_key4, '' )
JOIN    conformed.dim_geography       dg   ON sa.geography_type_key = dg.geography_type_bkey
                                          AND sa.geography_key = dg.geography_bkey
JOIN    conformed.dim_currency        dc   ON sa.iso_currency_code = dc.iso_currency_code
JOIN    conformed.dim_seasonality     ds   ON sa.dim_retailer_id = ds.dim_retailer_id
                                          AND sa.year_seasonality_key = ds.year_seasonality_bkey
JOIN    markdown.dim_price_status     ps   ON sa.price_status_key = ps.price_status_bkey
JOIN    conformed.dim_channel         ch   ON sa.channel_key = ch.channel_bkey
WHERE   sa.batch_id                         = ##BATCH_ID##
;


BEGIN TRANSACTION;

    DELETE  FROM sales.fact_weekly_sales_initial
     USING  temp_fact_weekly_sales_initial  tmp
     WHERE  sales.fact_weekly_sales_initial.dim_date_id = tmp.dim_date_id
       AND  sales.fact_weekly_sales_initial.dim_retailer_id = tmp.dim_retailer_id
       AND  sales.fact_weekly_sales_initial.dim_product_id = tmp.dim_product_id
       AND  sales.fact_weekly_sales_initial.dim_geography_id = tmp.dim_geography_id
       AND  sales.fact_weekly_sales_initial.dim_currency_id = tmp.dim_currency_id
       AND  sales.fact_weekly_sales_initial.dim_seasonality_id = tmp.dim_seasonality_id
       AND  sales.fact_weekly_sales_initial.dim_price_status_id = tmp.dim_price_status_id
       AND  sales.fact_weekly_sales_initial.dim_channel_id = tmp.dim_channel_id;


    INSERT
    INTO    sales.fact_weekly_sales_initial
    (       batch_id,
            dim_date_id,
            dim_retailer_id,
            dim_product_id,
            dim_geography_id,
            dim_currency_id,
            dim_seasonality_id,
            dim_price_status_id,
            dim_channel_id,
            stock_value,
            stock_quantity,
            scanned_margin,
            combined_sales_value,
            combined_sales_quantity,
            clearance_sales_value,
            clearance_sales_quantity,
            promotion_sales_value,
            promotion_sales_quantity,
            retail_price,
            selling_price
    )
    SELECT  ##BATCH_ID## as batch_id,
            dim_date_id,
            dim_retailer_id,
            dim_product_id,
            dim_geography_id,
            dim_currency_id,
            dim_seasonality_id,
            dim_price_status_id,
            dim_channel_id,
            stock_value,
            stock_quantity,
            scanned_margin,
            combined_sales_value,
            combined_sales_quantity,
            clearance_sales_value,
            clearance_sales_quantity,
            promotion_sales_value,
            promotion_sales_quantity,
            retail_price,
            selling_price
    FROM    temp_fact_weekly_sales_initial;
