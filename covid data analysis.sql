
-------------lets look at the data set
select* from dbo.death
order by 3,4;

-------------lets look at total cases vrs total death
select  location,date,total_cases,total_deaths,round((total_deaths/total_cases)*100,5) as percentage_death
from dbo.death
where location in ('France')
order by 1,2;

----------------------------------------------------------------------------------
--lets look at total_cases vrs population
select  location,date,total_cases,population,round((total_cases/population)*100,4) as totalcases
from dbo.death
where location in ('France')
order by 1,2;
--------------------------------------------------------------------------------------------------------------
--which country has highest infection rate compared to population
select  location,max(total_cases) as highest_count,population,round((max(total_cases)/population)*100,2) as  infection_rate
from dbo.death
group by population,location
--where location in ('France')
order by infection_rate DESC;

-----------------------------------------------------------------------------------------------------
--countries with highest death count per population
select  location,max(cast(total_deaths as int)) as death_count
from dbo.death
where continent is not null
group by location
order by death_count DESC;

-----------------------------------------------------
--lets break death count per population by the continent
select  continent,max(population) as max_population,round((max(cast(total_deaths as int))/max(population))*100,4) as death_count
from dbo.death
where continent is not null
group by continent
order by death_count DESC;

---------------------------------------------------------------------
------------lets look globally new cases,new death

select sum(new_cases) as new_cases,sum(cast(new_deaths as int)) as death_cases,round((sum(cast(new_deaths as int))/sum(new_cases))*100,3) as death_percent
from dbo.death
where continent is not null
order by 1,2;
------------------------------------------------------------------------------------------------------
--lets now see next table vaccine
---lets see total population that get vaccinated
select d.location,d.continent,population,v.new_vaccinations,
sum(convert(int,v.new_vaccinations)) over(partition by d.location order by d.location,d.date ) as rolling_sum_vaccine
from vaccine.dbo.vaccine as v inner join
dbo.death as d on d.location=v.location and d.date=v.date
where d.continent is not null --and d.location in ('Canada')
order by 1,2;

--------------------------------------------------------------------------------
--we want to see what % of population get vaccinated
 with popvrvac(location,continent,population,new_vaccinations,rolling_sum_vaccine)
 as
 (
 select d.location,d.continent,population,v.new_vaccinations,
sum(convert(int,v.new_vaccinations)) over(partition by d.location order by d.location,d.date ) as rolling_sum_vaccine
from vaccine.dbo.vaccine as v inner join
dbo.death as d on d.location=v.location and d.date=v.date
where d.continent is not null --and d.location in ('Canada')
--order by 1,2
)
select*, round((rolling_sum_vaccine/population)*100,3) as percent_vacinated from popvrvac;

-------------------------------------
--create view to store global data 
create view globaldata
as
select sum(new_cases) as new_cases,sum(cast(new_deaths as int)) as death_cases,round((sum(cast(new_deaths as int))/sum(new_cases))*100,3) as death_percent
from dbo.death
where continent is not null
--order by 1,2;

select* from globaldata;