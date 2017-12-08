select 
    '2017-08-31'                                                         as reporting_date
  , '0'                                                                  as reporting_date_period_type
  , to_char(full_date, 'YYYY-MM-DD')                                     as calendar_date          
  , cast(to_char(full_date, 'YYYYMMDD') as int)                          as dim_date_id 
  , case when day_is_weekday = 1 then 'Y' else 'N' end                   as is_weekday7
  , case when day_is_weekday = 1 then 'Y' else 'N' end                   as is_working_day
  , 'N'                                                                  as is_business_holiday
  , 'N'                                                                  as is_national_holiday  
  , to_char(full_date, 'YYYY-MM-DD')                                     as fiscal_date_string
  , extract(day from full_date)                                          as fiscal_day_of_month
  , substring(day_name, 1, 3)                                            as fiscal_day_with_suffix
  , extract(month from full_date)                                        as fiscal_month_number
  , to_char(full_date, 'MON')                                            as fiscal_month_name
  , cast( extract(year from full_date) || '-' || extract(month from full_date) || '-01' as date ) as fiscal_month_start_date
  , case 
     when extract(month from full_date)  = 1  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-31' as date)
     when extract(month from full_date)  = 2  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-28' as date)
     when extract(month from full_date)  = 3  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-31' as date)
     when extract(month from full_date)  = 4  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-30' as date)
     when extract(month from full_date)  = 5  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-31' as date)
     when extract(month from full_date)  = 6  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-30' as date)
     when extract(month from full_date)  = 7  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-31' as date)
     when extract(month from full_date)  = 8  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-31' as date)
     when extract(month from full_date)  = 9  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-30' as date)
     when extract(month from full_date)  = 10 then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-31' as date)
     when extract(month from full_date)  = 11 then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-30' as date)
     when extract(month from full_date)  = 12 then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-31' as date)
    end                                                   as fiscal_month_end_date
  , cast(to_char(full_date, 'YYYYMM') as int )            as fiscal_year_month
  , extract(week from full_date)                          as fiscal_week_number
  , 1                                                     as fiscal_continuum_week_number
  , 1                                                     as fiscal_continuum_month_number
  , 1                                                     as fiscal_continuum_quarter_number
  , 1                                                     as fiscal_continuum_year_week_number
  , cast(extract(year from full_date) || '-' || extract(month from full_date) || '-01' as date) as fiscal_continuum_year_week_number_start_date
  , case 
      when extract(month from full_date)  = 1  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-31' as date)
      when extract(month from full_date)  = 2  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-28' as date)
      when extract(month from full_date)  = 3  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-31' as date)
      when extract(month from full_date)  = 4  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-30' as date)
      when extract(month from full_date)  = 5  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-31' as date)
      when extract(month from full_date)  = 6  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-30' as date)
      when extract(month from full_date)  = 7  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-31' as date)
      when extract(month from full_date)  = 8  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-31' as date)
      when extract(month from full_date)  = 9  then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-30' as date)
      when extract(month from full_date)  = 10 then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-31' as date)
      when extract(month from full_date)  = 11 then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-30' as date)
      when extract(month from full_date)  = 12 then cast(extract(year from full_date) || '-' || extract(month from full_date) || '-31' as date)
     end                                                   as fiscal_continuum_year_week_number_end_date
   , extract(day from full_date)                           as fiscal_week_day_number
   , day_name                                              as fiscal_week_day_name
   , case 
       when extract(quarter from full_date) = 1 then 'ONE'
       when extract(quarter from full_date) = 2 then 'TWO'
       when extract(quarter from full_date) = 3 then 'THREE'
       when extract(quarter from full_date) = 4 then 'FOUR'
     end                                                   as fiscal_quarter_name
   , extract(quarter from full_date)                       as fiscal_quarter_number
   , case 
       when extract(quarter from full_date) = 1 and extract(month from full_date) = 1 then extract(day from full_date)
       when extract(quarter from full_date) = 1 and extract(month from full_date) = 2 then extract(day from full_date) + 31
       when extract(quarter from full_date) = 1 and extract(month from full_date) = 3 then extract(day from full_date) + 59
     
       when extract(quarter from full_date) = 2 and extract(month from full_date) = 4 then extract(day from full_date)
       when extract(quarter from full_date) = 2 and extract(month from full_date) = 5 then extract(day from full_date) + 30
       when extract(quarter from full_date) = 2 and extract(month from full_date) = 6 then extract(day from full_date) + 61
     
       when extract(quarter from full_date) = 3 and extract(month from full_date) = 7 then extract(day from full_date)
       when extract(quarter from full_date) = 3 and extract(month from full_date) = 8 then extract(day from full_date) + 31
       when extract(quarter from full_date) = 3 and extract(month from full_date) = 9 then extract(day from full_date) + 62
     
       when extract(quarter from full_date) = 4 and extract(month from full_date) = 10 then extract(day from full_date)
       when extract(quarter from full_date) = 4 and extract(month from full_date) = 11 then extract(day from full_date) + 31
       when extract(quarter from full_date) = 4 and extract(month from full_date) = 12 then extract(day from full_date) + 61
     end                                                   as fiscal_quarter_day_number
   , case 
       when extract(quarter from full_date) = 1 and extract(month from full_date) = 1 then 1
       when extract(quarter from full_date) = 1 and extract(month from full_date) = 2 then 2
       when extract(quarter from full_date) = 1 and extract(month from full_date) = 3 then 3
     
       when extract(quarter from full_date) = 2 and extract(month from full_date) = 4 then 1
       when extract(quarter from full_date) = 2 and extract(month from full_date) = 5 then 2
       when extract(quarter from full_date) = 2 and extract(month from full_date) = 6 then 3
     
       when extract(quarter from full_date) = 3 and extract(month from full_date) = 7 then 1
       when extract(quarter from full_date) = 3 and extract(month from full_date) = 8 then 2
       when extract(quarter from full_date) = 3 and extract(month from full_date) = 9 then 3
     
       when extract(quarter from full_date) = 4 and extract(month from full_date) = 10 then 1
       when extract(quarter from full_date) = 4 and extract(month from full_date) = 11 then 2
       when extract(quarter from full_date) = 4 and extract(month from full_date) = 12 then 3
     end                                                   as fiscal_quarter_month_number
   , case 
       when extract(quarter from full_date) = 1 then cast(extract(year from full_date) || '-01-01' as date)
       when extract(quarter from full_date) = 2 then cast(extract(year from full_date) || '-04-01' as date)
       when extract(quarter from full_date) = 3 then cast(extract(year from full_date) || '-07-01' as date)
       when extract(quarter from full_date) = 4 then cast(extract(year from full_date) || '-10-01' as date)
     end                                                   as  fiscal_quarter_start_date
   , case 
       when extract(quarter from full_date) = 1 then cast(extract(year from full_date) || '-03-31' as date)
       when extract(quarter from full_date) = 2 then cast(extract(year from full_date) || '-06-30' as date)
       when extract(quarter from full_date) = 3 then cast(extract(year from full_date) || '-09-30' as date)
       when extract(quarter from full_date) = 4 then cast(extract(year from full_date) || '-12-31' as date)
     end                                                      as fiscal_quarter_end_date
    , extract(year from full_date)                            as fiscal_year
    , cast(extract(year from full_date) || '-01-01' as date)  as fiscal_year_start_date
    , cast(extract(year from full_date) || '-12-31' as date)  as fiscal_year_end_date
    , to_char(full_date, 'YYYYQNMM')                          as fiscal_year_quarter_month_number
    
from mdj.date_dimension
;
  