DROP VIEW IF EXISTS stage.uv_fiscal_calendar_data_file;

CREATE VIEW stage.uv_fiscal_calendar_data_file
	(
	retailer_bkey
	,batch_id
	,calendar_date
	,fiscal_month_number
	,fiscal_month_name
	,fiscal_week_number
	,fiscal_quarter_number
	,fiscal_year
	,is_working_day
	,is_business_holiday
	,is_national_holiday
	,fiscal_week_day_name
	,fiscal_quarter_name
	)
AS
SELECT
	retailer_bkey
	,batch_id
	,calendar_date
	,fiscal_month_number
	,fiscal_month_name
	,fiscal_week_number
	,fiscal_quarter_number
	,fiscal_year
	,is_working_day
	,is_business_holiday
	,is_national_holiday
	,fiscal_week_day_name
	,fiscal_quarter_name
FROM
	stage.fiscal_calendar_dimension;