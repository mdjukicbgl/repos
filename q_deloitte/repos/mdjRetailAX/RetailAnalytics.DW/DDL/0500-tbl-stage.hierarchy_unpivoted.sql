CREATE TABLE IF NOT EXISTS stage.hierarchy_unpivoted (
    business_key varchar(255),
    hierarchy_node_b_key varchar(50),
    hierarchy_node_name varchar(254),
    hierarchy_level_description varchar(128),
    hierarchy_level numeric(10, 0),
    analytical_period_start_date date,
    analytical_period_end_date date
)