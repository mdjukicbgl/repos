CREATE TABLE IF NOT EXISTS scenario_week_parameters (
  scenario_week_parameter_id               SERIAL  NOT NULL,
  scenario_id                              INTEGER NOT NULL,
  week                                     INTEGER NOT NULL,
  minimum_relative_percentage_price_change DECIMAL(2, 2),
  CONSTRAINT pk_scenario_week_parameter PRIMARY KEY (scenario_week_parameter_id),
  CONSTRAINT fk_scenario_week_parameter_id FOREIGN KEY (scenario_id) REFERENCES scenario (scenario_id) ON DELETE CASCADE
);

