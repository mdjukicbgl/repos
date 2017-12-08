CREATE TABLE IF NOT EXISTS sales.fact_exchange_rate (
    batch_id numeric(10, 0) not null default 1,
    dim_date_id int8 not null default 1,
    numerator_dim_currency_id int8 not null,
    denominator_dim_currency_id int8 not null,
    dim_retailer_id int8 not null,
    exchange_rate numeric(18, 10) not null,
    PRIMARY KEY (dim_date_id, numerator_dim_currency_id, denominator_dim_currency_id, dim_retailer_id),
    FOREIGN KEY (dim_date_id) REFERENCES conformed.dim_date (dim_date_id),
    FOREIGN KEY (numerator_dim_currency_id) REFERENCES conformed.dim_currency (dim_currency_id),
    FOREIGN KEY (denominator_dim_currency_id) REFERENCES conformed.dim_currency (dim_currency_id),
    FOREIGN KEY (dim_retailer_id) REFERENCES conformed.dim_retailer (dim_retailer_id)
);