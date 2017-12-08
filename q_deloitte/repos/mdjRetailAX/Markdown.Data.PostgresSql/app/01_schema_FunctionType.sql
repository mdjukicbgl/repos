CREATE TABLE IF NOT EXISTS function_type (
  function_type_id  SERIAL       NOT NULL,
  name            VARCHAR(255) NOT NULL,
  CONSTRAINT pk_function_type PRIMARY KEY (function_type_id)
);

INSERT INTO function_type (function_type_id, name)
VALUES
  (0, 'None'),
  (1, 'Markdown');