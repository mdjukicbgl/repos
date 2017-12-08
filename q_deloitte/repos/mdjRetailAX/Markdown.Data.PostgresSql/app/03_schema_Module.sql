create table module
(
	module_id serial not null
		constraint pk_module
			primary key,
	name varchar(128)	not null,
	description varchar(128) not null
)
;
