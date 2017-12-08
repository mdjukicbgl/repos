CREATE TABLE function_instance (
  function_instance_id              SERIAL                            NOT NULL,

  function_group_id                 INTEGER                           NOT NULL,
  function_instance_type_id         INTEGER                           NOT NULL,
  function_instance_number          INTEGER                           NOT NULL,

  json                            JSON                              NULL,
  json_version                    INTEGER                           NOT NULL,

  timeout_date TIMESTAMPTZ DEFAULT (now() + interval '300 seconds') NOT NULL,
  created_date TIMESTAMPTZ DEFAULT now() NOT NULL,

  CONSTRAINT pk_function_instance PRIMARY KEY (function_instance_id),
  CONSTRAINT fk_function_instance_group FOREIGN KEY (function_group_id) REFERENCES function_group (function_group_id),
  CONSTRAINT fk_function_instance_type FOREIGN KEY (function_instance_type_id) REFERENCES function_instance_type (function_instance_type_id)
);
