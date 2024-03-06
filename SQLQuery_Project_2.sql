--This is a data exploration exercise--
--Data on Covid development, vaccinations and deaths for all countries that reported data--
--The data has been downloaded and loaded into SSMS as csv file--

--Selecting all variables in dataset--
select *
from CovidDeaths
order by 3, 4 --data_set is ordered by location and date

select *
from CovidVaccinations
order by 3, 4

--Date variable was imported as string and orders alphabetically in stead of needs to be formatted such 

--Format date variable as date
SELECT TRY_CONVERT(DATE, date, 101) AS FormattedDate
FROM PortfolioProject2..CovidDeaths
ORDER BY TRY_CONVERT(DATE, date, 111);

--add formatted column to table
ALTER TABLE PortfolioProject2..CovidDeaths
ADD FormattedDateColumn DATE;

UPDATE PortfolioProject2..CovidDeaths
SET FormattedDateColumn = TRY_CONVERT(DATE, date, 101);
CREATE INDEX IX_FormattedDateColumn ON PortfolioProject2..CovidDeaths(FormattedDateColumn) --create index for date column

--rename variable as date_2
EXEC sp_rename 'PortfolioProject2..CovidDeaths.FormattedDateColumn', 'date_2', 'COLUMN';

--selection of a number of variables and ordering by location and date, excluding world and continental aggregates
Select Location, date_2, total_cases, new_cases, total_deaths, population
From PortfolioProject2..CovidDeaths
where continent <>''
Order by location, date_2


--selection of total_cases
Select Location, date_2, total_cases, new_cases, total_deaths, population
From PortfolioProject2..CovidDeaths
where continent <>''
Order by location, date_2

-- Looking at total cases vs total deaths

--change type of variables total_cases and total_deaths to float
alter table PortfolioProject2..CovidDeaths
alter column total_cases FLOAT

alter table PortfolioProject2..CovidDeaths
alter column total_deaths FLOAT


--Shows the likelihood of dying if you contract covid in the country states
Select Location, date_2, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From PortfolioProject2..CovidDeaths
where total_cases>0 and location like '%states%' --where total cases>0 makes it possible for division to be carried out, NULL was changed to 0 as variable was altered
Order by 1,2 

--Shows the likelihood of dying if you contract covid in your country netherlands
Select Location, date_2, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From PortfolioProject2..CovidDeaths
where total_cases>0 and location like '%nether%'
Order by 1,2 

--Looking at Total Cases vs Population: for Netherlands

alter table PortfolioProject2..CovidDeaths
alter column population FLOAT

--selection of total cases per total population
Select Location, date_2, total_cases, Population, (total_cases/population)*100 as populationcases
From PortfolioProject2..CovidDeaths
where total_cases>0 and location like '%nether%'
Order by 1,2 

--selection of total cases per 100,000 people
Select Location, date_2, total_cases, Population, (total_cases/(population/100000)) as casesper100k
From PortfolioProject2..CovidDeaths
where total_cases>0 and location like '%nether%'
Order by 1,2 

--Looking at countries with highest  infection rate compared to population
Select location, continent, Population , MAX(total_cases) as Highestinfectioncount, MAX((total_cases/population))*100 as percent_populationinfected
From PortfolioProject2..CovidDeaths
where total_cases>0 and population>0 and continent<>''
Group by location, continent, population
Order by percent_populationinfected DESC

--Showing the counntries with the highest death count
Select Location, continent, MAX(total_deaths) as Totaldeathcount
From PortfolioProject2..CovidDeaths
--where total_cases>0 and population>0
where continent<>''
Group by location, continent
Order by Totaldeathcount DESC

--Showing chance of death when infected by location--
Select location, continent, MAX(total_deaths) as totaldeachtcount, MAX(total_cases) as total_infections, MAX(total_deaths)/MAX(total_cases)*100 as deathrate
From PortfolioProject2..CovidDeaths
where continent<>''
Group by location, continent
order by deathrate DESC

alter table PortfolioProject2..CovidDeaths
alter column new_cases FLOAT

--Showing global numbers of total infections and death + death percentage per day--
Select date_2, SUM(new_cases) as totals_infections, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as death_percentage
From PortfolioProject2..CovidDeaths
where new_cases>0 and continent<>''
Group by date_2
Order by 1, 2

--Showing global numbers of total infections and total death + death percentage, total over entire period--
Select SUM(new_cases) as totals_infections, SUM(cast(new_deaths as int)) as total_deaths, 
				(SUM(cast(new_deaths as int))/SUM(new_cases))*100 as death_percentage
