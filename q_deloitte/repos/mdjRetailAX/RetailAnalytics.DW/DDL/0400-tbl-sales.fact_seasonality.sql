CREATE TABLE IF NOT EXISTS sales.fact_seasonality (
    batch_id numeric(10, 0) not null default 1,
    dim_date_id int8 not null default 1,
    dim_retailer_id int8 not null,
    dim_product_id int8 not null,
    dim_seasonality_id int8 not null,
    dim_geography_id int8 not null,
    PRIMARY KEY (dim_date_id, dim_retailer_id, dim_product_id, dim_seasonality_id, dim_geography_id),
    FOREIGN KEY (dim_date_id) REFERENCES conformed.dim_date (dim_date_id),
    FOREIGN KEY (dim_retailer_id) REFERENCES conformed.dim_retailer (dim_retailer_id),
    FOREIGN KEY (dim_product_id) REFERENCES conformed.dim_product (dim_product_id),
    FOREIGN KEY (dim_seasonality_id) REFERENCES conformed.dim_seasonality (dim_seasonality_id),
    FOREIGN KEY (dim_geography_id) REFERENCES conformed.dim_geography (dim_geography_id)
);