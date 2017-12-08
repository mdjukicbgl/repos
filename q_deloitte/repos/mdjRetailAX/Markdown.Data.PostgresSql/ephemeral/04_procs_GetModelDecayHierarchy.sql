CREATE OR REPLACE FUNCTION ephemeral.get_model_decay_hierarchy
(
  p_model_run_id INTEGER,
  p_stage_max INTEGER,
  p_stage_offset_max INTEGER,
  p_decay_default DECIMAL(34,4)
)
RETURNS void
AS $$

DECLARE
  d_row_count INTEGER;

BEGIN
  RAISE NOTICE '[get_model_decay_hierarchy] Load model_decay_hierarchy';

 WITH RECURSIVE full_hierarchy_cte AS (
    SELECT
			h.hierarchy_id,
			h.name AS hierarchy_name,
			h.parent_id AS parent_hierarchy_id,
			s.stage,
			so.stage_offset,
			COALESCE(mda.children, 0) AS children,
			mda.decay
		FROM ephemeral.hierarchy AS h
		CROSS JOIN (SELECT generate_series AS stage FROM generate_series(0, p_stage_max)) AS s
		CROSS JOIN (SELECT generate_series AS stage_offset FROM generate_series(0, p_stage_offset_max)) AS so
		LEFT JOIN ephemeral.model_decay_average AS mda
			ON mda.model_run_id = p_model_run_id
			AND mda.hierarchy_id = h.hierarchy_id
			AND mda.stage = s.stage
			AND mda.stage_offset = so.stage_offset
	)
	,decay_hierarchy_cte (stage, stage_offset, parent_hierarchy_id, hierarchy_id, hierarchy_name, children, decay) AS
	(
		SELECT
			stage,
			stage_offset,
			parent_hierarchy_id,
			hierarchy_id,
			hierarchy_name,
			children,
			decay
		FROM full_hierarchy_cte AS a
		UNION ALL
		SELECT
			mda.stage,
			mda.stage_offset,
			mda.parent_hierarchy_id,
			mda.hierarchy_id,
			mda.hierarchy_name,
			mda.children + cte.children,
			cte.decay
		FROM decay_hierarchy_cte AS cte
		JOIN full_hierarchy_cte AS mda
			 ON mda.hierarchy_id = cte.parent_hierarchy_id
			AND mda.stage = cte.stage
			AND mda.stage_offset = cte.stage_offset
	)
	INSERT INTO ephemeral.model_decay_hierarchy
	(
		model_run_id,
		hierarchy_id,
		hierarchy_name,
		stage,
		stage_offset,
		children,
		decay
	)
	SELECT
		p_model_run_id,
		cte.hierarchy_id,
		hierarchy_name,
		stage,
		stage_offset,
		SUM(children) AS children,
		COALESCE(AVG(decay), p_decay_default) AS decay
	FROM decay_hierarchy_cte AS cte
	WHERE children > 0
	GROUP BY stage, stage_offset, cte.hierarchy_id, hierarchy_name;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_model_decay_hierarchy]     Count: %', d_row_count;
END
$$ LANGUAGE plpgsql;

