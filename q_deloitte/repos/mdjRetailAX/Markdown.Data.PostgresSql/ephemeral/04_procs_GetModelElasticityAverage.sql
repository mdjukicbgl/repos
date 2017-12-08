CREATE OR REPLACE FUNCTION ephemeral.get_model_elasticity_average(p_model_run_id INTEGER, p_stage_max INTEGER, p_elasticity_default DECIMAL(34,4))
RETURNS void
AS $$

DECLARE
  d_row_count INTEGER;

BEGIN

  /*
		Scenario Elasticity Average
		For each Product * Scenario Event * Week, average quantity, Price and Price Elasticity by Stage * Hierarchy
	*/
	-- Select weekly averages per Hierarchy
  RAISE NOTICE '[get_model_elasticity_average] Load model_elasticity_average';
	INSERT INTO ephemeral.model_elasticity_average (
		model_run_id,
		stage,
		parent_hierarchy_id,
		hierarchy_id,
		hierarchy_name,
		children,
		quantity,
		price,
		price_elasticity
	)
	SELECT
		p_model_run_id AS model_run_id,
		r.stage,
		h.parent_id,
		h.hierarchy_id,
		h.name AS hierarchy_name,
		COALESCE(r.children, 0) AS children,
		r.quantity AS quantity,
		r.price AS price,
		(CASE WHEN r.price_elasticity IS NULL AND depth = 0 THEN p_elasticity_default ELSE r.price_elasticity END) AS price_elasticity
	FROM (
		SELECT
			ph.hierarchy_id,
			me.stage,
			COUNT(*)                        AS children,
			AVG(me.quantity)                AS quantity,
			AVG(me.price)                   AS price,
			AVG(me.price_elasticity)        AS price_elasticity
		FROM    ephemeral.model_event       AS me
		JOIN    ephemeral.product_hierarchy AS ph   ON ph.product_id = me.product_id
        JOIN    model_run                   AS mr   ON me.model_run_id = mr.model_run_id
        LEFT JOIN
                model_hierarchy_filter      AS mpf  ON mr.model_id = mpf.model_id
                                                    AND ph.hierarchy_id = mpf.hierarchy_id
                                                    AND me.stage = mpf.stage
		WHERE   me.model_run_id     =  p_model_run_id 
        AND     me.stage            <= p_stage_max
        AND     me.price_elasticity >= COALESCE( mpf.min_elasticity, me.price_elasticity )
        AND     me.price_elasticity <= COALESCE( mpf.max_elasticity, me.price_elasticity )
		GROUP BY
                ph.hierarchy_id,
                me.stage
	) AS r
	JOIN ephemeral.hierarchy    AS h    ON h.hierarchy_id = r.hierarchy_id;

	GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_model_elasticity_average]     Count: %', d_row_count;
END
$$ LANGUAGE plpgsql;

