CREATE TABLE IF NOT EXISTS scenario_markdown_constraint (
  scenario_markdown_constraint_id SERIAL  NOT NULL,
  scenario_id                     INTEGER NOT NULL,
  week                            INTEGER NOT NULL,
  markdown_type_id                INTEGER     NULL,
  CONSTRAINT pk_scenario_markdown_constraint PRIMARY KEY (scenario_markdown_constraint_id),
  CONSTRAINT fk_scenario_markdown_constraint_markdown_type_id FOREIGN KEY (markdown_type_id) REFERENCES markdown_type (markdown_type_id),
  CONSTRAINT fk_scenario_markdown_constraint_scenario_id FOREIGN KEY (scenario_id) REFERENCES scenario (scenario_id) ON DELETE CASCADE
);

