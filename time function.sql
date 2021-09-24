---------------------------------------------------------------------------------------------------------------------------------
--convert into day,month name and number
select*, datename(weekday,DateOfBirth),datename(month,DateOfBirth),day(DateOfBirth),month(DateOfBirth) from Employees;
------------------------------------------------------------------------------------------------------------------------------
--those who are born in october
select* from Employees where datename(month,DateOfBirth)='October';
-----------------------------------------------------------------------------------------------------------
select*, convert(date,DateOfBirth) as [datepart] from Employees
where cast(DateOfBirth as date)='2017/10/9';
------------------------------------------------------------------------------------
--those born between inbetween  date range
select*, convert(date,DateOfBirth) as [datepart] from Employees
where cast(DateOfBirth as date) between '2017/10/1' and '2017/12/31';
--------------------------------------------------------------------------------------------------------------------------
--those born in 9th october e
select*, convert(date,DateOfBirth) as [datepart] from Employees
where day(DateOfBirth)=9 and  month(DateOfBirth)=10;
---------------------------------------------------------------------------------------------------------------------------------------

--those born in same year
select*, convert(date,DateOfBirth) as [datepart] from Employees
where year(DateOfBirth)='2017';
--------------------------------------------
select dateadd(day,1,convert(date,getdate()))  --tomorrow
select dateadd(day,-1,convert(date,getdate())) --yesterday
---------------------------------------------------------------------------------------------
--all those born yesterday
select*, convert(date,DateOfBirth) as [datepart] from Employees
where cast(DateOfBirth as date)=dateadd(day,-1,convert(date,getdate()));
-------------
--all those born between yesterday and today
select*, convert(date,DateOfBirth) as [datepart] from Employees
where cast(DateOfBirth as date) betweeb dateadd(day,-1,convert(date,getdate())) and cast(getdate() as date);
-----------------------------------------------------------------------------------
--all those born in lats 7 days excluding today
select*, convert(date,DateOfBirth) as [datepart] from Employees
where cast(DateOfBirth as date) between dateadd(day,-7,convert(date,getdate())) and dateadd(day,-1,convert(date,getdate()));

---------------------------------------
