CREATE OR REPLACE FUNCTION ephemeral.get_extrapolated_products_standard
(
  p_scenario_week INTEGER,
  p_weeks_to_extrapolate_on INTEGER,
  p_observed_decay_min DECIMAL(4, 2),
  p_observed_decay_max DECIMAL(4, 2),
  p_observed_decay_cap  INTEGER
)
RETURNS VOID
AS $$

DECLARE
  d_row_count INTEGER;
  p_observed_decay_cap_week int = p_scenario_week + p_observed_decay_cap;

BEGIN
  CREATE TEMP TABLE IF NOT EXISTS ephemeral.products_to_extrapolate
  (
    product_id INT,
    week       INT
  )
  ON COMMIT DROP;

  CREATE TEMP TABLE IF NOT EXISTS ephemeral.sales
  (
    week       INT,
    product_id INT,
    quantity   INT NULL,
    stock      INT NULL
  )
  ON COMMIT DROP;

  -- Identify products which have
  --    1. a complete data set
  --    2. no changes in price
  --    3. 1 or more weeks of positive sales
  --    4. data in the latest week
  RAISE NOTICE '[get_extrapolated_products_standard] Load products_to_extrapolate';
  WITH products_with_data AS
  (
      SELECT
        ted.product_id,
        ted.stock
      FROM ephemeral.extrapolation_data ted
      WHERE ted.week = p_scenario_week AND ted.quantity IS NOT NULL AND ted.stock != 0 AND ted.quantity != 0 )
  ,smooth_products AS
  (
      SELECT ted.product_id
      FROM products_with_data pd
      LEFT JOIN ephemeral.extrapolation_data ted ON ted.product_id = pd.product_id
      GROUP BY ted.product_id
      HAVING Max(ted.Price) = Min(ted.Price) AND count(*) = (p_weeks_to_extrapolate_on)
  )
  INSERT INTO ephemeral.products_to_extrapolate
  SELECT
    sp.product_id,
    w.week
  FROM ephemeral.weeks w
    CROSS JOIN smooth_products sp;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_products_standard]     Count: %', d_row_count;

  RAISE NOTICE '[get_extrapolated_products_standard] Load sales';
  INSERT INTO ephemeral.sales
  SELECT
    pte.week,
    pte.product_id,
    ted.quantity,
    ted.stock
  FROM ephemeral.products_to_extrapolate pte
  LEFT JOIN ephemeral.extrapolation_data ted ON pte.product_id = ted.product_id AND pte.week = ted.week;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_products_standard]     Count: %', d_row_count;

  -- Identify the sales trend which will be used to extrapolate future sales
  CREATE TEMP TABLE IF NOT EXISTS ephemeral.slopes (
    product_id        INT,
    quantity_slope     DECIMAL(18, 10),
    quantity_intercept DECIMAL(18, 10),
    average_sales      INT
  )
  ON COMMIT DROP;

  RAISE NOTICE '[get_extrapolated_products_standard] Load slopes';
  WITH cte_averages AS
  (
      SELECT
        S.product_id,
        AVG(S.Week)
        OVER (
          PARTITION BY S.product_id ) AS x1,
        Week                          AS x,
        AVG(S.quantity)
        OVER (
          PARTITION BY S.product_id ) AS q1,
        S.quantity                    AS q
      FROM ephemeral.sales S
      WHERE S.quantity IS NOT NULL
  )
    ,
      cte_slope AS
    (
        SELECT
          a.product_id,
          max(x1)                                                                                  AS x1,
          max(q1)                                                                                  AS q1,
          CAST(NULLIF(sum(((x - x1) * (q - q1))), 0) / sum((x - x1) * (x - x1)) AS DECIMAL(34, 4)) AS quantity_slope
        FROM cte_averages a
        GROUP BY a.product_id
    )
    ,
      cte_intercept AS
    (
        SELECT
          s.product_id,
          s.quantity_slope                                                       AS quantity_slopeUnclamped,
          (q1 - (x1 * s.quantity_slope))                                         AS quantity_intercept,
          ((p_scenario_week * s.quantity_slope) + (q1 - (x1 * s.quantity_slope))) AS q1interpolated,
          s.q1,
          s.x1
        FROM cte_slope s
    )
    ,
      cte_slope_to_decay AS
    (
        SELECT
          i.product_id,
          i.quantity_slopeUnClamped,
          i.quantity_intercept,
          i.q1interpolated,
          i.q1,
          (1 + (i.quantity_slopeUnClamped / NULLIF(i.q1interpolated, 0))) AS decay,
          /* convert slope of trend line to decay */
          i.x1
        FROM cte_intercept i
    )
    ,
      cte_clamped_decay AS
    (
        SELECT
          csd.product_id,
          csd.decay,
          GREATEST(LEAST(csd.decay, p_observed_decay_max), p_observed_decay_min) AS ClampedDecay,
          /* apply clamp */
          csd.q1interpolated
        FROM cte_slope_to_decay csd
    )
    ,
      cte_clamped_slope AS
    (
        SELECT
          cd.product_id,
          ((cd.clampedDecay - 1) * cd.q1interpolated) AS quantity_slopeClamped,
          /* Convert clamped decay back to slope of trend line*/
          cd.q1interpolated
        FROM cte_clamped_decay cd
    )
    ,
      cte_final_trend AS
    (
        SELECT
          c.product_id,
          c.quantity_slopeClamped,
          (c.q1interpolated - (p_scenario_week * c.quantity_slopeClamped)) AS Finalquantity_intercept,
          /*Find new intercept with the new slope*/
          i.q1interpolated,
          i.q1
        FROM cte_intercept i
          JOIN cte_clamped_slope c ON i.product_id = c.product_id
    )
  INSERT INTO ephemeral.slopes
  SELECT
    cft.product_id,
    cft.quantity_slopeClamped,
    cft.Finalquantity_intercept,
    cft.q1
  FROM cte_final_trend cft;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_products_standard]     Count: %', d_row_count;

  -- Insert predicted sales value.
  -- Where a trend cannot be calculated, we default to average sales.
  -- If the predicted sales value is negative (declining sales), we default sales to 0
  RAISE NOTICE '[get_extrapolated_products_standard] Load results';
  INSERT INTO ephemeral.results
  SELECT
    s.Week,
    s.product_id,
    ted.price,
    (CASE WHEN s.quantity IS NULL
      THEN
        GREATEST(COALESCE(((LEAST(s.week, p_observed_decay_cap_week) * g.quantity_slope) + g.quantity_intercept), g.average_sales), 0)
     ELSE
       s.quantity
     END) AS quantity,
    s.Stock,
    ted.cost_price,
    1     AS extrapolation_type_id
  FROM ephemeral.sales s
    JOIN ephemeral.slopes g ON g.product_id = s.product_id
    LEFT JOIN ephemeral.extrapolation_data ted
      ON s.product_id = ted.product_id AND s.Week = ted.Week
  ORDER BY s.product_id, s.Week;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_products_standard]     Count: %', d_row_count;
END;

$$ LANGUAGE plpgsql;