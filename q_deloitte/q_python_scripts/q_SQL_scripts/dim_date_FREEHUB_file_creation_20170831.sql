select a.* as line 
     , row_number() over () as row_id
  from 
(  
select 
    '2017-08-31'
  + '|'
  + '0'
  + '|'
  + cast(to_char(full_date, 'YYYYMMDD') as int)
  + '|'
  + year_day_number
  + '|'
  + year_week_number
  + '|'
  + year_week_number
  + '|'
  + month_number
  + '|'
  + full_date
  + '|'
  + case when day_is_weekday = 1 then 'Y' else 'N' end
  + '|'
  + case when day_is_weekday = 1 then 'Y' else 'N' end
  + '|'
  + au_format_date
  + '|'
  + us_format_date
  + '|'
  + month_day_number
  + '|'
  + substring(day_name, 1, 3)
  + '|'
  + month_number
  + '|'
  + month_name
  + '|'
  + case 
     when month_number = 1  then cast(year_number || '-01-01' as date)
     when month_number = 2  then cast(year_number || '-02-01' as date)
     when month_number = 3  then cast(year_number || '-03-01' as date)
     when month_number = 4  then cast(year_number || '-04-01' as date)
     when month_number = 5  then cast(year_number || '-05-01' as date)
     when month_number = 6  then cast(year_number || '-06-01' as date)
     when month_number = 7  then cast(year_number || '-07-01' as date)
     when month_number = 8  then cast(year_number || '-08-01' as date)
     when month_number = 9  then cast(year_number || '-09-01' as date)
     when month_number = 10 then cast(year_number || '-10-01' as date)
     when month_number = 11 then cast(year_number || '-11-01' as date)
     when month_number = 12 then cast(year_number || '-12-01' as date)
    end
  + '|'
  + case 
     when month_number = 1  then cast(year_number || '-01-31' as date)
     when month_number = 2  then cast(year_number || '-02-28' as date)
     when month_number = 3  then cast(year_number || '-03-31' as date)
     when month_number = 4  then cast(year_number || '-04-30' as date)
     when month_number = 5  then cast(year_number || '-05-31' as date)
     when month_number = 6  then cast(year_number || '-06-30' as date)
     when month_number = 7  then cast(year_number || '-07-31' as date)
     when month_number = 8  then cast(year_number || '-08-31' as date)
     when month_number = 9  then cast(year_number || '-09-30' as date)
     when month_number = 10 then cast(year_number || '-10-31' as date)
     when month_number = 11 then cast(year_number || '-11-30' as date)
     when month_number = 12 then cast(year_number || '-12-31' as date)
    end
  + '|'
  + month_day_number
  + '|'
  + year_week_number
  + '|'
  + year_week_number
  + '|'
  + 52
  + '|'
  + 52
  + '|'
  + cast(year_number || '-01-01' as date)
  + '|'
  + cast(year_number || '-01-01' as date)
  + '|'
  + cast(year_number || '-12-31' as date)
  + '|'
  + cast(year_number || '-12-31' as date)
  + '|'
  + year_week_number
  + '|'
  + 8
  + '|'
  + case when week_day_number = 1 then full_date else full_date end
  + '|'
  + case when week_day_number = 7 then full_date else full_date end
  + '|'
  + week_day_number
  + '|'
  + week_day_number
  + '|'
  + day_name
  + '|'
  + qtr_number
  + '|'
  + qtr_number
  + '|'
  + qtr_number
  + '|'
  + qtr_number
  + '|'
  + case 
     when qtr_number = 1 then cast(year_number || '-01-01' as date) 
     when qtr_number = 2 then cast(year_number || '-04-01' as date) 
     when qtr_number = 3 then cast(year_number || '-07-01' as date) 
     when qtr_number = 4 then cast(year_number || '-10-01' as date) 
     end
  + '|'
  + case 
     when qtr_number = 1 then cast(year_number || '-03-31' as date) 
     when qtr_number = 2 then cast(year_number || '-06-30' as date) 
     when qtr_number = 3 then cast(year_number || '-09-30' as date) 
     when qtr_number = 4 then cast(year_number || '-12-31' as date) 
     end
  + '|'
  + year_number
  + '|'
  + cast(year_number || '-01-01' as date)
  + '|'
  + cast(year_number || '-12-31' as date)
  + '|'
from mdj.date_dimension
) a
;
 