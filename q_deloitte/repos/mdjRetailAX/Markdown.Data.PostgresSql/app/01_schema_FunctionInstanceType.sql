CREATE TABLE function_instance_type (
  function_instance_type_id SERIAL       NOT NULL,
  sequence_order           INTEGER      NOT NULL,
  is_success               NUMERIC(1)   NOT NULL,
  is_error                 NUMERIC(1)   NOT NULL,
  name                     VARCHAR(255) NOT NULL,
  description              VARCHAR(255) NOT NULL,
  CONSTRAINT pk_function_instance_type PRIMARY KEY (function_instance_type_id)
);

INSERT INTO function_instance_type(function_instance_type_id, sequence_order, is_success, is_error, name, description)
VALUES
    (0, 0, 0, 0, 'None', 'None'),
    (1, 0, 0, 0, 'ModelStarting', 'Model Starting'),
    (2, 1, 0, 0, 'ModelRunning', 'Model Running'),
    (3, 2, 1, 0, 'ModelFinished', 'Model Finished'),
    (4, 3, 1, 1, 'ModelError',  'Model Error'),

    (5, 0, 0, 0, 'PartitionStarting', 'Partition Starting'),
    (6, 1, 0, 0, 'PartitionRunning', 'Partition Running'),
    (7, 2, 1, 0, 'PartitionFinished', 'Partition Finished'),
    (8, 3, 1, 1, 'PartitionError', 'Partition Error'),

    (9, 0, 0, 0, 'CalculateStarting', 'Calculate Starting'),
    (10, 1, 0, 0, 'CalculateRunning', 'Calculate Running'),
    (11, 2, 1, 0, 'CalculateFinished', 'Calculate Finished'),
    (12, 3, 1, 1, 'CalculateError', 'Calculate Error'),

    (13, 0, 0, 0, 'UploadStarting', 'Upload Starting'),
    (14, 1, 0, 0, 'UploadRunning',  'Upload Running'),
    (15, 2, 1, 0, 'UploadFinished',  'Upload Finished'),
    (16, 3, 1, 1, 'UploadError', 'Upload Error')
;
