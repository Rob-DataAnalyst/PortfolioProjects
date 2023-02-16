Select *
From PortfolioProject.dbo.CovidDeaths
where continent is not null
order by 3, 4

--Select *
--From PortfolioProject.dbo.CovidVaccinations
--order by 3, 4

-- Select Data we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject.dbo.CovidDeaths
where continent is not null
Order by 1, 2

-- Looking at Total Cases vs Total Deaths
-- Shows likeliness of dying if you contact Covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
Where location like '%states%'
Order by 1, 2

-- Looking at Total Cases vs Population
--Shows what percent of the population got Covid

Select location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
Where location like '%states%'
Order by 1, 2

Select continent, date, population, total_cases, (total_cases/population)*100 as PercentPopulation
From PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Where continent is not null
Order by continent

-- Looking at Countries with Highest Infection Rate vs Population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Group by population, location
Order by PercentPopulationInfected desc

-- Showing Countries with the highest Death Count per Population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
where continent is not null
Group by continent
Order by TotalDeathCount desc

-- LETS BREAK THINGS DOWN BY LOCATION (THE CORRECCT NUMBERS)

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
where continent is null
Group by location
Order by TotalDeathCount desc

-- Showing continents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
where continent is not null
Group by continent
Order by TotalDeathCount desc


-- GLOBAL NUMBERS by date

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
where continent is not null
Group by date
Order by 1, 2

--GLOBAL NUMBERS (TOTAL)

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
where continent is not null
--Group by date
Order by 1, 2

Select *
From PortfolioProject.dbo.CovidVaccinations

-- Let's join these two tables together
-- Looking at total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3


-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
--where dea.continent is not null
--order by 2, 3


Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating view to store data for later visualizations

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
--order by 2, 3

select *
From PercentPopulationVaccinated