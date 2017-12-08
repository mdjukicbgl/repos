CREATE OR REPLACE FUNCTION ephemeral.get_extrapolated_products_no_sales
(
  p_scenario_week INT
)
RETURNS VOID
AS $$

DECLARE
  d_row_count INTEGER;

BEGIN
  CREATE TEMP TABLE IF NOT EXISTS ephemeral.products_no_sales
  (
    product_id INT,
    week       INT
  )
  ON COMMIT DROP;

  -- Identify products with no sales
  RAISE NOTICE '[get_extrapolated_products_no_sales] Load products_no_sales';
  WITH nosales_products AS
  (
    SELECT ted.product_id
    FROM
      ephemeral.extrapolation_data ted
    WHERE ted.week = p_scenario_week AND ted.quantity IS NOT NULL AND ted.stock != 0 AND ted.quantity = 0
  )
  INSERT INTO ephemeral.products_no_sales
  SELECT
    sp.product_id,
    w.week
  FROM ephemeral.weeks w
  CROSS JOIN nosales_products sp;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_products_no_sales]     Count: %', d_row_count;

  RAISE NOTICE '[get_extrapolated_products_no_sales] Load results';
  INSERT INTO ephemeral.results
  SELECT
    pns.week,
    pns.product_id,
    ted.price,
    COALESCE(ted.quantity, 0) AS quantity,
    ted.stock,
    ted.cost_price,
    2                         AS extrapolation_type_id
  FROM
    ephemeral.products_no_sales pns
  LEFT JOIN ephemeral.extrapolation_data ted ON pns.product_id = ted.product_id AND pns.week = ted.week;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_products_no_sales]     Count: %', d_row_count;
END;
$$ LANGUAGE plpgsql;