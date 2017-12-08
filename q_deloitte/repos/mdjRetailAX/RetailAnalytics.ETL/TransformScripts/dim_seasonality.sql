
BEGIN TRANSACTION;
----------------------------------------------------------------------------------------------------------
-- update dim_seasonality.....
----------------------------------------------------------------------------------------------------------

 UPDATE
     conformed.dim_seasonality 
    SET batch_id              = changed_seasonality.batch_id
      , seasonality_name      = changed_seasonality.seasonality_name
      , year_seasonality_name = changed_seasonality.year_seasonality_name
   FROM (
 SELECT
        ##BATCH_ID## as batch_id 
      , sd.dim_retailer_id
      , sd.seasonality_name
      , sd.year_seasonality_name
      , sd.seasonality_bkey
      , sd.year_seasonality_bkey
   FROM
        stage.seasonality_dim sd
       JOIN
            conformed.dim_seasonality dc
         ON
                sd.dim_retailer_id       = dc.dim_retailer_id 
            AND sd.seasonality_bkey      = dc.seasonality_bkey
            AND sd.year_seasonality_bkey = dc.year_seasonality_bkey
            AND (
                   sd.seasonality_name       <> dc.seasonality_name
                OR sd.year_seasonality_name  <> dc.year_seasonality_name
            )

) changed_seasonality
 WHERE
        dim_seasonality.dim_retailer_id       = changed_seasonality.dim_retailer_id
    AND dim_seasonality.seasonality_bkey      = changed_seasonality.seasonality_bkey
    AND dim_seasonality.year_seasonality_bkey = changed_seasonality.year_seasonality_bkey
       
;

----------------------------------------------------------------------------------------------------------
-- insert dim_seasonality.....
----------------------------------------------------------------------------------------------------------
INSERT INTO conformed.dim_seasonality
(
    batch_id
  , dim_seasonality_id
  , dim_retailer_id
  , seasonality_bkey
  , year_seasonality_bkey
  , seasonality_name
  , year_seasonality_name
)
SELECT
    ##BATCH_ID## AS batch_id
  , max_dim_seasonality_id + row_number() over () as dim_seasonality_id
  , dim_retailer_id
  , seasonality_bkey
  , year_seasonality_bkey
  , seasonality_name
  , year_seasonality_name
FROM
     stage.seasonality_dim ps
   , ( select nvl(max(dim_seasonality_id), 0)  as max_dim_seasonality_id from conformed.dim_seasonality) 
WHERE
    NOT EXISTS
    (
     SELECT 1
       FROM
            conformed.dim_seasonality ds
      WHERE
            ds.dim_retailer_id       = ps.dim_retailer_id
        AND ds.seasonality_bkey      = ps.seasonality_bkey
        AND ds.year_seasonality_bkey = ps.year_seasonality_bkey
    )
;
