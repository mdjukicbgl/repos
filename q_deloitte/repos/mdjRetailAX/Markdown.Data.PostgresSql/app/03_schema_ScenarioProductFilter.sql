CREATE TABLE scenario_product_filter
(
  scenario_product_filter_id SERIAL  NOT NULL
    CONSTRAINT pk_scenario_product_filter
    PRIMARY KEY,
  scenario_id                INTEGER NOT NULL,
  product_id                 INTEGER NOT NULL,
  CONSTRAINT fk_scenario_product_filter_scenario_id FOREIGN KEY (scenario_id) REFERENCES scenario (scenario_id) ON DELETE CASCADE
);