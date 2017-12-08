
CREATE TABLE IF NOT EXISTS markdown.fact_weekly_sales_markdown
(
          batch_id            INTEGER DEFAULT 1 NOT NULL ENCODE lzo
        , dim_date_id         INTEGER DEFAULT 1 NOT NULL ENCODE lzo
        , dim_retailer_id     INTEGER NOT NULL ENCODE lzo
        , dim_product_id      BIGINT NOT NULL ENCODE lzo
        , dim_geography_id    INTEGER NOT NULL ENCODE lzo
        , dim_currency_id     SMALLINT NOT NULL ENCODE lzo
        , dim_seasonality_id  INTEGER NOT NULL ENCODE lzo
        , dim_junk_id         SMALLINT NOT NULL ENCODE lzo
        , dim_price_status_id SMALLINT NOT NULL ENCODE lzo
        , dim_channel_id      INTEGER NOT NULL ENCODE lzo
        , gross_margin DOUBLE PRECISION 
        , markdown_price DOUBLE PRECISION 
        , markdown_cost DOUBLE PRECISION 
        , cost_price DOUBLE PRECISION 
        , system_price DOUBLE PRECISION 
        , selling_price DOUBLE PRECISION 
        , original_selling_price DOUBLE PRECISION 
        , optimisation_original_selling_price DOUBLE PRECISION 
        , provided_selling_price DOUBLE PRECISION 
        , provided_original_selling_price DOUBLE PRECISION 
        , optimisation_selling_price DOUBLE PRECISION 
        , local_tax_rate DOUBLE PRECISION 
        , sales_value DOUBLE PRECISION 
        , sales_quantity DOUBLE PRECISION 
        , store_stock_value DOUBLE PRECISION 
        , store_stock_quantity DOUBLE PRECISION 
        , depot_stock_value DOUBLE PRECISION 
        , depot_stock_quantity DOUBLE PRECISION 
        , clearance_sales_value DOUBLE PRECISION 
        , clearance_sales_quantity DOUBLE PRECISION 
        , promotion_sales_value DOUBLE PRECISION 
        , promotion_sales_quantity DOUBLE PRECISION 
        , store_stock_value_no_negatives DOUBLE PRECISION 
        , store_stock_quantity_no_negatives DOUBLE PRECISION 
        , intake_plus_future_commitment_quantity DOUBLE PRECISION 
        , intake_plus_future_commitment_value DOUBLE PRECISION 
        , total_stock_value DOUBLE PRECISION 
        , total_stock_quantity DOUBLE PRECISION 
        , PRIMARY KEY (dim_date_id, dim_product_id, dim_geography_id, dim_seasonality_id, dim_channel_id)
        , FOREIGN KEY (dim_junk_id) REFERENCES sales.dim_junk(dim_junk_id)
        , FOREIGN KEY (dim_product_id) REFERENCES conformed.dim_product(dim_product_id)
        , FOREIGN KEY (dim_retailer_id) REFERENCES conformed.dim_retailer(dim_retailer_id)
        , FOREIGN KEY (dim_seasonality_id) REFERENCES conformed.dim_seasonality(dim_seasonality_id)
        , FOREIGN KEY (dim_channel_id) REFERENCES conformed.dim_channel(dim_channel_id)
        , FOREIGN KEY (dim_geography_id) REFERENCES conformed.dim_geography(dim_geography_id)
        , FOREIGN KEY (dim_currency_id) REFERENCES conformed.dim_currency(dim_currency_id)
        , FOREIGN KEY (dim_date_id) REFERENCES conformed.dim_date(dim_date_id)
)
DISTKEY(dim_date_id)
SORTKEY(
          dim_date_id
        , dim_product_id
        , dim_geography_id
        , dim_seasonality_id
        , dim_channel_id
)
;
