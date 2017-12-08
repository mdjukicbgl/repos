CREATE TABLE recommendation (
  recommendation_guid         UUID           NOT NULL,
  recommendation_product_guid UUID           NOT NULL,

  client_id                   INTEGER        NOT NULL,
  scenario_id                 INTEGER        NOT NULL,

  schedule_id                 INTEGER        NOT NULL,
  schedule_mask               INTEGER        NOT NULL,
  schedule_markdown_count     INTEGER        NOT NULL,
  is_csp                      BOOLEAN        NOT NULL,
  price_path_prices           VARCHAR(256)   NOT NULL,
  price_path_hash_code        INTEGER        NOT NULL,
  revision_id                 INTEGER        NOT NULL,

  rank                        INTEGER        NOT NULL,
  total_markdown_count        INTEGER        NOT NULL,
  terminal_stock              DECIMAL(34, 4) NOT NULL,
  total_revenue               DECIMAL(34, 4) NOT NULL,
  total_cost                  DECIMAL(34, 4) NOT NULL,
  total_markdown_cost         DECIMAL(34, 4) NOT NULL,
  final_discount              DECIMAL(34, 4) NULL,
  stock_value                 DECIMAL(34, 4) NOT NULL,
  estimated_profit            DECIMAL(34, 4) NOT NULL,
  estimated_sales             DECIMAL(34, 4) NOT NULL,
  sell_through_rate           DECIMAL(34, 4) NOT NULL,
  sell_through_target         DECIMAL(34, 4) NOT NULL,
  final_markdown_type_id      INTEGER        NOT NULL,

  -- TODO remove
  decision_state_id           INTEGER        NOT NULL DEFAULT(0),

  created_at                TIMESTAMPTZ DEFAULT now() NOT NULL,
  created_by                INTEGER NOT NULL,
  updated_at                TIMESTAMPTZ,
  updated_by                INTEGER, 

  CONSTRAINT pk_recommendation PRIMARY KEY (recommendation_guid),
  CONSTRAINT fk_recommendation_scenario FOREIGN KEY (scenario_id) REFERENCES scenario (scenario_id) ON DELETE CASCADE,
  CONSTRAINT fk_recommendation_product FOREIGN KEY (recommendation_product_guid) REFERENCES recommendation_product (recommendation_product_guid) ON DELETE CASCADE,
  CONSTRAINT  recommendation_fk_created_by FOREIGN KEY (created_by) REFERENCES "user" (user_id),
  CONSTRAINT  recommendation_fk_updated_by FOREIGN KEY (updated_by) REFERENCES "user" (user_id)
);

CREATE INDEX idx_recommendation_client_scenario ON recommendation (client_id, scenario_id);
CREATE INDEX idx_recommendation_client_scenario_product ON recommendation (client_id, scenario_id, recommendation_product_guid);
CREATE INDEX idx_recommendation_client_scenario_csp ON recommendation (client_id, scenario_id, is_csp);
CREATE INDEX idx_recommendation_client_scenario_rank ON recommendation (client_id, scenario_id, rank);
CREATE INDEX idx_recommendation_client_scenario_rank_revision ON recommendation (client_id, scenario_id, rank, revision_id);