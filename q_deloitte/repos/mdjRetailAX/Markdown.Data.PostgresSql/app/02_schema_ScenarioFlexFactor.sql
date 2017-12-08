CREATE TABLE IF NOT EXISTS scenario_flex_factor
(
	scenario_id integer not null,
	hierarchy_id integer not null,
    week integer not null,
    flex_factor numeric(5,2) not null
);
