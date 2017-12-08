create table organisation
(
	organisation_id serial not null
		constraint pk_organisation
			primary key,
	organisation_name varchar(128)	not null
)
;