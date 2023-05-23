select *
from census_data


-- Calculate total population

select sum(CAST(Population as int)) as tot_pop
from census_data


-- Calculate Total number of States

select count(distinct(State_name)) tot_state_cnt
from census_data



-- Calculate State wise total population

select [State_name], sum(CAST(Population as int)) as tot_pop
from census_data
group by [State_name]
order by 2 desc


-- Calculate Sex Ratio (Count of female per 1000 Male) at each row level

select *, round((cast(Female as float)/cast(Male as float))*1000,0) as sex_ratio
from census_data




-- Find out 10 States having highest Sex Ratio figure

with CTE as (
select *, round((cast(Female as float)/cast(Male as float))*1000,0) as sex_ratio
from census_data
)
select Top 10 State_name, round(avg(sex_ratio),0) as sex_ratio
from CTE
group by State_name
order by 2 desc


---- Find out 10 States having least Sex Ratio figure

with CTE as (
select *, round((cast(Female as float)/cast(Male as float))*1000,0) as sex_ratio
from census_data
)
select Top 10 State_name, round(avg(sex_ratio),0) as sex_ratio
from CTE
group by State_name
order by 2 asc


-- Calculate Literacy rate( defined as percentage of population is literate)

select * , round((cast(Literate as float)/cast(Population as float))*100,2) as literacy_rate
from census_data


-- Find out 10 States having highest Literacy rate

with CTE as (
select * , round((cast(Literate as float)/cast(Population as float))*100,2) as literacy_rate
from census_data
)
select Top 10 State_name, round(avg(literacy_rate),2) as avg_literacy_rate
from CTE
group by State_name
order by 2 desc



-- Find out 10 States having lowest Literacy rate

with CTE as (
select * , round((cast(Literate as float)/cast(Population as float))*100,2) as literacy_rate
from census_data
)
select Top 10 State_name, round(avg(literacy_rate),2) as avg_literacy_rate
from CTE
group by State_name
order by 2 asc



select * from census_data

-- Show Statewise population for Hindus, Muslim, Christian and Sikhs


select State_name, sum(cast(Population as int)) as tot_pop, round((sum(cast(Hindus as float))/sum(cast(Population as float)))*100,2) as pop_Hindus, 
round((sum(cast(Muslims as float))/sum(cast(Population as float)))*100,2) as pop_Muslim,
round((sum(cast(Christians as float))/sum(cast(Population as float)))*100,2) as pop_Christian,
round((sum(cast(Sikhs as float))/sum(cast(Population as float)))*100,2) as pop_Sikhs
from census_data
group by State_name
order by 3 desc



-- Show Rural and Urban household comparison Statewise

select State_name , sum(cast(Households as int)) as tot_house,  sum(cast(Urban_Households as int)) as tot_urban_house , 
sum(cast(Rural_Households as int)) as tot_rural_house,
round(((sum(cast(Urban_Households as float))/sum(cast(Households as float)))*100),2) as urban_house_perc,
round(((sum(cast(Rural_Households as float))/sum(cast(Households as float)))*100),2) as rural_house_perc
from census_data
group by State_name
order by 2 desc
