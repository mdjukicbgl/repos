CREATE TABLE scenario_function_group (
  scenario_function_group_id        SERIAL                            NOT NULL,
  scenario_id                     INTEGER                           NOT NULL,
  function_group_id                 INTEGER                           NOT NULL,

  CONSTRAINT pk_scenario_function_group PRIMARY KEY (scenario_function_group_id),
  CONSTRAINT fk_scenario_function_group_scenario FOREIGN KEY (scenario_id) REFERENCES scenario (scenario_id),
  CONSTRAINT fk_scenario_function_group_function_group FOREIGN KEY (function_group_id) REFERENCES function_group (function_group_id),
  CONSTRAINT uix_scenario_function_group_scenario_group UNIQUE (scenario_id, function_group_id)
);
