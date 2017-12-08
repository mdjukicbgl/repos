
  CREATE TABLE IF NOT EXISTS stage.currency_dim ( 
	row_id               int identity(1,1) NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	reporting_date       date  NOT NULL ,
	reporting_date_period_type smallint  NOT NULL ,
	currency_bkey        varchar(20)  NOT NULL ,
	currency             varchar(50)  NOT NULL ,
	iso_currency_code    char(3)  NOT NULL ,
	currency_symbol      varchar(4)   ,
	is_active            bool DEFAULT 1 NOT NULL 
 );

--drop table conformed.dim_currency cascade
 
CREATE TABLE IF NOT EXISTS conformed.dim_currency ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_currency_id      integer identity(1,1) NOT NULL ,
	currency_bkey        varchar(20)  NOT NULL ,
	currency             varchar(50)  NOT NULL ,
	iso_currency_code    char(3)  NOT NULL ,
	currency_symbol      varchar(4)   ,
	is_active            bool DEFAULT 1 NOT NULL ,
	CONSTRAINT pk_dim_currency PRIMARY KEY ( dim_currency_id )
 )  COMPOUND SORTKEY (dim_currency_id, iso_currency_code, currency_bkey, is_active, batch_id);


BEGIN TRANSACTION;

----------------------------------------------------------------------------------------------------------
-- update dim_currency.....
----------------------------------------------------------------------------------------------------------
UPDATE
    conformed.dim_currency
SET currency          = changed_currency.currency
  , iso_currency_code = changed_currency.iso_currency_code
  , currency_symbol   = changed_currency.currency_symbol
  , is_active         = changed_currency.is_active
FROM (
  SELECT
       sc.currency_bkey
     , sc.currency
     , sc.iso_currency_code
     , sc.currency_symbol
     , sc.is_active
  FROM
       stage.currency_dim sc
      JOIN
           conformed.dim_currency dc
        ON
           sc.currency_bkey     = dc.currency_bkey
       AND
           (
               sc.currency          <> dc.currency
            OR sc.iso_currency_code <> dc.iso_currency_code
            OR sc.currency_symbol   <> dc.currency_symbol
            OR sc.is_active         <> dc.is_active
           )
 WHERE
       sc.batch_id = ##BATCH_ID##
     ) changed_currency
WHERE
      dim_currency.currency_bkey = changed_currency.currency_bkey
;

----------------------------------------------------------------------------------------------------------
-- insert dim_currency.....
----------------------------------------------------------------------------------------------------------
INSERT  INTO conformed.dim_currency
(
    batch_id
  , currency_bkey
  , currency
  , iso_currency_code
  , currency_symbol
  , is_active
)
SELECT
    ##BATCH_ID## AS batch_id
  , currency_bkey
  , currency
  , iso_currency_code
  , currency_symbol
  , is_active
FROM
    stage.currency_dim sc
WHERE
    NOT EXISTS
    (
     SELECT  *
       FROM
            conformed.dim_currency dc
      WHERE
            dc.currency_bkey = sc.currency_bkey
    )
    AND sc.batch_id = ##BATCH_ID##
;

