CREATE TABLE file_upload_type (
  file_upload_type_id   SERIAL       NOT NULL,
  name                  VARCHAR(255) NOT NULL,
  description           VARCHAR(255) NOT NULL,
  CONSTRAINT pk_file_upload_type PRIMARY KEY (file_upload_type_id)
);

-- TODO better description
INSERT INTO file_upload_type (file_upload_type_id, name, description)
VALUES
  (0, 'None', 'None'),
  (1, 'Product', 'List of products');

