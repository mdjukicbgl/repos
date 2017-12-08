-- DROP FUNCTION public.fn_delete_result_partition(INTEGER, INTEGER, INTEGER);
-- SELECT * FROM fn_delete_result_partition("p_client_id" := 0, "p_scenario_id" := 100, "p_partition_number" := 1)
CREATE OR REPLACE FUNCTION fn_delete_result_partition(
  p_client_id        INTEGER,
  p_scenario_id      INTEGER,
  p_partition_number INTEGER
)
  RETURNS VOID AS $$
BEGIN

  -- Delete projections
  DELETE FROM recommendation_projection p
  WHERE p.recommendation_projection_guid IN (
    SELECT p.recommendation_projection_guid
    FROM recommendation_projection p
      JOIN recommendation r ON r.recommendation_guid = p.recommendation_guid
      JOIN recommendation_product rp ON rp.recommendation_product_guid = r.recommendation_product_guid
    WHERE rp.client_id = p_client_id
          AND rp.scenario_id = p_scenario_id
          AND rp.partition_number = p_partition_number
  );

  -- Delete recommendations
  DELETE
  FROM recommendation r
  WHERE r.recommendation_guid IN (
    SELECT r.recommendation_guid
    FROM recommendation r
      JOIN recommendation_product rp ON rp.recommendation_product_guid = r.recommendation_product_guid
    WHERE rp.client_id = p_client_id
          AND rp.scenario_id = p_scenario_id
          AND rp.partition_number = p_partition_number
  );

  -- Delete products
  DELETE FROM recommendation_product
  WHERE client_id = p_client_id
        AND scenario_id = p_scenario_id
        AND partition_number = p_partition_number;

END;
$$ LANGUAGE plpgsql;
