select *
from CovidDeaths
order by 3, 4

select *
from CovidVaccinations
order by 3, 4

--alter table PortfolioProject2..CovidDeaths
--drop column FormattedDateColumn

SELECT TRY_CONVERT(DATE, date, 101) AS FormattedDate
FROM PortfolioProject2..CovidDeaths
ORDER BY TRY_CONVERT(DATE, date, 111);

ALTER TABLE PortfolioProject2..CovidDeaths
ADD FormattedDateColumn DATE;

UPDATE PortfolioProject2..CovidDeaths
SET FormattedDateColumn = TRY_CONVERT(DATE, date, 101);
CREATE INDEX IX_FormattedDateColumn ON PortfolioProject2..CovidDeaths(FormattedDateColumn)

EXEC sp_rename 'PortfolioProject2..CovidDeaths.FormattedDateColumn', 'date_2', 'COLUMN';

Select Location, date_2, total_cases, new_cases, total_deaths, population
From PortfolioProject2..CovidDeaths
Order by location, date_2



/* Table 2: Vaccinations*/

--SELECT TRY_CONVERT(DATE, date, 101) AS FormattedDate
--FROM PortfolioProject2..CovidVaccinations
--ORDER BY TRY_CONVERT(DATE, date, 111);

--ALTER TABLE PortfolioProject2..CovidVaccinations
--ADD FormattedDateColumn2 DATE;

--UPDATE PortfolioProject2..CovidVaccinations
--SET FormattedDateColumn2 = TRY_CONVERT(DATE, date, 101);
--CREATE INDEX IX_FormattedDateColumn2 ON PortfolioProject2..CovidVaccinations(FormattedDateColumn2)

--EXEC sp_rename 'PortfolioProject2..CovidVaccinations.FormattedDateColumn2', 'date_2', 'COLUMN';

Select Location, date_2, total_cases, new_cases, total_deaths, population
From PortfolioProject2..CovidDeaths
Order by location, date_2

-- Looking at total cases vs total deaths
alter table PortfolioProject2..CovidDeaths
alter column total_cases FLOAT

alter table PortfolioProject2..CovidDeaths
alter column total_deaths FLOAT


--Shows the likelihood of dying if you contract covid in the country states
Select Location, date_2, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From PortfolioProject2..CovidDeaths
where total_cases>0 and location like '%states%'
Order by 1,2 

--Shows the likelihood of dying if you contract covid in your country netherlands
Select Location, date_2, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From PortfolioProject2..CovidDeaths
where total_cases>0 and location like '%nether%'
Order by 1,2 

--Shows the likelihood of dying if you contract covid in the country ghana
Select Location, date_2, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From PortfolioProject2..CovidDeaths
where total_cases>0 and location like '%nether%'
Order by 1,2 

--Looking at Total Cases vs Population

alter table PortfolioProject2..CovidDeaths
alter column population FLOAT

--alter table PortfolioProject2..CovidDeaths
--alter column total_deaths FLOAT

Select Location, date_2, total_cases, Population, (total_cases/population)*100 as populationcases
From PortfolioProject2..CovidDeaths
where total_cases>0 and location like '%states%'
Order by 1,2 

--Looking at countries with highest  infection rate compared to population
Select location, continent, Population , MAX(total_cases) as Highestinfectioncount, MAX((total_cases/population))*100 as percent_populationinfected
From PortfolioProject2..CovidDeaths
where total_cases>0 and population>0 and continent<>''
Group by location, continent, population
Order by percent_populationinfected DESC

--Showing the counntries with the highest deat count per population
Select Location, continent, MAX(total_deaths) as Totaldeathcount
From PortfolioProject2..CovidDeaths
--where total_cases>0 and population>0
where continent<>''
Group by location, continent
Order by Totaldeathcount DESC

----LETS BREAK THINGS DOWN BY CONTINENT
----Showing the counntries with the highest deat count per population
--Select continent , MAX(total_deaths) as Totaldeathcount
--From PortfolioProject2..CovidDeaths
----where total_cases>0 and population>0
--where continent<>''
--Group by continent
--Order by Totaldeathcount DESC

--LETS BREAK THINGS DOWN BY CONTINENT
--Showing the counntries with the highest deat count per population
Select location , MAX(total_deaths) as Totaldeathcount
From PortfolioProject2..CovidDeaths
--where total_cases>0 and population>0
where continent=''
Group by location
Order by Totaldeathcount DESC

alter table PortfolioProject2..CovidDeaths
alter column new_cases FLOAT

--Showing global numbers--
Select date_2, SUM(new_cases) as totals_infections, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as death_per
From PortfolioProject2..CovidDeaths
where new_cases>0 and continent<>'' --new_cases>0 and new_deaths>0 and
Group by date_2
Order by 1, 2

--Showing global numbers--
Select SUM(new_cases) as totals_infections, SUM(cast(new_deaths as int)) as total_deaths, 
				(SUM(cast(new_deaths as int))/SUM(new_cases))*100 as death_per
From PortfolioProject2..CovidDeaths
where  continent<>''
--Group by date_2
Order by 1, 2

select *
From PortfolioProject2..CovidVaccinations
where ISNUMERIC(new_tests) <> 0


update PortfolioProject2..CovidVaccinations
set new_tests = NULL
where new_tests = ''

update PortfolioProject2..CovidVaccinations
set total_tests = NULL
where total_tests = ''

update PortfolioProject2..CovidVaccinations
set total_tests_per_thousand = NULL
where total_tests_per_thousand = ''

update PortfolioProject2..CovidVaccinations
set new_tests_per_thousand = NULL
where new_tests_per_thousand = ''

update PortfolioProject2..CovidVaccinations
set new_tests_smoothed = NULL
where new_tests_smoothed = ''

