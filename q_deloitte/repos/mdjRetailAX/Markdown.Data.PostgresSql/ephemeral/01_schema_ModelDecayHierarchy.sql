CREATE TEMP TABLE IF NOT EXISTS ephemeral.model_decay_hierarchy (
  model_decay_hierarchy_id  SERIAL          NOT NULL,
  model_run_id              INTEGER             NOT NULL,
  stage                     INTEGER             NOT NULL,
  stage_offset              INTEGER             NOT NULL,
  hierarchy_id              INTEGER             NOT NULL,
  hierarchy_name            VARCHAR(128)    NOT NULL,
  children                  INTEGER             NOT NULL,
  decay                     DECIMAL(34, 4)  NOT NULL,
  CONSTRAINT pk_model_decay_hierarchy PRIMARY KEY (model_decay_hierarchy_id),
  CONSTRAINT uix_model_decay_hierarchy UNIQUE (model_run_id, stage, stage_offset, hierarchy_id)
)
ON COMMIT DROP;
