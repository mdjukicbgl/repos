CREATE OR REPLACE FUNCTION ephemeral.get_model_elasticity_hierarchy
(
	p_model_run_id integer,
	p_stage_max integer,
	p_elasticity_default DECIMAL(34,4)
)
RETURNS void
AS $$

DECLARE
  d_row_count INTEGER;

BEGIN

  RAISE NOTICE '[get_model_elasticity_hierarchy] Load model_elasticity_hierarchy';

  WITH RECURSIVE full_hierarchy_cte AS (
    SELECT
      h.hierarchy_id,
      h.name AS hierarchy_name,
      h.parent_id AS parent_hierarchy_id,
      s.stage,
      mea.price,
      mea.price_elasticity,
      mea.quantity,
      COALESCE(mea.children, 0) AS children
    FROM ephemeral.hierarchy AS h
    CROSS JOIN (SELECT generate_series AS stage FROM generate_series(0, p_stage_max)) AS s
    LEFT JOIN ephemeral.model_elasticity_average AS mea
      ON model_run_id = p_model_run_id
         AND mea.hierarchy_id = h.hierarchy_id
         AND mea.stage = s.stage
	),
	elasticity_hierarchy_cte AS
	(
		SELECT 
			stage,
			parent_hierarchy_id,
			hierarchy_id,
			hierarchy_name,
			children,
			quantity,
			price,
			price_elasticity
		FROM full_hierarchy_cte
		UNION ALL
		SELECT
			sea.stage,
			sea.parent_hierarchy_id,
			sea.hierarchy_id,
			sea.hierarchy_name,
			sea.Children + cte.children,
			cte.quantity,
			cte.price,
			cte.price_elasticity
		FROM elasticity_hierarchy_cte AS cte
		JOIN full_hierarchy_cte AS sea
			ON sea.hierarchy_id = cte.parent_hierarchy_id
			AND sea.Stage = cte.stage
	)
	INSERT INTO ephemeral.model_elasticity_hierarchy (
	  model_run_id,
	  stage,
	  hierarchy_id,
	  hierarchy_name,
	  children,
	  quantity,
	  price,
	  price_elasticity
	)
	SELECT
		p_model_run_id AS model_run_id,
		stage,
		hierarchy_id,
		hierarchy_name,
		SUM(children) AS children,
		AVG(quantity) AS quantity,
		AVG(price) AS price,
		COALESCE(AVG(price_elasticity), p_elasticity_default) AS price_elasticity
	FROM elasticity_hierarchy_cte
	WHERE children > 0
	GROUP BY stage, hierarchy_id, hierarchy_name;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_model_elasticity_hierarchy]     Count: %', d_row_count;

END
$$ LANGUAGE plpgsql;
