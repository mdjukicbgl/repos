-- DROP VIEW scenario_summary
CREATE OR REPLACE VIEW scenario_summary AS
  WITH summary_cte AS (
    SELECT
      scenario_id,
      MAX(lgs.last_function_instance_id)         last_function_instance_id,
      SUM(lgs.function_instance_count)           function_instance_count,
      SUM(lgs.function_instance_total)           function_instance_count_total,
      MIN(lgs.attempt_count_min)               attempt_count_min,
      AVG(lgs.attempt_count_avg)               attempt_count_avg,
      MAX(lgs.attempt_count_max)               attempt_count_max,
      SUM(lgs.success_count)                   success_count,
      SUM(lgs.timeout_count + lgs.error_count) error_count,
      MIN(lgs.created_date)                    last_run_date
    FROM scenario_function_group slg
      LEFT JOIN function_group_summary lgs ON lgs.function_group_id = slg.function_group_id
    GROUP BY slg.scenario_id
  ),
  duration_cte AS (
    SELECT
      slg.scenario_id,
      (MAX(created_date) - MIN(created_date)) duration
    FROM function_instance_summary lis
    JOIN scenario_function_group slg ON slg.function_group_id = lis.function_group_id
    GROUP BY slg.scenario_id
  ),
  current_phase_cte AS (
    SELECT
      slg.scenario_id,
      slg.function_group_id,
      lgs.function_group_type_id,
      lgs.function_group_type_name,
      row_number()
      OVER (
        PARTITION BY slg.scenario_id
        ORDER BY function_group_type_id DESC) rank
    FROM scenario_function_group slg
      JOIN function_group_summary lgs ON lgs.function_group_id = slg.function_group_id
  ),
  whole_cte AS (
    SELECT
      s.scenario_id,
      s.scenario_name,
      (CASE WHEN last_function_instance_id IS NULL THEN
          1 -- New
        WHEN sum.error_count > 0 THEN
          4 -- Failed
        WHEN lli.function_instance_type_id = 15 THEN
          3 -- Complete
        ELSE
          2 -- Running
      END)                                         scenario_summary_status_type_id,
      sum.last_function_instance_id,
      COALESCE(cp.function_group_type_id, 0)         last_group_type_id,
      cp.function_group_type_name                    last_group_type_name,
      COALESCE(sum.function_instance_count, 0)       function_instance_count,
      COALESCE(sum.function_instance_count_total, 0) function_instance_count_total,
      COALESCE(sgj.product_total, 0)               product_total,
      COALESCE(st.products_count, 0)               product_count,
      COALESCE(sgj.recommendation_count, 0)        recommendation_count,
      COALESCE(sum.attempt_count_min, 0)           attempt_count_min,
      COALESCE(sum.attempt_count_avg, 0)           attempt_count_avg,
      COALESCE(sum.attempt_count_max, 0)           attempt_count_max,
      COALESCE(EXTRACT(EPOCH FROM d.duration), 0)  duration,
      COALESCE(sum.success_count, 0)               success_count,
      COALESCE(sum.error_count, 0)                 error_count,
      last_run_date,
      st.products_cost,
      st.products_accepted_cost,
      st.products_accepted_count,
      st.products_rejected_count,
      st.products_revised_count,
      st.products_accepted_percentage,
      st.products_rejected_percentage,
      st.products_revised_percentage,
      st.products_estimated_profit,
      st.products_estimated_sales,
      st.products_average_depth,
      st.products_markdown_cost,
      st.products_terminal_stock,
      s.organisation_id
    FROM scenario s
        INNER JOIN scenario_totals st ON st.scenario_id = s.scenario_id
      LEFT JOIN duration_cte d ON d.scenario_id = s.scenario_id
      LEFT JOIN summary_cte sum ON sum.scenario_id = s.scenario_id
      LEFT JOIN current_phase_cte cp ON cp.scenario_id = s.scenario_id AND cp.rank = 1
      LEFT JOIN function_instance lli ON lli.function_instance_id = sum.last_function_instance_id
      LEFT JOIN scenario_group_json sgj ON sgj.scenario_id = s.scenario_id AND sgj.rank = 1
  ),
  error_summary_cte AS (
    SELECT
      ss.scenario_id,
      ARRAY(
        SELECT
          to_char(fi.created_date, 'MM-DD-YYYY HH24:MI:SS') || ' ' || fit.name || ' - ' || (fi.json ->> 'ErrorMessage' :: TEXT) AS error_message
          FROM function_group ffg
          JOIN function_instance fi ON fi.function_group_id = ffg.function_group_id
          JOIN function_instance_type fit ON fit.function_instance_type_id = fi.function_instance_type_id
          WHERE ffg.function_group_id = fg.function_group_id AND LENGTH(fi.json ->> 'ErrorMessage' :: TEXT) > 0
          ORDER BY fi.created_date
      ) as error_messages
    FROM whole_cte ss
    JOIN function_instance fi ON fi.function_instance_id = ss.last_function_instance_id
    JOIN function_group fg ON fg.function_group_id = fi.function_group_id
    WHERE scenario_summary_status_type_id = 4
  )

  SELECT
    w.scenario_id,
    w.scenario_name,
    sst.scenario_summary_status_type_id,
    sst.name                          scenario_summary_status_type_name,
    w.last_function_instance_id,
    w.last_group_type_id,
    w.last_group_type_name,
    w.function_instance_count,
    w.function_instance_count_total,
    w.product_total,
    w.product_count,
    w.recommendation_count,
    w.attempt_count_min,
    w.attempt_count_avg,
    w.attempt_count_max,
    w.duration,
    w.success_count,
    w.error_count,
    w.last_run_date,
    w.last_run_date ::date as last_run_date_without_time,
    es.error_messages,
    w.products_cost,
    w.products_accepted_cost,
    w.products_accepted_count,
    w.products_rejected_count,
    w.products_revised_count,
    w.products_accepted_percentage,
    w.products_rejected_percentage,
    w.products_revised_percentage,
    w.products_estimated_profit,
    w.products_estimated_sales,
    w.products_average_depth,
    w.products_markdown_cost,
    w.products_terminal_stock,
    w.organisation_id
  FROM whole_cte w
    LEFT JOIN scenario_summary_status_type sst ON sst.scenario_summary_status_type_id = w.scenario_summary_status_type_id
    LEFT JOIN error_summary_cte es ON es.scenario_id = w.scenario_id

;