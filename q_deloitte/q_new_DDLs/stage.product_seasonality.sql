- - - - - - - - - - - - - - - -  O L D   stage   D D L - - - - - - - - - - - - - - -
#
# Current version of DDL - stage.product_seasonality
#
CREATE TABLE stage.product_seasonality
(
	batch_id INTEGER,
	dim_retailer_id INTEGER,
	reporting_date VARCHAR(10),
	reporting_date_period_type CHAR(1),
	product_key1 VARCHAR(20),
	product_key2 VARCHAR(20),
	product_key3 VARCHAR(20),
	product_key4 VARCHAR(20),
	geography_type_key CHAR(1),
	geography_key VARCHAR(20),
	seasonality_key VARCHAR(20),
	year_seasonality_key VARCHAR(20),
	year_seasonality_start_date VARCHAR(10),
	year_seasonality_end_date VARCHAR(10),
	row_id BIGINT IDENTITY NOT NULL
)
DISTSTYLE EVEN;


#
# NEW table DDL - stage.product_seasonality
#
- - - - - - - - - - - - - - - -  N E W   stage   S Q L - - - - - - - - - - - - - - -
CREATE TABLE stage.product_seasonality
(
          batch_id                    INT NOT NULL DEFAULT 1 -- will be updated within the framework script via the ##BATCH_ID## tag
        , dim_retailer_id             INT                    -- Lookup to be performed upon ClientName portion of source_file_name column
        , reporting_date              VARCHAR(10)
        , reporting_date_period_type  CHAR(1)
        , product_key1                VARCHAR(20)
        , product_key2                VARCHAR(20)
        , product_key3                VARCHAR(20)
        , product_key4                VARCHAR(20)
        , geography_type_key          CHAR(1)
        , geography_key               VARCHAR(20)
        , seasonality_key             VARCHAR(20)
        , year_seasonality_key        VARCHAR(20)
        , year_seasonality_start_date VARCHAR(10)
        , year_seasonality_end_date   VARCHAR(10)
        , row_id                      BIGINT IDENTITY NOT NULL
)
DISTKEY(product_key1)
INTERLEAVED SORTKEY(product_key1, year_seasonality_key)
;
