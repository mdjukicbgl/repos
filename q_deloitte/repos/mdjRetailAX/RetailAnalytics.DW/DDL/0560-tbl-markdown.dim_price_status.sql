CREATE TABLE IF NOT EXISTS markdown.dim_price_status (
    dim_price_status_id int8 identity(0,1) not null,
    batch_id numeric(10, 0) not null default 1,
    dim_retailer_id int8,
    price_status_bkey varchar(20) not null,
    price_status varchar(50) not null,
    PRIMARY KEY (dim_price_status_id)
);