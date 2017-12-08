CREATE TABLE dashboard (
  dashboard_id             SERIAL                                       NOT NULL,
  dashboard_layout_type_id INTEGER                                      NOT NULL,
  title                    VARCHAR(255) DEFAULT ('Unnamed dashboard')   NOT NULL,
  CONSTRAINT pk_dashboard PRIMARY KEY (dashboard_id),
  CONSTRAINT fk_dashboard_dashboard_layout FOREIGN KEY (dashboard_layout_type_id) REFERENCES dashboard_layout_type (dashboard_layout_type_id)
);