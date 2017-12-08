create 
--drop 
view dw.dim_date_vw as

WITH nums AS (
		 SELECT TOP 15000 row_number() over (
PARTITION BY NULL order by id) n
FROM l_browser -- or some other large table;
		 )
				  				  
, date_stuff AS (
SELECT n, 
DATEADD(day, N, cast('19981231' AS date)) AS calendar_date
                                    FROM nums)
,mq AS (
SELECT cast(to_char(calendar_date,'YYYYMMDD') AS int) AS Date_Key
		,Calendar_Date
		,to_char(calendar_date,'FMMonth DD, YYYY')  AS Date_Name 
		,to_char(calendar_date,'Month') AS Month_Name
        ,cast(to_char(calendar_date,'dd') as int) AS Day_of_Month
        ,cast(to_char(calendar_date,'D') as int) AS Day_of_Week
		,to_char(calendar_date,'Day') AS Day_Name
		,
CASE to_char(calendar_date,'Day')
                        WHEN 'Saturday' THEN 'Weekend'
                        WHEN 'Sunday' THEN 'Weekend'
                        ELSE 'Weekday'
                      END Weekday_Weekend
		,dateadd(day, -1, date_trunc('week', calendar_date)) Week_Start_Date
		,cast(to_char(dateadd(day, -1, date_trunc('week', calendar_date)),'YYYYMMDD') AS int) Week_Start_Date_Key
		,DATEADD(day, 5, date_trunc('week', calendar_date)) AS Week_End_Date
		,cast(to_char(
DATEADD(day, 5, date_trunc('week', calendar_date)),'YYYYMMDD') AS int) Week_End_Date_Key
		,
DATEADD(day,-1,calendar_date) AS Previous_Day_Date
		,cast(to_char(
DATEADD(day,-1,calendar_date),'YYYYMMDD') AS int) AS Previous_Day_Date_Key
		,
DATEADD(day,1,calendar_date) AS Next_Day_Date
		,cast(to_char(
DATEADD(day,1,calendar_date),'YYYYMMDD') AS int) AS Next_Day_Date_Key
		,date_trunc('month',calendar_date) Month_Begin_Date
		,cast(to_char(date_trunc('month',calendar_date), 'YYYYMMDD') AS int) AS Month_Begin_Date_Key
		,cast(last_day(Calendar_date) as timestamp) Month_End_Date
		,cast(to_char(last_day(Calendar_date),'YYYYMMDD') AS int) AS Month_End_Date_Key
		,
cast(to_char(calendar_date,'YYYY') as int) AS Calendar_Year		
		,
DATEPART('Quarter',calendar_date) AS Calendar_Quarter	
		,cast(
DATEPART(Year,calendar_date) AS varchar)+ ' Q' + 
DATEPART(Quarter,calendar_date) AS Calendar_Year_Quarter
		,cast(to_char(calendar_date,'YYYYMM') as int) AS Calendar_Month_Of_Year
		,cast(to_char(calendar_date,'WW') as int) Calendar_Week_Of_Year
		,cast(to_char(calendar_date,'IW') as int) Calendar_Week_Of_Year_ISO
		,cast(to_char(calendar_date,'DDD') as int) AS Calendar_Day_Of_Year
		,cast(to_char(DATEADD(month,5,calendar_date),'YYYY') as int) AS Fiscal_Year				
		,
cast(DATEPART(quarter,
DATEADD(month,5,calendar_date)) as int) AS Fiscal_Quarter

		,cast(to_char(
DATEADD(month,5,calendar_date),'YYYY') AS varchar) + ' Q' + 
DATEPART(quarter,
DATEADD(month,5,calendar_date))  AS Fiscal_Year_Quarter

		,cast(to_char(
DATEADD(month,5,calendar_date),'YYYYMM') as int) AS Fiscal_Month_Of_Year

		,cast(to_char(
DATEADD(month,5,calendar_date),'WW') as int) Fiscal_Week_Of_Year

,cast(to_char(
DATEADD(month,5,calendar_date),'IW') as int) Fiscal_Week_Of_Year_ISO

		,cast(to_char(
DATEADD(month,5,calendar_date),'DDD') as int) AS Fiscal_Day_Of_Year

FROM date_stuff
)
,HOLIDAY_PREP AS (
SELECT *
,cast(cast(fiscal_year as varchar(4)) + '-' + case fiscal_quarter
when 1 then '08-01' 
when 2 then '11-01' 
when 3 then '02-01' 
when 4 then '05-01' 
end as timestamp) as fiscal_quarter_begin_date
,cast(cast(fiscal_year as varchar(4)) + '-' + case fiscal_quarter
when 1 then '10-31'
when 2 then '01-31'
when 3 then '04-30'
when 4 then '07-31'
end as timestamp) as fiscal_quarter_end_date

,ROW_NUMBER() OVER (PARTITION BY DATEPART('Y', CALENDAR_DATE),DATEPART(MON, CALENDAR_DATE), DAY_NAME ORDER BY CALENDAR_DATE) AS MONTH_DAYNAME_RANK
,ROW_NUMBER() OVER (PARTITION BY DATEPART('Y', CALENDAR_DATE),DATEPART(MON, CALENDAR_DATE), DAY_NAME ORDER BY CALENDAR_DATE DESC) AS MONTH_DAYNAME_RANK_REV
FROM mq)

