select a.* as line
     , row_number() over () as row_id
from
(
select 
    '2017-08-31'
  + '|'
  + '0'
  + '|'
  + to_char(full_date, 'YYYY-MM-DD')                                                                 
  + '|'
  + cast(to_char(full_date, 'YYYYMMDD') as int)
  + '|'
  + case when day_is_weekday = 1 then 'Y' else 'N' end
  + '|'
  + case when day_is_weekday = 1 then 'Y' else 'N' end
  + '|'
  + 'N'
  + '|'
  + 'N'
  + '|'
  + to_char(full_date, 'YYYY-MM-DD')
  + '|'
  + extract(day from full_date)
  + '|'
  + substring(day_name, 1, 3)
  + '|'
  + extract(month from full_date)
  + '|'
  + to_char(full_date, 'MON')
  + '|'
  + cast( extract(year from full_date) || '-' || extract(month from full_date) || '-01' as date )
  + '|'
  + case 
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
    end
  + '|'
  + cast(to_char(full_date, 'YYYYMM') as int )
  + '|'
  + extract(week from full_date)
  + '|'
  + 1
  + '|'
  + 1
  + '|'
  + 1
  + '|'
  + 1
  + '|'
  + cast(extract(year from full_date) || '-' || extract(month from full_date) || '-01' as date)
  + '|'
  + case 
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
     end
   + '|'
   + extract(day from full_date)
   + '|'
   + day_name
   + '|'
   + case 
       when extract(quarter from full_date) = 1 then 'ONE'
       when extract(quarter from full_date) = 2 then 'TWO'
       when extract(quarter from full_date) = 3 then 'THREE'
       when extract(quarter from full_date) = 4 then 'FOUR'
     end
   + '|'
   + extract(quarter from full_date)
   + '|'
   + case 
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
     end
   + '|'
   + case 
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
     end
   + '|'
   + case 
       when extract(quarter from full_date) = 1 then cast(extract(year from full_date) || '-01-01' as date)
       when extract(quarter from full_date) = 2 then cast(extract(year from full_date) || '-04-01' as date)
       when extract(quarter from full_date) = 3 then cast(extract(year from full_date) || '-07-01' as date)
       when extract(quarter from full_date) = 4 then cast(extract(year from full_date) || '-10-01' as date)
     end
   + '|'
   + case 
       when extract(quarter from full_date) = 1 then cast(extract(year from full_date) || '-03-31' as date)
       when extract(quarter from full_date) = 2 then cast(extract(year from full_date) || '-06-30' as date)
       when extract(quarter from full_date) = 3 then cast(extract(year from full_date) || '-09-30' as date)
       when extract(quarter from full_date) = 4 then cast(extract(year from full_date) || '-12-31' as date)
     end
    + '|'
    + extract(year from full_date)
    + '|'
    + cast(extract(year from full_date) || '-01-01' as date)
    + '|'
    + cast(extract(year from full_date) || '-12-31' as date)
    + '|'
    + to_char(full_date, 'YYYYQNMM')
    + '|'
from mdj.date_dimension
) a
;
  