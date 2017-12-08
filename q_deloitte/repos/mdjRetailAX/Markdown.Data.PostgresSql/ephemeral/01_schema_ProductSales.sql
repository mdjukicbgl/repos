CREATE TEMP TABLE IF NOT EXISTS ephemeral.product_sales (
  product_sales_id                    SERIAL         NOT NULL,
  product_id                          INTEGER        NOT NULL,
  week                                INTEGER        NOT NULL,
  price                               DECIMAL(34, 4) NOT NULL,
  quantity                            INTEGER        NOT NULL,
  stock                               INTEGER        NOT NULL,
  intake_plus_future_commitment_stock INTEGER        NOT NULL,
  cost_price                          DECIMAL(34, 4) NOT NULL,
  price_status                        VARCHAR(50)    NOT NULL,
  price_status_id                     INT            NOT NULL,
  previous_price_status               VARCHAR(50)    NULL,
  previous_price_status_id            INT            NULL,
  CONSTRAINT pk_product_sales PRIMARY KEY (product_sales_id)
)
ON COMMIT DROP;