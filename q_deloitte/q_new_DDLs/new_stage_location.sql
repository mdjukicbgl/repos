
- - - - - - - - - - - - - - - -  C u r r e n t   D D L - - - - - - - - - - - - - - -
#
# Current version of DDL - geography
#
create table stage.geography (
    batch_id int,
    dim_retailer_id int,
    reporting_date varchar(10),
    reporting_date_period_type char(1),
    geography_type_key char(1),
    geography_key varchar(20),
    geographical_location_name varchar(100),
    geographical_location_description varchar(256),
    geographical_location_status varchar(100),
    geographical_location_county_state varchar(100),
    geographical_location_country varchar(100),
    geographical_location_region varchar(100),
    geographical_location_subregion varchar(100),
    longitude varchar(50),
    latitude varchar(50),
    row_id bigint identity(1,1) not null
);

- - - - - - - - - - - - - - - -  O u t p u t   S Q L - - - - - - - - - - - - - - -
#
# NEW table DDL - location
#
CREATE TABLE stage.location
(
        batch_id                   INT          NOT NULL DEFAULT 1  -- will be updated within the framework script via the ##BATCH_ID## tag
      , reporting_date             VARCHAR(10)  NOT NULL
      , reporting_date_period_type CHAR(1) NOT  NULL
      , location_bkey              VARCHAR(20)  NOT NULL
      , location_name              VARCHAR(100) NOT NULL
      , location_description       VARCHAR(256)
      , location_subtype           VARCHAR(30)
      , location_status            VARCHAR(100)
      , city_town                  VARCHAR(100)
      , county_state               VARCHAR(100)
      , country                    VARCHAR(100)
      , region                     VARCHAR(100)
      , subregion                  VARCHAR(100)
      , longitude                  FLOAT
      , latitude                   FLOAT
      , trading_start_date         DATE
      , trading_end_date           DATE
      , location_status            VARCHAR(20)
      , default_cluster            VARCHAR(30)
      , building_floor_space       FLOAT
      , stock_allocation_grade     VARCHAR(10)
      , PRIMARY KEY (location_bkey)
)
distkey(location_bkey)
sortkey(location_bkey)
;

#
# Notes: We need to incorporate the following columns within the staging table:
#
# - batch_id --> passed via env variable
# - dim_retailer_id --> use the Client Name within the filename to extract this and lookup against 
# - row_id --> identity column 
#
# If so, do we need a second stageing table to hold these missing elements??
#


- - - - - - - - - - - - - - - -  C u r r e n t   D D L - - - - - - - - - - - - - - -
#
# Current dim_geography table 
#

CREATE TABLE conformed.dim_geography
(
    dim_geography_id                                                                     BIGINT IDENTITY(-1, 1) NOT NULL
  , batch_id                                                                             BIGINT DEFAULT 1 NOT NULL
  , dim_retailer_id                                                                      BIGINT NOT NULL
  , geography_bkey                                                                       VARCHAR(20) NOT NULL
  , geography_type_bkey                                                                  VARCHAR(20) DEFAULT '0'::CHARACTER VARYING NOT NULL
  , effective_start_date_time TIMESTAMP DEFAULT '2007-01-01 00:00:00'::TIMESTAMP without TIME zone NOT NULL
  , effective_end_date_time   TIMESTAMP DEFAULT '2500-01-01 00:00:00'::TIMESTAMP without TIME zone NOT NULL
  , geography_type                                                                       VARCHAR(20) DEFAULT 'Unknown'::CHARACTER VARYING NOT NULL
  , geography_name                                                                       VARCHAR(100) NOT NULL
  , city_name                                                                            VARCHAR(50)
  , country_name                                                                         VARCHAR(50)
  , region_name                                                                          VARCHAR(50)
  , longitude_position                                                                   VARCHAR(50)
  , latitude_position                                                                    VARCHAR(50)
)
DISTSTYLE EVEN
;


- - - - - - - - - - - - - - - -  O u t p u t   S Q L - - - - - - - - - - - - - - -
#
# NEW dim_geography table 
#

CREATE TABLE conformed.dim_location
(
        batch_id                    INT         NOT NULL DEFAULT 1  -- will be updated within the framework script via the ##BATCH_ID## tag
      , dim_retailer_id             INT   -- Lookup to be performed upon ClientName portion of source_file_name column
      , reporting_date              VARCHAR(10)  NOT NULL
      , reporting_date_period_type  CHAR(1) NOT  NULL
      , location_bkey               VARCHAR(20)  NOT NULL
      , location_name               VARCHAR(100) NOT NULL
      , location_description        VARCHAR(256)
      , location_subtype            VARCHAR(30)
      , location_status             VARCHAR(100)
      , city_town                   VARCHAR(100)
      , county_state                VARCHAR(100)
      , country                     VARCHAR(100)
      , region                      VARCHAR(100)
      , subregion                   VARCHAR(100)
      , longitude                   FLOAT
      , latitude                    FLOAT
      , trading_start_date          DATE
      , trading_end_date            DATE
      , location_status             VARCHAR(20)
      , default_cluster             VARCHAR(30)
      , building_floor_space        FLOAT
      , stock_allocation_grade      VARCHAR(10)
      , row_id                      BIGINT IDENTITY(1,1) NOT NULL  -- introduced as part of transformation 
      , PRIMARY KEY (location_bkey)
)
distkey(location_bkey)
sortkey(location_bkey)
;








