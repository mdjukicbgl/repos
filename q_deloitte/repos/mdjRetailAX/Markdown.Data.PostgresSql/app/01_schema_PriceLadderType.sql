CREATE TABLE IF NOT EXISTS price_ladder_type (
  price_ladder_type_id  SERIAL       NOT NULL,
  description           VARCHAR(255) NOT NULL,
  CONSTRAINT pk_price_ladder_type PRIMARY KEY (price_ladder_type_id)
);

INSERT INTO price_ladder_type (price_ladder_type_id, description)
VALUES
  (0, 'None'),
  (1, 'Fixed'),
  (2, 'Percent');