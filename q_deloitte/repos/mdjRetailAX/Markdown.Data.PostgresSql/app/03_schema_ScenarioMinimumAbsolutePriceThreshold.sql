CREATE TABLE IF NOT EXISTS scenario_minimum_absolute_price_change (
  scenario_minimum_absolute_price_change_id     SERIAL         NOT NULL,
  scenario_id                                   INTEGER        NOT NULL,
  original_selling_price_threshold              DECIMAL(34, 4) NULL,
  minimum_absolute_price_change_above_threshold DECIMAL(34, 4) NULL,
  minimum_absolute_price_change_below_threshold DECIMAL(34, 4) NULL,

  CONSTRAINT pk_scenario_minimum_absolute_price_change PRIMARY KEY (scenario_minimum_absolute_price_change_id),
  CONSTRAINT fk_scenario_minimum_absolute_price_change FOREIGN KEY (scenario_id) REFERENCES scenario (scenario_id) ON DELETE CASCADE
);

