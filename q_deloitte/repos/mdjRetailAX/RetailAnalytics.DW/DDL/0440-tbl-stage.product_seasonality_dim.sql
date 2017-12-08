drop table if exists stage.product_seasonality_dim;

create table stage.product_seasonality_dim (
    batch_id int,
    dim_retailer_id int,
    reporting_date varchar(10),
    reporting_date_period_type char(1),
    product_key1 varchar(20),
    product_key2 varchar(20),
    product_key3 varchar(20),
    product_key4 varchar(20),
    geography_type_key char(1),
    geography_key varchar(20),
    seasonality_key varchar(20),
    year_seasonality_key varchar(20),
    year_seasonality_start_date varchar(10),
    year_seasonality_end_date varchar(10),
    row_id bigint identity(1,1) not null
);
