CREATE TABLE IF NOT EXISTS sales.dim_status (
    dim_status_id int8 identity(1,1) not null,
    batch_id numeric(10, 0) not null default 1,
    status_hierarchy_node varchar(50) not null,
    parent_dim_status_id int8,
    status_hierarchy_level numeric(5, 0) not null default 0,
    status_breadcrumb varchar(512) not null default ''::character varying,
    is_leaf_node numeric(1, 0) not null default 0,
    PRIMARY KEY (dim_status_id),
    FOREIGN KEY (parent_dim_status_id) REFERENCES sales.dim_status (dim_status_id)
);