From PortfolioProject2..CovidDeaths
where  continent<>''
--Group by date_2
Order by 1, 2


--Moving on to the CovidVaccinations dataset
select * 
from PortfolioProject2..CovidVaccinations

--Converting date variable 
SELECT TRY_CONVERT(DATE, date, 101) AS FormattedDate
FROM PortfolioProject2..CovidVaccinations
ORDER BY TRY_CONVERT(DATE, date, 111);

ALTER TABLE PortfolioProject2..CovidVaccinations
ADD FormattedDateColumn2 DATE;

UPDATE PortfolioProject2..CovidVaccinations
SET FormattedDateColumn2 = TRY_CONVERT(DATE, date, 101);
CREATE INDEX IX_FormattedDateColumn2 ON PortfolioProject2..CovidVaccinations(FormattedDateColumn2)

EXEC sp_rename 'PortfolioProject2..CovidVaccinations.FormattedDateColumn2', 'date_2', 'COLUMN';

--Looking at Total Population vs Vaccinations with join 

select dea.continent, dea.location, dea.date_2, dea.population, vac.new_vaccinations
from PortfolioProject2..CovidDeaths dea
join PortfolioProject2..CovidVaccinations vac
on dea.location = vac.location
and dea.date_2 = vac.date_2
where dea.continent is not null
order by 1,2,3

--Creating rollingtotal of newvaccinations per country
select dea.continent, dea.location, dea.date_2, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date_2) as rollingtotalvacinations
from PortfolioProject2..CovidDeaths dea
join PortfolioProject2..CovidVaccinations vac
on dea.location = vac.location
and dea.date_2 = vac.date_2
where dea.continent is not null
order by 2,3


--TEMP TABLE--

DROP Table if exists #percentpopvaccinated
Create table #percentpopvaccinated
(
continent varchar(50),
location varchar(50),
date_2 date,
population float,
new_vaccinations varchar(50),
rollingtotalvaccinations decimal
)
Insert into #percentpopvaccinated 
select dea.continent, dea.location, dea.date_2, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date_2) as rollingtotalvaccinations
from PortfolioProject2..CovidDeaths dea
join PortfolioProject2..CovidVaccinations vac
on dea.location = vac.location and dea.date_2 = vac.date_2
where dea.continent is not null
--order by 2,3

Select *, (rollingtotalvaccinations/population)*100 as per
From #percentpopvaccinated

--Creating new tests as percentage of rolling total of new tests with TEMP TABLE, alongside average percentage of rolling percentage
DROP TAble if exists #percenttests
Create table #percenttests
(continent varchar(50), 
location varchar(50),
date_2 date, 
new_tests int, 
rollingtotaltests float
)
Insert into #percenttests
select dea.continent, dea.location, dea.date_2, vac.new_tests,
sum(convert(int, vac.new_tests)) over(partition by dea.location order by dea.location, dea.date_2) as rollingtotaltests
from PortfolioProject2..CovidDeaths as dea
join PortfolioProject2..CovidVaccinations as vac
on dea.location = vac.location and 
dea.date_2 = vac.date_2
where dea.continent<>''

select *, (new_tests/rollingtotaltests)*100 as percent_newtest, 
avg((new_tests/rollingtotaltests)*100) over(partition by location order by location) as average_percent
from #percenttests
where new_tests is not null

--USE CTE, with the CTE, created measure rollingtotalvaccinations can be used in caluclations. run entire code along with cte
With popvsvac (continent, location, date_2, population, new_vaccinations, rollingtotalvaccinations)
as 
(
select dea.continent, dea.location, dea.date_2, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date_2) as rollingtotalvaccinations
from PortfolioProject2..CovidDeaths dea
join PortfolioProject2..CovidVaccinations vac
on dea.location = vac.location
and dea.date_2 = vac.date_2
where dea.continent is not null--order by 2,3
)
Select *, (rollingtotalvaccinations/population)*100 as rollingpercentageofpop
From popvsvac
where new_vaccinations is not null

---Creating View to store data for later
drop view  if exists percentpopvaccinated
create view percentpopvaccinated as
select dea.continent, dea.location, dea.date_2, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date_2) as rollingtotalvaccinations
from PortfolioProject2..CovidDeaths dea
join PortfolioProject2..CovidVaccinations vac
on dea.location = vac.location and dea.date_2 = vac.date_2
where dea.continent is not null
--order by 2,3

select *
from percentpopvaccinated