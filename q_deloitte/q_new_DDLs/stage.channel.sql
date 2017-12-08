
- - - - - - - - - - - - - - - -  C u r r e n t   Stage   D D L - - - - - - - - - - - - - - -
#
# OLD version of DDL - Channel
#
CREATE TABLE stage.channel
(
	batch_id INTEGER,
	dim_retailer_id BIGINT,
	reporting_date VARCHAR(10),
	reporting_date_period_type CHAR(1),
	channel_key VARCHAR(20),
	channel_name VARCHAR(50),
	channel_description VARCHAR(100),
	channel_code VARCHAR(10),
	row_id BIGINT IDENTITY NOT NULL
)
DISTSTYLE EVEN;


- - - - - - - - - - - - - - - -  N E W   Stage   S Q L - - - - - - - - - - - - - - -
#
# NEW version of DDL - Channel
#
CREATE TABLE stage.channel
(
      batch_id                   INT 		      NOT NULL DEFAULT 1 -- will be updated within the framework script via the ##BATCH_ID## tag
    , dim_retailer_id            BIGINT                              -- Lookup to be performed upon ClientName portion of source_file_name column     
    , reporting_date             DATE
    , reporting_date_period_type CHAR(1)
    , channel_bkey               VARCHAR(20)
    , channel_name               VARCHAR(50)
    , channel_description        VARCHAR(100)
    , channel_code               VARCHAR(10)
    , row_id                     BIGINT IDENTITY  NOT NULL
    , PRIMARY KEY(channel_bkey)
)
DISTKEY(channel_bkey)
SORTKEY(channel_bkey)
;


- - - - - - - - - - - - - - - -  C u r r e n t   dim   S Q L - - - - - - - - - - - - - - - 
#
# OLD version of dim.channel
#
CREATE TABLE conformed.dim_channel
(
	dim_channel_id BIGINT IDENTITY(-1, 1) NOT NULL,
	dim_retailer_id BIGINT NOT NULL,
	channel_bkey VARCHAR(50) NOT NULL,
	channel_name VARCHAR(50) NOT NULL,
	channel_description VARCHAR(250),
	channel_code CHAR(10),
	PRIMARY KEY (dim_channel_id),
    FOREIGN KEY (dim_retailer_id) REFERENCES conformed.dim_retailer (dim_retailer_id)
)
DISTSTYLE EVEN;



- - - - - - - - - - - - - - - -  N E W  dim   S Q L - - - - - - - - - - - - - - -
#
# NEW version of dim.channel
#

CREATE TABLE IF NOT EXISTS conformed.dim_channel
(
      dim_channel_id             INT8 IDENTITY(-1,1)  NOT NULL
    , batch_id                   INT                  NOT NULL DEFAULT 1
    , calendar_date              DATE                 NOT NULL
    , reporting_date_period_type CHAR(1)              NOT NULL
    , dim_retailer_id            INT8                 NOT NULL
    , channel_bkey               VARCHAR(20)          NOT NULL
    , channel_name               VARCHAR(50)          NOT NULL
    , channel_description        VARCHAR(100)
    , channel_code               CHAR(10)
    , PRIMARY KEY (dim_channel_id)
    , FOREIGN KEY (dim_retailer_id) REFERENCES conformed.dim_retailer (dim_retailer_id)
)
DISTKEY(channel_bkey)
SORTKEY(channel_bkey)
;
