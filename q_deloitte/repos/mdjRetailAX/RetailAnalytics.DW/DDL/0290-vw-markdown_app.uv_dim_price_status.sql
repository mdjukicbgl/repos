DROP VIEW IF EXISTS markdown_app.uv_dim_price_status;

CREATE VIEW markdown_app.uv_dim_price_status
AS
SELECT
	dim_price_status_id
	,batch_id
	,price_status_bkey
	,price_status
FROM
	markdown.dim_price_status;