CREATE TABLE sales.fact_weekly_stock
(
    batch_id                          INTEGER  NOT NULL DEFAULT 1 ENCODE lzo
  , dim_date_id                       INTEGER  NOT NULL DEFAULT 1 ENCODE lzo
  , dim_retailer_id                   INTEGER  NOT NULL           ENCODE lzo
  , dim_product_id                    BIGINT   NOT NULL           ENCODE lzo
  , dim_geography_id                  INTEGER  NOT NULL           ENCODE lzo
  , dim_currency_id                   SMALLINT NOT NULL           ENCODE lzo
  , stock_value                       DOUBLE PRECISION            ENCODE zstd
  , stock_quantity                    INTEGER                     ENCODE lzo
  , stock_cost                        DOUBLE PRECISION            ENCODE zstd
  , cost_price                        DOUBLE PRECISION            ENCODE zstd
  , future_commitment_stock_value     DOUBLE PRECISION            ENCODE zstd
  , future_commitment_stock_quantity  INTEGER                     ENCODE lzo
  , future_commitment_stock_cost      DOUBLE PRECISION            ENCODE zstd
  , intake_stock_value                DOUBLE PRECISION            ENCODE zstd
  , intake_stock_quantity             DOUBLE PRECISION            ENCODE zstd
  , intake_stock_cost                 DOUBLE PRECISION            ENCODE zstd
  , transit_stock_value               DOUBLE PRECISION            ENCODE zstd
  , transit_stock_quantity            DOUBLE PRECISION            ENCODE zstd
  , transit_stock_cost                DOUBLE PRECISION            ENCODE zstd
)
DISTSTYLE EVEN
;