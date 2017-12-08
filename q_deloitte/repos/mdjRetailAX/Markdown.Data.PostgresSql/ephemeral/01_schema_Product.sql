CREATE TEMP TABLE IF NOT EXISTS ephemeral.product (
  product_id             SERIAL         NOT NULL,
  name                   VARCHAR(128)   NOT NULL,
  original_selling_price DECIMAL(34, 4) NOT NULL,
  CONSTRAINT pk_product PRIMARY KEY (product_id)
)
ON COMMIT DROP;

