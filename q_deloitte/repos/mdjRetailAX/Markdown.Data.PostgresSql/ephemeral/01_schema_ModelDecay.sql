CREATE TEMP TABLE IF NOT EXISTS ephemeral.model_decay (
  model_decay_id      SERIAL          NOT NULL,
  model_run_id        INTEGER             NOT NULL,
  product_id          INTEGER             NOT NULL,
  stage               INTEGER             NOT NULL,
  stage_offset        INTEGER             NOT NULL,
  week                INTEGER             NOT NULL,
  parent_hierarchy_id INTEGER             NULL,
  hierarchy_id        INTEGER             NOT NULL,
  hierarchy_name      VARCHAR(128)    NULL,
  decay               DECIMAL(34, 4)  NULL,
  CONSTRAINT pk_model_decay PRIMARY KEY (model_decay_id),
  CONSTRAINT uix_model_decay UNIQUE (model_run_id, product_id, stage, stage_offset, decay)
)
ON COMMIT DROP;
