SELECT *
From CovidAnalysis..CovidDeaths
Where continent is not null
ORDER by 3,4;

--SELECT *
--From CovidAnalysis..CovidVaccinations
--ORDER by 3,4;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidAnalysis..CovidDeaths
ORDER by 1,2;


-- Total cases VS total deaths
SELECT location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidAnalysis..CovidDeaths
ORDER by 1,2;

-- Total cases VS Population
SELECT location, date, total_cases, population,(total_cases/population)*100 AS InfectedCasesPercentage
FROM CovidAnalysis..CovidDeaths
Where (total_cases/population)*100 > 1 and continent is not null
ORDER by 1,2;

-- Highest Cases 
SELECT location, population, MAX(total_cases) as Highestcase,MAX((total_cases/population)*100) AS InfectedCasesPercentage
FROM CovidAnalysis..CovidDeaths
Where continent is not null
GROUP BY location, population
ORDER by Highestcase DESC;

-- countries with highest death

SELECT location, Max(total_deaths) as HighestDeaths, population, Max((total_deaths/population)*100) AS HighestDeathPercentage
FROM CovidAnalysis..CovidDeaths
Where continent is not null
GROUP BY location, population
ORDER by HighestDeaths DESC;

-- continent with highest death

SELECT continent, Max(total_deaths) as HighestDeaths
FROM CovidAnalysis..CovidDeaths
Where continent is not null
GROUP BY continent
ORDER by HighestDeaths DESC;

Select Sum(new_cases) as total_cases, sum(new_deaths) as total_death, (sum(new_deaths))/Sum(new_cases)*100 as death_percentage
From CovidAnalysis..CovidDeaths
where continent is not null
group by 1,2;


-- new vaccinations Vs Population of deaths
Select deth.continent, deth.location, vacc.location, deth.date, deth.population, vacc.new_vaccinations
from CovidAnalysis..CovidDeaths deth
Join CovidAnalysis..CovidVaccinations vacc
	on deth.location = vacc.location and
	deth.date = vacc.date
Where deth.continent is not null
order by 2,3,4

-- Sum of vaccincations as per location in a new row
Select deth.continent, deth.location, deth.date, deth.population, vacc.new_vaccinations,
SUM(Convert(int,vacc.new_vaccinations)) OVER (Partition by deth.location Order by deth.location, deth.date) As People_Vaccinated
from CovidAnalysis..CovidDeaths deth
Join CovidAnalysis..CovidVaccinations vacc
	on deth.location = vacc.location and
	deth.date = vacc.date
Where deth.continent is not null
order by 2,3

-- Using CTE, We get percentage of people vaccinated

WITH PopVsVac (continent,location, date, population, new_vaccinations,People_Vaccinated)
as
(
Select deth.continent, deth.location, deth.date, deth.population, vacc.new_vaccinations,
SUM(Convert(numeric,vacc.new_vaccinations)) OVER (Partition by deth.location Order by deth.location, deth.date) As People_Vaccinated
from CovidAnalysis..CovidDeaths deth
Join CovidAnalysis..CovidVaccinations vacc
	on deth.location = vacc.location and
	deth.date = vacc.date
Where deth.continent is not null
)
Select *,(People_Vaccinated/population) *100 as percentage_vaccinated_people 
From PopVsVac



-- Using Temp table
Drop Table if exists #PercentPeopleVaccinated -- for creating table again with modification
Create table #PercentPeopleVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
people_vaccinated numeric
)

Insert into #PercentPeopleVaccinated
Select deth.continent, deth.location, deth.date, deth.population, vacc.new_vaccinations,
SUM(Convert(BIGINT,vacc.new_vaccinations)) OVER (Partition by deth.location Order by deth.location, deth.date) As People_Vaccinated
from CovidAnalysis..CovidDeaths deth
Join CovidAnalysis..CovidVaccinations vacc
	on deth.location = vacc.location and
	deth.date = vacc.date
Where deth.continent is not null

Select *,(People_Vaccinated/population) *100 as percentage_vaccinated_people 
From #PercentPeopleVaccinated


-- View for data visualization
Drop View PercentPeopleVaccinated
USE CovidAnalysis
GO
Create View PercentPeopleVaccinated as 
Select deth.continent, deth.location, deth.date, deth.population, vacc.new_vaccinations,
SUM(Convert(BIGINT,vacc.new_vaccinations)) OVER (Partition by deth.location Order by deth.location, deth.date) As People_Vaccinated
from CovidAnalysis..CovidDeaths deth
Join CovidAnalysis..CovidVaccinations vacc
	on deth.location = vacc.location and
	deth.date = vacc.date
Where deth.continent is not null