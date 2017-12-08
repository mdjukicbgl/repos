CREATE OR REPLACE FUNCTION ephemeral.get_extrapolated_sales
(
  p_scenario_id INTEGER,
  p_scenario_week INTEGER,
  p_schedule_week_min INTEGER,
  p_weeks_to_extrapolate_on INTEGER, -- determines how many weeks of data will be used to extrapolate from
  p_decay_backdrop DECIMAL(2,2),
  p_observed_decay_min DECIMAL(4,2),
  p_observed_decay_max DECIMAL(4,2),
  p_observed_decay_cap  INTEGER
)
RETURNS VOID
AS $$

DECLARE
  --  Week before the sales period begins. This week is used to get 'Current Stock', 'Current Price' etc...
  p_extrapolation_end_week int = (p_schedule_week_min - 1);
  -- Start of the range of weeks of data used to extrapolate from. The the last week is always p_scenario_week ie. the latest week of data.
  p_data_start_week int = (p_scenario_week - (p_weeks_to_extrapolate_on - 1));
  d_row_count INTEGER;

BEGIN
  CREATE TEMP TABLE IF NOT EXISTS ephemeral.extrapolation_data
  (
    product_id       INTEGER        NOT NULL,
    week             INTEGER        NOT NULL,
    price            DECIMAL(34, 4) NOT NULL,
    quantity         INTEGER        NOT NULL,
    stock            INTEGER        NOT NULL,
    cost_price       DECIMAL(34, 4) NOT NULL
  )
  ON COMMIT DROP;

  RAISE NOTICE '[get_extrapolated_sales] Load extrapolation_data';
  INSERT INTO ephemeral.extrapolation_data
  (
    product_id,
    week,
    price,
    quantity,
    stock,
    cost_price)
    SELECT
      tps.product_id,
      tps.week,
      tps.price,
      tps.quantity,
      tps.stock,
      tps.cost_price
    FROM ephemeral.product_sales tps
      JOIN ephemeral.product AS p ON p.product_id = tps.product_id
      JOIN ephemeral.product_hierarchy AS ph ON ph.product_id = p.product_id
      JOIN in_scope_scenario_product AS issp ON issp.product_id = p.product_id;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_sales]     Count: %', d_row_count;

  CREATE TEMP TABLE IF NOT EXISTS ephemeral.results
  (
    week              INTEGER,
    product_id        INTEGER,
    price             DECIMAL(34, 4),
    quantity          INTEGER,
    stock             INTEGER,
    cost_price        DECIMAL(34, 4),
    extrapolation_type_id INTEGER
  ) ON COMMIT DROP;

  CREATE TEMP TABLE IF NOT EXISTS ephemeral.extrapolated_product_sales (
    week                  INTEGER,
    product_id            INTEGER,
    price                 DECIMAL(34, 2),
    quantity              INTEGER,
    stock                 INTEGER,
    previous_stock        INTEGER,
    cost_price            DECIMAL(34, 2),
    extrapolation_type_id INTEGER,
    CONSTRAINT pk_extrapolated_product_sales PRIMARY KEY (week, product_id)
  ) ON COMMIT DROP;


  -- Weeks of data sales and weeks of extrapolation
  RAISE NOTICE '[get_extrapolated_sales] Load weeks';
  CREATE TEMP TABLE IF NOT EXISTS ephemeral.weeks
  (
    week INT
  )
  ON COMMIT DROP;
  INSERT INTO ephemeral.weeks
  SELECT generate_series
  FROM generate_series(p_data_start_week, p_extrapolation_end_week);
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_sales]     Count: %', d_row_count;

  -- Standard extrapolation: products which do not change price, have sales for all n (set by user) weeks required for extrapolation
  RAISE NOTICE '[get_extrapolated_sales] Calling get_extrapolated_products_standard';
  PERFORM ephemeral.get_extrapolated_products_standard
  (
      p_scenario_week := p_scenario_week,
      p_weeks_to_extrapolate_on := p_weeks_to_extrapolate_on,
      p_observed_decay_min := p_observed_decay_min,
      p_observed_decay_max := p_observed_decay_max,
      p_observed_decay_cap := p_observed_decay_cap
  );

  -- 'Default Decay' extrapolation: applies a default decay to products which we cannot extrapolate data for because there are products which do not have the weeks of data required for extrapolation or if they have price changes
  RAISE NOTICE '[get_extrapolated_sales] Calling get_extrapolated_products_default_decay';
  PERFORM ephemeral.get_extrapolated_products_default_decay
  (
      p_scenario_week := p_scenario_week,
      p_weeks_to_extrapolate_on := p_weeks_to_extrapolate_on,
      p_decay_backdrop := p_decay_backdrop,
      p_schedule_week_min := p_schedule_week_min,
      p_observed_decay_cap := p_observed_decay_cap
  );

  -- 'No Sales' extrapolation: identify products which have no sales but have stock in the latest week of data. The procedure sets a predicted sales rate of 0 for these products.
  RAISE NOTICE '[get_extrapolated_sales] Calling get_extrapolated_products_no_sales';
  PERFORM ephemeral.get_extrapolated_products_no_sales
  (
      p_scenario_week := p_scenario_week
  );

  -- 'No Stock' extrapolation: Products which have no stock in the latest week of data should have a predicted sales rate of 0 for these products.
  RAISE NOTICE '[get_extrapolated_sales] Calling get_extrapolated_products_no_stock';
  PERFORM ephemeral.get_extrapolated_products_no_stock
  (
      p_scenario_week := p_scenario_week
  );

  -- Derive the predicted stock based on the extrapolated sales figures
  RAISE NOTICE '[get_extrapolated_sales] Loading extrapolated_product_sales (extrapolated)';

  RAISE NOTICE '[get_extrapolated_sales] Loading extrapolated_product_sales (normal - data start week)';
  INSERT INTO ephemeral.extrapolated_product_sales
  SELECT
    t.week,
    t.product_id,
    t.price,
    t.quantity,
    t.stock,
    NULL AS PreviousStock,
    t.cost_price,
    t.extrapolation_type_id
  FROM ephemeral.results t
  WHERE t.Week = p_data_start_week;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_sales]     Count: %', d_row_count;

  RAISE NOTICE '[get_extrapolated_sales] Loading extrapolated_product_sales (normal)';

  WITH cte_previous_stock AS
    (
      SELECT
    t.week,
    t.product_id,
    t.price,
    t.quantity,
    t.stock,
    LAG(t.stock,1,0) OVER(PARTITION BY t.product_id ORDER BY t.week) AS PreviousStock,
    t.cost_price,
    t.extrapolation_type_id
  FROM ephemeral.results t
  WHERE t.Week <= p_scenario_week
  )
 INSERT INTO ephemeral.extrapolated_product_sales
  SELECT
    t.week,
    t.product_id,
    t.price,
    t.quantity,
    t.stock,
    t.PreviousStock,
    t.cost_price,
    t.extrapolation_type_id
  FROM cte_previous_stock t
  WHERE t.Week <= p_scenario_week and t.week > p_data_start_week;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_sales]     Count: %', d_row_count;

  WITH RECURSIVE cte_update_stock (week, product_id, price, quantity, stock, cost_price, extrapolation_type_id) AS (
    SELECT
      tr.week,
      tr.product_Id,
      tr.price,
      tr.quantity,
      tr.stock,
      tr.cost_price,
      tr.extrapolation_type_id
    FROM
      ephemeral.results tr
    WHERE tr.week = p_scenario_week
    UNION ALL
    SELECT
      (cus.week + 1)                         AS Week,
      cus.product_Id,
      cus.price,
      tr.quantity,
      GREATEST((cus.stock - tr.quantity), 0) AS stock,
      cus.cost_price,
      tr.extrapolation_type_id
    FROM
      cte_update_stock cus
      LEFT JOIN ephemeral.results tr ON cus.product_id = tr.product_id AND (cus.week + 1) = tr.week
    WHERE (cus.Week + 1) < p_schedule_week_min
  ),
      cte_update_previous_stock AS
    (
        SELECT
          cus.week,
          cus.product_id,
          cus.price,
          cus.quantity,
          cus.stock,
          LAG(cus.stock, 1, 0)
          OVER (
            PARTITION BY cus.product_id
            ORDER BY cus.week ) AS previous_stock,
          cus.cost_price,
          cus.extrapolation_type_id
        FROM cte_update_stock cus
    )
  INSERT INTO ephemeral.extrapolated_product_sales
    SELECT
      cups.week,
      cups.product_id,
      cups.price,
      cups.quantity,
      cups.stock,
      cups.previous_stock,
      cups.cost_price,
      cups.extrapolation_type_id
    FROM cte_update_previous_stock cups
    WHERE cups.week > p_scenario_week;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_sales]     Count: %', d_row_count;

  -- LEAST is used below as if we predict sales will be greater than stock (based on consumer behaviour) we will
  -- actually sell the units in stock (and not the predicted value)
  RAISE NOTICE '[get_extrapolated_sales] Loading extrapolated_product_sales_final';
  INSERT INTO ephemeral.extrapolated_product_sales_final
  SELECT
    t.week,
    t.product_Id,
    t.price,
    LEAST(t.quantity,t.previous_stock) as quantity,
    GREATEST(stock,0) as stock,
    t.cost_price,
    t.extrapolation_type_id
  FROM ephemeral.extrapolated_product_sales t;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_extrapolated_sales]     Count: %', d_row_count;
END;
$$ LANGUAGE plpgsql;
