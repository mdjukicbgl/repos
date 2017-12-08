CREATE TABLE IF NOT EXISTS model_run
(
	model_run_id SERIAL NOT NULL CONSTRAINT pk_model_run PRIMARY KEY,
	model_id INTEGER NOT NULL,
	created_date TIMESTAMPTZ DEFAULT now() NOT NULL
)
;

