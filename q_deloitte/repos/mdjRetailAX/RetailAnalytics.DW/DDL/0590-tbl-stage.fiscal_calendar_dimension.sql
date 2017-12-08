CREATE TABLE IF NOT EXISTS stage.fiscal_calendar_dimension
	(
		batch_id INT NOT NULL
		,reporting_date DATE NOT NULL
		,reporting_date_period_type SMALLINT
		,retailer_bkey VARCHAR(20) NOT NULL
		,calendar_date DATE NOT NULL
		,dim_retailer_id INT NULL
		,dim_date_id INT NULL
		,is_weekday7 BOOL NULL
		,is_working_day BOOL NULL
		,is_business_holiday BOOL NULL
		,is_national_holiday BOOL NULL
		,fiscal_date_string CHAR(11) NULL
		,fiscal_day_of_month INT NULL
		,fiscal_day_with_suffix VARCHAR(6) NULL
		,fiscal_month_number INT NOT NULL
		,fiscal_month_name VARCHAR(30) NOT NULL
		,fiscal_month_start_date DATE NULL
		,fiscal_month_end_date DATE NULL
		,fiscal_year_month INT NULL
		,fiscal_week_number SMALLINT NOT NULL
		,fiscal_continuum_year_week_number INT NULL
		,fiscal_continuum_year_week_number_start_date DATE NULL
		,fiscal_continuum_year_week_number_end_date DATE NULL
		,fiscal_week_day_number SMALLINT NULL
		,fiscal_week_day_name VARCHAR(30) NULL
		,fiscal_quarter_name VARCHAR(6) NULL
		,fiscal_quarter_number SMALLINT NOT NULL
		,fiscal_quarter_day_number INT NULL
		,fiscal_quarter_month_number INT NULL
		,fiscal_quarter_start_date DATE NULL
		,fiscal_quarter_end_date DATE NULL
		,fiscal_year INT NOT NULL
		,fiscal_year_start_date DATE NULL
		,fiscal_year_end_date DATE NULL
	);