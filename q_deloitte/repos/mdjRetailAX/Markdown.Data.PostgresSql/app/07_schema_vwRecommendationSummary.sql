-- DROP VIEW recommendation_summary
CREATE OR REPLACE VIEW recommendation_summary
AS
  SELECT
    r.recommendation_guid recommendation_summary_guid,
    r.recommendation_guid,
    r.recommendation_product_guid,

    r.client_id,
    r.scenario_id,
    p.product_id,
    p.price_ladder_id,
    
    schedule_id,
    s.schedule_mask,
    schedule_markdown_count,
    is_csp,
    price_path_prices,
    price_path_hash_code,
    revision_id,

    rank,
    total_markdown_count,
    terminal_stock,
    total_revenue,
    total_cost,
    total_markdown_cost,
    final_discount,
    stock_value,
    estimated_profit,
    estimated_sales,
    sell_through_rate,
    r.sell_through_target,
    final_markdown_type_id,
    decision_state_id,

    (SELECT array_to_json(array_agg(row_to_json(x)))
     FROM (
            SELECT *
            FROM recommendation_projection proj
            WHERE proj.recommendation_guid = r.recommendation_guid
          ) x
    ) projection_json,

    proj.weeks,
    proj.prices,
    proj.discounts,
    proj.quantities,

    -- TODO refactor this
    weeks[1] as week1,
    prices[1] as price1,
    discounts[1] as discount1,
    weeks[2] as week2,
    prices[2] as price2,
    discounts[2] as discount2,
    weeks[3] as week3,
    prices[3] as price3,
    discounts[3] as discount3,
    weeks[4] as week4,
    prices[4] as price4,
    discounts[4] as discount4,
    weeks[5] as week5,
    prices[5] as price5,
    discounts[5] as discount5,
    weeks[6] as week6,
    prices[6] as price6,
    discounts[6] as discount6,
    weeks[7] as week7,
    prices[7] as price7,
    discounts[7] as discount7,
    weeks[8] as week8,
    prices[8] as price8,
    discounts[8] as discount8,
    weeks[9] as week9,
    prices[9] as price9,
    discounts[9] as discount9,
    weeks[10] as week10,
    prices[10] as price10,
    discounts[10] as discount10,
    s.organisation_id

  FROM recommendation r
  JOIN recommendation_product p ON p.recommendation_product_guid = r.recommendation_product_guid
  JOIN (
    SELECT
      rp.recommendation_guid,
      ARRAY_AGG(week
      ORDER BY week)     weeks,
      ARRAY_AGG(price
      ORDER BY week)     prices,
      ARRAY_AGG(discount
      ORDER BY week)     discounts,
      ARRAY_AGG(quantity
      ORDER BY week)     quantities
    FROM recommendation_projection rp
      INNER JOIN recommendation r ON rp.recommendation_guid = r.recommendation_guid
    GROUP BY rp.recommendation_guid
  ) proj ON r.recommendation_guid = proj.recommendation_guid
  join scenario s on r.scenario_id = s.scenario_id




