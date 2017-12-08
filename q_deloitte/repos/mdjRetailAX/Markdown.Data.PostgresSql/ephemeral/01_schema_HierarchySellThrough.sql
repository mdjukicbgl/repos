CREATE TEMP TABLE IF NOT EXISTS ephemeral.hierarchy_sell_through (
  hierarchy_sell_through_id SERIAL         NOT NULL,
  hierarchy_id              INTEGER        NOT NULL,
  value                     DECIMAL(34, 4) NOT NULL,
  CONSTRAINT pk_hierarchy_sell_through PRIMARY KEY (hierarchy_sell_through_id),
  CONSTRAINT uix_hierarchy_sell_through_hierarchy_id UNIQUE (hierarchy_id)
)
ON COMMIT DROP;
