CREATE TABLE widget_type (
  widget_type_id SERIAL       NOT NULL,
  name           VARCHAR(255) NOT NULL,
  description    VARCHAR(255) NOT NULL,
  CONSTRAINT pk_widget_type PRIMARY KEY (widget_type_id)
);

INSERT INTO widget_type(widget_type_id, name, description)
VALUES
  (0, 'None', 'None'),
  (1, 'ScenarioSummary', 'Summary view of all scenario')
;