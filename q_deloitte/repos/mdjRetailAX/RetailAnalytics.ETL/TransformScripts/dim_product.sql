
DROP TABLE IF EXISTS temp_product;

---------------------------------------------------------------------------------------------------
-- Create temp table.....
---------------------------------------------------------------------------------------------------
CREATE TEMP TABLE temp_product (
     batch_id
   , dim_product_id
   , dim_retailer_id
   , reporting_date
   , reporting_date_period_type
   , product_bkey1
   , product_bkey2
   , product_bkey3
   , product_bkey4
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
   , product_planned_end_date
   , effective_end_date_time
)
DISTKEY(dim_product_id)
INTERLEAVED SORTKEY( dim_product_id, dim_retailer_id, product_bkey1, product_bkey2, product_bkey3, product_bkey4 )
AS
SELECT
    ##BATCH_ID## as batch_id
  , dp.dim_product_id
  , sp.dim_retailer_id
  , sp.reporting_date
  , sp.reporting_date_period_type
  , sp.product_bkey1
  , ISNULL( sp.product_bkey2, '' )
  , ISNULL( sp.product_bkey3, '' )
  , ISNULL( sp.product_bkey4, '' )
  , sp.product_name
  , sp.product_description
  , sp.product_sku_code
  , sp.product_size
  , sp.product_colour_code
  , sp.product_colour
  , sp.product_gender
  , sp.product_age_group
  , sp.brand_name
  , sp.supplier_name
  , sp.product_status
  , sp.product_planned_end_date
  , dp.effective_end_date_time
FROM
    stage.product_dim sp
   JOIN
        conformed.dim_product dp
     ON     sp.dim_retailer_id                                                                                                                = dp.dim_retailer_id
        AND sp.product_bkey1              = dp.product_bkey1
        AND ISNULL( sp.product_bkey2, '') = dp.product_bkey2
        AND ISNULL( sp.product_bkey3, '') = dp.product_bkey3
        AND ISNULL( sp.product_bkey4, '') = dp.product_bkey4
        AND
        (
            sp.product_name             <> dp.product_name
         OR sp.product_description      <> dp.product_description
         OR sp.product_sku_code         <> dp.product_sku_code
         OR sp.product_size             <> dp.product_size
         OR sp.product_colour_code      <> dp.product_colour_code
         OR sp.product_colour           <> dp.product_colour
         OR sp.product_gender           <> dp.product_gender
         OR sp.product_age_group        <> dp.product_age_group
         OR sp.brand_name               <> dp.brand_name
         OR sp.supplier_name            <> dp.supplier_name
         OR sp.product_status           <> dp.product_status
         OR sp.product_planned_end_date <> dp.product_planned_end_date
        )
WHERE
        dp.effective_end_date_time = '2500-01-01'
;

---------------------------------------------------------------------------------------------------
-- Close out the current record.....
---------------------------------------------------------------------------------------------------

BEGIN TRANSACTION;

UPDATE
    conformed.dim_product
   SET effective_end_date_time = DATEADD(sec, -1, tp.reporting_date)
  FROM
    temp_product tp
 WHERE
       dim_product.product_bkey1           = tp.product_bkey1
   AND dim_product.product_bkey2           = tp.product_bkey2
   AND dim_product.product_bkey3           = tp.product_bkey3
   AND dim_product.product_bkey4           = tp.product_bkey4   
   AND dim_product.effective_end_date_time = '2500-01-01'
;

---------------------------------------------------------------------------------------------------
-- Insert new version.....
---------------------------------------------------------------------------------------------------
INSERT  INTO conformed.dim_product
(
     batch_id
   , dim_product_id
   , dim_retailer_id
   , product_bkey1
   , product_bkey2
   , product_bkey3
   , product_bkey4
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
   , product_planned_end_date
)
SELECT
    ##BATCH_ID##
  , max_dim_product_id + row_number() over () as dim_product_id  
  , dim_retailer_id
  , product_bkey1
  , product_bkey2
  , product_bkey3
  , product_bkey4
  , cast(reporting_date as date) AS effective_start_date_time
  , '2500-01-01'                 AS effective_end_date_time
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
  , product_planned_end_date
  FROM
       temp_product
     , (select nvl(max(dim_product_id), 0) as max_dim_product_id from conformed.dim_product) 
;

---------------------------------------------------------------------------------------------------
-- Insert new active record.....
---------------------------------------------------------------------------------------------------
INSERT  INTO conformed.dim_product
  (
    batch_id
  , dim_product_id
  , dim_retailer_id
  , product_bkey1
  , product_bkey2
  , product_bkey3
  , product_bkey4
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
  , product_planned_end_date
  )
SELECT
    ##BATCH_ID##
  , max_dim_product_id + row_number() over () as dim_product_id  
  , dim_retailer_id
  , product_bkey1
  , product_bkey2
  , product_bkey3
  , product_bkey4
  , cast(reporting_date as date) AS effective_start_date_time
  , '2500-01-01'                 AS effective_end_date_time
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
  , product_planned_end_date
  FROM
       stage.product_dim sp
     , (select nvl(max(dim_product_id), 0) as max_dim_product_id from conformed.dim_product) 
 WHERE   NOT EXISTS ( SELECT  1
                        FROM  conformed.dim_product     dp
                       WHERE  dp.dim_retailer_id        = sp.dim_retailer_id
                         AND  dp.product_bkey1          = sp.product_bkey1
                         AND  dp.product_bkey2          = isnull( sp.product_bkey2, '' )
                         AND  dp.product_bkey3          = isnull( sp.product_bkey3, '' )
                         AND  dp.product_bkey4          = isnull( sp.product_bkey4, '' )
                      )
 ;