update PortfolioProject2..CovidVaccinations
set new_tests_smoothed_per_thousand = NULL
where new_tests_smoothed_per_thousand = ''

update PortfolioProject2..CovidVaccinations
set positive_rate = NULL
where positive_rate = ''

update PortfolioProject2..CovidVaccinations
set tests_per_case = NULL
where tests_per_case = ''

update PortfolioProject2..CovidVaccinations
set tests_units = NULL
where tests_units = ''

update PortfolioProject2..CovidVaccinations
set total_vaccinations = NULL
where total_vaccinations = ''


update PortfolioProject2..CovidVaccinations
set people_vaccinated = NULL
where people_vaccinated = ''


update PortfolioProject2..CovidVaccinations
set people_fully_vaccinated = NULL
where people_fully_vaccinated = ''

update PortfolioProject2..CovidVaccinations
set new_vaccinations = NULL
where new_vaccinations = ''

update PortfolioProject2..CovidVaccinations
set new_vaccinations_smoothed = NULL
where new_vaccinations_smoothed = ''

update PortfolioProject2..CovidVaccinations
set total_vaccinations_per_hundred = NULL
where total_vaccinations_per_hundred = ''

update PortfolioProject2..CovidVaccinations
set people_vaccinated_per_hundred = NULL
where people_vaccinated_per_hundred = ''


update PortfolioProject2..CovidVaccinations
set people_fully_vaccinated_per_hund = NULL
where people_fully_vaccinated_per_hund = ''

update PortfolioProject2..CovidVaccinations
set new_vaccinations_smoothed_per_mi = NULL
where new_vaccinations_smoothed_per_mi = ''

update PortfolioProject2..CovidVaccinations
set stringency_index = NULL
where stringency_index = ''

update PortfolioProject2..CovidVaccinations
set population = NULL
where population = ''

update PortfolioProject2..CovidVaccinations
set population_density = NULL
where population_density = ''

update PortfolioProject2..CovidVaccinations
set median_age = NULL
where median_age = ''

update PortfolioProject2..CovidVaccinations
set aged_65_older = NULL
where aged_65_older = ''

update PortfolioProject2..CovidVaccinations
set aged_70_older = NULL
where aged_70_older = ''

update PortfolioProject2..CovidVaccinations
set gdp_per_capita = NULL
where gdp_per_capita = ''

update PortfolioProject2..CovidVaccinations
set extreme_poverty = NULL
where extreme_poverty = ''

update PortfolioProject2..CovidVaccinations
set cardiovasc_death_rate = NULL
where cardiovasc_death_rate = ''

update PortfolioProject2..CovidVaccinations
set diabetes_prevalence = NULL
where diabetes_prevalence = ''

update PortfolioProject2..CovidVaccinations
set female_smokers = NULL
where female_smokers = ''

update PortfolioProject2..CovidVaccinations
set male_smokers = NULL
where male_smokers = ''

update PortfolioProject2..CovidVaccinations
set handwashing_facilities = NULL
where handwashing_facilities = ''

update PortfolioProject2..CovidVaccinations
set hospital_beds_per_thousand = NULL
where hospital_beds_per_thousand = ''

update PortfolioProject2..CovidVaccinations
set life_expectancy = NULL
where life_expectancy = ''

update PortfolioProject2..CovidVaccinations
set human_development_index = NULL
where human_development_index = ''

--Updates covid deaths--
update PortfolioProject2..CovidDeaths
set total_cases = NULL
where total_cases = 0

update PortfolioProject2..CovidDeaths
set new_cases = NULL
where new_cases = 0

update PortfolioProject2..CovidDeaths
set new_cases_smoothed = NULL
where new_cases_smoothed = ''

update PortfolioProject2..CovidDeaths
set total_deaths = NULL
where total_deaths = 0

update PortfolioProject2..CovidDeaths
set new_deaths_smoothed = NULL
where new_deaths_smoothed = ''

update PortfolioProject2..CovidDeaths
set total_cases_per_million = NULL
where total_cases_per_million = ''

update PortfolioProject2..CovidDeaths
set total_deaths = NULL
where total_deaths = 0

update PortfolioProject2..CovidDeaths
set continent = NULL
where continent = ''












select * 
from PortfolioProject2..CovidVaccinations

SELECT TRY_CONVERT(DATE, date, 101) AS FormattedDate
FROM PortfolioProject2..CovidVaccinations
ORDER BY TRY_CONVERT(DATE, date, 111);

ALTER TABLE PortfolioProject2..CovidVaccinations
ADD FormattedDateColumn2 DATE;

UPDATE PortfolioProject2..CovidVaccinations
SET FormattedDateColumn2 = TRY_CONVERT(DATE, date, 101);
CREATE INDEX IX_FormattedDateColumn2 ON PortfolioProject2..CovidVaccinations(FormattedDateColumn2)

EXEC sp_rename 'PortfolioProject2..CovidVaccinations.FormattedDateColumn2', 'date_2', 'COLUMN';

--Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date_2, dea.population, vac.new_vaccinations
from PortfolioProject2..CovidDeaths dea
join PortfolioProject2..CovidVaccinations vac
on dea.location = vac.location
and dea.date_2 = vac.date_2
where dea.continent is not null

order by 1,2,3

--Creating rollingtotal of newvaccinations per country)
select dea.continent, dea.location, dea.date_2, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date_2) as rollingtotalvacinations
from PortfolioProject2..CovidDeaths dea
join PortfolioProject2..CovidVaccinations vac
on dea.location = vac.location
and dea.date_2 = vac.date_2
where dea.continent is not null
order by 2,3


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
Select *, (rollingtotalvaccinations/population)*100
From popvsvac

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

---Creating View to store data for later
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