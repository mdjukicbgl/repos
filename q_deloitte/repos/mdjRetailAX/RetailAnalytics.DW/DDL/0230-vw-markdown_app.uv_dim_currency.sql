DROP VIEW IF EXISTS markdown_app.uv_dim_currency;

CREATE VIEW markdown_app.uv_dim_currency
AS
SELECT
	dim_currency_id
	,currency
	,iso_currency_code
	,currency_symbol
	,is_active
FROM
	conformed.dim_currency
WHERE
	is_active = 1;
