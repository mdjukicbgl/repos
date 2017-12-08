-- DROP VIEW recommendation_product_summary
CREATE OR REPLACE VIEW recommendation_product_summary
AS
  SELECT
    rp.recommendation_product_guid recommendation_product_summary_guid,
    rp.recommendation_product_guid,

    rp.client_id,
    rp.scenario_id,
    rp.model_id,
    rp.product_id,
    rp.product_name,
    rp.price_ladder_id,

    rp.partition_number,
    rp.partition_count,

    rp.hierarchy_id,
    rp.hierarchy_name,

    coalesce(rev.revision_count, 0) revision_count,

    rp.schedule_count,
    rp.schedule_cross_product_count,
    rp.schedule_product_mask_filter_count,
    rp.schedule_max_markdown_filter_count,

    rp.high_prediction_count,
    rp.negative_revenue_count,
    rp.invalid_markdown_type_count,

    rp.current_markdown_count,
    rp.current_markdown_type_id,
    rp.current_selling_price,
    rp.original_selling_price,
    rp.current_cost_price,
    rp.current_stock,
    rp.current_sales_quantity,

    rp.sell_through_target,

    rp.current_markdown_depth,
    rp.current_discount_ladder_depth,

    rp.state_name,
    rp.decision_state_name,

    rec.recommendation_guid recommendation_guid,
    csp.recommendation_guid csp_recommendation_guid,
    rev.recommendation_guid rev_recommendation_guid,

    (CASE
     WHEN rp.decision_state_name = 'Revised' AND rev.recommendation_guid IS NOT NULL
       THEN rev.recommendation_guid
     WHEN rp.decision_state_name = 'Accepted' AND rec.recommendation_guid IS NOT NULL
       THEN rec.recommendation_guid
     WHEN rp.decision_state_name = 'Rejected' AND csp.recommendation_guid IS NOT NULL
       THEN csp.recommendation_guid
     ELSE
       COALESCE(rev.recommendation_guid, rec.recommendation_guid, csp.recommendation_guid)
     END
    ) decision_recommendation_guid

  FROM recommendation_product rp

    LEFT JOIN recommendation csp ON csp.client_id = rp.client_id
                                    AND csp.scenario_id = rp.scenario_id
                                    AND csp.recommendation_product_guid = rp.recommendation_product_guid
                                    AND csp.is_csp = TRUE

    LEFT JOIN recommendation rec ON rec.client_id = rp.client_id
                                    AND rec.scenario_id = rp.scenario_id
                                    AND rec.recommendation_product_guid = rp.recommendation_product_guid
                                    AND rec.is_csp = FALSE
                                    AND rec.rank = 1
                                    AND rec.revision_id = 0

    LEFT JOIN (
        SELECT
          r.recommendation_guid,
          r.recommendation_product_guid,
          rp.client_id,
          rp.scenario_id,
          rp.product_id,

          MAX(r.revision_id) OVER (PARTITION BY rp.scenario_id, rp.product_id) AS revision_count,

          ROW_NUMBER()
          OVER (
            PARTITION BY rp.scenario_id, rp.product_id
            ORDER BY revision_id DESC, rank ASC ) AS final_rank
        FROM recommendation r
          JOIN recommendation_product rp ON rp.recommendation_product_guid = r.recommendation_product_guid
        WHERE revision_id > 0
      ) rev
      ON rev.recommendation_product_guid = rp.recommendation_product_guid
         AND rev.client_id = rp.client_id
         AND rev.scenario_id = rp.scenario_id
         AND final_rank = 1;
