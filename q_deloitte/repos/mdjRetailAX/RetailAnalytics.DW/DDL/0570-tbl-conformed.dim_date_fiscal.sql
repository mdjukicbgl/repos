-- Create fiscal calendar
CREATE TABLE IF NOT EXISTS Conformed.dim_date_fiscal
	(
		dim_retailer_id INT NOT NULL
		,batch_id INT NOT NULL
		,dim_date_id INT NOT NULL
		,is_weekday7 BOOL NOT NULL
		,is_working_day BOOL NOT NULL
		,is_business_holiday BOOL NOT NULL
		,is_national_holiday BOOL NOT NULL
		,fiscal_date_string CHAR(11) NOT NULL
		,fiscal_day_of_month INT NOT NULL
		,fiscal_day_with_suffix VARCHAR(6) NOT NULL
		,fiscal_month_number INT NOT NULL
		,fiscal_month_name NVARCHAR(30) NOT NULL
		,fiscal_month_start_date DATE NOT NULL
		,fiscal_month_end_date DATE NOT NULL
		,fiscal_year_month INT NOT NULL
		,fiscal_week_number SMALLINT NOT NULL
		,fiscal_continuum_year_week_number INT NOT NULL
		,fiscal_continuum_year_week_number_start_date DATE NOT NULL
		,fiscal_continuum_year_week_number_end_date DATE NOT NULL
		,fiscal_week_day_number SMALLINT NOT NULL
		,fiscal_week_day_name NVARCHAR(30) NOT NULL
		,fiscal_quarter_name VARCHAR(6) NOT NULL
		,fiscal_quarter_number SMALLINT NOT NULL
		,fiscal_quarter_day_number INT NOT NULL
		,fiscal_quarter_month_number INT NOT NULL
		,fiscal_quarter_start_date DATE NOT NULL
		,fiscal_quarter_end_date DATE NOT NULL
		,fiscal_year INT NOT NULL
		,fiscal_year_start_date DATE NOT NULL
		,fiscal_year_end_date DATE NOT NULL
		,CONSTRAINT PK_dim_date_fiscal PRIMARY KEY (dim_retailer_id,dim_date_id)
	);

ALTER TABLE Conformed.dim_date_fiscal  ADD FOREIGN KEY(dim_date_id)
REFERENCES Conformed.dim_date (dim_date_id);

ALTER TABLE Conformed.dim_date_fiscal ADD FOREIGN KEY (dim_retailer_id)
REFERENCES Conformed.dim_retailer (dim_retailer_id);
