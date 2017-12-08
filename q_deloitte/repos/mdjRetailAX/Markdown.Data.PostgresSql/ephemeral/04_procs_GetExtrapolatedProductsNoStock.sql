CREATE OR REPLACE FUNCTION ephemeral.get_extrapolated_products_no_stock
(
  p_scenario_week INT
)
RETURNS VOID
AS $$

DECLARE
  d_row_count INTEGER;

BEGIN
  CREATE TEMP TABLE IF NOT EXISTS ephemeral.products_no_stock
  (
    product_id INT,
    Week       INT,
    CONSTRAINT pk_products_no_stock PRIMARY KEY (Week, product_id)
  )
  ON COMMIT DROP;

  -- Identify products with volatile prices and no stock
  RAISE NOTICE '[get_extrapolated_products_no_stock] Load products_no_stock (volatile)';
  WITH cte_products_with_data AS
  (
    SELECT
      ted.product_id,
      ted.stock
    FROM ephemeral.extrapolation_data ted
    WHERE ted.week = p_scenario_week AND ted.quantity IS NOT NULL AND ted.stock = 0 AND ted.quantity != 0
  )
  ,cte_volatile_price_products AS
  (
    SELECT ted.product_id
    FROM cte_products_with_data pd
    LEFT JOIN ephemeral.extrapolation_data ted ON ted.product_id = pd.product_id
    GROUP BY ted.product_id
    HAVING Max(ted.Price) > Min(ted.Price)
  )
  INSERT INTO ephemeral.products_no_stock
  SELECT
    vpp.product_id,
    w.week
  FROM ephemeral.weeks w
  CROSS JOIN cte_volatile_price_products vpp;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_products_no_stock]     Count: %', d_row_count;

  -- Identify products with stable prices and no stock
  RAISE NOTICE '[get_extrapolated_products_no_stock] Load products_no_stock (stable)';
  WITH cte_products_with_data AS
  (
    SELECT
      ted.product_id,
      ted.stock
    FROM
      ephemeral.extrapolation_data ted
    WHERE ted.week = p_scenario_week AND ted.quantity IS NOT NULL AND ted.stock = 0
  ), cte_products_insufficient_data AS
  (
    SELECT
      ted.product_id
    FROM
      cte_products_with_data pd
      LEFT JOIN ephemeral.extrapolation_data ted ON ted.product_id = pd.product_id
      WHERE ted.quantity != 0
    GROUP BY ted.product_id
    HAVING Max(ted.Price) = Min(ted.Price)
  )
  INSERT INTO ephemeral.products_no_stock
  SELECT
    pid.product_id,
    w.week
  FROM ephemeral.weeks w
    CROSS JOIN cte_products_insufficient_data pid;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_products_no_stock]     Count: %', d_row_count;

  -- Identify products with no stock and no sales
  RAISE NOTICE '[get_extrapolated_products_no_stock] Load products_no_stock (no sales)';
  WITH cte_products_with_data AS
  (
    SELECT
      ted.product_id,
      ted.stock
    FROM
      ephemeral.extrapolation_data ted
    WHERE ted.week = p_scenario_week AND ted.quantity IS NOT NULL AND ted.stock = 0
  ), cte_products_insufficient_data AS
  (
    SELECT
      ted.product_id
    FROM
      cte_products_with_data pd
      LEFT JOIN ephemeral.extrapolation_data ted ON ted.product_id = pd.product_id
    GROUP BY ted.product_id
    HAVING MAX(ted.quantity) = 0
  )
  INSERT INTO ephemeral.products_no_stock
  SELECT
    pid.product_id,
    w.week
  FROM ephemeral.weeks w CROSS JOIN cte_products_insufficient_data pid;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_products_no_stock]     Count: %', d_row_count;

  -- Products with no stock we default our stock and quantity sold predictions to 0
  RAISE NOTICE '[get_extrapolated_products_no_stock] Load results';
  INSERT INTO ephemeral.results
  SELECT
    pns.Week,
    pns.product_id,
    ted.price,
    COALESCE(ted.quantity, 0) AS quantity,
    COALESCE(ted.stock, 0)    AS Stock,
    ted.cost_price,
    4                         AS extrapolation_type_id
  FROM
    ephemeral.products_no_stock pns
    LEFT JOIN ephemeral.extrapolation_data ted ON pns.product_id = ted.product_id AND pns.week = ted.week;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_products_no_stock]     Count: %', d_row_count;
END;
$$ LANGUAGE plpgsql;