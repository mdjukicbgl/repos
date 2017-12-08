CREATE OR REPLACE FUNCTION ephemeral.get_scenario_data
(
  p_model_run_id integer,
  p_scenario_id integer,
  p_scenario_week integer,
  p_schedule_week_min integer,
  p_schedule_week_max integer,
  p_weeks_to_extrapolate_on integer,
  p_decay_backdrop DECIMAL(2,2),
  p_observed_decay_min DECIMAL(4,2),
  p_observed_decay_max DECIMAL(4,2),
  p_markdown_count_start_week integer,
  p_partition_count integer,
  p_allow_promo_as_markdown BOOLEAN,
  p_minimum_promo_percentage DECIMAL(5,2),
  p_observed_decay_cap integer
)
RETURNS SETOF refcursor
AS $$

DECLARE
  ref_header refcursor;
  ref_scenario refcursor;

  ref_price_ladder_values refcursor;
  ref_hierarchy refcursor;
  ref_hierarchy_sell_through refcursor;

  ref_product refcursor;
  ref_product_hierarchy refcursor;
  ref_product_price_ladder refcursor;
  ref_product_parameter_values refcursor;
  ref_product_markdown_constraint refcursor;
  ref_product_sales_tax refcursor;

  ref_flex_factor refcursor;
  ref_product_minimum_absolute_price_change refcursor;
  ref_product_week_parameter_values refcursor;
  ref_product_week_markdown_type_parameter_values refcursor;

  p_extrapolation_end_week INTEGER = (p_schedule_week_min - 1);
  p_extrapolate BOOLEAN = CASE WHEN p_scenario_week < p_extrapolation_end_week THEN TRUE ELSE FALSE END;
  p_extrapolation_data_start_week INTEGER = (p_scenario_week - (p_weeks_to_extrapolate_on-1));
  p_actual_markdown_count_start_week INTEGER = COALESCE(p_markdown_count_start_week,0);
  p_scenario_length INTEGER = (p_schedule_week_max - p_schedule_week_min) + 1;
  d_row_count INTEGER;

