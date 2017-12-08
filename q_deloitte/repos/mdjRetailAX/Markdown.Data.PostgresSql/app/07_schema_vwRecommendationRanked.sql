CREATE OR REPLACE VIEW recommendation_ranked
AS
  WITH rank1_revisions_accepted_and_csp AS
  (
      SELECT
        row_number()
        OVER (
          PARTITION BY r.scenario_id, rp.product_id
          ORDER BY r.revision_id DESC, r.rank ASC ) AS revision_rank,
        r.recommendation_guid,
        r.rank,
        r.decision_state_id,
        r.is_csp
      FROM recommendation AS r
        JOIN recommendation_product rp ON rp.recommendation_product_guid = r.recommendation_product_guid
      WHERE (r.decision_state_id = 2 AND r.rank = 1) OR (r.is_csp = 'TRUE')
  )
  SELECT
    r.recommendation_guid,

    rp.client_id,
    rp.scenario_id,
    rp.product_id,
    rp.product_name,
    rp.model_id,
    rp.price_ladder_id,
    rp.partition_number,
    rp.partition_count,
    rp.current_selling_price,
    rp.original_selling_price,
    rp.hierarchy_id,
    rp.hierarchy_name,
    rp.state_name,
    rp.decision_state_name,

    r.rank,
    r.is_csp,
    r.decision_state_id,
    dst.decision_state_type_name,

    r.terminal_stock,
    r.schedule_id,
    r.schedule_mask,
    r.total_markdown_count,
    r.schedule_markdown_count,
    r.price_path_hash_code,
    r.revision_id,
    r.price_path_prices,
    r.sell_through_rate,
    r.sell_through_target,

    r.total_revenue,
    r.estimated_profit,
    r.estimated_sales,
    r.final_discount,
    r.stock_value
  FROM recommendation r
    JOIN recommendation_product rp ON rp.recommendation_product_guid = r.recommendation_product_guid
    JOIN rank1_revisions_accepted_and_csp r1 ON r.recommendation_guid = r1.recommendation_guid AND r1.revision_rank = 1
    JOIN decision_state_type dst ON r.decision_state_id = dst.decision_state_type_id

