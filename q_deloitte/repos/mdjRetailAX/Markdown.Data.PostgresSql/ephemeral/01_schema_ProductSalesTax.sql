CREATE TEMP TABLE IF NOT EXISTS ephemeral.product_sales_tax (
  product_sales_tax_id SERIAL         NOT NULL,
  product_id           INTEGER        NOT NULL,
  week                 INTEGER        NOT NULL,
  rate                 DECIMAL(34, 4) NOT NULL,
  CONSTRAINT pk_product_sales_tax_id PRIMARY KEY (product_sales_tax_id),
  CONSTRAINT uix_product_sales_tax_product_id UNIQUE (product_id, week)
)
ON COMMIT DROP;

