CREATE TABLE IF NOT EXISTS conformed.dim_retailer (
    dim_retailer_id int8 identity(0,1) not null,
    batch_id numeric(10, 0) not null,
    retailer_bkey varchar(20) not null default '1',
    parent_retailer_bkey varchar(20),
    retailer_name varchar(150) not null,
    parent_dim_retailer_id numeric(10, 0),
    PRIMARY KEY (dim_retailer_id),
    FOREIGN KEY (parent_dim_retailer_id) REFERENCES conformed.dim_retailer (dim_retailer_id)
);