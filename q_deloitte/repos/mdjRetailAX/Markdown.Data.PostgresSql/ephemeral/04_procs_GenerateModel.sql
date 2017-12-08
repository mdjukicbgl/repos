CREATE OR REPLACE FUNCTION ephemeral.generate_model(p_model_id INTEGER)
RETURNS SETOF refcursor
AS $$
DECLARE
  ref_model refcursor;
  ref_decay_hierarchy refcursor;
  ref_elasticity_hierarchy refcursor;

  p_model_run_id INTEGER;
  p_model_week INTEGER;

  p_stage_max INTEGER;
  p_stage_offset_max INTEGER;
  p_decay_min DECIMAL(34, 4);
  p_decay_max DECIMAL(34, 4);
  p_decay_default DECIMAL(34, 4);
  p_elasticity_min DECIMAL(34, 4);
  p_elasticity_max DECIMAL(34, 4);
  p_elasticity_default DECIMAL(34, 4);

  d_row_count INTEGER;
BEGIN
  RAISE NOTICE '[generate_model] Generate Model Started';

  SELECT stage_max INTO p_stage_max FROM model WHERE model_id = p_model_id;
  SELECT stage_offset_max INTO p_stage_offset_max FROM model WHERE model_id = p_model_id;
  SELECT decay_min INTO p_decay_min FROM model WHERE model_id = p_model_id;
  SELECT decay_max INTO p_decay_max FROM model WHERE model_id = p_model_id;
  SELECT decay_default INTO p_decay_default FROM model WHERE model_id = p_model_id;
  SELECT elasticity_min INTO p_elasticity_min FROM model WHERE model_id = p_model_id;
  SELECT elasticity_max INTO p_elasticity_max FROM model WHERE model_id = p_model_id;
  SELECT elasticity_default INTO p_elasticity_default FROM model WHERE model_id = p_model_id;

  -- Create a Model Run
  RAISE NOTICE '[generate_model] Creating Model Run (p_model_id: %)', p_model_id;
  INSERT INTO model_run (model_id) VALUES (p_model_id) RETURNING model_run_id INTO p_model_run_id;
  RAISE NOTICE '[generate_model]     p_model_run_id: %', p_model_run_id;

  -- Get the relevant week of the model (optional).
  RAISE NOTICE '[generate_model] Get model week';
  SELECT m.Week INTO p_model_week
  FROM model AS m
  JOIN model_run AS mr ON mr.model_id = m.model_id
  WHERE mr.model_run_id = p_model_run_id;
  RAISE NOTICE '[generate_model]     p_model_week: %', p_model_week;

  -- Calculate Markdown Events and Elasticities
  RAISE NOTICE '[generate_model] Calculate Events + Elasticities';
  PERFORM ephemeral.get_model_event
  (
      p_model_run_id := p_model_run_id,
      p_elasticity_default := p_elasticity_default,
      p_is_md_count := FALSE
  );

  -- Calculate Elasticity
  RAISE NOTICE '[generate_model] Calculate Elasticity Average';
  PERFORM ephemeral.get_model_elasticity_average
  (
      p_model_run_id := p_model_run_id,
      p_stage_max := p_stage_max,
      p_elasticity_default := p_elasticity_default
  );

  RAISE NOTICE '[generate_model] Calculate Elasticity Hierarchy';
  PERFORM ephemeral.get_model_elasticity_hierarchy
  (
      p_model_run_id := p_model_run_id,
      p_stage_max := p_stage_max,
      p_elasticity_default := p_elasticity_default
  );

  ---- Calculate Decay
  RAISE NOTICE '[generate_model] Calculate Model Decay';
  PERFORM ephemeral.get_model_decay
  (
      p_model_run_id := p_model_run_id,
      p_model_week := p_model_week,
      p_stage_max := p_stage_max,
      p_stage_offset_max :=
      p_stage_offset_max,
      p_decay_min := p_decay_min,
      p_decay_max := p_decay_max,
      p_decay_default := p_decay_default
  );

  RAISE NOTICE '[generate_model] Calculate Model Decay Average';
  PERFORM ephemeral.get_model_decay_average
  (
      p_model_run_id := p_model_run_id,
      p_decay_default := p_decay_default
  );

  RAISE NOTICE '[generate_model] Calculate Model Hierarchy';
  PERFORM ephemeral.get_model_decay_hierarchy
  (
      p_model_run_id := p_model_run_id,
      p_stage_max := p_stage_max,
      p_stage_offset_max := p_stage_offset_max,
      p_decay_default := p_decay_default
  );

  --
  -- Model
  --
  RAISE NOTICE '[get_scenario_data] Writing ref_model';
  OPEN ref_model FOR
  SELECT
    p_model_run_id as model_run_id,
    m.model_id,
    week,
    stage_max,
    stage_offset_max,
    decay_min,
    decay_max,
    decay_default,
    elasticity_min,
    elasticity_max,
    elasticity_default
  FROM model AS m
  JOIN model_run AS mr ON mr.model_id = m.model_id
  WHERE model_run_id = p_model_run_id;
  RETURN NEXT ref_model;

  --
  -- Decay Hierarchy
  --
  RAISE NOTICE '[get_scenario_data] Writing ref_decay_hierarchy';
  OPEN ref_decay_hierarchy FOR
  SELECT
     h.path,
     mh.stage,
     mh.stage_offset,
     h.hierarchy_id,
     h.parent_id AS parent_hierarchy_id,
     h.name AS hierarchy_name,
     mh.children,
     mh.decay
  FROM ephemeral.model_decay_hierarchy AS mh
  JOIN ephemeral.hierarchy AS h ON h.hierarchy_id = mh.hierarchy_id
  WHERE model_run_id = p_model_run_id
  ORDER BY LENGTH(path), h.path, h.hierarchy_id, mh.stage, mh.stage_offset;
  RETURN NEXT ref_decay_hierarchy;

  --
  -- Elasticity Hierarchy
  --
  RAISE NOTICE '[get_scenario_data] Writing ref_elasticity_hierarchy';
  OPEN ref_elasticity_hierarchy FOR
  SELECT
    h.path,
    mh.stage,
    h.hierarchy_id,
    h.parent_id AS parent_hierarchy_id,
    h.name AS hierarchy_name,
    mh.children,
    mh.quantity,
    mh.price_elasticity,
    mh.price_elasticity
  FROM ephemeral.model_elasticity_hierarchy AS mh
  JOIN ephemeral.hierarchy AS h ON h.hierarchy_id = mh.hierarchy_id
  WHERE model_run_id = p_model_run_id
  ORDER BY LENGTH(h.path), h.path, h.hierarchy_id, stage;
  RETURN NEXT ref_elasticity_hierarchy;

END;
$$ LANGUAGE  plpgsql;


