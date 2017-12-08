/*
  Populate scenario_product with the product data required for the scenario.
  If extrapolation is required, this function calls the function which handles extrapolation
 */
CREATE OR REPLACE FUNCTION ephemeral.get_scenario_product_data
(
  p_model_run_id INTEGER,
  p_scenario_id INTEGER,
  p_scenario_week INTEGER,
  p_schedule_week_min INTEGER,
  p_weeks_to_extrapolate_on INTEGER,
  p_decay_backdrop DECIMAL(2,2),
  p_observed_decay_min DECIMAL(4,2),
  p_observed_decay_max DECIMAL(4,2),
  p_extrapolate BOOLEAN,
  p_extrapolation_end_week INTEGER,
  p_allow_promo_as_markdown BOOLEAN,
  p_minimum_promo_percentage DECIMAL(5,4),
  p_observed_decay_cap INTEGER
)
RETURNS VOID
AS $$

DECLARE
  d_row_count INTEGER;

BEGIN

  RAISE NOTICE '[get_scenario_product_data] Calling get_model_event';
  PERFORM ephemeral.get_model_event
  (
      p_model_run_id := p_model_run_id, 
      p_elasticity_default := 1, 
      p_is_md_count := TRUE,
      p_allow_promo_as_markdown := p_allow_promo_as_markdown,
      p_minimum_promo_percentage := p_minimum_promo_percentage       
  );

  IF p_extrapolate = TRUE THEN
    RAISE NOTICE '[get_scenario_product_data] Calling get_extrapolated_sales';
    PERFORM ephemeral.get_extrapolated_sales(
        p_scenario_id := p_scenario_id,
        p_scenario_week := p_scenario_week,
        p_schedule_week_min := p_schedule_week_min,
        p_weeks_to_extrapolate_on := p_weeks_to_extrapolate_on,
        p_decay_backdrop := p_decay_backdrop,
        p_observed_decay_min := p_observed_decay_min,
        p_observed_decay_max := p_observed_decay_max,
        p_observed_decay_cap := p_observed_decay_cap
    );

    RAISE NOTICE '[get_scenario_product_data] Load scenario_product (p_extrapolate = TRUE)';
    INSERT INTO ephemeral.scenario_product
    SELECT
      p.product_id,
      ppl.partition_number,
      p.name,
     (SELECT COUNT(*) -- TODO recalculate the events for this to work correctly
       FROM ephemeral.model_event
       WHERE model_run_id = p_model_run_id 
       AND product_id = p.product_id) AS current_markdown_count,
      c.current_stock,
      c.current_selling_price,
      c.current_sales_quantity,
      c.current_cost_price,
      p.original_selling_price,
      c.current_cover,
      o.data_intake_plus_future_commitment_stock
    FROM ephemeral.product_price_ladder AS ppl
    JOIN ephemeral.product AS p ON p.product_id = ppl.product_id
    JOIN ephemeral.product_hierarchy AS ph ON ph.product_id = p.product_id
    JOIN in_scope_scenario_product AS issp ON issp.product_id = ppl.product_id
    -- Get most recent sales data for 'current' values
    JOIN (
        SELECT ROW_NUMBER() OVER (PARTITION BY t.product_id ORDER BY t.Week DESC) AS number,
        t.product_id,
        t.stock                 AS current_stock,
        t.price                 AS current_selling_price,
        t.quantity              AS current_sales_quantity,
        t.cost_price            AS current_cost_price,
        COALESCE((t.stock/NULLIF(t.quantity,0)), 9999) as current_cover
      FROM ephemeral.extrapolated_product_sales_final t
      WHERE (p_extrapolation_end_week IS NULL 
      OR (p_extrapolation_end_week IS NOT NULL 
      AND t.Week <= p_extrapolation_end_week))
    ) AS c ON c.product_id = p.product_id 
            AND c.Number = 1
    LEFT JOIN (
        SELECT ROW_NUMBER() OVER (PARTITION BY t.product_id ORDER BY t.Week DESC) AS number,
        t.product_id,
        t.stock                 AS data_stock,
        t.intake_plus_future_commitment_stock AS data_intake_plus_future_commitment_stock
      FROM ephemeral.product_sales t
      WHERE (p_scenario_week IS NULL OR (p_scenario_week IS NOT NULL AND t.Week = p_scenario_week))
    ) AS o ON o.product_id = p.product_id AND o.Number = 1
    GROUP BY
      p.product_id,
      ppl.product_id,
      ppl.partition_number,
      p.name,
      c.current_stock,
      c.current_selling_price,
      c.current_sales_quantity,
      c.current_cost_price,
      p.original_selling_price,
      c.current_cover,
      o.data_intake_plus_future_commitment_stock
    ORDER BY ppl.partition_number, ppl.product_id;
    GET DIAGNOSTICS d_row_count = ROW_COUNT;
    RAISE NOTICE '[get_scenario_product_data]     Count: %', d_row_count;
  ELSE
    RAISE NOTICE '[get_scenario_product_data] Load scenario_product (p_extrapolate = FALSE)';
    INSERT INTO ephemeral.scenario_product
    SELECT
      p.product_id,
      ppl.partition_number,
      p.name,
      ( SELECT  COUNT(*) -- TODO recalculate the events for this to work correctly
        FROM    ephemeral.model_event
        WHERE   model_run_id = p_model_run_id 
        AND     product_id = p.product_id ) AS current_markdown_count,
      c.current_stock,
      c.current_selling_price,
      c.current_sales_quantity,
      c.current_cost_price,
      p.original_selling_price,
      c.current_cover,
      c.data_intake_plus_future_commitment_stock
    FROM ephemeral.product_price_ladder AS ppl
    JOIN ephemeral.product AS p ON p.product_id = ppl.product_id
    JOIN ephemeral.product_hierarchy AS ph ON ph.product_id = p.product_id
    JOIN in_scope_scenario_product AS issp ON issp.product_id = ppl.product_id
    -- Get most recent sales data for 'current' values
    JOIN (
        SELECT ROW_NUMBER() OVER (PARTITION BY t.product_id ORDER BY t.Week DESC) AS number,
        t.product_id,
        t.stock                 AS current_stock,
        t.price                 AS current_selling_price,
        t.quantity              AS current_sales_quantity,
        t.cost_price            AS current_cost_price,
        COALESCE((t.stock/NULLIF(t.quantity,0)), 9999) as current_cover,
        t.intake_plus_future_commitment_stock AS data_intake_plus_future_commitment_stock
      FROM ephemeral.product_sales t
      WHERE (p_scenario_week IS NULL OR (p_scenario_week IS NOT NULL AND t.Week = p_scenario_week))
    ) AS c ON c.product_id = p.product_id AND c.Number = 1
    GROUP BY
      p.product_id,
      ppl.product_id,
      ppl.partition_number,
      p.name,
      c.current_stock,
      c.current_selling_price,
      c.current_sales_quantity,
      c.current_cost_price,
      p.original_selling_price,
      c.current_cover,
      c.data_intake_plus_future_commitment_stock
    ORDER BY ppl.partition_number, ppl.product_id;
    GET DIAGNOSTICS d_row_count = ROW_COUNT;
    RAISE NOTICE '[get_scenario_product_data]     Count: %', d_row_count;
  END IF;
END;
$$ LANGUAGE plpgsql;