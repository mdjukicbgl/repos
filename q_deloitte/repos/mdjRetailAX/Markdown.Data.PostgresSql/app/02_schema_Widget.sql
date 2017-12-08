CREATE TABLE widget (
  widget_id          SERIAL				NOT NULL,
  widget_type_id     INTEGER			NOT NULL,
  organisation_id integer not null,

  CONSTRAINT pk_widget PRIMARY KEY (widget_id),
  CONSTRAINT fk_widget_widget_type FOREIGN KEY (widget_type_id) REFERENCES widget_type (widget_type_id),
  CONSTRAINT widget_fk_organisation_id FOREIGN KEY (organisation_id) REFERENCES organisation (organisation_id) 
)
;

CREATE TABLE IF NOT EXISTS widget_instance (
  widget_instance_id SERIAL                 NOT NULL,
  widget_id          INTEGER                NOT NULL,
  dashboard_id       INTEGER                NOT NULL,
  layout_ordinal_id  INTEGER DEFAULT (1)    NOT NULL,
  title              VARCHAR(255) DEFAULT ('Unnamed widget'),
  json               JSONB                  NULL,
  json_version       INTEGER DEFAULT (1)    NOT NULL,
  is_visible         BOOL DEFAULT (true)    NOT NULL,
  
  CONSTRAINT pk_widget_instance PRIMARY KEY (widget_instance_id),
  CONSTRAINT fk_widget_instance_widget FOREIGN KEY (widget_id) REFERENCES widget (widget_id),
  CONSTRAINT fk_widget_instance_dashboard FOREIGN KEY (dashboard_id) REFERENCES dashboard (dashboard_id)
);
