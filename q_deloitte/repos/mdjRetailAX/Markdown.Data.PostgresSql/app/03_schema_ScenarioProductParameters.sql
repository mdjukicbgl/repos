CREATE TABLE scenario_product_parameters
(
  scenario_product_parameter_id SERIAL  NOT NULL
    CONSTRAINT pk_scenario_product_parameters PRIMARY KEY,
  scenario_id                   INTEGER NOT NULL,
  product_id                    INTEGER NOT NULL,
  hierarchy_type                VARCHAR(50),
  minimum_cover                 DECIMAL(34, 4),
  max_markdowns                 INTEGER,
  CONSTRAINT fk_scenario_product_parameter_id FOREIGN KEY (scenario_id) REFERENCES scenario (scenario_id) ON DELETE CASCADE
);