CREATE OR REPLACE FUNCTION ephemeral.get_product_minimum_absolute_price_change(p_scenario_id INTEGER)
  RETURNS VOID
AS $$

BEGIN
  CREATE TEMP TABLE IF NOT EXISTS ephemeral.product_minimum_absolute_price_change (
    product_minimum_absolute_price_change SERIAL,
    product_id                            INT,
    partition_number                      INT,
    minimum_absolute_price_change         DECIMAL(34, 2),
    CONSTRAINT pk_product_minimum_absolute_price_change PRIMARY KEY (product_minimum_absolute_price_change)
  )
  ON COMMIT DROP;


  RAISE NOTICE '[get_product_minimum_absolute_price_change] Load product minimum absolute price change';
  WITH ctePriceThreshold AS
  (
    SELECT
      tsp.product_id,
      tsp.partition_number,
      COALESCE(s.minimum_absolute_price_change_below_threshold, 0) AS minimum_absolute_price_change
    FROM ephemeral.scenario_product tsp
      LEFT JOIN scenario_minimum_absolute_price_change s ON s.scenario_id = p_scenario_id
    WHERE tsp.original_selling_price <= COALESCE(s.original_selling_price_threshold, 0)
    UNION
    SELECT
      tsp.product_id,
      tsp.partition_number,
      COALESCE(s.minimum_absolute_price_change_above_threshold, 0) AS minimum_absolute_price_change
    FROM ephemeral.scenario_product tsp
      LEFT JOIN scenario_minimum_absolute_price_change s ON s.scenario_id = p_scenario_id
    WHERE tsp.original_selling_price > COALESCE(s.original_selling_price_threshold, 0)
  )
  INSERT INTO ephemeral.product_minimum_absolute_price_change
  (
    product_id,
    partition_number,
    minimum_absolute_price_change
  )
    SELECT
      cpt.product_id,
      cpt.partition_number,
      cpt.minimum_absolute_price_change
    FROM ctePriceThreshold cpt;
END
$$ LANGUAGE plpgsql;
