DROP VIEW IF EXISTS markdown_app.uv_dim_hierarchy_node;

CREATE VIEW markdown_app.uv_dim_hierarchy_node
AS
SELECT
	dim_hierarchy_node_id
	,batch_id
	,dim_hierarchy_id
	,hierarchy_node_bkey
	,parent_hierarchy_node_bkey
	,parent_dim_hierarchy_node_id
	,effective_start_date_time
	,effective_end_date_time
	,hierarchy_node_name
	,hierarchy_node_level
	,hierarchy_breadcrumb_node_name
	,hierarchy_breadcrumb_node_id
	,is_leaf_node
FROM
	conformed.dim_hierarchy_node;