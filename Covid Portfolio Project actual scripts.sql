SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidDeaths
--ORDER BY 3,4

--Select Data that we are going to be using

Select Location, date, total_cases, new_cases,total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2

--looking at total cases vs total deaths
--shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
Where location like 'philippines'
and continent is not null
ORDER BY 1,2

--Looking at the total cases vs the population
--shows what percentage of population got Covid

Select Location, date,Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
--Where location like 'philippines'
ORDER BY 1,2

--Looking at countries with highest infection rate compared to population

Select Location,Population, MAX(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
--Where location like 'philippines'
Group by Location, Population
ORDER BY PercentPopulationInfected DESC

--Showing the countries with the highest death count per population

Select Location, max(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--Where location like 'philippines'
WHERE continent is not null
Group by Location
ORDER BY TotalDeathCount DESC

--LET'S BREAK THINGS DOWN BY CONTINENT

Select continent, max(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--Where location like 'philippines'
WHERE continent is not null
Group by continent
ORDER BY TotalDeathCount DESC

-- Showing the continent with the highest death count

Select continent, max(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--Where location like 'philippines'
WHERE continent is not null
Group by continent
ORDER BY TotalDeathCount DESC

--Global Numbers

Select  sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as new_deaths,sum(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
--Where location like 'philippines'
WHERE continent is not null
--group by date
ORDER BY 1,2


--Looking at total vaccinations vs Vaccinations

WITH PopvsVac (Continent,Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as
(

select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.Location order by dea.location,
dea.date) as  RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
select *
FROM PopVSvac

--USE CTE

WITH PopvsVac (Continent,Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as
(

select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.Location order by dea.location,
dea.date) as  RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
select *, (RollingPeopleVaccinated/Population)*100
FROM PopVSvac

--Temp Table

drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert Into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.Location order by dea.location,
dea.date) as  RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3
select *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

--Creating view to store data for later  visualizations

Create View PercentpopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.Location order by dea.location,
dea.date) as  RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea 
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3


Select *
FROM PercentpopulationVaccinated





























