CREATE TABLE recommendation_projection (
  recommendation_projection_guid UUID           NOT NULL,
  recommendation_guid            UUID           NOT NULL,

  client_id                      INTEGER        NOT NULL,
  scenario_id                    INTEGER        NOT NULL,

  week                           INTEGER        NOT NULL,
  discount                       DECIMAL(34, 4) NOT NULL,
  price                          DECIMAL(34, 4) NOT NULL,
  quantity                       INTEGER        NOT NULL,
  revenue                        DECIMAL(34, 4) NOT NULL,
  stock                          INTEGER        NOT NULL,
  markdown_cost                  DECIMAL(34, 4) NOT NULL,
  accumulated_markdown_count     INTEGER        NOT NULL,
  markdown_count                 INTEGER        NOT NULL,
  elasticity                     DECIMAL(34, 4) NOT NULL,
  decay                          DECIMAL(34, 4) NOT NULL,
  markdown_type_id               INTEGER        NOT NULL,

  CONSTRAINT pk_recommendation_projection PRIMARY KEY (recommendation_projection_guid),
  CONSTRAINT fk_recommendation_projection_recommendation FOREIGN KEY (recommendation_guid) REFERENCES recommendation (recommendation_guid) ON DELETE CASCADE,
  CONSTRAINT fk_recommendation_projection_scenario_id FOREIGN KEY (scenario_id) REFERENCES scenario (scenario_id) ON DELETE CASCADE
);

CREATE INDEX idx_recommendation_projection_client_scenario ON recommendation_projection (client_id, scenario_id);
CREATE INDEX idx_recommendation_projection_client_scenario_recommendation ON recommendation_projection (client_id, scenario_id, recommendation_guid);
CREATE INDEX idx_recommendation_projection_client_scenario_week ON recommendation_projection (client_id, scenario_id, week);