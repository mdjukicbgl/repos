create table user_role
(
	user_role_id serial not null
		constraint pk_user_role
			primary key,
	user_id integer not null,
	role_id integer not null,

	 UNIQUE (user_id, role_id),
	CONSTRAINT fk_user_id FOREIGN KEY (user_id)
  REFERENCES "user" (user_id) ON DELETE CASCADE,

  CONSTRAINT fk_ur_role_id FOREIGN KEY (role_id)
  REFERENCES role (role_id) ON DELETE CASCADE
)
;