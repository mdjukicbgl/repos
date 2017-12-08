CREATE TABLE IF NOT EXISTS stage.channel_dim ( 
  --row_id               bigint DEFAULT "identity"(264652, 0, '1,1'::text) NOT NULL ,
  row_id               int  identity  NOT NULL ,
  batch_id             integer DEFAULT 1 NOT NULL ,
  --retailer_bkey        varchar(20)  NOT NULL ,
  dim_retailer_id      integer   ,
  channel_bkey         varchar(20)  NOT NULL ,
  channel_name         varchar(50)  NOT NULL ,
  channel_description  varchar(250)   ,
  channel_code         varchar(10)   ,
  reporting_date       date  NOT NULL ,
  reporting_date_period_type smallint  NOT NULL 
 );


CREATE TABLE IF NOT EXISTS conformed.dim_channel ( 
  batch_id             integer DEFAULT 1 NOT NULL ,
  dim_channel_id       integer  NOT NULL ,
  dim_retailer_id      integer  NOT NULL ,
  channel_bkey         varchar(20)  NOT NULL ,
  channel_name         varchar(50)  NOT NULL ,
  channel_description  varchar(250)   ,
  channel_code         varchar(10)   ,
  CONSTRAINT pk_dim_channel PRIMARY KEY ( dim_channel_id )
 )  COMPOUND SORTKEY (dim_channel_id, dim_retailer_id, channel_bkey, channel_name, batch_id);

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
                    sc.channel_name           <> dc.channel_name
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
    , dim_retailer_id
    , channel_bkey
    , channel_name
    , channel_description
    , channel_code
  )
SELECT
    ##BATCH_ID## as batch_id
  , dim_retailer_id
  , channel_key
  , channel_name
  , channel_description
  , channel_code
FROM
    stage.channel_dim sc
WHERE
    NOT EXISTS
    (
     SELECT  1
       FROM
            conformed.dim_channel dc
      WHERE
            dc.dim_retailer_id  = sc.dim_retailer_id
            AND dc.channel_bkey = sc.channel_key
    )
;