-- DROP VIEW function_group_summary
CREATE OR REPLACE VIEW function_group_summary AS

-- Get averages
WITH instance_cte AS (
  SELECT
    fis.function_group_id,
    MAX(function_instance_id) function_instance_id,
    COUNT(*)                function_instance_count,
    SUM(fis.is_timeout)     timeout_count,
    SUM(fit.is_success)     success_count,
    MIN(fis.attempt_number) attempt_count_min,
    AVG(fis.attempt_number) attempt_count_avg,
    MAX(fis.attempt_number) attempt_count_max,
    SUM(fit.is_error)       error_count
  FROM function_instance_summary fis
    JOIN function_instance_type fit ON fit.function_instance_type_id = fis.function_instance_type_id
  WHERE rank = 1
  GROUP BY fis.function_group_id
),
duration_cte AS (
  SELECT
    function_group_id,
    (MAX(created_date) - MIN(created_date)) duration
  FROM function_instance_summary lis
    GROUP BY lis.function_group_id
)
SELECT
  lg.function_group_id,
  lg.function_version,
  lg.function_type_id,
  lt.name                                                  function_type_name,
  lg.function_group_type_id,
  lgt.name                                                 function_group_type_name,
  lgt.sequence_order                                       function_group_type_order,
  lg.function_instance_total,
  i.function_instance_id                                     last_function_instance_id,
  cast(coalesce(i.function_instance_count, 0) AS INTEGER)    function_instance_count,
  cast(
    CASE WHEN (i.function_instance_count IS NULL AND (now() - lg.created_date) > INTERVAL '300 seconds') THEN
      -- All have timed out - expect 1 function to have started by 300s
      lg.function_instance_total
    WHEN (i.function_instance_count < function_instance_total AND (now() - lg.created_date) > INTERVAL '900 seconds') THEN
      -- Something still hasn't started after 900s, assume timed out
      lg.function_instance_total - i.function_instance_count
    ELSE
      -- Use the function_instance_summary (ais) record to determine if a function has timed out
       coalesce(i.timeout_count, 0)
    END AS INTEGER)                                        timeout_count,
  cast(coalesce(i.success_count, 0) AS INTEGER)            success_count,
  cast(coalesce(i.error_count, 0) AS INTEGER)              error_count,
  cast(coalesce(i.attempt_count_min, 0) AS INTEGER)        attempt_count_min,
  cast(coalesce(i.attempt_count_avg, 0) AS NUMERIC(38, 2)) attempt_count_avg,
  cast(coalesce(i.attempt_count_max, 0) AS INTEGER)        attempt_count_max,
  coalesce(EXTRACT(EPOCH FROM d.duration), 0)              duration,
  lg.created_date
FROM
  function_group lg
  JOIN function_type lt ON lt.function_type_id = lg.function_type_id
  JOIN function_group_type lgt ON lgt.function_group_type_id = lg.function_group_type_id
  LEFT JOIN instance_cte i ON i.function_group_id = lg.function_group_id
  LEFT JOIN duration_cte d ON d.function_group_id = lg.function_group_id
;
