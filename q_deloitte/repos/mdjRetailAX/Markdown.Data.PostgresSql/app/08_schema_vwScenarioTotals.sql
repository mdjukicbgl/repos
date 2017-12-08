-- DROP VIEW scenario_totals
CREATE OR REPLACE VIEW scenario_totals
AS
WITH totals_cte AS
  (
    SELECT
      rp.scenario_id,
      COUNT(DISTINCT rp.product_id) AS count,
      SUM(r.total_markdown_cost)    AS sum_total_markdown_cost
    FROM recommendation_product_summary rp
      JOIN recommendation r ON r.recommendation_guid = rp.decision_recommendation_guid
    GROUP BY rp.scenario_id
  ),
  accepted_cte AS
  (
    SELECT
      rp.scenario_id,
      COUNT(DISTINCT r.recommendation_product_guid)              AS count,
      SUM(r.total_cost)                                          AS sum_total_cost,
      SUM(r.total_markdown_cost)                                 AS sum_total_markdown_cost,
      SUM(r.estimated_profit)                                    AS sum_estimated_profit,
      SUM(r.estimated_sales)                                     AS sum_estimated_sales,
      SUM(r.terminal_stock)                                      AS sum_terminal_stock,
      SUM(r.final_discount * r.stock_value) / (case when sum(r.stock_value)=0 THEN 1 else sum(r.stock_value) end) AS average_depth
    FROM recommendation_product_summary rp
      JOIN recommendation r ON r.recommendation_guid = rp.decision_recommendation_guid
    WHERE rp.state_name = 'Ok' AND rp.decision_state_name = 'Accepted'
    GROUP BY rp.scenario_id
  ),
  revised_cte AS
  (
    SELECT
      rp.scenario_id,
      COUNT(*) AS count
    FROM recommendation_product rp
    WHERE rp.state_name = 'Ok' AND rp.decision_state_name = 'Revised'
    GROUP BY rp.scenario_id
  ),
  rejected_cte AS
  (
    SELECT
      rp.scenario_id,
      COUNT(*) AS count
    FROM recommendation_product rp
    WHERE rp.state_name = 'Ok' AND rp.decision_state_name = 'Rejected'
    GROUP BY rp.scenario_id
  )
SELECT
  s.scenario_id,

  -- All
  COALESCE(totals.count, 0)                             products_count,
  COALESCE(totals.sum_total_markdown_cost, 0)           products_cost,

  -- Accepted
  COALESCE(accepted.count, 0)                           products_accepted_count,
  COALESCE(accepted.count / totals.count :: DECIMAL, 0) products_accepted_percentage,
  -- should the next one be sum_total_cost?
  COALESCE(accepted.sum_total_markdown_cost, 0)         products_accepted_cost,
  COALESCE(accepted.sum_total_markdown_cost, 0)         products_markdown_cost,
  COALESCE(accepted.sum_estimated_profit, 0)            products_estimated_profit,
  COALESCE(accepted.sum_estimated_sales, 0)             products_estimated_sales,
  COALESCE(accepted.sum_terminal_stock, 0)              products_terminal_stock,
  COALESCE(accepted.average_depth, 0)                   products_average_depth,

  -- Rejected
  COALESCE(rejected.count, 0)                           products_rejected_count,
  COALESCE(rejected.count / totals.count :: DECIMAL, 0) products_rejected_percentage,

  -- Revised
  COALESCE(revised.count, 0)                            products_revised_count,
  COALESCE(revised.count / totals.count :: DECIMAL, 0)  products_revised_percentage,
  s.organisation_id

FROM scenario s
  LEFT JOIN totals_cte totals ON totals.scenario_id = s.scenario_id
  LEFT JOIN accepted_cte accepted ON accepted.scenario_id = s.scenario_id
  LEFT JOIN revised_cte revised ON revised.scenario_id = s.scenario_id
  LEFT JOIN rejected_cte rejected ON rejected.scenario_id = s.scenario_id