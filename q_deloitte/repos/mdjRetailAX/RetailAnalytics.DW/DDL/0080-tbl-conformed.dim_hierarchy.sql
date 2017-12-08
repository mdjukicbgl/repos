CREATE TABLE IF NOT EXISTS conformed.dim_hierarchy (
    dim_hierarchy_id int8 identity(-1,1) not null,
    batch_id numeric(10, 0) not null default 1,
    dim_retailer_id numeric(10, 0) not null default 1,
    hierarchy_name varchar(255) not null,
    PRIMARY KEY (dim_hierarchy_id),
    FOREIGN KEY (dim_retailer_id) REFERENCES conformed.dim_retailer (dim_retailer_id)
);