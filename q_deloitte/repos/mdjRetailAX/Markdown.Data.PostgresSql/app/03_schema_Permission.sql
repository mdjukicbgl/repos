create table permission
(
	permission_id serial not null
		constraint pk_permission
			primary key,
	permission_code varchar(128) not null,
	description varchar(128) not null
)
;