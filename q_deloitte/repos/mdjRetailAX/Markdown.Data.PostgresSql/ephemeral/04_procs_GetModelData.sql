CREATE OR REPLACE FUNCTION ephemeral.get_model_data
(
  p_model_week INT
)
RETURNS VOID
AS $$

DECLARE
  d_row_count INTEGER;

BEGIN
  RAISE NOTICE '[get_model_data] Getting model data (p_model_week: %)', p_model_week;

  RAISE NOTICE '[get_model_data] Load hierarchy';
  INSERT INTO ephemeral.hierarchy
  (
    hierarchy_id,
    parent_id,
    depth,
    name,
    path
  )
  SELECT
    *
  FROM dblink('datawarehouse',
    $REDSHIFT$
      SELECT
         dim_hierarchy_node_id as hierarchy_id,
         parent_dim_hierarchy_node_id as parent_id,
         hierarchy_node_level as depth,
         hierarchy_node_name as name,
         hierarchy_breadcrumb_node_id as path
      FROM
         markdown_app.uv_dim_hierarchy_node dh
      LEFT OUTER JOIN  ((SELECT MAX(hierarchy_node_level) as MaxNode, dim_hierarchy_id FROM markdown_app.uv_dim_hierarchy_node GROUP BY dim_hierarchy_id)) MN
                    ON MN.dim_hierarchy_id = dh.dim_hierarchy_id
      WHERE
          dh.dim_hierarchy_id = 3 -- Currently pulling in a specific hierarchy
         AND effective_end_date_time = '2500-01-01 00:00:00' -- Currently only pulling in the latest version of this type of hierarchy
         AND hierarchy_node_level != MN.MaxNode -- Filter out the product level
      ;
    $REDSHIFT$
  ) AS dbl_hierarchy
  (
    hierarchy_id int,
    parent_id int,
    depth int,
    name varchar(128),
    path varchar(128)
  );
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_model_data]     Count: %', d_row_count;

  RAISE NOTICE '[get_model_data] Load product_hierarchy';
  INSERT INTO ephemeral.product_hierarchy
  (
    product_id,
    hierarchy_id
  )
  SELECT
    *
  FROM dblink('datawarehouse',
    $REDSHIFT$
      SELECT
             dp.dim_product_id,
             dp.dim_hierarchy_node_id
      FROM
             markdown_app.uv_dim_product dp
      WHERE
             dp.dim_retailer_id = 1
             AND dp.dim_hierarchy_id = 3
      ;
    $REDSHIFT$
  ) AS temp_product_hierarchy
  (
    product_id int,
    hierarchy_id int
  );
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_model_data]     Count: %', d_row_count;

  RAISE NOTICE '[get_model_data] Load product';
  INSERT INTO ephemeral.product
  (
    product_id,
    name,
    original_selling_price
  )
  SELECT
    *
  FROM dblink('datawarehouse',
    $REDSHIFT$
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
    $REDSHIFT$
  ) AS dbl_product
  (
   product_id INTEGER, name varchar(128),
   original_selling_price NUMERIC (34,4)
  );
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_model_data]     Count: %', d_row_count;

  RAISE NOTICE '[get_model_data] Load product_sales_tax';
  INSERT INTO ephemeral.product_sales_tax
  (
    product_id,
    week,
    rate
  )
  SELECT
    *
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
           AND ddwuv.week_sequence_number_usa <= ' || p_model_week || '
    ) AS r
    WHERE r.rank = 1
    ORDER BY dim_product_id'
  ) AS dbl_product_sales_tax
  (
    product_id int,
    week int,
    rate NUMERIC (34,4)
  );
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_model_data]     Count: %', d_row_count;

  RAISE NOTICE '[get_model_data] Load product_sales';
  INSERT INTO ephemeral.product_sales
  (
    product_id,
    week,
    price,
    quantity,
    stock,
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
      fwsba.cost_price,
      fwsba.price_status,
      fwsba.price_status_id,
      fwsba.previous_price_status,
      fwsba.previous_price_status_id
    FROM
    markdown_app.uv_fact_weekly_sales_basic_aggregated fwsba
    WHERE fwsba.week_sequence_number_usa <= ' || p_model_week || '
    ;'
  ) AS dbl_product_sales
  (
   product_id int,
   week int,
   price numeric(34,4),
   quantity numeric(34,4) ,
   stock numeric(34,4),
   cost_price numeric(34,4),
   price_status varchar(50),
   price_status_id int,
   previous_price_status varchar(50),
   previous_price_status_id int
  );
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_model_data]     Count: %', d_row_count;

  RAISE NOTICE '[get_model_data] Load product_price_changes';
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
  SELECT
    *
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
  WHERE week_sequence_number_usa <= ' || p_model_week || '
  ;'
  ) AS dbl_product_price_changes
  (
     product_id int,
     week int,
     quantity numeric(34,4),
     previous_quantity numeric(34,4),
     price numeric(34,4),
     previous_price numeric(34,4),
     is_md_preceded_by_promotion int,
     is_promotional_price_change int,
     is_full_price int
  );
  GET DIAGNOSTICS d_row_count = ROW_COUNT;
  RAISE NOTICE '[get_model_data]     Count: %', d_row_count;
END;

$$ LANGUAGE  plpgsql;