,HOLIDAY_IDENTIFIER as (
SELECT *,
CASE
			WHEN Month_Name = 'January' AND
			Day_of_Month = 1 THEN 'New Years Day'
			WHEN Month_Name = 'May' AND
			DAY_NAME = 'Monday' AND
			MONTH_DAYNAME_RANK_REV = 1 THEN 'Memorial Day'
			WHEN Month_Name = 'July' AND
			Day_of_Month = 4 THEN '4th of July/Independence Day'
			WHEN Month_Name = 'September' AND
			DAY_NAME = 'Monday' AND
			MONTH_DAYNAME_RANK = 1 THEN 'Labor Day'
			WHEN Month_Name = 'October' AND
			DAY_NAME = 'Monday' AND
			MONTH_DAYNAME_RANK = 2 THEN 'Columbus Day'
			WHEN Month_Name = 'November' AND
			Day_of_Month = 11 THEN 'Veterans Day'
			WHEN Month_Name = 'November' AND
			DAY_NAME = 'Thursday' AND
			MONTH_DAYNAME_RANK = 4 THEN 'Thanksgiving'
			WHEN Month_Name = 'December' AND
			Day_of_Month = 25 THEN 'Christmas'
		END AS HOLIDAY
FROM holiday_prep)

select DATE_KEY
		,CALENDAR_DATE
		,DATE_NAME
		,MONTH_NAME
		,DAY_OF_MONTH
		,DAY_OF_WEEK
		,DAY_NAME
		,WEEKDAY_WEEKEND
		,WEEK_START_DATE
		,WEEK_START_DATE_KEY
		,WEEK_END_DATE
		,WEEK_END_DATE_KEY
		,PREVIOUS_DAY_DATE
		,PREVIOUS_DAY_DATE_KEY
		,NEXT_DAY_DATE
		,NEXT_DAY_DATE_KEY
		,MONTH_BEGIN_DATE
		,MONTH_BEGIN_DATE_KEY
		,MONTH_END_DATE
		,MONTH_END_DATE_KEY
		,CALENDAR_YEAR
		,CALENDAR_QUARTER
		,CALENDAR_YEAR_QUARTER
		,CALENDAR_MONTH_OF_YEAR
		,CALENDAR_WEEK_OF_YEAR
		,CALENDAR_WEEK_OF_YEAR_ISO
		,CALENDAR_DAY_OF_YEAR
		,FISCAL_YEAR
		,FISCAL_QUARTER
		,FISCAL_YEAR_QUARTER
		,FISCAL_MONTH_OF_YEAR
		,FISCAL_WEEK_OF_YEAR
		,FISCAL_WEEK_OF_YEAR_ISO
		,FISCAL_DAY_OF_YEAR
		,FISCAL_QUARTER_BEGIN_DATE
		,FISCAL_QUARTER_END_DATE
	
		,case 
		when datepart(MON, calendar_date) in (3,4,5) then 'Spring'
		when datepart(MON, calendar_date) in (6,7,8) then 'Summer'
		when datepart(MON, calendar_date) in (9,10,11) then 'Fall'
		when datepart(MON, calendar_date) in (12,1,2) then 'Winter'
		end as season
		,datepart(MON, dateadd(month,5,calendar_date)) as fiscal_month_sort
		,HOLIDAY
		,case when holiday is null and day_name not in ('Saturday', 'Sunday') then 'Y' else 'N' end as BUSINESS_DAY
from HOLIDAY_IDENTIFIER as HI
--where date_key = '20161001'
ORDER BY calendar_date ASC