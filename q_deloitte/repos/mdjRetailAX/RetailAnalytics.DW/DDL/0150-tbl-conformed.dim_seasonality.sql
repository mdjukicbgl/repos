CREATE TABLE IF NOT EXISTS conformed.dim_seasonality (
    dim_seasonality_id int8 identity(-1,1) not null,
    batch_id numeric(10, 0) not null default 1,
    dim_retailer_id numeric(10, 0) not null,
    seasonality_bkey varchar(50) not null,
    seasonality_name varchar(50) not null,
    PRIMARY KEY (dim_seasonality_id),
    FOREIGN KEY (dim_retailer_id) REFERENCES conformed.dim_retailer (dim_retailer_id)
);