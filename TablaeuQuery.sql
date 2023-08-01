-- Query for Excel file TablaeuData.xlsx

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidAnalysis..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


-- Query for Excel file TablaeuData1.xlsx

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidAnalysis..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International','High income','Upper middle income','Lower middle income','Low income')
Group by location
order by TotalDeathCount desc

-- Query for Excel file TablaeuData2.xlsx

Select Location, Population, MAX(total_cases) as Highestcase,  Max((total_cases/population))*100 as InfectedCasesPercentage
From CovidAnalysis..CovidDeaths
Group by Location, Population
order by InfectedCasesPercentage desc

-- Query for Excel file TablaeuData3.xlsx

Select Location, Population,date, MAX(total_cases) as Highestcase,  Max((total_cases/population))*100 as InfectedCasesPercentage
From CovidAnalysis..CovidDeaths
Group by Location, Population, date
order by InfectedCasesPercentage desc
