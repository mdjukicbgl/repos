CREATE TABLE IF NOT EXISTS conformed.dim_hierarchy_node (
    dim_hierarchy_node_id int8 identity(1,1) not null,
    batch_id numeric(10, 0) not null default 1,
    dim_hierarchy_id int8 not null,
    hierarchy_node_bkey varchar(255) not null,
    parent_hierarchy_node_bkey varchar(255),
    hierarchy_node_name varchar(255) not null,
    parent_dim_hierarchy_node_id int8,
    effective_start_date_time timestamp not null default '2007-01-01 00:00:00'::timestamp without time zone,
    effective_end_date_time timestamp not null default '2500-01-01 00:00:00'::timestamp without time zone,
    hierarchy_node_level numeric(5, 0) not null default 0,
    hierarchy_breadcrumb_node_name varchar(1024) not null default ''::character varying,
    hierarchy_breadcrumb_node_id varchar(256) not null default ''::character varying,
    is_leaf_node numeric(1, 0) not null default 0,
    PRIMARY KEY (dim_hierarchy_node_id),
    FOREIGN KEY (dim_hierarchy_id) REFERENCES conformed.dim_hierarchy (dim_hierarchy_id)
);