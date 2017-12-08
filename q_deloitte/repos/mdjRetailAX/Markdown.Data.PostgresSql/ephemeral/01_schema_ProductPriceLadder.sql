CREATE TEMP TABLE IF NOT EXISTS ephemeral.product_price_ladder (
  product_id              INTEGER    NOT NULL,
  partition_number        INTEGER    NOT NULL,
  price_ladder_id         INTEGER    NOT NULL
)
ON COMMIT DROP;