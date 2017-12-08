create table role_permission
(
	role_permission_id serial not null
		constraint pk_role_permission
			primary key,
	role_id integer not null,
	permission_id integer not null,

	 UNIQUE (role_id, permission_id),
	CONSTRAINT fk_permission_id FOREIGN KEY (permission_id)
  REFERENCES permission (permission_id) ON DELETE CASCADE,

  CONSTRAINT fk_rp_role_id FOREIGN KEY (role_id)
  REFERENCES role (role_id) ON DELETE CASCADE
)
;