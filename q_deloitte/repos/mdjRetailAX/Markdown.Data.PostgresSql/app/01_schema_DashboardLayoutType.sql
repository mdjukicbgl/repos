CREATE TABLE dashboard_layout_type (
  dashboard_layout_type_id SERIAL       NOT NULL,
  description              VARCHAR(255) NOT NULL,
  CONSTRAINT pk_dashboard_layout_type PRIMARY KEY (dashboard_layout_type_id)
);

INSERT INTO dashboard_layout_type(dashboard_layout_type_id, description)
VALUES
    (0, 'None'),
    (1, 'Grid')
;