CREATE TEMP TABLE IF NOT EXISTS ephemeral.extrapolated_product_sales_final (
  week                  INT,
  product_id            INT,
  price                 DECIMAL(34, 2),
  quantity              INT,
  stock                 INT,
  cost_price            DECIMAL(34, 2),
  extrapolation_type_id INT,
  CONSTRAINT pk_extrapolated_product_sales_final PRIMARY KEY (week, product_id)
)
ON COMMIT DROP;
