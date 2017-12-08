CREATE TEMP TABLE IF NOT EXISTS ephemeral.product_price_changes (
  price_change_id             SERIAL         NOT NULL,
  product_id                  INTEGER        NOT NULL,
  week                        INTEGER        NOT NULL,
  quantity                    INTEGER        NOT NULL,
  previous_quantity           INTEGER        NULL,
  price                       DECIMAL(34, 4) NOT NULL,
  previous_price              DECIMAL(34, 4) NULL,
  is_md_preceded_by_promotion INT            NOT NULL,
  is_promotional_price_change INT            NOT NULL,
  is_full_price               INT            NOT NULL,
  CONSTRAINT pk_price_change PRIMARY KEY (price_change_id),
  CONSTRAINT uix_price_change UNIQUE (product_id, week)
)
ON COMMIT DROP
;

