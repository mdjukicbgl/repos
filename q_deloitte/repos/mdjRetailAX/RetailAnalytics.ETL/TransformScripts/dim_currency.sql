BEGIN TRANSACTION;

----------------------------------------------------------------------------------------------------------
-- update dim_currency.....
----------------------------------------------------------------------------------------------------------
UPDATE
    conformed.dim_currency
SET batch_id          = changed_currency.batch_id
  , currency          = changed_currency.currency
  , iso_currency_code = changed_currency.iso_currency_code
  , currency_symbol   = changed_currency.currency_symbol
  , is_active         = changed_currency.is_active
FROM (
  SELECT
       ##BATCH_ID## as batch_id 
     , sc.currency_bkey
     , sc.currency
     , sc.iso_currency_code
     , sc.currency_symbol
     , sc.is_active
  FROM
       stage.currency_dim sc
      JOIN
           conformed.dim_currency dc
        ON
           sc.currency_bkey     = dc.currency_bkey
       AND
           (
               sc.currency          <> dc.currency
            OR sc.iso_currency_code <> dc.iso_currency_code
            OR sc.currency_symbol   <> dc.currency_symbol
            OR sc.is_active         <> dc.is_active
           )

     ) changed_currency
WHERE
      dim_currency.currency_bkey = changed_currency.currency_bkey
;

----------------------------------------------------------------------------------------------------------
-- insert dim_currency.....
----------------------------------------------------------------------------------------------------------
INSERT  INTO conformed.dim_currency
(
    batch_id
  , dim_currency_id  
  , currency_bkey
  , currency
  , iso_currency_code
  , currency_symbol
  , is_active
)
SELECT
    ##BATCH_ID## AS batch_id
  , max_dim_currency_id + row_number() over () as dim_currency_id
  , currency_bkey
  , currency
  , iso_currency_code
  , currency_symbol
  , is_active
FROM
     stage.currency_dim sc
   , (select nvl(max(dim_currency_id), 0) as max_dim_currency_id from conformed.dim_currency)  
WHERE
    NOT EXISTS
    (
     SELECT 1
       FROM
            conformed.dim_currency dc
      WHERE
            dc.currency_bkey = sc.currency_bkey
    )
;

