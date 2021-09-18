
-- here i am analysing US geological survey about earthquake in sql.I have done this analysis in python and tableau too.

select* from dbo.earth;

--total rows in table
select  count(*) from dbo.earth;

-- min and max time avialable in table
select min(occurred_on) as earlier_time,max(occurred_on) as last_time from dbo.earth;

--max and min magnitude of the earthquake
select max(magnitude) as highest_magnitude,min(magnitude) as lowest_magnitude from dbo.earth;

--total number of earthquake by cause and its respective highest magnitude
select cause,count(*) as total_number,max(magnitude) as max_magnitude  from dbo.earth group by cause order by 2 DESC;

-- latest earthquake cause by nuclear explosion
select place,magnitude,occurred_on from dbo.earth 
where cause='nuclear explosion'
order by occurred_on DESC
OFFSET 0 ROWS FETCH FIRST 1 ROWS ONLY;

-- another way to write above quary
select top 1 place,magnitude,occurred_on from dbo.earth 
where cause='nuclear explosion'
order by occurred_on DESC;

-- total number of the earthquake  according to year
-- we can see that maximum earthquake(713) occcur in year 2011
with new_table
as
(select year(occurred_on) as [year],magnitude from dbo.earth)
select [year],count(magnitude) as total_count from new_table
group by [year]
order by total_count DESC;


--here in this sql query,i divide magnitude into bins and count them
--I created CTE table and make one column called earthquake_status, which I have group by to get total number

with new_table
as 
(select
case
when magnitude between 5 and 6 then 'not dangerous'
when magnitude between 6 and 7 then 'powerful'
when magnitude between 7 and 8 then ' dangerous'
when magnitude between 8 and 9 then 'extremly dangerous'
else 'extremly devestating'
end as earthquake_status
from dbo.earth)
select earthquake_status,count(earthquake_status) as total_count from new_table group by earthquake_status
order by total_count DESC;


select* from dbo.earth where magnitude>9;











