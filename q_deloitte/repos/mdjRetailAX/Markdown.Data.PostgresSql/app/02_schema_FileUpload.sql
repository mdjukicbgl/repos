CREATE TABLE file_upload (
  file_upload_id      SERIAL        NOT NULL,
  file_upload_type_id INTEGER       NOT NULL,
  guid                UUID          NOT NULL,
  name                VARCHAR(255)  NOT NULL,
  size                BIGINT        NOT NULL,
  last_modified_date  TIMESTAMPTZ   NOT NULL,
  presigned_url       VARCHAR(2048) NOT NULL,
  expiration_date     TIMESTAMPTZ   NOT NULL,
  is_aborted          BOOLEAN       NOT NULL,
  start_date          TIMESTAMPTZ   NOT NULL,
  finish_date         TIMESTAMPTZ,
  CONSTRAINT pk_file_upload PRIMARY KEY (file_upload_id),
  CONSTRAINT fk_file_upload_type FOREIGN KEY (file_upload_type_id) REFERENCES file_upload_type (file_upload_type_id)
);


