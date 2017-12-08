CREATE TABLE IF NOT EXISTS stage.node (
    hierarchy_node_id int8 identity(1,1) not null,
    hierarchy_node_b_key varchar(50),
    hierarchy_node_name varchar(128) not null,
    hierarchy_node_level numeric(5, 0) not null default 0,
    is_duplicate_bkey numeric(1, 0) not null default 0,
    PRIMARY KEY (hierarchy_node_id)
    );
