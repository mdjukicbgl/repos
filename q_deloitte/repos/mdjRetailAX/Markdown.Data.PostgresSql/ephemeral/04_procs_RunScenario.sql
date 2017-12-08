CREATE OR REPLACE FUNCTION ephemeral.run_scenario(p_scenario_id INTEGER)
RETURNS void
AS $$

DECLARE p_model_run_id INTEGER;
DECLARE p_schedule_week_min INTEGER;
DECLARE p_schedule_week_max INTEGER;
DECLARE p_schedule_stage_min INTEGER;
DECLARE p_schedule_stage_max INTEGER;
DECLARE p_stage_max INTEGER;
DECLARE p_stage_offset_max INTEGER;
DECLARE p_price_floor DECIMAL(38, 4);
DECLARE p_allow_promo_as_markdown BOOLEAN;
DECLARE p_minimum_promo_percentage DECIMAL(5,4);

BEGIN

  SELECT model_run_id INTO p_model_run_id FROM model_run ORDER BY model_run_id DESC FETCH FIRST 1 ROWS ONLY;
  SELECT schedule_week_min INTO p_schedule_week_min FROM scenario WHERE scenario_id = p_scenario_id;
  SELECT schedule_week_max INTO p_schedule_week_max FROM scenario WHERE scenario_id = p_scenario_id;
  SELECT schedule_stage_min INTO p_schedule_stage_min FROM scenario WHERE scenario_id = p_scenario_id;
  SELECT schedule_stage_max INTO p_schedule_stage_max FROM scenario WHERE scenario_id = p_scenario_id;
  SELECT stage_max INTO p_stage_max FROM scenario WHERE scenario_id = p_scenario_id;
  SELECT stage_offset_max INTO p_stage_offset_max FROM scenario WHERE scenario_id = p_scenario_id;
  SELECT price_floor INTO p_price_floor FROM scenario WHERE scenario_id = p_scenario_id;
  SELECT allow_promo_as_markdown INTO p_allow_promo_as_markdown FROM scenario WHERE scenario_id = p_scenario_id;
  SELECT minimum_promo_percentage INTO p_minimum_promo_percentage FROM scenario WHERE scenario_id = p_scenario_id;
END;

$$ LANGUAGE  plpgsql;

