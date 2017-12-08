CREATE TEMP TABLE IF NOT EXISTS ephemeral.model_elasticity_hierarchy (
  model_elasticity_hierarchy_id SERIAL          NOT NULL,
  model_run_id                  INTEGER             NOT NULL,
  stage                         INTEGER             NOT NULL,
  hierarchy_id                  INTEGER             NOT NULL,
  hierarchy_name                VARCHAR(128)    NOT NULL,
  children                      INTEGER             NOT NULL,
  quantity                      DECIMAL(34, 4)  NOT NULL,
  price                         DECIMAL(34, 4)  NOT NULL,
  price_elasticity              DECIMAL(34, 4)  NOT NULL,
  CONSTRAINT pk_model_elasticity_hierarchy PRIMARY KEY (model_elasticity_hierarchy_id),
  CONSTRAINT uix_model_elasticity_hierarchy UNIQUE (model_run_id, stage, hierarchy_id)
)
ON COMMIT DROP;
