CREATE TABLE IF NOT EXISTS price_ladder_value (
  price_ladder_value_id SERIAL          NOT NULL,
  price_ladder_id       INTEGER         NOT NULL,
  "order"               INTEGER         NOT NULL,
  value                 DECIMAL(34, 4)  NULL,
  CONSTRAINT pk_price_ladder_value PRIMARY KEY (price_ladder_value_id),
  CONSTRAINT fk_price_ladder_id FOREIGN KEY (price_ladder_id) REFERENCES price_ladder (price_ladder_id)
);
