/*
FY14: Mon 24 Feb 2014
FY15: Mon 2 Mar 2015
FY16: Mon 29 Feb 2016
FY17: Mon 27 Feb 2017

And you’re correct, the quarters are
Q1 = weeks 1-13
Q2 = weeks 14-26
Q3 = weeks 27-39
Q4 = weeks 40-52 (or 40-53 if applicable)
--*/
TRUNCATE TABLE Stage.fiscal_calendar
INSERT INTO Stage.fiscal_calendar
		(
			batch_id
			,reporting_date
			,reporting_date_period_type
			,calendar_date
			--,fiscal_month_number
			,fiscal_month_name
			--,fiscal_week_number
			--,fiscal_quarter_number
			,fiscal_year
			--,is_working_day
			--,is_business_holiday
			--,is_national_holiday
			,fiscal_week_day_name
			--,fiscal_quarter_name
		)
SELECT
	1 batch_id
	,CAST(GETDATE()-1 AS DATE) reporting_date
	,0 reporting_date_period_type
	,calendar_date
	--,fiscal_month_number
	,calendar_month_name AS fiscal_month_name
	--,fiscal_week_number
	--,fiscal_quarter_number
	,2014 fiscal_year
	--,is_working_day
	--,is_business_holiday
	--,is_national_holiday
	,DATENAME(WEEKDAY,calendar_date)
FROM
	Conformed.dim_date
WHERE
	calendar_date BETWEEN '24 Feb 2014' AND '1 Mar 2015'
UNION ALL
SELECT
	1 batch_id
	,CAST(GETDATE()-1 AS DATE) reporting_date
	,0 reporting_date_period_type
	,calendar_date
	--,fiscal_month_number
	,calendar_month_name AS fiscal_month_name
	--,fiscal_week_number
	--,fiscal_quarter_number
	,2015 fiscal_year
	--,is_working_day
	--,is_business_holiday
	--,is_national_holiday
	,DATENAME(WEEKDAY,calendar_date)
FROM
	Conformed.dim_date
WHERE
	calendar_date BETWEEN '2 Mar 2015' AND '28 Feb 2016'
UNION ALL
SELECT
	1 batch_id
	,CAST(GETDATE()-1 AS DATE) reporting_date
	,0 reporting_date_period_type
	,calendar_date
	--,fiscal_month_number
	,calendar_month_name AS fiscal_month_name
	--,fiscal_week_number
	--,fiscal_quarter_number
	,2016 fiscal_year
	--,is_working_day
	--,is_business_holiday
	--,is_national_holiday
	,DATENAME(WEEKDAY,calendar_date)
FROM
	Conformed.dim_date
WHERE
	calendar_date BETWEEN '29 Feb 2016' AND '26 Feb 2017'
UNION ALL
SELECT
	1 batch_id
	,CAST(GETDATE()-1 AS DATE) reporting_date
	,0 reporting_date_period_type
	,calendar_date
	--,fiscal_month_number
	,calendar_month_name AS fiscal_month_name
	--,fiscal_week_number
	--,fiscal_quarter_number
	,2017 fiscal_year
	--,is_working_day
	--,is_business_holiday
	--,is_national_holiday
	,DATENAME(WEEKDAY,calendar_date)
FROM
	Conformed.dim_date
WHERE
	calendar_date BETWEEN '27 Feb 2017' AND '25 Feb 2018';

UPDATE fc
SET fc.fiscal_week_number = a.Fiscal_week_number
FROM
	(
	SELECT
		fc.calendar_date
		,ROW_NUMBER() OVER (PARTITION BY fc.fiscal_year ORDER BY dd.calendar_date) AS Fiscal_week_number
	FROM
		Conformed.dim_date dd
	INNER JOIN
		Stage.fiscal_calendar fc ON dd.calendar_date = fc.calendar_date
	WHERE
		dd.is_weekday7_eu_iso = 1
	) a
INNER JOIN
	Stage.fiscal_calendar fc ON a.calendar_date = fc.calendar_date ;