DROP VIEW IF EXISTS markdown_app.uv_dim_date_weekly_usa;

CREATE VIEW markdown_app.uv_dim_date_weekly_usa
AS
SELECT
	dd.dim_date_id
	,dd.day_sequence_number
	,dd.week_sequence_number_usa
	,dd.month_sequence_number
	,dd.calendar_date
	,dd.is_weekday7_usa
	,dd.calendar_date_usa
	,dd.calendar_day_of_month
	,dd.day_with_suffix
	,dd.calendar_month_number
	,dd.calendar_month_name
	,dd.calendar_month_start_date
	,dd.calendar_month_end_date
	,dd.calendar_year_month
	,dd.calendar_week_number_usa
	,dd.calendar_continuum_year_week_number_usa
	,dd.calendar_continuum_year_week_number_usa_start_date
	,dd.calendar_continuum_year_week_number_usa_end_date
	,dd.week_day_number_usa
	,dd.week_day_name
	,dd.calendar_quarter_name
	,dd.calendar_quarter_number
	,dd.calendar_quarter_day_number
	,dd.calendar_quarter_month_number
	,dd.calendar_quarter_start_date
	,dd.calendar_quarter_end_date
	,dd.calendar_year
	,dd.calendar_year_start_date
	,dd.calendar_year_end_date
FROM
	conformed.dim_date dd
WHERE
	dd.is_weekday7_usa = 1;