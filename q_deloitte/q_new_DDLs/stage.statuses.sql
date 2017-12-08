
- - - - - - - - - - - - - - - -  O L D   stage   D D L - - - - - - - - - - - - - - -

#
# OLD version of DDL - stage.statuses
#
CREATE TABLE stage.statuses
(
	batch_id INTEGER,
	dim_retailer_id INTEGER,
	reporting_date VARCHAR(10),
	reporting_date_period_type CHAR(1),
	status_type_bkey CHAR(1),
	status_bkey VARCHAR(20),
	status_name VARCHAR(50),
	is_global_status CHAR(1),
	is_unknown_member CHAR(1),
	row_id BIGINT IDENTITY NOT NULL
)
DISTSTYLE EVEN;   


- - - - - - - - - - - - - - - -  N E W   stage   D D L - - - - - - - - - - - - - - -
#
# NEW table DDL - stage.statuses
#

CREATE TABLE stage.statuses
(
      batch_id                   INT NOT NULL DEFAULT 1 -- will be updated within the framework script via the ##BATCH_ID## tag
    , dim_retailer_id            INT                    -- Lookup to be performed upon ClientName portion of source_file_name column
    , calendar_date              VARCHAR(10)
    , reporting_date_period_type CHAR(1)
    , status_type_bkey           CHAR(1)
    , status_bkey                VARCHAR(20)
    , status_name                VARCHAR(50)
    , is_global_status           CHAR(1)
    , is_unknown_member          CHAR(1)
    , row_id                     BIGINT IDENTITY NOT NULL
    , PRIMARY KEY(status_type_bkey, status_bkey)
)
DISTKEY(status_bkey)
SORTKEY(status_bkey)
;


- - - - - - - - - - - - - - - -  O L D   markdown   D D L - - - - - - - - - - - - - - -
#
# OLD version of DDL - markdown.dim_price_status
#
CREATE TABLE markdown.dim_price_status
(
	dim_price_status_id BIGINT IDENTITY(0, 1) NOT NULL,
	batch_id NUMERIC(10, 0) DEFAULT 1 NOT NULL,
	price_status_bkey VARCHAR(20) NOT NULL,
	price_status VARCHAR(50) NOT NULL,
	dim_retailer_id BIGINT ENCODE lzo,
	PRIMARY KEY (dim_price_status_id)
)
DISTSTYLE EVEN;

- - - - - - - - - - - - - - - -  N E W   markdown   D D L - - - - - - - - - - - - - - -
#
# NEW version of DDL - markdown.dim_status
#
CREATE TABLE conformed.dim_statuses
(
	dim_status_id BIGINT IDENTITY(0, 1) NOT NULL,   --check this out
	batch_id int DEFAULT 1 NOT NULL,
	dim_retailer_id BIGINT ENCODE lzo,
	calendar_date date not null
	reporting_date_period_type char(1) not NULL
	status_type_bkey char(1) not null
	status_bkey VARCHAR(20) not null
	status_name VARCHAR(50) not null
	is_global_status boolean not null
	is_unknown_member boolean not null
    PRIMARY KEY (status_type_bkey, status_bkey)
)
DISTKEY(status_bkey)
SORTKEY(status_bkey)
;


