USE RetailAnalyticDm;
GO

SELECT
	*
FROM
	Conformed.dim_retailer dr;


/*
INSERT INTO Stage.fiscal_calendar_dimension
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
*/

UPDATE Stage.fiscal_calendar_dimension
SET dim_date_id = CAST(CONVERT(CHAR(10),calendar_date,112) AS INT)
	,is_working_day = 1
	,is_business_holiday = 0
	,is_national_holiday = 0

UPDATE fcd
SET dim_retailer_id = dr.dim_retailer_id
	,fcd.is_weekday7 = dd.is_weekday7_eu_iso
	,fcd.fiscal_date_string = dd.calendar_date_eu
FROM
	Stage.fiscal_calendar_dimension fcd
INNER JOIN
	Conformed.dim_retailer dr ON fcd.retailer_bkey = dr.retailer_bkey
INNER JOIN
	Conformed.dim_date dd ON fcd.dim_date_id = dd.dim_date_id

UPDATE fcd2
SET fcd2.fiscal_week_number = fcd.fiscal_week_number
FROM
	Stage.fiscal_calendar_dimension fcd
INNER JOIN
	Conformed.dim_date dd ON dd.calendar_date BETWEEN DATEADD(dd,-6,fcd.calendar_date) AND fcd.calendar_date
INNER JOIN
	Stage.fiscal_calendar_dimension fcd2 ON dd.dim_date_id = fcd2.dim_date_id
WHERE
	fcd.fiscal_week_number IS NOT NULL;
		
UPDATE Stage.fiscal_calendar_dimension
SET fiscal_quarter_number =		CASE
									WHEN fiscal_week_number < 14 THEN 1
									WHEN fiscal_week_number < 27 THEN 2
									WHEN fiscal_week_number < 40 THEN 3
									ELSE 4
								END

UPDATE Stage.fiscal_calendar_dimension
SET fiscal_quarter_name =	CONCAT('Q',fiscal_quarter_number);

;WITH QuarterDayNumber
AS	(
	SELECT
		fiscal_year
		,fiscal_quarter_number
		,ROW_NUMBER() OVER (PARTITION BY fiscal_year,fiscal_quarter_number ORDER BY dim_date_id) AS fiscal_quarter_day_number
		,dim_date_id
	FROM
		Stage.fiscal_calendar_dimension
	)
UPDATE fcd
SET
	fiscal_quarter_day_number = qdn.fiscal_quarter_day_number
	,fiscal_month_name = CASE
							WHEN qdn.fiscal_quarter_day_number < 31
								AND fcd.fiscal_quarter_number = 1 THEN 'Month 1'
							WHEN qdn.fiscal_quarter_day_number < 61
								AND fcd.fiscal_quarter_number = 1 THEN 'Month 2'
							WHEN fcd.fiscal_quarter_number = 1 THEN 'Month 3'
							WHEN qdn.fiscal_quarter_day_number < 31
								AND fcd.fiscal_quarter_number = 2 THEN 'Month 4'
							WHEN qdn.fiscal_quarter_day_number < 61
								AND fcd.fiscal_quarter_number = 2 THEN 'Month 5'
							WHEN fcd.fiscal_quarter_number = 2 THEN 'Month 6'
							WHEN qdn.fiscal_quarter_day_number < 31
								AND fcd.fiscal_quarter_number = 3 THEN 'Month 7'
							WHEN qdn.fiscal_quarter_day_number < 61
								AND fcd.fiscal_quarter_number = 3 THEN 'Month 8'
							WHEN fcd.fiscal_quarter_number = 3 THEN 'Month 9'
							WHEN qdn.fiscal_quarter_day_number < 31
								AND fcd.fiscal_quarter_number = 4 THEN 'Month 10'
							WHEN qdn.fiscal_quarter_day_number < 61
								AND fcd.fiscal_quarter_number = 4 THEN 'Month 11'
							WHEN fcd.fiscal_quarter_number = 4 THEN 'Month 12'
						END
FROM
	QuarterDayNumber qdn
INNER JOIN
	Stage.fiscal_calendar_dimension fcd ON qdn.dim_date_id = fcd.dim_date_id;

---------------------------------------------------------------------------------
;WITH QuarterDayNumber
AS	(
	SELECT
		fiscal_year
		,fiscal_quarter_number
		,ROW_NUMBER() OVER (PARTITION BY fiscal_year,fiscal_quarter_number ORDER BY dim_date_id) AS fiscal_quarter_day_number
		,dim_date_id
	FROM
		Stage.fiscal_calendar_dimension
	)
