-- DROP VIEW scenario_group_json
CREATE OR REPLACE VIEW scenario_group_json AS

-- Pick last JSON column of each group
WITH calc_cte AS (
    SELECT
      lis.function_instance_id,
      lis.function_instance_type_id,
      lis.function_instance_type_name,
      lis.function_instance_number,
      lis.function_group_id,
      lgt.function_group_type_id,
      lgt.name function_group_type_name,
      li.json,
      li.json_version
    FROM function_instance_summary lis
      JOIN function_instance li ON li.function_instance_id = lis.function_instance_id
      JOIN function_group_type lgt ON lgt.function_group_type_id = lis.function_group_type_id
    WHERE lis.rank = 1
          AND lgt.function_group_type_id = 3 -- Calculate
),
-- Aggregate columns
calc_data_cte AS (
  SELECT
    cj.function_instance_id,
    cj.function_group_id,
    cj.function_instance_number,
    (cj.json ->> 'ProductCount') :: INTEGER        product_count,
    (cj.json ->> 'ProductTotal') :: INTEGER        product_total,
    (cj.json ->> 'RecommendationCount') :: BIGINT recommendation_count
  FROM
    calc_cte cj
  WHERE json_version = 1
)
SELECT
  slg.scenario_id,
  slg.function_group_id,
  SUM(c.product_count)        product_count,
  SUM(c.product_total)        product_total,
  SUM(c.recommendation_count) recommendation_count,
  row_number()
    OVER (
      PARTITION BY slg.scenario_id
      ORDER BY slg.function_group_id DESC) rank
FROM
  scenario_function_group slg
  JOIN calc_data_cte c ON c.function_group_id = slg.function_group_id
GROUP BY slg.scenario_id, slg.function_group_id
;