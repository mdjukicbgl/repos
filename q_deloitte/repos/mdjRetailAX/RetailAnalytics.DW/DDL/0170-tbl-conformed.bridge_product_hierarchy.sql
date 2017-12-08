CREATE TABLE IF NOT EXISTS conformed.bridge_product_hierarchy (
    batch_id numeric(10, 0) not null default 1,
    dim_product_id int8 not null,
    dim_hierarchy_node_id int8 not null,
    effective_start_date_time timestamp not null default '2007-01-01 00:00:00'::timestamp without time zone,
    effective_end_date_time timestamp not null default '2500-01-01 00:00:00'::timestamp without time zone,
    PRIMARY KEY (dim_product_id, dim_hierarchy_node_id, effective_end_date_time),
    FOREIGN KEY (dim_product_id) REFERENCES conformed.dim_product (dim_product_id),
    FOREIGN KEY (dim_hierarchy_node_id) REFERENCES conformed.dim_hierarchy_node (dim_hierarchy_node_id)
);