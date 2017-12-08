CREATE TABLE IF NOT EXISTS stage.hierarchy_node (
    hierarchy_node_bkey varchar(50) not null,
    parent_hierarchy_node_bkey varchar(50),
    hierarchy_node_name varchar(128) not null,
    hierarchy_node_level numeric(5, 0),
    hierarchy_breadcrumb varchar(1024),
    is_leaf_node numeric(1, 0),
    PRIMARY KEY (hierarchy_node_bkey),
    FOREIGN KEY (parent_hierarchy_node_bkey) REFERENCES stage.hierarchy_node (hierarchy_node_bkey)
)