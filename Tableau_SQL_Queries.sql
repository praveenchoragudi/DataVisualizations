-- The following SQL queries are used to generate a dashboard in Tableau

--GLOBAL NUMBERS

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 as death_percentage
FROM public."CovidDeaths"
WHERE continent IS NOT NULL
ORDER BY 1,2

--Observing data, we found that Europen Union is part of Europe Continent as well as World, International
-- For maintaining consistency we run the following query excluding the above generalised data
SELECT location,SUM(new_deaths) as total_death_count
FROM public."CovidDeaths"
WHERE continent IS NOT NULL AND new_deaths IS NOT NULL AND location NOT IN ('World','European Union', 'International')
GROUP BY location
ORDER BY total_death_count DESC

--Looking at countries with highest infection rate

SELECT MAX(total_cases)AS Highest_Infection_Count,location, population, MAX(total_cases/population)*100 AS infected_percentage
FROM public."CovidDeaths"
WHERE continent IS NOT NULL AND total_cases IS NOT NULL
GROUP BY location, population
ORDER BY infected_percentage DESC

--Let us join the two tables CovidDeaths and CovidVacciantions from the database

SELECT * 
FROM public."CovidDeaths" dea JOIN public."CovidVaccinations" vac 
ON dea.location = vac.location AND dea.date = vac.date

--Looking at total population versus total vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM public."CovidDeaths" dea JOIN public."CovidVaccinations" vac 
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1,2,3


--Showing Countries with highest death count per population

SELECT location,MAX(total_deaths) AS total_death_count
FROM public."CovidDeaths"
WHERE total_deaths IS NOT NULL AND continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC

--Showing continents with death count per population

SELECT continent, MAX(total_deaths) AS death_count
FROM public."CovidDeaths"
WHERE total_deaths IS NOT NULL AND continent IS NOT NULL
GROUP BY continent
ORDER BY death_count DESC

