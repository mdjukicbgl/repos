
CREATE TABLE IF NOT EXISTS stage.stock_measures
    (
        row_id                           BIGINT NOT NULL  ENCODE zstd
      , batch_id                         INTEGER NOT NULL ENCODE lzo
      , dim_retailer_id                  INTEGER NOT NULL ENCODE lzo 
      , reporting_date                   DATE             ENCODE lzo
      , reporting_date_period_type       SMALLINT         ENCODE lzo
      , location_bkey                    VARCHAR(20)      ENCODE lzo
      , product_bkey1                    VARCHAR(20)      ENCODE lzo
      , product_bkey2                    VARCHAR(20)      ENCODE lzo
      , product_bkey3                    VARCHAR(20)      ENCODE lzo
      , product_bkey4                    VARCHAR(20)      ENCODE lzo
      , product_status_key               VARCHAR(20)      ENCODE lzo
      , iso_currency_code                CHAR(3)          ENCODE lzo
      , stock_value                      DOUBLE PRECISION ENCODE zstd
      , stock_quantity                   INTEGER          ENCODE lzo
      , stock_cost                       DOUBLE PRECISION ENCODE zstd
      , cost_price                       DOUBLE PRECISION ENCODE zstd
      , future_commitment_stock_value    DOUBLE PRECISION ENCODE zstd
      , future_commitment_stock_quantity INTEGER          ENCODE zstd
      , future_commitment_stock_cost     DOUBLE PRECISION ENCODE zstd
      , intake_stock_value               DOUBLE PRECISION ENCODE zstd
      , intake_stock_quantity            DOUBLE PRECISION ENCODE zstd
      , intake_stock_cost                DOUBLE PRECISION ENCODE zstd
      , transit_stock_value              DOUBLE PRECISION ENCODE zstd
      , transit_stock_quantity           DOUBLE PRECISION ENCODE zstd
      , transit_stock_cost               DOUBLE PRECISION ENCODE zstd
    )
    DISTSTYLE EVEN
;
