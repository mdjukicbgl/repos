with nums as ( select 0  as val
                  union all
				 select 1
				  union all
				 select 2
				  union all
				 select 3
				  union all
				 select 4
				  union all
				 select 5
				  union all
				 select 6
				  union all
				 select 7
				  union all
				 select 8
				  union all
				 select 9
				  )
select rows_no
  from (select cast( a.val||b.val as int) as rows_no
    from nums a
       , nums b
	   ) c
where c.rows_no between 1 and 40
order by 1
 ;
 ---------------------------------------------
with nums as ( select 'Y'  as val
                  union all
				 select 'N'
				  )
select rows_no
  from (select  a.val||','||b.val||','||c.val||','||d.val||','||e.val	 as rows_no
    from nums a
       , nums b
	   , nums c
	   , nums d
	   , nums e
	   ) c
--where c.rows_no < 5
 order by 1
;			
---------------------------------------------------------------------------------------------------
with venue_sales as 
(select venuename, venuecity, sum(pricepaid) as venuename_sales
from sales, venue, event
where venue.venueid=event.venueid and event.eventid=sales.eventid
group by venuename, venuecity),

top_venues as
(select venuename
from venue_sales
where venuename_sales > 800000)

select venuename, venuecity, venuestate,
sum(qtysold) as venue_qty,
sum(pricepaid) as venue_sales
from sales, venue, event
where venue.venueid=event.venueid and event.eventid=sales.eventid
and venuename in(select venuename from top_venues)
group by venuename, venuecity, venuestate
order by venuename;	   
---------------------------------------------
with nums as ( select 'Y'  as val
                  union all
				 select 'N'
				  ),
nums1 as ( select '0'  as val1
                  union all
				 select '1'
				  )			
select rows_no
  from (select  a.val||','||b.val||','||c.val1||','||d.val1 as rows_no
    from nums a
       , nums b
	   , nums1 c
	   , nums1 d
	   
	   ) c
--where c.rows_no < 5
 order by 1
;