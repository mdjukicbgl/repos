create table role
(
	role_id serial not null
		constraint pk_role
			primary key,
	name varchar(128)	not null,
	description varchar(128) not null,
	module_id integer not null,

	CONSTRAINT fk_module_id FOREIGN KEY (module_id)
  REFERENCES module (module_id) ON DELETE CASCADE
)
;