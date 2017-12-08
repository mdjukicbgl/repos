CREATE TEMP TABLE IF NOT EXISTS ephemeral.hierarchy (
  hierarchy_id SERIAL       NOT NULL,
  parent_id    INTEGER      NULL,
  depth        INTEGER      NOT NULL,
  name         VARCHAR(128) NULL,
  path         VARCHAR(128) NOT NULL,
  CONSTRAINT pk_hierarchy PRIMARY KEY (hierarchy_id)
)
ON COMMIT DROP;
