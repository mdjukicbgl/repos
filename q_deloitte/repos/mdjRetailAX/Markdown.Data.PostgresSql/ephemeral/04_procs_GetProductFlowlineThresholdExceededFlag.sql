CREATE OR REPLACE FUNCTION ephemeral.get_product_flowline_threshold_exceeded_flag(p_scenario_id INTEGER)
  RETURNS VOID
AS $$

BEGIN
  CREATE TEMP TABLE IF NOT EXISTS ephemeral.product_flowline_threshold_exceeded_flag (
    product_flowline_threshold_exceeded_flag_id SERIAL,
    product_id                                  INT,
    partition_number                            INT,
    has_exceeded_flowline_threshold             INT,
    CONSTRAINT pk_product_flowline_threshold_exceeded_flag PRIMARY KEY (product_flowline_threshold_exceeded_flag_id)
  )
  ON COMMIT DROP;


  RAISE NOTICE '[get_product_flowline_threshold_exceeded_flag] Load product product flowline threshold exceeded flag';

  WITH
      cteProductList
      -- We need to find all the products in the hierarchy plus identify which parameter value to use
    AS (   SELECT
             hi.depth,
             ph.product_id,
             shp.max_flowline_stock_quantity_threshold
           FROM scenario_hierarchy_parameters AS shp
             JOIN ephemeral.hierarchy_path AS hi
               ON shp.hierarchy_id = hi.hierarchy_id AND shp.hierarchy_id = ANY (hi.path)
             JOIN ephemeral.product_hierarchy AS ph ON ph.hierarchy_id = hi.hierarchy_id
             JOIN ephemeral.scenario_product AS tsp ON ph.product_id = tsp.product_id
           WHERE shp.scenario_id = p_scenario_id
    ),
      cteProductSelect
    AS (   SELECT
             product_id,
             max(depth) AS depth
           FROM cteProductList
           GROUP BY
             product_id
    ),
      cteSparseList
    AS (   SELECT
             pl.product_id,
             pl.max_flowline_stock_quantity_threshold
           FROM cteProductList pl
             LEFT JOIN cteProductSelect cs ON cs.product_id = pl.product_id
                                              AND cs.depth = pl.depth
           GROUP BY
             pl.product_id,
             pl.max_flowline_stock_quantity_threshold
    ),
      cteFlowlineThreshold AS
    (
      SELECT
        tsp.product_id,
        tsp.partition_number,
        0 AS has_exceeded_flowline_threshold
      FROM ephemeral.scenario_product tsp
        JOIN cteSparseList csl ON tsp.product_id = csl.product_id
      WHERE tsp.data_intake_plus_future_commitment_stock <= csl.max_flowline_stock_quantity_threshold
      UNION
      SELECT
        tsp.product_id,
        tsp.partition_number,
        1 AS has_exceeded_flowline_threshold
      FROM ephemeral.scenario_product tsp
        JOIN cteSparseList csl ON tsp.product_id = csl.product_id
      WHERE tsp.data_intake_plus_future_commitment_stock > csl.max_flowline_stock_quantity_threshold
    )
  INSERT INTO ephemeral.product_flowline_threshold_exceeded_flag
  (
    product_id,
    partition_number,
    has_exceeded_flowline_threshold
  )
    SELECT
      cpt.product_id,
      cpt.partition_number,
      cpt.has_exceeded_flowline_threshold
    FROM cteFlowlineThreshold cpt;
END
$$ LANGUAGE plpgsql;
