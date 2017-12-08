-- DROP VIEW function_instance_summary
CREATE VIEW function_instance_summary AS

-- Rank each function instance by group/partition
WITH ranked_cte AS (
    SELECT
      i.function_instance_id,
      i.function_instance_number,
      i.function_group_id,
      i.function_instance_type_id,
      i.created_date,
      i.timeout_date,

      row_number()
        OVER (
          PARTITION BY function_group_id, function_instance_number
          ORDER BY created_date DESC, function_instance_id DESC) AS rank,

      (i.created_date - lead(i.created_date)
        OVER (
          PARTITION BY function_group_id, function_instance_number
          ORDER BY created_date DESC, function_instance_id DESC)) AS duration

    FROM function_instance i
),
-- Workout accumulated duration
duration_cte AS (
    SELECT
      r.function_instance_id,
      SUM(r.duration) OVER (PARTITION BY r.function_group_id, r.function_instance_number
                      ORDER BY r.rank DESC) duration_acc
    FROM ranked_cte r
),
-- Detect 'retry' attempts
attempt_cte AS (
  SELECT
    r.function_instance_id,
    r.function_instance_number,
    r.function_group_id,

    r.rank,

    lgt.function_group_type_id,
    lgt.name AS                        function_group_type_name,
    lgt.sequence_order AS              function_group_type_order,

    lit.function_instance_type_id,
    lit.name AS                        function_instance_type_name,
    lit.sequence_order AS              function_instance_type_order,

    LAG(lit.sequence_order)
    OVER (
      PARTITION BY r.function_group_id, r.function_instance_number, lg.function_group_type_id
      ORDER BY r.created_date, r.function_instance_id ) prev_function_instance_order,

    r.timeout_date,
    r.created_date
  FROM ranked_cte r
    JOIN function_group lg ON lg.function_group_id = r.function_group_id
    JOIN function_group_type lgt ON lgt.function_group_type_id = lg.function_group_type_id
    JOIN function_instance_type lit ON lit.function_instance_type_id = r.function_instance_type_id
),

-- Introduce a running attempt_number
summary_cte AS (
  SELECT
    r.function_instance_id,
    r.function_group_id,
    r.function_group_type_id,
    r.function_group_type_name,
    r.function_instance_number,
    r.rank,
    SUM((CASE WHEN r.prev_function_instance_order IS NULL OR
                   r.function_instance_type_order < r.prev_function_instance_order
      THEN 1
         ELSE 0 END))
    OVER (
      PARTITION BY r.function_group_id, r.function_instance_number, r.function_group_type_id) AS attempt_number,
    r.function_instance_type_id,
    r.function_instance_type_name,
    r.timeout_date,
    r.created_date,
    (now() - r.created_date) AS run_period
  FROM attempt_cte r
),


json_cte AS (
  SELECT
    li.function_instance_id,
    li.json->>'ProductCount' product_count,
    li.json->>'ProductTotal' product_total
  FROM
    function_instance li
),

-- Detect time outs
timeout_cte AS (
      SELECT r.function_instance_id
      FROM summary_cte r
        JOIN function_instance_type lit ON lit.function_instance_type_id = r.function_instance_type_id
      WHERE rank = 1
        AND lit.is_success != 1
        AND ((r.attempt_number >= 3 AND r.run_period > interval '300 seconds')
          OR (r.run_period > interval '900 seconds'))
)

-- Select and merge
SELECT
  r.function_instance_id,
  r.function_group_id,
  r.function_group_type_id,
  r.function_group_type_name,
  r.function_instance_number,
  r.rank,
  r.attempt_number,
  r.function_instance_type_id,
  r.function_instance_type_name,
  (CASE WHEN t.function_instance_id IS NOT NULL
    THEN 1
   ELSE 0 END) is_timeout,
  j.product_count,
  j.product_total,
  r.timeout_date,
  r.created_date,
  d.duration_acc
FROM summary_cte r
  LEFT JOIN timeout_cte t ON t.function_instance_id = r.function_instance_id
  LEFT JOIN json_cte j ON j.function_instance_id = r.function_instance_id
  LEFT JOIN duration_cte d ON d.function_instance_id = r.function_instance_id
ORDER BY r.created_date, r.function_instance_id, r.rank
;