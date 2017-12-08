CREATE OR REPLACE FUNCTION ephemeral.get_product_discount_rules(p_scenario_id INTEGER)
  RETURNS VOID
AS $$

BEGIN
  CREATE TEMP TABLE IF NOT EXISTS ephemeral.product_discount_rules (
    product_discount_rules  SERIAL,
    product_id              INT,
    partition_number        INT,
    week                    INT,
    markdown_type_id        INT,
    min_discount_percentage NUMERIC(5, 2),
    max_discount_percentage NUMERIC(5, 2),
    CONSTRAINT pk_product_discount_rules PRIMARY KEY (product_discount_rules)
  )
  ON COMMIT DROP;


  RAISE NOTICE '[get_product_discount_rules] Load product discount rules';
  WITH
      cteProductList
      -- We need to find all the products in the hierarchy plus identify which week/factor
    AS (   SELECT
             hi.depth,
             swmp.week,
             ph.product_id,
             swmp.markdown_type_id,
             swmp.min_discount_percentage,
             swmp.max_discount_percentage
           FROM scenario_week_markdown_type_parameters AS swmp
             JOIN ephemeral.hierarchy_path AS hi
               ON swmp.hierarchy_id = hi.hierarchy_id AND swmp.hierarchy_id = ANY (hi.path)
             JOIN ephemeral.product_hierarchy AS ph ON ph.hierarchy_id = hi.hierarchy_id
             JOIN ephemeral.scenario_product AS tsp ON ph.product_id = tsp.product_id
           WHERE swmp.scenario_id = p_scenario_id
    ),
      cteProductSelect
    AS (   SELECT
             product_id,
             week,
             max(depth) AS depth
           FROM cteProductList
           GROUP BY
             product_id,
             week
    ),
      cteSparseList
    AS (   SELECT
             pl.product_id,
             pl.week,
             pl.markdown_type_id,
             pl.min_discount_percentage,
             pl.max_discount_percentage
           FROM cteProductList pl
             LEFT JOIN cteProductSelect cs ON cs.product_id = pl.product_id
                                              AND cs.week = pl.week
                                              AND cs.depth = pl.depth
           GROUP BY
             pl.product_id,
             pl.week,
             pl.markdown_type_id,
             pl.min_discount_percentage,
             pl.max_discount_percentage
    )
  INSERT INTO ephemeral.product_discount_rules
  (
    product_id,
    partition_number,
    week,
    markdown_type_id,
    min_discount_percentage,
    max_discount_percentage
  )
    SELECT
      tsp.product_id,
      tsp.partition_number,
      sl.week,
      sl.markdown_type_id,
      sl.min_discount_percentage,
      sl.max_discount_percentage
    FROM ephemeral.scenario_product tsp
      LEFT JOIN cteSparseList sl ON tsp.product_id = sl.product_id;
END
$$ LANGUAGE plpgsql;
