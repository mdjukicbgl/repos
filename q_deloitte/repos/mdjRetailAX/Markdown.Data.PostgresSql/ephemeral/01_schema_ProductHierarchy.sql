CREATE TEMP TABLE IF NOT EXISTS ephemeral.product_hierarchy (
  product_hierarchy_id SERIAL NOT NULL,
  product_id           INTEGER    NOT NULL,
  hierarchy_id         INTEGER    NOT NULL,
  CONSTRAINT pk_product_hierarchy PRIMARY KEY (product_hierarchy_id)
)
ON COMMIT DROP;
