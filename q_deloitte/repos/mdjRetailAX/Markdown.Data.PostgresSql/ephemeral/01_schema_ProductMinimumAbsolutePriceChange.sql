CREATE TEMP TABLE IF NOT EXISTS ephemeral.product_minimum_absolute_price_change (
  product_minimum_absolute_price_change SERIAL,
  product_id            INT,
  partition_number      INT,
  minimum_absolute_price_change            DECIMAL(34, 2),
  CONSTRAINT pk_eproduct_minimum_absolute_price_change PRIMARY KEY (product_minimum_absolute_price_change)
)
ON COMMIT DROP;
