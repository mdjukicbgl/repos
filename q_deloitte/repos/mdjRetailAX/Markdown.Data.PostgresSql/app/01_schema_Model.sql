CREATE TABLE IF NOT EXISTS model (
  model_id           SERIAL                     NOT NULL,
  week               INTEGER                    NULL,
  stage_max          INTEGER                    NOT NULL,
  stage_offset_max   INTEGER                    NOT NULL,
  decay_min          DECIMAL(34, 4)             NULL,
  decay_max          DECIMAL(34, 4)             NULL,
  decay_default      DECIMAL(34, 4) DEFAULT (1) NOT NULL,
  elasticity_min     DECIMAL(34, 4)             NULL,
  elasticity_max     DECIMAL(34, 4)             NULL,
  elasticity_default DECIMAL(34, 4) DEFAULT (1) NOT NULL,
  CONSTRAINT pk_model PRIMARY KEY (model_id)
)
;

