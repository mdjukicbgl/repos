CREATE TABLE function_group (
  function_group_id         SERIAL                            NOT NULL,
  function_type_id          INTEGER                           NOT NULL,
  function_group_type_id    INTEGER                           NOT NULL,
  function_version          VARCHAR(20) DEFAULT ('$LATEST')   NOT NULL,
  function_instance_total   INTEGER                           NOT NULL,

  timeout_date TIMESTAMPTZ DEFAULT (now() + interval '300 seconds') NOT NULL,
  created_date TIMESTAMPTZ DEFAULT now() NOT NULL,

  CONSTRAINT pk_function_group PRIMARY KEY (function_group_id),
  CONSTRAINT fk_function_group_function_type FOREIGN KEY (function_type_id) REFERENCES function_type (function_type_id),
  CONSTRAINT fk_function_group_function_group_type FOREIGN KEY (function_group_type_id) REFERENCES function_group_type (function_group_type_id)
);