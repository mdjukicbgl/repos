
----------------------------------------------------------------------------------------------------------
-- update dim_channel.....
----------------------------------------------------------------------------------------------------------
BEGIN TRANSACTION;

UPDATE
    conformed.dim_channel
SET 
    batch_id            = changed_channel.batch_id     
  , channel_name        = changed_channel.channel_name
  , channel_description = changed_channel.channel_description
  , channel_code        = changed_channel.channel_code
FROM
    (
     SELECT
            ##BATCH_ID## as batch_id
          , sc.dim_retailer_id
          , sc.channel_bkey
          , sc.channel_name
          , sc.channel_description
          , sc.channel_code
       FROM
            stage.channel_dim sc
           JOIN
                conformed.dim_channel dc
             ON
                sc.dim_retailer_id  = dc.dim_retailer_id
            AND 
                sc.channel_bkey = dc.channel_bkey
            AND
                (
                       sc.channel_name        <> dc.channel_name
                    OR sc.channel_description <> dc.channel_description
                    OR sc.channel_code        <> dc.channel_code
                )
    )
    changed_channel
WHERE
    dim_channel.dim_retailer_id  = changed_channel.dim_retailer_id
  AND 
    dim_channel.channel_bkey = changed_channel.channel_bkey
;

----------------------------------------------------------------------------------------------------------
-- insert dim_channel.....
----------------------------------------------------------------------------------------------------------
INSERT  INTO conformed.dim_channel
  (
      batch_id
    , dim_channel_id  
    , dim_retailer_id
    , channel_bkey
    , channel_name
    , channel_description
    , channel_code
  )
SELECT
    ##BATCH_ID## as batch_id
  , max_dim_channel_id + row_number() over () as dim_channel_id 
  , dim_retailer_id
  , channel_bkey
  , channel_name
  , channel_description
  , channel_code

FROM
     stage.channel_dim sc
   , (select nvl(max(dim_channel_id), 0) as max_dim_channel_id from conformed.dim_channel) 
WHERE
    NOT EXISTS
    (
     SELECT  1
       FROM
            conformed.dim_channel dc
      WHERE
            dc.dim_retailer_id  = sc.dim_retailer_id
            AND dc.channel_bkey = sc.channel_bkey
    )
;
