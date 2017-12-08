CREATE TEMP TABLE IF NOT EXISTS ephemeral.model_elasticity_average (
  model_elasticity_average_id SERIAL         NOT NULL,
  model_run_id                INTEGER            NOT NULL,
  stage                       INTEGER            NOT NULL,
  parent_hierarchy_id         INTEGER            NULL,
  hierarchy_id                INTEGER            NOT NULL,
  hierarchy_name              VARCHAR(128)   NULL,
  children                    INTEGER            NULL,
  quantity                    DECIMAL(34, 4) NULL,
  price                       DECIMAL(34, 4) NULL,
  price_elasticity            DECIMAL(34, 4) NULL,
  CONSTRAINT pk_model_elasticity_average PRIMARY KEY (model_elasticity_average_id),
  CONSTRAINT uix_model_elasticity_average UNIQUE (model_run_id, stage, hierarchy_id)
)
ON COMMIT DROP;
