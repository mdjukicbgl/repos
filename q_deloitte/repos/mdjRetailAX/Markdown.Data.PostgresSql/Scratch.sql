/*
SELECT
  pid,
  (now() - query_start) AS duration,
  query,
  state
FROM testdb.pg_catalog.pg_stat_activity
WHERE now() - pg_stat_activity.query_start > interval '5 minutes';

 SELECT pg_cancel_backend(15783);


 GRANT USAGE ON SCHEMA public TO testdb;
 GRANT SELECT ON ALL TABLES IN SCHEMA public TO testdb;
*/

-- Clear database
TRUNCATE scenario, recommendation CASCADE;

-- Create scenario
INSERT INTO scenario
(scenario_id, week, schedule_week_min, schedule_week_max, schedule_stage_min, schedule_stage_max, stage_max, stage_offset_max,
 price_floor, client_id, scenario_name, schedule_mask) VALUES
  (100, 897, 890, 897, 1, 4, NULL, NULL, NULL, 0, 'Default scenario', 255);

INSERT INTO
  scenario_hierarchy_filter (scenario_id, hierarchy_id)
VALUES
  (100, 7793),
  (100, 15874),
  (100, 15828),
  (100, 15515),
  (100, 14895),
  (100, 13207),
  (100, 11527);

INSERT INTO price_ladder
  (price_ladder_type_id, description)
VALUES
  (2, 'Unnamed country price ladder (1)'),
  (2, 'Unnamed country price ladder (2)'),
  (2, 'Unnamed country price ladder (3)');

INSERT INTO price_ladder_value (price_ladder_id, "order", value)
VALUES
    (1, 1, 0.1000),
    (1, 2, 0.1500),
    (1, 3, 0.2000),
    (1, 4, 0.2500),
    (1, 5, 0.3000),
    (1, 6, 0.3500),
    (1, 7, 0.4000),
    (1, 8, 0.4500),
    (1, 9, 0.5000),
    (1, 10, 0.5500),
    (1, 11, 0.6000),
    (1, 12, 0.6500),
    (1, 13, 0.7000),
    (1, 14, 0.7500),
    (1, 15, 0.8000),
    (1, 16, 0.8500),
    (1, 17, 0.9000),
    (1, 18, 0.9500),
    (2, 1, 0.1000),
    (2, 2, 0.1500),
    (2, 3, 0.2000),
    (2, 4, 0.2500),
    (2, 5, 0.3000),
    (2, 6, 0.3500),
    (2, 7, 0.4000),
    (2, 8, 0.4500),
    (2, 9, 0.5000),
    (2, 10, 0.5500),
    (2, 11, 0.6000),
    (2, 12, 0.6500),
    (2, 13, 0.7000),
    (2, 14, 0.7500),
    (2, 15, 0.8000),
    (2, 16, 0.8500),
    (2, 17, 0.9000),
    (2, 18, 0.9500),
    (3, 1, 0.1000),
    (3, 2, 0.1500),
    (3, 3, 0.2000),
    (3, 4, 0.2500),
    (3, 5, 0.3000),
    (3, 6, 0.3500),
    (3, 7, 0.4000),
    (3, 8, 0.4500),
    (3, 9, 0.5000),
    (3, 10, 0.5500),
    (3, 11, 0.6000),
    (3, 12, 0.6500),
    (3, 13, 0.7000),
    (3, 14, 0.7500),
    (3, 15, 0.8000),
    (3, 16, 0.8500),
    (3, 17, 0.9000),
    (3, 18, 0.9500);

INSERT INTO dashboard(dashboard_id, dashboard_layout_type_id, title)
VALUES
  (100, 1, 'Test Dashboard')
;

INSERT INTO widget(widget_id, widget_type_id)
VALUES
  (100, 1)
;

INSERT INTO widget_instance(widget_instance_id, widget_id, dashboard_id, layout_ordinal_id, title)
VALUES
  (100, 100, 100, 1, 'Scenarios')
