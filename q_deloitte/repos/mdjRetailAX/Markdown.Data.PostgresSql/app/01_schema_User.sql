create table "user"
(
  user_id serial not null
    constraint pk_user
      primary key,
  user_name varchar(128)  not null,
  organisation_id integer not null,

  CONSTRAINT fk_organisation_id FOREIGN KEY (organisation_id)
  REFERENCES organisation (organisation_id) ON DELETE CASCADE
)
;