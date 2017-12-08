CREATE OR REPLACE FUNCTION ephemeral.get_extrapolated_products_default_decay (
  p_scenario_week INT,
  p_weeks_to_extrapolate_on INT,
  p_decay_backdrop DECIMAL(2,2), -- the default decay set by the user for us when we cannot extrapolate sales for a product using linear extrapolation
  p_schedule_week_min INT,
  p_observed_decay_cap  INTEGER
)
RETURNS VOID
AS $$

DECLARE
  d_row_count INTEGER;
  p_observed_decay_cap_week int = p_scenario_week + p_observed_decay_cap;

BEGIN
  CREATE TEMP TABLE IF NOT EXISTS ephemeral.products_to_apply_backdrop
  (
    product_id INT,
    Week       INT,
    CONSTRAINT pk_products_to_apply_backdrop PRIMARY KEY (Week, product_id)
  )
  ON COMMIT DROP;

  -- Identify products with volatile prices where we cannot apply the standard extrapolation method
  RAISE NOTICE '[get_extrapolated_products_default_decay] Load products_to_apply_backdrop (volatile)';
  WITH cte_products_with_data AS
  (
    SELECT
      ted.product_id,
      ted.stock
    FROM
      ephemeral.extrapolation_data ted
    WHERE ted.week = p_scenario_week AND ted.quantity IS NOT NULL AND ted.stock != 0 AND ted.quantity != 0 )
  , cte_volatile_price_products AS
  (
    SELECT
      ted.product_id
    FROM
      cte_products_with_data pd
      LEFT JOIN ephemeral.extrapolation_data ted ON ted.product_id = pd.product_id
      WHERE ted.quantity != 0
    GROUP BY ted.product_id
    HAVING Max(ted.Price) > Min(ted.Price)
  )
  INSERT INTO ephemeral.products_to_apply_backdrop
    SELECT
      vpp.product_id,
      w.week
    FROM ephemeral.weeks w CROSS JOIN cte_volatile_price_products vpp;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_products_standard]     Count: %', d_row_count;

  -- Identify products with stable prices but with less weeks of data than the required number
  RAISE NOTICE '[get_extrapolated_products_default_decay] Load products_to_apply_backdrop (stable)';
  WITH cte_products_with_data AS
  (
    SELECT
      ted.product_id,
      ted.stock
    FROM
      ephemeral.extrapolation_data ted
    WHERE ted.week = p_scenario_week AND ted.quantity IS NOT NULL AND ted.stock != 0 AND ted.quantity != 0
  )
  , cte_products_insufficient_data AS
  (
    SELECT
      ted.product_id
    FROM
      cte_products_with_data pd
      LEFT JOIN ephemeral.extrapolation_data ted ON ted.product_id = pd.product_id
    GROUP BY ted.product_id
    HAVING Max(ted.Price) = Min(ted.Price) AND count(*) < (p_weeks_to_extrapolate_on)
  )
  INSERT INTO ephemeral.products_to_apply_backdrop
    SELECT
      pid.product_id,
      w.week
    FROM ephemeral.weeks w CROSS JOIN cte_products_insufficient_data pid;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_products_standard]     Count: %', d_row_count;

  -- Iteratively apply the default decay
  RAISE NOTICE '[get_extrapolated_products_default_decay] Load results (extrapolated)';
  WITH RECURSIVE cte_backdrop_products(Week, product_id, Price, quantity, Stock, cost_price, extrapolation_type_id) AS (
    SELECT
      pns.Week,
      pns.product_id,
      ted.Price,
      CAST(ted.quantity AS DECIMAL(34, 4)) AS quantity,
      ted.stock,
      ted.cost_price,
      3                                    AS extrapolation_type_id
    FROM
      ephemeral.products_to_apply_backdrop pns
      LEFT JOIN ephemeral.extrapolation_data ted
        ON pns.product_id = ted.product_id
           AND pns.week = ted.week
    WHERE pns.Week = p_scenario_week
    UNION ALL
    SELECT
      bp.Week + 1,
      bp.product_id,
      bp.price,
      CAST(bp.quantity * p_decay_backdrop AS DECIMAL(34, 4)) AS quantity,
      NULL                                                   AS Stock,
      bp.cost_price,
      3                                                      AS extrapolation_type_id
    FROM
      cte_backdrop_products bp
    WHERE (bp.week + 1) <= p_observed_decay_cap_week
  )
  INSERT INTO ephemeral.results
  SELECT
    bp.Week,
    bp.product_id,
    bp.price,
    CAST(bp.quantity as INT) quantity,
    bp.Stock,
    bp.cost_price,
    bp.extrapolation_type_id
  FROM cte_backdrop_products bp
  LEFT JOIN ephemeral.sales s ON bp.product_id = s.product_id AND bp.week = s.Week;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_products_standard]     Count: %', d_row_count;

  WITH RECURSIVE cte_backdrop_products(Week, product_id, Price, quantity, Stock, cost_price, extrapolation_type_id) AS (
    SELECT
      r.Week,
      r.product_id,
      r.Price,
      CAST(r.quantity AS DECIMAL(34, 4)) AS quantity,
      r.stock,
      r.cost_price,
      3                                    AS extrapolation_type_id
    FROM ephemeral.products_to_apply_backdrop pns
      LEFT JOIN ephemeral.results r
        ON pns.product_id = r.product_id
           AND pns.week = r.week
    WHERE r.Week = p_observed_decay_cap_week
    UNION ALL
    SELECT
      bp.Week + 1,
      bp.product_id,
      bp.price,
      CAST(bp.quantity AS DECIMAL(34, 4)) AS quantity,
      NULL                                                   AS Stock,
      bp.cost_price,
      3                                                      AS extrapolation_type_id
    FROM
      cte_backdrop_products bp
    WHERE (bp.week + 1) < p_schedule_week_min
  )
  INSERT INTO ephemeral.results
  SELECT
    bp.Week,
    bp.product_id,
    bp.price,
    CAST(bp.quantity as INT) quantity,
    bp.Stock,
    bp.cost_price,
    bp.extrapolation_type_id
  FROM cte_backdrop_products bp
  LEFT JOIN ephemeral.sales s ON bp.product_id = s.product_id AND bp.week = s.Week
  WHERE bp.week > p_observed_decay_cap_week;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_products_standard]     Count: %', d_row_count;

  RAISE NOTICE '[get_extrapolated_products_default_decay] Load results (normal)';
  INSERT INTO ephemeral.results
  SELECT
    pab.Week       ,
    pab.product_id ,
    ted.price      ,
    ted.quantity     ,
    ted.Stock,
    ted.cost_price   ,
    3              AS extrapolation_type_id
  FROM
    ephemeral.products_to_apply_backdrop pab
  LEFT JOIN ephemeral.extrapolation_data ted
    ON pab.product_id = ted.product_id AND pab.week = ted.week
  WHERE pab.Week < p_scenario_week AND ted.quantity IS NOT NULL;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_products_standard]     Count: %', d_row_count;
END;
$$ LANGUAGE plpgsql;