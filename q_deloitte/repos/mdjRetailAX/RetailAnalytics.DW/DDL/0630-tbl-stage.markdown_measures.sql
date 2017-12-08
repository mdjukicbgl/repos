CREATE TABLE stage.markdown_measures
(
    batch_id int8 NOT NULL
  , dim_retailer_id                        INTEGER NOT NULL DEFAULT 0
  , calendar_date DATE NOT NULL
  , retailer_bkey                          VARCHAR(20) NOT NULL
  , product_bkey                           VARCHAR(20) NOT NULL
  , geography_bkey                         VARCHAR(20) NOT NULL
  , currency_bkey                          VARCHAR(20) NOT NULL
  , seasonality_bkey                       VARCHAR(20) NOT NULL
  , junk_bkey                              VARCHAR(20) NOT NULL
  , price_status_bkey                      VARCHAR(20) NOT NULL
  , channel_bkey                           VARCHAR(20) NOT NULL
  , gross_margin                           DOUBLE PRECISION NULL
  , markdown_price                         DOUBLE PRECISION NULL
  , markdown_cost                          DOUBLE PRECISION NULL
  , cost_price                             DOUBLE PRECISION NULL
  , system_price                           DOUBLE PRECISION NULL
  , selling_price                          DOUBLE PRECISION NULL
  , original_selling_price                 DOUBLE PRECISION NULL
  , optimisation_original_selling_price    DOUBLE PRECISION NULL
  , provided_selling_price                 DOUBLE PRECISION NULL
  , provided_original_selling_price        DOUBLE PRECISION NULL
  , optimisation_selling_price             DOUBLE PRECISION NULL
  , local_tax_rate                         DOUBLE PRECISION NULL
  , sales_value                            DOUBLE PRECISION NULL
  , sales_quantity                         DOUBLE PRECISION NULL
  , store_stock_value                      DOUBLE PRECISION NULL
  , store_stock_quantity                   DOUBLE PRECISION NULL
  , depot_stock_value                      DOUBLE PRECISION NULL
  , depot_stock_quantity                   DOUBLE PRECISION NULL
  , clearance_sales_value                  DOUBLE PRECISION NULL
  , clearance_sales_quantity               DOUBLE PRECISION NULL
  , promotion_sales_value                  DOUBLE PRECISION NULL
  , promotion_sales_quantity               DOUBLE PRECISION NULL
  , store_stock_value_no_negatives         DOUBLE PRECISION NULL
  , store_stock_quantity_no_negatives      DOUBLE PRECISION NULL
  , intake_plus_future_commitment_quantity DOUBLE PRECISION NULL
  , intake_plus_future_commitment_value    DOUBLE PRECISION NULL
  , total_stock_value                      DOUBLE PRECISION NULL
  , total_stock_quantity                   DOUBLE PRECISION NULL
  , row_id                                 BIGINT NOT NULL
)
DISTSTYLE EVEN
; 