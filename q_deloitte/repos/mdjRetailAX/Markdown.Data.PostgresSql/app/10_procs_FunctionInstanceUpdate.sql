-- DROP FUNCTION public.fn_function_instance_update(INTEGER, TEXT, VARCHAR, VARCHAR, INTEGER, VARCHAR, INTEGER, TEXT, INTEGER);
CREATE OR REPLACE FUNCTION fn_function_instance_update (
  -- scenario_function
  p_scenario_id               INTEGER,

  -- function_group
  p_function_type_name          VARCHAR(255),
  p_function_group_type_name    VARCHAR(255),
  p_function_version            VARCHAR(20),
  p_function_instance_total     INTEGER,

  -- function_instance
  p_function_instance_type_name VARCHAR(255),
  p_function_instance_number    INTEGER,
  p_json                        TEXT,
  p_json_version                INTEGER
)
RETURNS TABLE(
  function_group_id         INTEGER,
  function_version          VARCHAR(20),
  function_type_id          INTEGER,
  function_type             VARCHAR(255),
  function_group_type_id    INTEGER,
  function_group_type_name  VARCHAR(255),
  function_group_type_order INTEGER,
  function_instance_total   INTEGER,
  last_function_instance_id INTEGER,
  function_instance_count   INTEGER,
  timeout_count           INTEGER,
  success_count           INTEGER,
  error_count             INTEGER,
  attempt_count_min       INTEGER,
  attempt_count_avg       NUMERIC(38, 2),
  attempt_count_max       INTEGER,
  created_date            TIMESTAMPTZ
) AS $$
DECLARE
  d_function_group_id INTEGER;
  d_function_type_id INTEGER;
  d_function_group_type_id INTEGER;
  d_function_instance_type_id INTEGER;
BEGIN

  SELECT t.function_type_id INTO d_function_type_id FROM function_type t WHERE "name" ILIKE p_function_type_name;
  IF d_function_type_id IS NULL THEN
   RAISE EXCEPTION 'Unknown function_type name: %. Please check type table.', p_function_type_name;
  END IF;

  SELECT t.function_group_type_id INTO d_function_group_type_id FROM function_group_type t WHERE name ILIKE p_function_group_type_name;
  IF d_function_group_type_id IS NULL THEN
   RAISE EXCEPTION 'Unknown function_group_type name: %. Please check type table.', p_function_group_type_name;
  END IF;

  SELECT t.function_instance_type_id INTO d_function_instance_type_id FROM function_instance_type t WHERE name ILIKE p_function_instance_type_name;
  IF d_function_instance_type_id IS NULL THEN
   RAISE EXCEPTION 'Unknown function_instance_type name: %. Please check type table.', p_function_instance_type_name;
  END IF;

  IF NOT EXISTS(
    -- Check for existing function_group/scenario_function_group record
    SELECT
      slg.scenario_id,
      lg.function_group_id,
      lg.function_group_type_id
    FROM function_group lg
      JOIN scenario_function_group slg ON slg.function_group_id = lg.function_group_id
    WHERE slg.scenario_id = p_scenario_id AND lg.function_group_type_id = d_function_group_type_id
  )
  THEN
    -- Create new function_group
    INSERT INTO function_group (function_type_id, function_group_type_id, function_version, function_instance_total)
      VALUES
        (d_function_type_id, d_function_group_type_id, p_function_version, p_function_instance_total)
      RETURNING function_group.function_group_id INTO d_function_group_id;

    -- Create new scenario_function_group association
    INSERT INTO scenario_function_group(scenario_id, function_group_id)
      VALUES
        (p_scenario_id, d_function_group_id);
  ELSE
    -- Otherwise get function_group_id
    SELECT max(lg.function_group_id)
       INTO d_function_group_id
      FROM function_group lg
        JOIN scenario_function_group slg ON slg.function_group_id = lg.function_group_id
      WHERE slg.scenario_id = p_scenario_id AND lg.function_group_type_id = d_function_group_type_id;
  END IF;

  INSERT INTO function_instance (function_group_id, function_instance_type_id, function_instance_number, "json", json_version)
    VALUES (d_function_group_id, d_function_instance_type_id, p_function_instance_number, p_json::json, p_json_version);

  RETURN QUERY SELECT
     r.function_group_id,
     r.function_version,
     r.function_type_id,
     r.function_type_name,
     r.function_group_type_id,
     r.function_group_type_name,
     r.function_group_type_order,
     r.function_instance_total,
     r.last_function_instance_id,
     r.function_instance_count,
     r.timeout_count,
     r.success_count,
     r.error_count,
     r.attempt_count_min,
     r.attempt_count_avg,
     r.attempt_count_max,
     r.created_date
   FROM function_group_summary r
   WHERE r.function_group_id = d_function_group_id;
END;
$$ LANGUAGE plpgsql;
