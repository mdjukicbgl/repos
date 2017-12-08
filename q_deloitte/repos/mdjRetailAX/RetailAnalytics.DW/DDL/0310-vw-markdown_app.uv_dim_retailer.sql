DROP VIEW IF EXISTS markdown_app.uv_dim_retailer;

CREATE VIEW markdown_app.uv_dim_retailer
AS
SELECT
	dim_retailer_id
	,batch_id
	,retailer_bkey
	,parent_retailer_bkey
	,retailer_name
	,parent_dim_retailer_id
FROM
	conformed.dim_retailer;
