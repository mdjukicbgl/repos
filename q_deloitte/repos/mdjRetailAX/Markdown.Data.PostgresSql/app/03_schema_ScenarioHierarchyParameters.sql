CREATE TABLE scenario_hierarchy_parameters
(
  scenario_hierarchy_parameter_id       SERIAL  NOT NULL,
  scenario_id                           INTEGER NOT NULL,
  hierarchy_id                          INTEGER NOT NULL,
  max_flowline_stock_quantity_threshold INTEGER NOT NULL,
  CONSTRAINT pk_scenario_hierarchy_parameters PRIMARY KEY (scenario_hierarchy_parameter_id),
  CONSTRAINT fk_scenario_hierarchy_parameter_id FOREIGN KEY (scenario_id) REFERENCES scenario (scenario_id) ON DELETE CASCADE
);