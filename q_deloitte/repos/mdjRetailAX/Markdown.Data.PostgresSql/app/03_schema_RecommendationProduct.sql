CREATE TABLE recommendation_product (
  recommendation_product_guid        UUID           NOT NULL,

  client_id                          INTEGER        NOT NULL,
  scenario_id                        INTEGER        NOT NULL,

  model_id                           INTEGER        NOT NULL,
  product_id                         INTEGER        NOT NULL,
  product_name                       VARCHAR(128)   NOT NULL,
  price_ladder_id                    INTEGER        NOT NULL,

  partition_number                   INTEGER        NOT NULL,
  partition_count                    INTEGER        NOT NULL,

  hierarchy_id                       INTEGER        NOT NULL,
  hierarchy_name                     VARCHAR(128)   NOT NULL,

  schedule_count                     INTEGER        NOT NULL,
  schedule_cross_product_count       INTEGER        NOT NULL,
  schedule_product_mask_filter_count INTEGER        NOT NULL,
  schedule_max_markdown_filter_count INTEGER        NOT NULL,

  high_prediction_count              INTEGER        NOT NULL,
  negative_revenue_count             INTEGER        NOT NULL,
  invalid_markdown_type_count        INTEGER        NOT NULL,

  current_markdown_count             INTEGER        NOT NULL,
  current_markdown_type_id           INTEGER        NOT NULL,
  current_selling_price              DECIMAL(34, 4) NOT NULL,
  original_selling_price             DECIMAL(34, 4) NOT NULL,
  current_cost_price                 DECIMAL(34, 4) NOT NULL,
  current_stock                      INTEGER        NOT NULL,
  current_sales_quantity             INTEGER        NOT NULL,

  sell_through_target                DECIMAL(34, 4) NOT NULL,

  current_markdown_depth             DECIMAL(34, 4) NOT NULL,
  current_discount_ladder_depth      DECIMAL(34, 4) NULL,

  state_name                         VARCHAR(12)    NOT NULL,
  decision_state_name                VARCHAR(12)    NOT NULL,

  created_at                TIMESTAMPTZ DEFAULT now() NOT NULL,
  created_by                INTEGER NOT NULL,
  updated_at                TIMESTAMPTZ,
  updated_by                INTEGER,

  CONSTRAINT pk_recommendation_product PRIMARY KEY (recommendation_product_guid),
  CONSTRAINT fk_recommendation_product_scenario FOREIGN KEY (scenario_id) REFERENCES scenario (scenario_id) ON DELETE CASCADE,
  CONSTRAINT recommendation_product_fk_created_by FOREIGN KEY (created_by) REFERENCES "user" (user_id),
  CONSTRAINT  recommendation_product_fk_updated_by FOREIGN KEY (updated_by) REFERENCES "user" (user_id)
);

CREATE INDEX idx_recommendation_product_client_scenario ON recommendation_product (client_id, scenario_id);
CREATE INDEX idx_recommendation_product_client_scenario_partition ON recommendation_product (client_id, scenario_id, partition_number);