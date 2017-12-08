CREATE TABLE IF NOT EXISTS scenario_summary_status_type (
  scenario_summary_status_type_id SERIAL       NOT NULL,
  name                    VARCHAR(255) NOT NULL,
  CONSTRAINT pk_scenario_summary_status_type PRIMARY KEY (scenario_summary_status_type_id)
);

INSERT INTO scenario_summary_status_type (scenario_summary_status_type_id, name)
VALUES
  (0, 'None'),
  (1, 'New'),
  (2, 'Running'),
  (3, 'Complete'),
  (4, 'Failed');