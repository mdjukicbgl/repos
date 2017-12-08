CREATE OR REPLACE FUNCTION ephemeral.get_model_decay
(
  p_model_run_id integer,
  p_model_week integer,
  p_stage_max integer,
  p_stage_offset_max integer,
  p_decay_min numeric,
  p_decay_max numeric,
  p_decay_default numeric
)
RETURNS void
AS $$

DECLARE
  d_row_count INTEGER;

BEGIN
  RAISE NOTICE '[get_model_decay] Load model_decay';
  INSERT INTO ephemeral.model_decay (
    model_run_id,
    product_id,
    stage,
    stage_offset,
    week,
    parent_hierarchy_id,
    hierarchy_id,
    hierarchy_name,
    decay
  )
  SELECT
    p_model_run_id,
    r.product_id,
    r.stage,
    r.stage_offset,
    r.week,
    h.parent_id,
    h.hierarchy_id,
    h.name,
    r.decay
  FROM (SELECT
          ps.product_id,
          se.stage,
          (ps.week - se.week) AS stage_offset,
          ps.week,
          ps.price,
          ROW_NUMBER()
          OVER (PARTITION BY se.product_id, se.stage ORDER BY ps.week) AS decay_count,
          (CASE WHEN se.quantity = 0 THEN
            p_decay_default
          ELSE
            GREATEST(LEAST((CAST(ps.quantity AS DECIMAL(34, 4)) / CAST(se.quantity AS DECIMAL(34, 4))), p_decay_max), p_decay_min)
          END) AS decay
        FROM (SELECT
                product_id,
                stage,
                week,
                price,
                quantity
              FROM ephemeral.model_event
              WHERE model_run_id = model_run_id) AS se
          JOIN ephemeral.product_sales AS ps
            ON ps.product_id = se.product_id AND ps.week >= se.week AND ps.price = se.price
        WHERE (p_model_week IS NULL OR (p_model_week IS NOT NULL AND ps.week <= p_model_week))) AS r
    JOIN ephemeral.product_hierarchy AS ph
      ON ph.product_id = r.product_id
    JOIN ephemeral.hierarchy AS h
      ON h.hierarchy_id = ph.hierarchy_id
  WHERE r.stage <= p_stage_max
        AND r.stage_offset <= p_stage_offset_max
        AND r.stage_offset > 0;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_model_decay]     Count: %', d_row_count;
END
$$ LANGUAGE plpgsql;

