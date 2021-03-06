CREATE TABLE IF NOT EXISTS stage.seasonality_dim ( 
	row_id               bigint  NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	reporting_date       date  NOT NULL ,
	reporting_date_period_type smallint  NOT NULL ,
	seasonality_bkey     varchar(20)  NOT NULL ,
	year_seasonality_bkey varchar(20)   ,
	seasonality_name     varchar(50)  NOT NULL ,
	year_seasonality_name varchar(50)   
 );
 
 CREATE TABLE IF NOT EXISTS conformed.dim_seasonality ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_seasonality_id   integer  NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	seasonality_bkey     varchar(20)  NOT NULL ,
	year_seasonality_bkey varchar(20)   ,
	seasonality_name     varchar(50)  NOT NULL ,
	year_seasonality_name varchar(50)   ,
	CONSTRAINT pk_dim_seasonality PRIMARY KEY ( dim_seasonality_id )
 )  COMPOUND SORTKEY (dim_seasonality_id, dim_retailer_id, year_seasonality_bkey, year_seasonality_name, batch_id);

----------------------------------------------------------------------------------------------------------
-- update dim_seasonality.....
----------------------------------------------------------------------------------------------------------
with changed_seasonality AS
(
 SELECT
        sd.dim_retailer_id
      , sd.seasonality_name
      , sd.year_seasonality_name
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
  WHERE
        sd.batch_id = ##BATCH_ID##
)
UPDATE
    conformed.dim_seasonality
   SET seasonality_name      = changed_seasonality.seasonality_name
     , year_seasonality_name = changed_seasonality.year_seasonality_name
  FROM changed_seasonality
 WHERE
        dim_seasonality.dim_retailer_id       = changed_seasonality.dim_retailer_id
    AND dim_seasonality.seasonality_bkey      = changed_seasonality.seasonality_bkey
    AND dim_seasonality.year_seasonality_bkey = changed_seasonality.year_seasonality_bkey
       
;

----------------------------------------------------------------------------------------------------------
-- insert dim_seasonality.....
----------------------------------------------------------------------------------------------------------
BEGIN TRANSACTION;
INSERT INTO conformed.dim_seasonality
(
    batch_id
  , dim_retailer_id
  , seasonality_bkey
  , year_seasonality_bkey
  , seasonality_name
  , year_seasonality_name
)
SELECT
    ##BATCH_ID## AS batch_id
  , dim_retailer_id
  , seasonality_bkey
  , year_seasonality_bkey
  , seasonality_name
  , year_seasonality_name
FROM
    stage.seasonality_dim ps
WHERE
    NOT EXISTS
    (
     SELECT  *
       FROM
            conformed.dim_seasonality ds
      WHERE
            ds.dim_retailer_id       = ps.dim_retailer_id
        AND ds.seasonality_bkey      = ps.seasonality_bkey
        AND ds.year_seasonality_bkey = ps.year_seasonality_bkey
    )
    AND ps.batch_id = ##BATCH_ID##
;
