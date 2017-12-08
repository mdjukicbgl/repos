
- - - - - - - - - - - - - - - -  O L D   Stage   D D L - - - - - - - - - - - - - - -
#
# Current version of DDL - stage.product
#
CREATE TABLE stage.product
(
	batch_id INTEGER,
	dim_retailer_id INTEGER,
	reporting_date VARCHAR(10),
	reporting_date_period_type CHAR(1),
	product_key1 VARCHAR(20),
	product_key2 VARCHAR(20),
	product_key3 VARCHAR(20),
	product_key4 VARCHAR(20),
	product_name VARCHAR(50),
	product_description VARCHAR(512),
	product_sku_code VARCHAR(20),
	product_size VARCHAR(20),
	product_colour_code VARCHAR(20),
	product_colour VARCHAR(50),
	product_gender VARCHAR(10),
	product_age_group VARCHAR(50),
	brand_name VARCHAR(100),
	supplier_name VARCHAR(50),
	product_status VARCHAR(30),
	row_id BIGINT IDENTITY NOT NULL
)
DISTSTYLE EVEN;

- - - - - - - - - - - - - - - -  N E W   S Q L - - - - - - - - - - - - - - -
#
# NEW table DDL - stage.product
#
CREATE TABLE stage.product
(
    batch_id                   INT 			     NOT NULL DEFAULT 1  -- will be updated within the framework script via the ##BATCH_ID## tag
  , dim_retailer_id            INT	   		   -- Lookup to be performed upon ClientName portion of source_file_name column
  , reporting_date             DATE    		   -- DWH attribute calendar_date	
  , reporting_date_period_type CHAR(1) 		   -- no DWH attribute name defined
  , product_bkey1              VARCHAR(20)
  , product_bkey2              VARCHAR(20)
  , product_bkey3              VARCHAR(20)
  , product_bkey4              VARCHAR(20)
  , product_name               VARCHAR(50)    NOT NULL
  , product_description        VARCHAR(512)
  , product_sku_code           VARCHAR(20)
  , product_size               VARCHAR(20)
  , product_colour_code        VARCHAR(20)
  , product_colour             VARCHAR(50)
  , product_gender             VARCHAR(10)
  , product_age_group          VARCHAR(50)
  , brand_name                 VARCHAR(100)
  , supplier_name              VARCHAR(50)
  , product_status             VARCHAR(30)
  , planned_end_date           DATE
  , row_id                     BIGINT IDENTITY NOT NULL
  , PRIMARY KEY(product_key1, product_key2, product_key3, product_key4)
)
DISTKEY(product_bkey1)
SORTKEY(product_bkey1)
;


- - - - - - - - - - - - - - - -  O L D   dim   S Q L - - - - - - - - - - - - - - - 
#
# OLD version of dim.product
#
CREATE TABLE conformed.dim_product
(
  dim_product_id BIGINT IDENTITY(-1, 1) NOT NULL ENCODE delta,
  batch_id NUMERIC(10, 0) NOT NULL ENCODE runlength,
  dim_retailer_id BIGINT NOT NULL ENCODE runlength,
  product_bkey VARCHAR(50) NOT NULL ENCODE lzo,
  effective_start_date_time TIMESTAMP DEFAULT '2007-01-01 00:00:00'::timestamp without time zone NOT NULL ENCODE runlength,
  effective_end_date_time TIMESTAMP DEFAULT '2500-01-01 00:00:00'::timestamp without time zone NOT NULL ENCODE lzo,
  product_name VARCHAR(100) NOT NULL ENCODE lzo,
  product_description VARCHAR(512) ENCODE lzo,
  product_sku_code VARCHAR(50) ENCODE lzo,
  product_size VARCHAR(20) ENCODE lzo,
  product_colour_code CHAR(10) ENCODE lzo,
  product_colour VARCHAR(50) ENCODE lzo,
  product_gender CHAR(10) ENCODE lzo,
  product_age_group VARCHAR(50) ENCODE lzo,
  brand_name VARCHAR(100) ENCODE lzo,
  supplier_name VARCHAR(50) ENCODE lzo,
  product_status VARCHAR(10) ENCODE lzo
)
DISTSTYLE EVEN;

ALTER TABLE conformed.dim_product
ADD CONSTRAINT pk_dimproduct_2002106173
PRIMARY KEY (dim_product_id);

ALTER TABLE conformed.dim_product
  ADD CONSTRAINT fk_dimproduct_dimretailer_2034106287
    FOREIGN KEY (dim_retailer_id) REFERENCES conformed.dim_retailer(dim_retailer_id);

ALTER TABLE conformed.dim_product
ADD CONSTRAINT akdimproductk2k3k5_2018106230
UNIQUE (dim_retailer_id, product_bkey, effective_end_date_time);


- - - - - - - - - - - - - - - -  N E W   dim   S Q L - - - - - - - - - - - - - - - 
#
# NEW version of dim.product
#
CREATE TABLE conformed.dim_product
(
      dim_product_id                                                                       BIGINT IDENTITY(-1, 1) NOT NULL ENCODE delta
    , batch_id                                                                             INT DEFAULT 1          NOT NULL ENCODE runlength
    , dim_retailer_id                                                                      BIGINT                 NOT NULL ENCODE runlength
    , product_bkey                                                                         VARCHAR(50)            NOT NULL ENCODE lzo
    , effective_start_date_time TIMESTAMP DEFAULT '2007-01-01 00:00:00'::TIMESTAMP without TIME zone              NOT NULL ENCODE runlength
    , effective_end_date_time TIMESTAMP DEFAULT '2500-01-01 00:00:00'::TIMESTAMP without   TIME zone              NOT NULL ENCODE lzo
    , product_name                                                                         VARCHAR(100)           NOT NULL ENCODE lzo
    , product_description                                                                  VARCHAR(512)                    ENCODE lzo
    , product_sku_code                                                                     VARCHAR(50)                     ENCODE lzo
    , product_size                                                                         VARCHAR(20)                     ENCODE lzo
    , product_colour_code                                                                  CHAR(10)                        ENCODE lzo
    , product_colour                                                                       VARCHAR(50)                     ENCODE lzo
    , product_gender                                                                       CHAR(10)                        ENCODE lzo
    , product_age_group                                                                    VARCHAR(50)                     ENCODE lzo
    , brand_name                                                                           VARCHAR(100)                    ENCODE lzo
    , supplier_name                                                                        VARCHAR(50)                     ENCODE lzo
    , product_status                                                                       VARCHAR(10)                     ENCODE lzo
    , planned_end_date                                                                     DATE
    , PRIMARY KEY(dim_product_id)
    , FOREIGN KEY (dim_retailer_id) REFERENCES conformed.dim_retailer(dim_retailer_id)
    , UNIQUE (dim_retailer_id, product_bkey, effective_end_date_time)
)
DISTKEY(product_bkey)
INTERLEAVED SORTKEY(product_bkey, dim_product_id)
;


