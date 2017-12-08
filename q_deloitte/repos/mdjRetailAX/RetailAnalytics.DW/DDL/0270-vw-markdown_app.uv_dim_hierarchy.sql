DROP VIEW IF EXISTS markdown_app.uv_dim_hierarchy;

CREATE VIEW markdown_app.uv_dim_hierarchy
AS
SELECT
	dim_hierarchy_id
	,batch_id
	,dim_retailer_id
	,hierarchy_name
FROM
	conformed.dim_hierarchy;
