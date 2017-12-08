CREATE TEMP TABLE IF NOT EXISTS ephemeral.model_decay_average (
  model_decay_average_id SERIAL          NOT NULL,
  model_run_id           INTEGER             NOT NULL,
  stage                  INTEGER             NOT NULL,
  stage_offset           INTEGER             NOT NULL,
  parent_hierarchy_id    INTEGER             NULL,
  hierarchy_id           INTEGER             NOT NULL,
  hierarchy_name         VARCHAR(128)    NULL,
  children               INTEGER             NOT NULL,
  decay                  DECIMAL(34, 4)  NULL,
  CONSTRAINT pk_model_decay_average PRIMARY KEY (model_decay_average_id),
  CONSTRAINT uix_model_decay_average UNIQUE (model_run_id, stage, stage_offset, hierarchy_id)
)
ON COMMIT DROP;
