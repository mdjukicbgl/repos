CREATE OR REPLACE FUNCTION ephemeral.get_model_event
(
  p_model_run_id                INTEGER,
  p_elasticity_default          DECIMAL(34, 4),
  p_is_md_count                 BOOLEAN,
  p_allow_promo_as_markdown     BOOLEAN DEFAULT FALSE,
  p_minimum_promo_percentage    DECIMAL(5,4) DEFAULT 0
)
RETURNS VOID
AS $$

DECLARE
  d_row_count INTEGER;

/*
  Scenario Event
  A Markdown Event occurs when a product is sold for less than the previous price (Price < PreviousPrice)
  Price Elasticity of Demand is ((Q1-Q0)/Q0) / ((P1-P0)/P0)
*/
-- Select all Markdown 0 stages from the first product sales
BEGIN

  IF p_is_md_count = TRUE
  THEN
    RAISE NOTICE '[get_model_event] Load model_event (p_is_md_count = TRUE)';
    WITH cte_identify_all_events AS
    (
      SELECT
        p.product_id,
        p.week,
        p.quantity,
        p.previous_quantity,
        p.price,
        p.previous_price,
        p.is_md_preceded_by_promotion,
        p.is_promotional_price_change,
        p.is_full_price
      FROM ephemeral.product_price_changes AS p
    )
    , cte_identify_markdown_events AS
    (
      SELECT
         iea.product_id,
         DENSE_RANK()
            OVER (
            PARTITION BY iea.product_id
            ORDER BY iea.price DESC ) AS stage,
         iea.week,
         iea.quantity,
         iea.previous_quantity,
         iea.price,
         iea.previous_price
       FROM cte_identify_all_events iea
       WHERE
         iea.price < iea.previous_price 
         AND iea.is_full_price = 0
         AND (
           ( p_allow_promo_as_markdown = TRUE
         AND (
              ( iea.is_promotional_price_change = 1
         AND    iea.price < iea.previous_price * ( 1 - p_minimum_promo_percentage )
              )
         OR   ( iea.is_promotional_price_change = 0
         --AND    iea.is_md_preceded_by_promotion = 0
              )
             )
           )
         OR
            (   p_allow_promo_as_markdown = FALSE
         AND    iea.is_promotional_price_change = 0
         AND    iea.is_md_preceded_by_promotion = 0
            )
         )
    )
    INSERT INTO ephemeral.model_event
    (
      model_run_id,
      product_id,
      stage,
      week,
      quantity,
      previous_quantity,
      price,
      previous_price,
      price_elasticity
    )
    SELECT
      p_model_run_id,
      product_id,
      stage,
      week,
      quantity,
      previous_quantity,
      price,
      previous_price,
      1 AS price_elasticity
    FROM cte_identify_markdown_events;
    GET DIAGNOSTICS d_row_count = ROW_COUNT;
    RAISE NOTICE '[get_model_event]     Count: %', d_row_count;
  ELSE
    RAISE NOTICE '[get_model_event] Load model_event (p_is_md_count = FALSE)';
    WITH cte_identify_all_events AS
    (
      SELECT
        p.product_id,
        p.week,
        p.quantity,
        p.previous_quantity,
        p.price,
        p.previous_price,
        p.is_md_preceded_by_promotion,
        p.is_promotional_price_change,
        p.is_full_price
      FROM ephemeral.product_price_changes AS p
    ),
    cte_identify_markdown_events AS
    (
      SELECT
       product_id,
       DENSE_RANK()
       OVER (
         PARTITION BY product_id
         ORDER BY price DESC )                      AS stage,
       week,
       quantity,
       previous_quantity,
       price,
       previous_price,
       COALESCE(NULLIF((
                         ((CAST(quantity AS DECIMAL(34, 4)) - CAST(previous_quantity AS DECIMAL(34, 4))) /
                          CAST(NULLIF(previous_quantity, 0) AS DECIMAL(34, 4)))
                         /
                         NULLIF(((CAST(price AS DECIMAL(34, 4)) - CAST(previous_price AS DECIMAL(34, 4))) /
                                 CAST(NULLIF(previous_price, 0) AS DECIMAL(34, 4))), 0)
                       ), 0), p_elasticity_default) AS price_elasticity
      FROM cte_identify_all_events iea
      WHERE iea.price < iea.previous_price 
      AND   iea.is_md_preceded_by_promotion = 0 
      AND   iea.is_promotional_price_change = 0 
      AND   iea.is_full_price = 0
    )
    INSERT INTO ephemeral.model_event
    (
      model_run_id,
      product_id,
      stage,
      week,
      quantity,
      previous_quantity,
      price,
      previous_price,
      price_elasticity
    )
    SELECT
      p_model_run_id,
      product_id,
      0                    AS stage,
      week,
      quantity,
      NULL                 AS previous_quantity,
      price,
      NULL                 AS previous_price,
      p_elasticity_default AS price_elasticity
    FROM (
           SELECT
             product_id,
             week,
             quantity,
             price,
             DENSE_RANK()
             OVER (
               PARTITION BY product_id
               ORDER BY price DESC, week ASC ) AS Rank
           FROM ephemeral.product_sales) AS r
    WHERE rank = 1
    UNION ALL
    -- Select all remaining
    SELECT
      p_model_run_id,
      product_id,
      stage,
      week,
      quantity,
      previous_quantity,
      price,
      previous_price,
      price_elasticity
    FROM cte_identify_markdown_events;
    GET DIAGNOSTICS d_row_count = ROW_COUNT;
    RAISE NOTICE '[get_model_event]     Count: %', d_row_count;
  END IF;
END;
$$ LANGUAGE plpgsql;