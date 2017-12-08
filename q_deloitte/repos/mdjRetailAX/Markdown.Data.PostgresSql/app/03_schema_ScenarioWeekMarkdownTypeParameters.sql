CREATE TABLE IF NOT EXISTS scenario_week_markdown_type_parameters (
  scenario_week_markdown_type_parameters_id SERIAL  NOT NULL,
  scenario_id                INTEGER NOT NULL,
  hierarchy_id               INTEGER NOT NULL,
  week                       INTEGER NOT NULL,
  markdown_type_id           INTEGER NOT NULL,
  min_discount_percentage        NUMERIC(5, 2),
  max_discount_percentage        NUMERIC(5, 2),
  CONSTRAINT pk_scenario_scenario_week_markdown_type_parameters PRIMARY KEY (scenario_week_markdown_type_parameters_id),
  CONSTRAINT fk_scenario_week_markdown_type_parameters_markdown_type_id FOREIGN KEY (markdown_type_id) REFERENCES markdown_type (markdown_type_id),
  CONSTRAINT fk_scenario_week_markdown_type_parameters_scenario_id FOREIGN KEY (scenario_id) REFERENCES scenario (scenario_id) ON DELETE CASCADE,
  CONSTRAINT uix_scenario_week_markdown_type_parameters UNIQUE (scenario_id, hierarchy_id, week, markdown_type_id)
);