BEGIN
  RAISE NOTICE '[get_scenario_data] Get Scenario Data Started (scenario_id: %)', p_scenario_id;

  RAISE NOTICE '[get_scenario_data] Load hierarchy';
  INSERT INTO ephemeral.hierarchy
  (
    hierarchy_id,
    parent_id,
    depth,
    name,
    path
  )
  SELECT *
  FROM dblink('datawarehouse',$REDSHIFT$
  SELECT
     dim_hierarchy_node_id as hierarchy_id,
     parent_dim_hierarchy_node_id as parent_id,
     hierarchy_node_level as depth,
     hierarchy_node_name as name,
     hierarchy_breadcrumb_node_id as path
  FROM
     markdown_app.uv_dim_hierarchy_node dh
  LEFT OUTER JOIN  ((SELECT MAX(hierarchy_node_level) as MaxNode, 
                            dim_hierarchy_id 
                    FROM    markdown_app.uv_dim_hierarchy_node 
                    GROUP BY dim_hierarchy_id)) MN
            ON MN.dim_hierarchy_id = dh.dim_hierarchy_id
  WHERE
      dh.dim_hierarchy_id = 3 --Currently pulling in a specific hierarchy
     AND effective_end_date_time = '2500-01-01 00:00:00' --Currently only pulling in the latest version of this type of hierarchy
     AND hierarchy_node_level != MN.MaxNode --Filter out the product level
  ;
  $REDSHIFT$) AS dbl_hierarchy (hierarchy_id int,parent_id int, depth int, name varchar(128) , path varchar(128));
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_scenario_data]     Count: %', d_row_count;


  RAISE NOTICE '[get_scenario_data] Load product_hierarchy';
  INSERT INTO ephemeral.product_hierarchy
  (
    product_id,
    hierarchy_id
  )
  SELECT *
  FROM dblink('datawarehouse',$REDSHIFT$
  SELECT
     dp.dim_product_id,
     dp.dim_hierarchy_node_id
  FROM
     markdown_app.uv_dim_product dp
  WHERE
     dp.dim_retailer_id = 1
     AND dp.dim_hierarchy_id = 3
  ;
  $REDSHIFT$) AS dbl_product_hierarchy (product_id int, hierarchy_id int);
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_scenario_data]     Count: %', d_row_count;

  RAISE NOTICE '[get_scenario_data] Load product';
  INSERT INTO ephemeral.product
  (
  product_id,
  name,
  original_selling_price
  )
  SELECT *
  FROM dblink('datawarehouse',$REDSHIFT$
  SELECT
   dp.dim_product_id,
  dp.product_name,
  CAST(MAX(optimisation_osp) as numeric(34,4)) as original_selling_price
  FROM
   markdown_app.uv_dim_date_weekly_usa ddwuv
  INNER JOIN
   markdown_app.uv_fact_weekly_sales_basic fwsb ON ddwuv.dim_date_id = fwsb.dim_date_id
  INNER JOIN
   markdown_app.uv_dim_product dp ON fwsb.dim_product_id = dp.dim_product_id
  WHERE
   dp.dim_retailer_id = 1
   AND dp.dim_hierarchy_id = 3
   AND optimisation_osp is not null
  GROUP BY
  dp.dim_product_id,
  dp.product_name
  ;
  $REDSHIFT$) AS dbl_product(product_id int,name varchar(128), original_selling_price NUMERIC (34,4));
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_scenario_data]     Count: %', d_row_count;

  RAISE NOTICE '[get_scenario_data] Load product_sales_tax';
  INSERT INTO ephemeral.product_sales_tax
  (
    product_id,
    week,
    rate
  )
  SELECT *
  FROM dblink('datawarehouse',
  'SELECT
    r.dim_product_id,
    r.week_sequence_number_usa,
    CAST(r.vat - 1 AS NUMERIC(34, 4)) AS rate
  FROM (
    SELECT
      fwsb.dim_product_id,
      ddwuv.week_sequence_number_usa,
      fwsb.vat,
      ROW_NUMBER() OVER (PARTITION BY fwsb.dim_product_id ORDER BY ddwuv.week_sequence_number_usa DESC) AS rank
    FROM markdown_app.uv_fact_weekly_sales_basic fwsb
      JOIN markdown_app.uv_dim_date_weekly_usa ddwuv ON ddwuv.dim_date_id = fwsb.dim_date_id
    WHERE fwsb.vat IS NOT NULL
         AND fwsb.dim_retailer_id = 1
         AND ddwuv.week_sequence_number_usa >= '||p_extrapolation_data_start_week ||'
         AND ddwuv.week_sequence_number_usa <= '|| p_scenario_week ||'
  ) AS r
  WHERE r.rank = 1
  ORDER BY dim_product_id
  ') AS dbl_product_sales_tax (product_id int,week int, rate NUMERIC (34,4));
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_scenario_data]     Count: %', d_row_count;

  RAISE NOTICE '[get_scenario_data] Load product_sales';
  INSERT INTO ephemeral.product_sales
  (
    product_id,
    week,
    price,
    quantity,
    stock,
    intake_plus_future_commitment_stock,
    cost_price,
    price_status,
    price_status_id,
    previous_price_status,
    previous_price_status_id
  )
  SELECT *
  FROM dblink('datawarehouse','
  SELECT
          fwsba.dim_product_id,
          fwsba.week_sequence_number_usa,
          fwsba.optimisation_csp,
          fwsba.sales_quantity,
          fwsba.total_stock_quantity,
          50 as total_intake_plus_future_commitment_quantity,
          fwsba.cost_price,
          fwsba.price_status,
          fwsba.price_status_id,
          fwsba.previous_price_status,
          fwsba.previous_price_status_id
  FROM
  markdown_app.uv_fact_weekly_sales_basic_aggregated fwsba
  WHERE fwsba.week_sequence_number_usa >= '|| p_extrapolation_data_start_week ||' and fwsba.week_sequence_number_usa <= ' || p_scenario_week || '
  ;
  ') AS dbl_product_sales (product_id int, week int, price numeric(34,4), quantity numeric(34,4) ,
       stock numeric(34,4), intake_plus_future_commitment_stock numeric(34,4), cost_price numeric(34,4), price_status varchar(50), price_status_id int,
       previous_price_status varchar(50), previous_price_status_id int);
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_scenario_data]     Count: %', d_row_count;

  RAISE NOTICE '[get_scenario_data] Load product_price_changes';
  INSERT INTO ephemeral.product_price_changes
  (
    product_id,
    week,
    quantity,
    previous_quantity,
    price,
    previous_price,
    is_md_preceded_by_promotion,
    is_promotional_price_change,
    is_full_price
  )
  SELECT *
  FROM dblink('datawarehouse','
  SELECT
          dim_product_id,
          week_sequence_number_usa,
          sales_quantity,
          previous_quantity,
          optimisation_csp,
          previous_price,
          is_md_preceded_by_promotion,
          is_promotional_price_change,
          is_full_price
  FROM
  markdown_app.uv_price_changes
  WHERE week_sequence_number_usa >= '||p_actual_markdown_count_start_week ||' and week_sequence_number_usa <= ' || p_scenario_week || '
  ;
  ') AS dbl_product_price_changes (product_id int, week int, quantity numeric(34,4), previous_quantity numeric(34,4),
       price numeric(34,4), previous_price numeric(34,4), is_md_preceded_by_promotion int, is_promotional_price_change int, is_full_price int);
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_scenario_data]     Count: %', d_row_count;

  RAISE NOTICE '[get_scenario_data] Creating in_scope_scenario_product';
  CREATE TEMP TABLE IF NOT EXISTS in_scope_scenario_product
  (
    product_id INT
  )
  ON COMMIT DROP;

  INSERT INTO in_scope_scenario_product
    SELECT spf.product_id
    FROM scenario_product_filter spf
    WHERE spf.scenario_id = p_scenario_id
    UNION
    SELECT ph.product_id
    FROM ephemeral.product_hierarchy AS ph
      JOIN ephemeral.hierarchy AS h ON h.hierarchy_id = ph.hierarchy_id
      JOIN scenario_hierarchy_filter AS shf ON shf.hierarchy_id = ph.hierarchy_id AND shf.scenario_id = p_scenario_id
    GROUP BY ph.product_id;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_scenario_data]     Count: %', d_row_count;

  RAISE NOTICE '[get_scenario_data] Load product_price_ladder';
  INSERT INTO ephemeral.product_price_ladder
  SELECT
    product_id,
    partition_number,
    price_ladder_id
  FROM (
    SELECT
      ppl.product_id,
      (((DENSE_RANK() OVER (ORDER BY p.product_id, ppl.price_ladder_id))-1) % p_partition_count)+1 AS partition_number, /* Revisit how the partition number is derived so its done in a better way*/
      ppl.price_ladder_id
    FROM (SELECT product_id, 1 as price_ladder_id FROM ephemeral.product) AS ppl
	  JOIN ephemeral.product AS p ON p.product_id = ppl.product_id
    JOIN ephemeral.product_hierarchy AS ph ON ph.product_id = p.product_id
    JOIN in_scope_scenario_product AS issp ON issp.product_id = p.product_id
  ) AS r
  ORDER BY r.partition_number, r.product_id, r.price_ladder_id;
  GET DIAGNOSTICS d_row_count = ROW_COUNT;

  RAISE NOTICE '[get_scenario_data] Creating ephemeral.scenario_weeks';
  CREATE TEMP TABLE IF NOT EXISTS ephemeral.scenario_weeks
    (
    weeks INT
    )
  ON COMMIT DROP;

  RAISE NOTICE '[get_scenario_data] Populating ephemeral.scenario_weeks';

  INSERT INTO ephemeral.scenario_weeks
  SELECT generate_series as weeks
  FROM generate_series(1, p_scenario_length);
  RAISE NOTICE '[get_scenario_data]     Count: %', d_row_count;

  RAISE NOTICE '[get_scenario_data] Creating ephemeral.scenario_week_markdown_type';

  CREATE TEMP TABLE IF NOT EXISTS ephemeral.scenario_week_markdown_type
    (
    week INT,
    markdown_type_id INT
    )
  ON COMMIT DROP;

  RAISE NOTICE '[get_scenario_data] Populating ephemeral.scenario_week_markdown_type';

  INSERT INTO ephemeral.scenario_week_markdown_type
  SELECT
          sw.weeks AS week,
          m.markdown_type_id
        FROM markdown_type m
          CROSS JOIN ephemeral.scenario_weeks sw
        WHERE m.name IN ('New', 'Further');
  RAISE NOTICE '[get_scenario_data]     Count: %', d_row_count;

  CREATE TEMP TABLE IF NOT EXISTS ephemeral.hierarchy_path
    (
    hierarchy_id INT,
    depth INT,
    path INT[]
    )
  ON COMMIT DROP;

  INSERT INTO ephemeral.hierarchy_path
    SELECT
      hierarchy_id,
      depth,
      array_remove((string_to_array(path,':','')),null)::INT[] as path
    FROM hierarchy;

  --
  -- Header
  --
  RAISE NOTICE '[get_scenario_data] Writing ref_header';
  OPEN ref_header FOR
  SELECT
    COUNT(*) AS product_count,
    MAX(partition_number) AS partition_count
  FROM ephemeral.product_price_ladder;
  RETURN NEXT ref_header;

  --
  -- Scenario
  --
  RAISE NOTICE '[get_scenario_data] Writing ref_scenario';
  OPEN ref_scenario FOR
  SELECT
    scenario_id,
    schedule_mask,
    schedule_week_min,
    schedule_week_max,
    schedule_stage_min,
    schedule_stage_max,
    stage_max,
    stage_offset_max,
    price_floor,
    markdown_count_start_week,
    default_markdown_type,
    default_decision_state_name,
    allow_promo_as_markdown,
    minimum_promo_percentage,
    organisation_id
  FROM scenario AS s
  WHERE scenario_id = p_scenario_id;
  RETURN NEXT ref_scenario;

  --
  -- Price Ladder Values
  --
  RAISE NOTICE '[get_scenario_data] Writing ref_price_ladder_values';
  OPEN ref_price_ladder_values FOR
  SELECT
    plv.price_ladder_value_id,
    plv.price_ladder_id,
    pl.price_ladder_type_id,
    plv."order",
    plv."value"
  FROM price_ladder_value AS plv
  JOIN price_ladder AS pl ON pl.price_ladder_id = plv.price_ladder_id
  ORDER BY plv.price_ladder_id, "order";
  RETURN NEXT ref_price_ladder_values;

  --
  -- Hierarchy
  --
  RAISE NOTICE '[get_scenario_data] Writing ref_hierarchy';
  OPEN ref_hierarchy FOR
  SELECT
    ph.hierarchy_id,
    ph.parent_id,
    ph.depth,
    ph.name,
    ph.path
  FROM ephemeral.hierarchy ph;
  RETURN NEXT ref_hierarchy;

  --
  -- Hierarchy Sell Through
  --
  RAISE NOTICE '[get_scenario_data] Writing ref_hierarchy_sell_through';
  OPEN ref_hierarchy_sell_through FOR
  SELECT
    hierarchy_sell_through_id,
    hierarchy_id,
    value
  FROM ephemeral.hierarchy_sell_through;
  RETURN NEXT ref_hierarchy_sell_through;

  --
  -- Products
  --
  RAISE NOTICE '[get_scenario_data] Creating scenario_product';
  CREATE TEMP TABLE IF NOT EXISTS ephemeral.scenario_product
  (
    product_id INT,
    partition_number INT,
    name VARCHAR(50),
    current_markdown_count INT,
    current_stock INT,
    current_selling_price DECIMAL(34,2),
    current_sales_quantity INT,
    current_cost_price DECIMAL(34,2),
    original_selling_price DECIMAL(34,2),
    current_cover DECIMAL(34,2),
    data_intake_plus_future_commitment_stock INT
  )
  ON COMMIT DROP;

  RAISE NOTICE '[get_scenario_data] Calling get_scenario_product_data';
  PERFORM ephemeral.get_scenario_product_data
  (
      p_model_run_id := p_model_run_id,
      p_scenario_id := p_scenario_id,
      p_scenario_week := p_scenario_week,
      p_schedule_week_min := p_schedule_week_min,
      p_weeks_to_extrapolate_on := p_weeks_to_extrapolate_on,
      p_decay_backdrop := p_decay_backdrop,
      p_observed_decay_min := p_observed_decay_min,
      p_observed_decay_max := p_observed_decay_max,
      p_extrapolate := p_extrapolate,
      p_extrapolation_end_week := p_extrapolation_end_week,
      p_allow_promo_as_markdown := p_allow_promo_as_markdown,
      p_minimum_promo_percentage := p_minimum_promo_percentage,
	  p_observed_decay_cap := p_observed_decay_cap
  );
   /* The above function now populates the temp_scenario_product table with the data required for the scenario. This is either data from the latest week or the extrapolated sales data */

    RAISE NOTICE '[get_get_discount_rules] Calling get_product_markdown_type';
  PERFORM ephemeral.get_product_markdown_type ();

   RAISE NOTICE '[get_product_minimum_absolute_price_change] Calling get_product_minimum_absolute_price_change';
  PERFORM ephemeral.get_product_minimum_absolute_price_change
  (
    p_scenario_id := p_scenario_id
  );

  RAISE NOTICE '[get_get_discount_rules] Calling get_product_discount_rules';
  PERFORM ephemeral.get_product_discount_rules
  (
      p_scenario_id := p_scenario_id
  );

  RAISE NOTICE '[get_product_flowline_threshold_exceeded_flag] Calling get_product_flowline_threshold_exceeded_flag';
  PERFORM ephemeral.get_product_flowline_threshold_exceeded_flag
  (
    p_scenario_id := p_scenario_id
  );
 
  RAISE NOTICE '[get_scenario_data] Writing ref_product';
  OPEN ref_product FOR
  SELECT
    tsp.product_id,
    tsp.partition_number,
    tsp.name,
    tsp.current_markdown_count,
    tsp.current_stock,
    tsp.current_selling_price,
    tsp.current_sales_quantity,
    tsp.current_cost_price,
    tsp.original_selling_price,
    tsp.current_cover,
    pmt.current_markdown_type_id as current_markdown_type
  FROM ephemeral.scenario_product tsp
  JOIN ephemeral.product_markdown_type pmt ON pmt.product_id = tsp.product_id AND pmt.partition_number = tsp.partition_number
  JOIN in_scope_scenario_product issp ON issp.product_id = pmt.product_id
  ORDER BY partition_number;
  RETURN NEXT ref_product;

  --
  -- Product Hierarchies
  --
  RAISE NOTICE '[get_scenario_data] Writing ref_product_hierarchy';
  OPEN ref_product_hierarchy FOR
  SELECT
    ppl.product_id,
    ppl.partition_number,
    h.hierarchy_id,
    h.path AS hierarchy_path,
    h.name AS hierarchy_name
  FROM ephemeral.product_price_ladder AS ppl
    JOIN ephemeral.product_hierarchy AS ph ON ph.product_id = ppl.product_id
    JOIN ephemeral.hierarchy AS h ON h.hierarchy_id = ph.hierarchy_id
    JOIN in_scope_scenario_product AS issp ON issp.product_id = ppl.product_id
  ORDER BY ppl.partition_number, ppl.product_id;
  RETURN NEXT ref_product_hierarchy;

  --
  -- Product Price Ladder
  --
  RAISE NOTICE '[get_scenario_data] Writing ref_product_price_ladder';
  OPEN ref_product_price_ladder FOR
  SELECT
    ppl.product_id,
    ppl.partition_number,
    ppl.price_ladder_id
  FROM ephemeral.product_price_ladder AS ppl
  ORDER BY ppl.partition_number;
  RETURN NEXT ref_product_price_ladder;

  --
  -- Product Tax Rate
  --
  RAISE NOTICE '[get_scenario_data] Writing ref_product_sales_tax';
  OPEN ref_product_sales_tax FOR
  SELECT
    pst.product_id,
    ppl.partition_number,
    pst.week,
    rate
  FROM ephemeral.product_sales_tax as pst
  JOIN ephemeral.product_price_ladder AS ppl ON ppl.product_id = pst.product_id
  ORDER BY ppl.partition_number, pst.product_id;
  RETURN NEXT ref_product_sales_tax;

  --
  -- Product Parameter Values
  --
  RAISE NOTICE '[get_scenario_data] Writing ref_product_parameter_values';
  OPEN ref_product_parameter_values FOR
  SELECT
    tsp.product_id,
    tsp.partition_number,
    CASE WHEN tsp.current_cover < COALESCE(spp.minimum_cover, 0)
      THEN 0
    ELSE NULL END AS Mask,
    CASE WHEN spp.max_markdowns IS NULL
      THEN NULL
    ELSE GREATEST((spp.max_markdowns - tsp.current_markdown_count), 0) END AS max_markdown,
    COALESCE(pftef.has_exceeded_flowline_threshold, 0) as has_exceeded_flowline_threshold
  FROM ephemeral.scenario_product tsp
  LEFT JOIN scenario_product_parameters spp
  ON spp.product_id = tsp.product_id AND spp.scenario_id = p_scenario_id
  LEFT JOIN ephemeral.product_flowline_threshold_exceeded_flag pftef
  ON pftef.product_id = tsp.product_id
  ORDER BY tsp.partition_number, tsp.product_id asc;
  RETURN NEXT ref_product_parameter_values;

  --
  -- Scenario Product Markdown Constraint
  --
  RAISE NOTICE '[get_scenario_data] Writing ref_product_markdown_constraint';
  OPEN ref_product_markdown_constraint FOR
  SELECT
    tsp.product_id,
    tsp.partition_number,
    sw.weeks as week,
    COALESCE(sms.markdown_type_id, s.default_markdown_type) as markdown_type_id
  FROM ephemeral.scenario_weeks sw
  CROSS JOIN ephemeral.scenario_product tsp
  LEFT JOIN scenario s ON s.scenario_id = p_scenario_id
  LEFT JOIN scenario_markdown_constraint sms ON sms.scenario_id = p_scenario_id AND sms.week = sw.weeks
  ORDER BY tsp.partition_number, tsp.product_id, sw.weeks asc ;
  RETURN NEXT ref_product_markdown_constraint;

  --
  -- Flex Factors
  --
  RAISE NOTICE '[get_scenario_data] Writing ref_flex_factor';
  OPEN ref_flex_factor FOR
  WITH
  cteProductList
  -- We need to find all the products in the hierarchy plus identify which week/factor
  AS    (   SELECT  hi.depth,
                    sff.week,
                    ph.product_id,
                    sff.flex_factor
            FROM    scenario_flex_factor        AS sff
            JOIN    ephemeral.hierarchy_path AS hi ON sff.hierarchy_id = hi.hierarchy_id AND sff.hierarchy_id = ANY (hi.path)
            JOIN    ephemeral.product_hierarchy AS ph   ON ph.hierarchy_id = hi.hierarchy_id
            JOIN    ephemeral.scenario_product  AS tsp  ON ph.product_id = tsp.product_id
            WHERE   sff.scenario_id     = p_scenario_id
  ),
  cteProductSelect
  AS    (   SELECT  product_id,
                    week,
                    max(depth)          AS depth
            FROM    cteProductList
            GROUP BY
                    product_id,
                    week
  ),
  cteSparseList
  AS    (   SELECT  pl.product_id,
                    pl.week,
                    pl.flex_factor
            FROM    cteProductSelect    cs
            JOIN    cteProductList      pl  ON cs.product_id = pl.product_id
                                            AND cs.week = pl.week
                                            AND cs.depth = pl.depth
  )
  SELECT    tsp.product_id,
            tsp.partition_number,
            sw.weeks                    AS week,
            COALESCE( sl.flex_factor, 1 )
                                        AS flex_factor
  FROM      ephemeral.scenario_product  tsp
  CROSS JOIN
            ephemeral.scenario_weeks              sw
  LEFT JOIN cteSparseList               sl  ON tsp.product_id = sl.product_id
                                            AND sw.weeks = sl.week
  ORDER BY  tsp.partition_number,
            tsp.product_id,
            sw.weeks;
  RETURN NEXT ref_flex_factor;

    --
  -- Scenario Product Minimum Absoulute Price Change
  --
  RAISE NOTICE '[get_scenario_data] Writing ref_product_minimum_absolute_price_change';
  OPEN ref_product_minimum_absolute_price_change FOR
  SELECT
  pmap.product_id,
  pmap.partition_number,
  pmap.minimum_absolute_price_change
  FROM ephemeral.product_minimum_absolute_price_change pmap
  ORDER BY pmap.partition_number, pmap.product_id asc ;
  RETURN NEXT ref_product_minimum_absolute_price_change;

  --
  -- Scenario Week Parameters
  --
  RAISE NOTICE '[get_scenario_data] Writing ref_product_markdown_constraint';
  OPEN ref_product_week_parameter_values FOR
  SELECT
    tsp.product_id,
    tsp.partition_number,
    sw.weeks as week,
    COALESCE(swp.minimum_relative_percentage_price_change, 0) as minimum_relative_percentage_price_change
  FROM ephemeral.scenario_weeks sw
  CROSS JOIN ephemeral.scenario_product tsp
  LEFT JOIN scenario_week_parameters swp ON swp.scenario_id = p_scenario_id AND swp.week = sw.weeks
  ORDER BY tsp.partition_number, tsp.product_id, sw.weeks asc ;
  RETURN NEXT ref_product_week_parameter_values;

  --
  -- Product Discount Rules
  --
  RAISE NOTICE '[get_scenario_data] Writing ref_product_week_markdown_type_parameter_values';
  OPEN ref_product_week_markdown_type_parameter_values FOR
  SELECT
  tsp.product_id,
  tsp.partition_number,
  swm.week,
  swm.markdown_type_id,
  COALESCE(psr.min_discount_percentage, 0) as min_discount_percentage,
  COALESCE(psr.max_discount_percentage, 1) as max_discount_percentage
  FROM ephemeral.scenario_week_markdown_type swm
  CROSS JOIN ephemeral.scenario_product tsp
  LEFT JOIN ephemeral.product_discount_rules psr
  ON  psr.product_id = tsp.product_id AND tsp.partition_number = psr. partition_number AND psr.week = swm.week AND psr.markdown_type_id = swm.markdown_type_id
  ORDER BY tsp.partition_number, tsp.product_id, swm.week, swm.markdown_type_id asc;
  RETURN NEXT ref_product_week_markdown_type_parameter_values;

END;
$$ LANGUAGE plpgsql;
