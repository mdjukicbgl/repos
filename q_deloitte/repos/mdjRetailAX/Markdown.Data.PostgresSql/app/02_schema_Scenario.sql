CREATE TABLE scenario
(
  scenario_id                 SERIAL                    NOT NULL
    CONSTRAINT pk_scenario
    PRIMARY KEY,
  week                        INTEGER,
  schedule_week_min           INTEGER                   NOT NULL,
  schedule_week_max           INTEGER                   NOT NULL,
  schedule_stage_min          INTEGER                   NOT NULL,
  schedule_stage_max          INTEGER                   NOT NULL,
  stage_max                   INTEGER,
  stage_offset_max            INTEGER,
  price_floor                 NUMERIC(34, 4),
  scenario_name               VARCHAR(128),
  schedule_mask               INTEGER DEFAULT 255       NOT NULL,
  markdown_count_start_week   INTEGER                   NOT NULL,
  default_markdown_type       INTEGER                   NOT NULL,
  default_decision_state_name VARCHAR(12)               NOT NULL,
  allow_promo_as_markdown     BOOLEAN                   NOT NULL DEFAULT FALSE,
  minimum_promo_percentage    NUMERIC(5, 4)             NOT NULL DEFAULT 0,
  organisation_id             INTEGER                   NOT NULL,
  created_at                  TIMESTAMPTZ DEFAULT now() NOT NULL,
  created_by                  INTEGER                   NOT NULL,
  updated_at                  TIMESTAMPTZ,
  updated_by                  INTEGER,

  CONSTRAINT scenario_fk_organisation_id FOREIGN KEY (organisation_id) REFERENCES organisation (organisation_id),
  CONSTRAINT scenario_fk_created_by FOREIGN KEY (created_by) REFERENCES "user" (user_id),
  CONSTRAINT scenario_fk_updated_by FOREIGN KEY (updated_by) REFERENCES "user" (user_id)

);


