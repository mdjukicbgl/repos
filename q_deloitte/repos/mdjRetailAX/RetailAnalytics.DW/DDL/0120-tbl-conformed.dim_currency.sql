CREATE TABLE IF NOT EXISTS conformed.dim_currency (
    dim_currency_id int8 identity (0,1)not null,
    currency varchar(50) not null,
    iso_currency_code char(3) not null,
    currency_symbol varchar(8),
    is_active numeric(1, 0) not null default 1,
    PRIMARY KEY (dim_currency_id)
);
