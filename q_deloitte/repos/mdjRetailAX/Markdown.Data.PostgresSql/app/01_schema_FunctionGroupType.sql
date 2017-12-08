CREATE TABLE function_group_type (
  function_group_type_id SERIAL       NOT NULL,
  sequence_order       INTEGER      NOT NULL,
  name                 VARCHAR(255) NOT NULL,
  CONSTRAINT pk_function_group_type PRIMARY KEY (function_group_type_id)
);

INSERT INTO function_group_type(function_group_type_id, sequence_order, name)
VALUES
    (0, 1, 'None'),
    (1, 2, 'Model'),
    (2, 3, 'Partition'),
    (3, 4, 'Calculate'),
    (4, 5, 'Upload')
;
