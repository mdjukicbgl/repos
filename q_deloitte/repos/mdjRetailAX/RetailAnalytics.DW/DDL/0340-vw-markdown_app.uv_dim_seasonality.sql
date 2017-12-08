DROP VIEW IF EXISTS markdown_app.uv_dim_seasonality;

CREATE VIEW markdown_app.uv_dim_seasonality
AS
SELECT
	dim_seasonality_id
	,batch_id
	,dim_retailer_id
	,seasonality_bkey
	,seasonality_name
FROM
	conformed.dim_seasonality;
