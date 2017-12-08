CREATE TABLE file_upload_scenario (
  file_upload_scenario_id   SERIAL   NOT NULL,
  file_upload_id      INTEGER        NOT NULL,
  scenario_id         INTEGER       NOT NULL,
  CONSTRAINT pk_file_upload_scenario PRIMARY KEY (file_upload_scenario_id),
  CONSTRAINT fk_file_upload_scenario_fileid FOREIGN KEY (file_upload_id) REFERENCES file_upload (file_upload_id),
  CONSTRAINT fk_file_upload_scenario_scenarioid FOREIGN KEY (scenario_id) REFERENCES scenario (scenario_id)
);
