CREATE TEMP TABLE IF NOT EXISTS ephemeral.model_event (
  model_event_id    SERIAL             NOT NULL,
  model_run_id      INTEGER            NOT NULL,
  product_id        INTEGER            NOT NULL,
  stage             INTEGER            NOT NULL,
  week              INTEGER            NOT NULL,
  quantity          INTEGER            NOT NULL,
  previous_quantity INTEGER            NULL,
  price             DECIMAL(34, 4) NOT NULL,
  previous_price    DECIMAL(34, 4) NULL,
  price_elasticity  DECIMAL(34, 4) NOT NULL,
  CONSTRAINT pk_model_event PRIMARY KEY (model_event_id),
  CONSTRAINT uix_model_event UNIQUE (model_run_id, product_id, stage, week)
)
ON COMMIT DROP;

