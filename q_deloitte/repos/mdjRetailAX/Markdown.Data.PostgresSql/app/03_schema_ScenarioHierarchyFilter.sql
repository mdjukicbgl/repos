CREATE TABLE scenario_hierarchy_filter
(
  scenario_hierarchy_filter_id serial not null
		constraint pk_scenario_hierarchy_filter
			primary key,
	scenario_id INTEGER NOT NULL,
	hierarchy_id INTEGER NOT NULL,
  CONSTRAINT fk_scenario_hierarchy_filter_scenario_id FOREIGN KEY (scenario_id) REFERENCES scenario (scenario_id) ON DELETE CASCADE
)
;
