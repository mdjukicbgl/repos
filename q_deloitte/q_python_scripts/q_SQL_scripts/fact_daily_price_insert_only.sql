CREATE TABLE IF NOT EXISTS stage.price_changes_measures ( 
	row_id               bigint DEFAULT "identity"(264700, 0, '1,1'::text) NOT NULL ,
	batch_id             integer  NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	reporting_date       date   ,
	reporting_date_period_type smallint   ,
	location_bkey        varchar(20)   ,
	product_bkey1        varchar(20)   ,
	product_bkey2        varchar(20)   ,
	product_bkey3        varchar(20)   ,
	product_bkey4        varchar(20)   ,
	channel_bkey         varchar(20)   ,
	year_seasonality_bkey varchar(20)   ,
	iso_currency_code    varchar(3)   ,
	price_status_bkey    smallint   ,
	system_price         double precision   ,
	selling_price        double precision   ,
	original_selling_price double precision   
 );


CREATE TABLE IF NOT EXISTS sales.fact_daily_price ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_retailer_id      integer  NOT NULL ,
	dim_date_id          integer DEFAULT 1 NOT NULL ,
	dim_product_id       bigint  NOT NULL ,
	dim_geography_id     integer  NOT NULL ,
	dim_channel_id       integer  NOT NULL ,
	dim_seasonality_id   integer  NOT NULL ,
	dim_price_status_id  integer  NOT NULL ,
	dim_currency_id      smallint  NOT NULL ,
	system_price         double precision   ,
	selling_price        double precision   ,
	original_selling_price double precision   ,
	previous_selling_price double precision   ,
	CONSTRAINT pk_fact_daily_price PRIMARY KEY ( dim_date_id, dim_product_id, dim_geography_id, dim_channel_id, dim_seasonality_id, dim_price_status_id )
 ) DISTKEY (dim_product_id) COMPOUND SORTKEY (dim_date_id, dim_product_id, dim_retailer_id, dim_price_status_id, dim_geography_id, dim_channel_id, dim_seasonality_id, dim_currency_id, batch_id);

------------------------------------------------------------
-- fact_daily_price.....
------------------------------------------------------------
INSERT INTO sales.fact_weekly_stock
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
    , COALESCE(prst.dim_price_status_id, CAST(ret.dim_retailer_id AS INTEGER) * -1)
    , COALESCE(curr.dim_currency_id, CAST(ret.dim_retailer_id     AS INTEGER) * -1)    
    , system_price
    , selling_price
    , original_selling_price
    , previous_selling_price
FROM
    stage.price_changes_measures mdpc

LEFT OUTER JOIN
        conformed.dim_retailer ret
     ON
        ret.retailer_bkey = mdpc.retailer_bkey

LEFT OUTER JOIN
        conformed.dim_date dte
     ON
        dte.calendar_date = mdpc.calendar_date

LEFT OUTER JOIN
        conformed.dim_product prd
     ON
        prd.product_bkey    = mdpc.product_key1 + '|' + ISNULL( mdpc.product_key2, '' ) + '|' + ISNULL( mdpc.product_key3, '' ) + '|' + ISNULL( mdpc.product_key4, '' )
    AND prd.dim_retailer_id = ret.dim_retailer_id    

LEFT OUTER JOIN
        conformed.dim_geography geo
     ON
        geo.geography_bkey  = mdpc.location_bkey
    AND geo.dim_retailer_id = ret.dim_retailer_id

LEFT OUTER JOIN
        conformed.dim_channel chan
     ON
        chan.channel_bkey    = mdpc.channel_bkey
    AND chan.dim_retailer_id = ret.dim_retailer_id

LEFT OUTER JOIN
        conformed.dim_seasonality seas
     ON
        seas.seasonality_bkey = mdpc.channel_bkey
    AND seas.dim_retailer_id  = ret.dim_retailer_id
--
-- dim_price_status_id here - Check this out with Stuart, as not sure that dim_status is the correct table
--
LEFT OUTER JOIN 
        conformed.dim_status stat
     ON stat.status_type_bkey = mdpc.price_status_bkey
    AND stat.status_type_bkey = 2 

LEFT OUTER JOIN
        conformed.dim_currency curr
     ON
        curr.currency_bkey = mdpc.currency_bkey

WHERE
    reporting_date_period_type = 1
;