;

-- Explore
SELECT * FROM scenario;
SELECT * FROM scenario_summary;
SELECT * FROM scenario_partition;
SELECT * FROM scenario_partition_status;
SELECT * FROM scenario_hierarchy_filter;


SELECT * FROM hierarchy LIMIT 10;



INSERT INTO
  scenario_hierarchy_filter (scenario_id, hierarchy_id)
VALUES
  (153, 7793),
  (153, 15874),
  (153, 15828),
  (153, 15515),
  (153, 14895),
  (153, 13207),
  (153, 11527);

--
-- Function refactor
--

-- function_type_id 1 = Markdown
INSERT INTO function_group (function_group_id, function_type_id, function_group_type_id, function_instance_total)
  VALUES
    (1, 1, 2, 1),
    (2, 1, 3, 2),
    (3, 1, 4, 1)
;


INSERT INTO scenario_function_group (scenario_id, function_group_id)
  VALUES
    (100, 1),
    (100, 2),
    (100, 3)
;


/*
5 - Partition starting
6 - Partition running
7 - Partition finished
8 - Partition error
 */
INSERT INTO function_instance (function_instance_number, function_group_id, function_instance_type_id, json, json_version)
  VALUES
    (1, 1, 5, '{}', 1),
    (1, 1, 6, '{}', 1),
    (1, 1, 7, '{}', 1)
;

/*
9 - Calc starting
10 - Calc running
11 - Calc finished
12 - Calc error
 */
INSERT INTO function_instance (function_instance_number, function_group_id, function_instance_type_id, json, json_version)
  VALUES
    (1, 2, 9, '{}', 1),
    (1, 2, 10, '{ "ProductCount": 123, "ProductTotal": 0 }', 1),
    (1, 2, 12, '{}', 1)
;

INSERT INTO function_instance (function_instance_number, function_group_id, function_instance_type_id, json, json_version)
  VALUES
    (1, 2, 9, '{}', 1),
    (1, 2, 10, '{ "ProductCount": 123, "ProductTotal": 0 }', 1),
    (1, 2, 12, '{}', 1)
;

INSERT INTO function_instance (function_instance_number, function_group_id, function_instance_type_id, json, json_version)
  VALUES
    (2, 2, 9, '{}', 1),
    (2, 2, 10, '{ "ProductCount": 123, "ProductTotal": 0 }', 1)
;

INSERT INTO function_instance (function_instance_number, function_group_id, function_instance_type_id, json, json_version)
  VALUES
    (1, 2, 9, '{}', 1),
    (1, 2, 10, '{ "ProductCount": 123, "ProductTotal": 123 }', 1),
    (1, 2, 11, '{}', 1)
;
/*
9 - Upload starting
10 - Upload running
11 - Upload finished
12 - Upload error
 */
INSERT INTO function_instance (function_instance_number, function_group_id, function_instance_type_id, json, json_version)
  VALUES
    (1, 3, 13, '{}', 1),
    (1, 3, 14, '{}', 1),
    (1, 3, 15, '{}', 1)
;

-- ALT

INSERT INTO scenario
(scenario_id, week, schedule_week_min, schedule_week_max, schedule_stage_min, schedule_stage_max, stage_max, stage_offset_max,
 price_floor, client_id, scenario_name, schedule_mask) VALUES
  (102, 897, 890, 897, 1, 4, NULL, NULL, NULL, 0, 'Test scenario', 255);

INSERT INTO function_group (function_group_id, function_type_id, function_group_type_id, function_instance_total)
  VALUES
    (4, 1, 2, 1)
;


INSERT INTO scenario_function_group (scenario_id, function_group_id)
  VALUES
    (101, 4)
;

INSERT INTO function_instance (function_instance_number, function_group_id, function_instance_type_id, json, json_version)
  VALUES
    (1, 4, 2, '{}', 1),

