CREATE TABLE IF NOT EXISTS price_ladder (
  price_ladder_id      SERIAL       NOT NULL  CONSTRAINT pk_price_ladder PRIMARY KEY,
  price_ladder_type_id INT          NOT NULL,
  description          VARCHAR(255) NOT NULL,

  CONSTRAINT fk_price_ladder_type_id FOREIGN KEY (price_ladder_type_id) REFERENCES price_ladder_type (price_ladder_type_id)
);

