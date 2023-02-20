
--Queries used for Tableau Project

-- 1.

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
where continent is not null
--Group by date
Order by 1, 2

-- Just a double check based off the data provided
-- Numbers are exremely close so we will keeo them - The Second includes Location

-- 2.

-- We take these out as they are not included in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Where continent is null
and location not in 
(
'World', 
'European Union', 
'International'
)
Group by location
order by TotalDeathCount desc

-- 3.

Select Location, Population, Max(total_cases) as HighestInfectionCount, 
Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Group by Location, Population
Order by PercentPopulationInfected desc


-- 4.

Select Location, Population, date, Max(total_cases) as HighestInfectionCount, 
Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
Order by PercentPopulationInfected desc
