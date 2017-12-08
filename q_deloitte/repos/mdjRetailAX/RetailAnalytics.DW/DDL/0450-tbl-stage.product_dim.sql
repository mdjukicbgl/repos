drop table if exists stage.product_dim;

create table stage.product_dim (
    batch_id int,
    dim_retailer_id int,
    reporting_date varchar(10),
    reporting_date_period_type char(1),
    product_key1 varchar(20),
    product_key2 varchar(20),
    product_key3 varchar(20),
    product_key4 varchar(20),
    product_name varchar(50),
    product_description varchar(512),
    product_sku_code varchar(20),
    product_size varchar(20),
    product_colour_code varchar(20),
    product_colour varchar(50),
    product_gender varchar(10),
    product_age_group varchar(50),
    brand_name varchar(100),
    supplier_name varchar(50),
    product_status varchar(30),
    row_id  bigint identity(1,1) not null
);