UPDATE fcd
SET
	fiscal_month_number = CASE
							WHEN qdn.fiscal_quarter_day_number < 31
								AND fcd.fiscal_quarter_number = 1 THEN 1
							WHEN qdn.fiscal_quarter_day_number < 61
								AND fcd.fiscal_quarter_number = 1 THEN 2
							WHEN fcd.fiscal_quarter_number = 1 THEN 3
							WHEN qdn.fiscal_quarter_day_number < 31
								AND fcd.fiscal_quarter_number = 2 THEN 4
							WHEN qdn.fiscal_quarter_day_number < 61
								AND fcd.fiscal_quarter_number = 2 THEN 5
							WHEN fcd.fiscal_quarter_number = 2 THEN 6
							WHEN qdn.fiscal_quarter_day_number < 31
								AND fcd.fiscal_quarter_number = 3 THEN 7
							WHEN qdn.fiscal_quarter_day_number < 61
								AND fcd.fiscal_quarter_number = 3 THEN 8
							WHEN fcd.fiscal_quarter_number = 3 THEN 9
							WHEN qdn.fiscal_quarter_day_number < 31
								AND fcd.fiscal_quarter_number = 4 THEN 10
							WHEN qdn.fiscal_quarter_day_number < 61
								AND fcd.fiscal_quarter_number = 4 THEN 11
							WHEN fcd.fiscal_quarter_number = 4 THEN 12
						END
	,fcd.fiscal_quarter_month_number = CASE
							WHEN qdn.fiscal_quarter_day_number < 31 THEN 1
							WHEN qdn.fiscal_quarter_day_number < 61 THEN 2
							ELSE 3
						END
FROM
	QuarterDayNumber qdn
INNER JOIN
	Stage.fiscal_calendar_dimension fcd ON qdn.dim_date_id = fcd.dim_date_id;


;WITH MonthDay
AS	(
	SELECT
		fiscal_year
		,fiscal_month_number
		,ROW_NUMBER() OVER (PARTITION BY fiscal_year,fiscal_month_number ORDER BY dim_date_id) AS fiscal_day_of_month
		,dim_date_id
		,calendar_date
		,fiscal_quarter_number
	FROM
		Stage.fiscal_calendar_dimension
	)
,MonthDateRange
AS	(
	SELECT
		MonthDay.fiscal_year
		,MonthDay.fiscal_month_number
		,MIN(MonthDay.calendar_date) AS fiscal_month_start_date
		,MAX(MonthDay.calendar_date) AS fiscal_month_End_date
	FROM
		MonthDay
	GROUP BY
		MonthDay.fiscal_year
		,MonthDay.fiscal_month_number
	)
,QuarterDateRange
AS	(
	SELECT
		MonthDay.fiscal_year
		,MonthDay.fiscal_quarter_number
		,MIN(MonthDay.calendar_date) AS fiscal_quarter_start_date
		,MAX(MonthDay.calendar_date) AS fiscal_quarter_End_date
	FROM
		MonthDay
	GROUP BY
		MonthDay.fiscal_year
		,MonthDay.fiscal_quarter_number
	)
,YearDateRange
AS	(
	SELECT
		MonthDay.fiscal_year
		,MIN(MonthDay.calendar_date) AS fiscal_year_start_date
		,MAX(MonthDay.calendar_date) AS fiscal_year_End_date
	FROM
		MonthDay
	GROUP BY
		MonthDay.fiscal_year
	)
UPDATE fcd
SET
	fiscal_day_of_month =  md.fiscal_day_of_month
	,fiscal_day_with_suffix =
							CONCAT(md.fiscal_day_of_month
									,CASE
										WHEN RIGHT(CAST(fcd.fiscal_day_of_month AS VARCHAR(3)),2) IN (11,12,13) THEN 'th'
										WHEN RIGHT(CAST(fcd.fiscal_day_of_month AS VARCHAR(3)),1) = '1' THEN 'st'
										WHEN RIGHT(CAST(fcd.fiscal_day_of_month AS VARCHAR(3)),1) = '2' THEN 'nd'
										WHEN RIGHT(CAST(fcd.fiscal_day_of_month AS VARCHAR(3)),1) = '3' THEN 'rd'
										ELSE 'th'
									END
									) 
	,fiscal_month_start_date = mdr.fiscal_month_start_date
	,fiscal_month_End_date = mdr.fiscal_month_End_date
	,fiscal_year_month = (fcd.fiscal_year*100)+fcd.fiscal_month_number
	--,fiscal_continuum_year_week_number
	,fiscal_continuum_year_week_number_start_date = dd.calendar_continuum_year_week_number_eu_start_date 
	,fiscal_continuum_year_week_number_end_date = dd.calendar_continuum_year_week_number_eu_end_date 
	,fiscal_week_day_number = dd.week_day_number_eu_iso 
	,fiscal_quarter_start_date = qdr.fiscal_quarter_start_date
	,fiscal_quarter_end_date = qdr.fiscal_quarter_end_date
	,fiscal_year_start_date = ydr.fiscal_year_start_date
	,fiscal_year_end_date = ydr.fiscal_year_end_date
