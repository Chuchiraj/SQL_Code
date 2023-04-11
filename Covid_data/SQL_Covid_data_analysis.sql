
--- Checking the Tables for understanding

select * from CovidDeaths
order by 3,4
select * from CovidVaccinations
order by 3,4



-- Task: Countries with Highest Infection Cases

select location, population, sum(new_cases) as tot_cases, round((sum(new_cases)/population)*100,2) as tot_case_perc_pop
from CovidDeaths
group by location, population
order by tot_case_perc_pop desc


-- Task: Death count Country wise

select location, sum(convert(int, new_deaths)) as tot_deaths
from CovidDeaths
where continent is not null     --Continent level sum is not needed in analysis
group by location
order by 2 desc


-- Task: Death count continent wise

select location, sum(cast(new_deaths as int)) as tot_death
from CovidDeaths
where continent is null
group by location
order by 2 desc



-- Task: Death percentage for locations



select location, population,
sum(cast (new_deaths as int))  as tot_deaths,
round((sum(cast (new_deaths as int))/population)*100,2) as death_perc
from CovidDeaths
where continent is not null
group by location, population
order by 4 desc


-- Task: Creating Procedure for Checking Country specific death count


create procedure [Check Country Death Count] @country varchar(50)
as

select location, sum(cast(new_deaths as int)) as tot_death
from CovidDeaths
where continent is not null and
location = @country
group by location

exec [Check Country Death Count] @country = 'India'


-----Working on Vaccinations--------

-- Task: Monthwise Total Vaccination Count

select Datename(MONTH,date) as mon,
DATENAME(YEAR,date) as yr,
sum(cast(new_vaccinations as int)) as tot_vaccination
from CovidVaccinations
where location = 'World'
group by  Datename(MONTH,date) ,
DATENAME(YEAR,date)
order by 3 desc




-- Task: Creating a view on vaccination table

Create view refined_vaccination_table
as
select location, date, convert(int, new_vaccinations) as new_vaccine
from CovidVaccinations
where continent is not null



select location, sum(new_vaccine) as tot_vaccination
from refined_vaccination_table
group by location
order by 2 desc
