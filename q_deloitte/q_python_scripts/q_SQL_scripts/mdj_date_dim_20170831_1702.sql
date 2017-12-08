--insert into conformed.dim_date
select 
    '2017-08-31'                                                         as reporting_date
  , '0'                                                                  as reporting_date_period_type
  , cast(to_char(full_date, 'YYYYMMDD') as int)                          as dim_date_id  
  , year_day_number                                                      as day_sequence_number
  , year_week_number                                                     as week_sequence_number_usa
  , year_week_number                                                     as week_sequence_number_eu_iso
  , month_number                                                         as month_sequence_number
  , full_date                                                            as calendar_date
  , day_is_weekday                                                       as is_weekday7_usa
  , day_is_weekday                                                       as is_weekday7_eu_iso
  , au_format_date                                                       as calendar_date_eu
  , us_format_date                                                       as calendar_date_usa
  , month_day_number                                                     as calendar_day_of_month
  , substring(day_name, 1, 3)                                            as day_with_suffix
  , month_number                                                         as calendar_month_number
  , month_name                                                           as calendar_month_name
  , case 
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
    end                                                                  as calendar_month_start_date
  , case 
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
    end                                                                  as calendar_month_end_date
  , month_day_number                                                     as calendar_year_month
  , year_week_number                                                     as calendar_week_number_usa
  , year_week_number                                                     as calendar_week_number_eu
  , 52                                                                   as calendar_continuum_year_week_number_usa
  , 52                                                                   as calendar_continuum_year_week_number_eu
  , cast(year_number || '-01-01' as date)                                as calendar_continuum_year_week_number_usa_start_date
  , cast(year_number || '-01-01' as date)                                as calendar_continuum_year_week_number_usa_end_date
  , cast(year_number || '-12-31' as date)                                as calendar_continuum_year_week_number_eu_start_date
  , cast(year_number || '-12-31' as date)                                as calendar_continuum_year_week_number_eu_end_date
    , year_week_number                                                   as calendar_iso_week_number 
  , 8                                                                    as calendar_continuum_year_iso_week_number 
  , case when week_day_number = 1 then full_date else full_date end      as calendar_continuum_year_iso_week_number_start_date
  , case when week_day_number = 7 then full_date else full_date end      as calendar_continuum_year_iso_week_number_end_date
  , week_day_number                                                      as week_day_number_usa
  , week_day_number                                                      as week_day_number_eu_iso
  , day_name                                                             as week_day_name
  , qtr_number                                                           as calendar_quarter_name
  , qtr_number                                                           as calendar_quarter_number
  , qtr_number                                                           as calendar_quarter_day_number
  , qtr_number                                                           as calendar_quarter_month_number
  , case 
     when qtr_number = 1 then cast(year_number || '-01-01' as date) 
     when qtr_number = 2 then cast(year_number || '-04-01' as date) 
		 when qtr_number = 3 then cast(year_number || '-07-01' as date) 
		 when qtr_number = 4 then cast(year_number || '-10-01' as date) 
		 end                                                                 as calendar_quarter_start_date
  , case 
     when qtr_number = 1 then cast(year_number || '-03-31' as date) 
     when qtr_number = 2 then cast(year_number || '-06-30' as date) 
		 when qtr_number = 3 then cast(year_number || '-09-30' as date) 
		 when qtr_number = 4 then cast(year_number || '-12-31' as date) 
		 end                                                                 as calendar_quarter_end_date		 
  , year_number                                                          as calendar_year
  , cast(year_number || '-01-01' as date)                                as calendar_year_start_date
  , cast(year_number || '-12-31' as date)                                as calendar_year_end_date
  
from mdj.date_dimension
;
  