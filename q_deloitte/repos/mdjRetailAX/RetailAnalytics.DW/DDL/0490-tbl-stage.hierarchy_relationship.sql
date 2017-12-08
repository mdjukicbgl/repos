CREATE TABLE stage.hierarchy_relationship
(	parent_hierarchy_node_id int NULL,
	child_hierarchy_node_id int NOT NULL,
	hierarchy_node_level numeric(5, 0) NOT NULL,
	business_key nvarchar(255) NOT NULL,
	is_broken bit NOT NULL,
PRIMARY KEY
(
	business_key,
	hierarchy_node_level,
	child_hierarchy_node_id
)
);