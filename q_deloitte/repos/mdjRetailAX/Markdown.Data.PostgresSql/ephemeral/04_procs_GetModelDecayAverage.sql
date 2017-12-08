CREATE OR REPLACE FUNCTION ephemeral.get_model_decay_average
(
  p_model_run_id INTEGER,
  p_decay_default DECIMAL(34, 4)
)
RETURNS void
AS $$

DECLARE
  d_row_count INTEGER;

BEGIN
  -- Select average decays Stage per Stage Offset per Hierarchy
  RAISE NOTICE '[get_model_decay_average] Load model_decay_average';
  INSERT INTO ephemeral.model_decay_average (
    model_run_id,
    stage,
    stage_offset,
    parent_hierarchy_id,
    hierarchy_id,
    hierarchy_name,
    children,
    decay
  )
  SELECT
    p_model_run_id          AS model_run_id,
    r.stage,
    r.stage_offset,
    h.parent_id,
    h.hierarchy_id,
    h.name                  AS hierarchy_name,
    COALESCE(r.children, 0) AS children,
    (CASE WHEN r.decay IS NULL AND depth = 0
      THEN p_decay_default
      ELSE r.decay
    END) AS decay
  FROM (
    SELECT
      me.hierarchy_id,
      me.stage,
      me.stage_offset,
      COUNT(*)                      AS children,
      AVG(me.decay)                 AS decay
      FROM ephemeral.model_decay    AS me
      JOIN model_run                AS mr   ON me.model_run_id = mr.model_run_id
      LEFT JOIN
            model_hierarchy_filter  AS mpf  ON mr.model_id = mpf.model_id
                                            AND me.hierarchy_id = mpf.hierarchy_id
                                            AND me.stage = mpf.stage
    WHERE   me.model_run_id     = p_model_run_id
    AND     me.decay            >= COALESCE( mpf.min_decay, me.decay )
    AND     me.decay            <= COALESCE( mpf.max_decay, me.decay )
    GROUP BY
            me.hierarchy_id, 
            me.stage, 
            me.stage_offset
  ) AS r
  JOIN ephemeral.hierarchy AS h ON h.hierarchy_id = r.hierarchy_id;

  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_model_decay_average]     Count: %', d_row_count;
END
$$ LANGUAGE plpgsql;
