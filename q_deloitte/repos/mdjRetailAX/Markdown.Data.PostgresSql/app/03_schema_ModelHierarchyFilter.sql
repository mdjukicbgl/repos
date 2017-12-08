CREATE TABLE IF NOT EXISTS model_hierarchy_filter
(
  model_hierarchy_filter_id SERIAL  NOT NULL
    CONSTRAINT pk_model_hierarchy_filter
    PRIMARY KEY,
  model_id                  INTEGER NOT NULL,
  hierarchy_id              INTEGER NOT NULL,
  stage                     INT,
  min_elasticity            DECIMAL(34, 4),
  max_elasticity            DECIMAL(34, 4),
  min_decay                 DECIMAL(34, 4),
  max_decay                 DECIMAL(34, 4),
  CONSTRAINT fk_hierarchy_filter_model_id FOREIGN KEY (model_id) REFERENCES model (model_id) ON DELETE CASCADE
);
