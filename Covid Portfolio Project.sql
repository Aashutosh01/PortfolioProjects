--Select * from CovidData order by 1,2
--Select * from CovidVaccinations order by 1,2

Select location, date, total_cases, new_cases, total_deaths, population 
from CovidData 
order by 1,2 

--Total Cases vs Total Deaths
--Likelihood of death due to covid in India 

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPct
from CovidData 
where location like '%India%'
order by 1,2 


--Total cases vs Population
--Shows the percentage of population in India that was infected with Covid

Select location, date, total_cases, population, (total_cases/population)*100 as InfectionPct
from CovidData 
where location like '%India%'
order by 1,2 

--Countries with highest infection rate compared to population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PctPopulationInfected
from CovidData 
Group by Location, population
order by PctPopulationInfected DESC

--Countries with the highest death count (population wise)

Select location, population, MAX(cast(total_deaths as int)) as TotalDeathCount, MAX(total_deaths/total_cases)*100 as DeathPct
from CovidData 
where continent is not null
Group by Location, population
order by TotalDeathCount DESC


Select * from CovidData as cd Join CovidVaccinations as cv
on cd.location = cv.location 
and cd.date = cv.date


--Total population vs Vaccinations

Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(CONVERT(int, cv.new_vaccinations)) OVER (Partition by cd.location Order by
cd.location, cd.date) as RollingCount
from CovidData as cd join CovidVaccinations as cv
on cd.location = cv.location 
and cd.date = cv.date
where cd.continent is not null
order by 2,3


--Using CTE

With PopVac (Continent, Location, Date, Population, New_Vaccinations, RollingCount)
as
(
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(CONVERT(int, cv.new_vaccinations)) OVER (Partition by cd.location Order by
cd.location, cd.date) as RollingCount
from CovidData as cd join CovidVaccinations as cv
on cd.location = cv.location 
and cd.date = cv.date
where cd.continent is not null
)
Select *
from PopVac


--Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated

(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric, 
New_vaccinations numeric,
RollingCount numeric
)
Insert into #PercentPopulationVaccinated
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(CONVERT(int, cv.new_vaccinations)) OVER (Partition by cd.location Order by
cd.location, cd.date) as RollingCount
from CovidData as cd join CovidVaccinations as cv
on cd.location = cv.location 
and cd.date = cv.date
where cd.continent is not null

Select * , (RollingCount/Population)*100
from #PercentPopulationVaccinated 

Create View PercentPopulationVaccinated as
Select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(CONVERT(int, cv.new_vaccinations)) OVER (Partition by cd.location Order by
cd.location, cd.date) as RollingCount
from CovidData as cd join CovidVaccinations as cv
on cd.location = cv.location 
and cd.date = cv.date
where cd.continent is not null


Select * from PercentPopulationVaccinated