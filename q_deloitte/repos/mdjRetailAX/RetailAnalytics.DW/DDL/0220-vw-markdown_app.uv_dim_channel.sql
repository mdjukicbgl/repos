DROP VIEW IF EXISTS markdown_app.uv_dim_channel;

CREATE VIEW markdown_app.uv_dim_channel
AS
SELECT
	dim_channel_id
	,dim_retailer_id
	,channel_bkey
	,channel_name
	,channel_description
	,channel_code
FROM
	conformed.dim_channel;