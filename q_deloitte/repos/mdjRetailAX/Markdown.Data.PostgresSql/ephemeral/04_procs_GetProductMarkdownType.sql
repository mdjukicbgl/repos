CREATE OR REPLACE FUNCTION ephemeral.get_product_markdown_type()
  RETURNS VOID
AS $$

BEGIN
  CREATE TEMP TABLE IF NOT EXISTS ephemeral.product_markdown_type (
    product_markdown_type_id SERIAL,
    product_id               INT,
    partition_number         INT,
    current_markdown_type_id INT,
    CONSTRAINT pk_product_markdown_type PRIMARY KEY (product_markdown_type_id)
  )
  ON COMMIT DROP;


  RAISE NOTICE '[get_product_markdown_type] Load product markdown type';
  INSERT INTO ephemeral.product_markdown_type
  (
    product_id,
    partition_number,
    current_markdown_type_id
  )
    SELECT
      tsp.product_id,
      tsp.partition_number,
      2 AS current_markdown_type_id
    FROM ephemeral.scenario_product tsp
      JOIN in_scope_scenario_product issp ON issp.product_id = tsp.product_id
    WHERE tsp.current_markdown_count = 0 and tsp.current_selling_price >= tsp.original_selling_price
    UNION
    SELECT
      tsp.product_id,
      tsp.partition_number,
      1 AS current_markdown_type_id
    FROM ephemeral.scenario_product tsp
      JOIN in_scope_scenario_product issp ON issp.product_id = tsp.product_id
    WHERE tsp.current_markdown_count >= 0 and tsp.current_selling_price < tsp.original_selling_price;
END
$$ LANGUAGE plpgsql;