FROM
	Stage.fiscal_calendar_dimension fcd
INNER JOIN
	Conformed.dim_date dd ON fcd.dim_date_id = dd.dim_date_id
INNER JOIN
	MonthDay md ON fcd.dim_date_id = md.dim_date_id
INNER JOIN
	MonthDateRange mdr ON fcd.fiscal_year = mdr.fiscal_year
						AND md.fiscal_month_number = mdr.fiscal_month_number
INNER JOIN
	QuarterDateRange qdr ON fcd.fiscal_year = qdr.fiscal_year
						AND fcd.fiscal_quarter_number = qdr.fiscal_quarter_number
INNER JOIN
	YearDateRange ydr ON fcd.fiscal_year = ydr.fiscal_year ;

--UPDATE fcd
--SET
--	fiscal_month_number = CASE
--							WHEN qdn.fiscal_quarter_day_number < 31
--								AND fcd.fiscal_quarter_number = 1 THEN 1
--							WHEN qdn.fiscal_quarter_day_number < 61
--								AND fcd.fiscal_quarter_number = 1 THEN 2
--							WHEN fcd.fiscal_quarter_number = 1 THEN 3
--							WHEN qdn.fiscal_quarter_day_number < 31
--								AND fcd.fiscal_quarter_number = 2 THEN 4
--							WHEN qdn.fiscal_quarter_day_number < 61
--								AND fcd.fiscal_quarter_number = 2 THEN 5
--							WHEN fcd.fiscal_quarter_number = 2 THEN 6
--							WHEN qdn.fiscal_quarter_day_number < 31
--								AND fcd.fiscal_quarter_number = 3 THEN 7
--							WHEN qdn.fiscal_quarter_day_number < 61
--								AND fcd.fiscal_quarter_number = 3 THEN 8
--							WHEN fcd.fiscal_quarter_number = 3 THEN 9
--							WHEN qdn.fiscal_quarter_day_number < 31
--								AND fcd.fiscal_quarter_number = 4 THEN 10
--							WHEN qdn.fiscal_quarter_day_number < 61
--								AND fcd.fiscal_quarter_number = 4 THEN 11
--							WHEN fcd.fiscal_quarter_number = 4 THEN 12
--						END
--FROM
--	MonthDay qdn
--INNER JOIN
--	Stage.fiscal_calendar_dimension fcd ON qdn.dim_date_id = fcd.dim_date_id

SELECT 

	fiscal_day_of_month
	,fiscal_day_with_suffix
	,fiscal_month_start_date
	,fiscal_month_end_date
	,fiscal_year_month
	,fiscal_continuum_year_week_number
	,fiscal_continuum_year_week_number_start_date
	,fiscal_continuum_year_week_number_end_date
	,fiscal_week_day_number
	,fiscal_quarter_start_date
	,fiscal_quarter_end_date
	,fiscal_year_start_date
	,fiscal_year_end_date
FROM
	Stage.fiscal_calendar_dimension fcd
;WITH ContinuumWeekNumber
AS	(
	SELECT
		fiscal_year
		,fiscal_week_number
		,ROW_NUMBER() OVER (ORDER BY fiscal_year
		,fiscal_week_number) AS fiscal_continuum_year_week_number
	FROM
		Stage.fiscal_calendar_dimension
	GROUP BY
		fiscal_year
		,fiscal_week_number
	)
UPDATE fcd
SET
	fiscal_continuum_year_week_number = cwn.fiscal_continuum_year_week_number
FROM
	Stage.fiscal_calendar_dimension fcd
INNER JOIN
	ContinuumWeekNumber cwn ON fcd.fiscal_year = cwn.fiscal_year
							AND fcd.fiscal_week_number = cwn.fiscal_week_number

SELECT
	 '2017-08-07' reporting_date
	,0 reporting_date_period_type 
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
	Stage.fiscal_calendar_dimension

SELECT
	*
FROM
	Stage.fiscal_calendar_dimension
