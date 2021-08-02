USE covid_data;

SELECT *
FROM covid_deaths
WHERE
	continent IS NOT NULL
ORDER BY 3, 4

--SELECT *
--FROM covid_vaccinations
--ORDER BY 3, 4

--Select Data to use

SELECT
	location,
	date,
	total_cases,
	new_cases,
	total_deaths,
	population
FROM covid_deaths
WHERE
	continent IS NOT NULL
ORDER BY 1, 2


--Total Cases vs Total Deaths
--likelihood of death if covid contracted in Canada and date
SELECT
	location,
	date,
	total_cases,
	total_deaths,
	(total_deaths / total_cases) * 100 AS death_percent
FROM covid_deaths
WHERE location = 'Canada'
	AND 
	continent IS NOT NULL
ORDER BY 1, 2

--Total Cases vs Pop (In Canada)
SELECT
	location,
	date,
	total_cases,
	population,
	(total_cases / population) * 100 AS percent_infected
FROM covid_deaths
WHERE location = 'Canada'
	AND 
	continent IS NOT NULL
ORDER BY 1, 2

--Highest rate of infection compared to country pop
SELECT 
	location,
	population,
	MAX(total_cases) as highest_infection_count,
	MAX((total_cases/population))*100 as percent_infected
FROM
	covid_deaths
WHERE
	continent IS NOT NULL
GROUP BY location, population
ORDER BY 4 DESC

--Highest rate of death compared to country pop
SELECT 
	location,
	MAX(cast(total_deaths as int)) as total_death_count
FROM
	covid_deaths
WHERE
	continent IS NOT NULL
GROUP BY 
	location
ORDER BY 2 DESC

-- continents with highest death count
SELECT 
	location as continent,
	MAX(cast(total_deaths as int)) as total_death_count
FROM
	covid_deaths
WHERE
	continent IS NULL
GROUP BY 
	location
ORDER BY 2 DESC

-- Global statistics
SELECT
	date,
	SUM(new_cases) AS total_cases,
	SUM(cast(new_deaths AS int)) AS total_deaths,
	(SUM(cast(new_deaths AS int))/SUM(new_cases))*100 as death_percentage
FROM
	covid_deaths
GROUP BY date
HAVING SUM(new_cases) <> 0
ORDER BY 1, 2

SELECT
	SUM(new_cases) AS total_cases,
	SUM(cast(new_deaths AS int)) AS total_deaths,
	(SUM(cast(new_deaths AS int))/SUM(new_cases))*100 as death_percentage
FROM
	covid_deaths
ORDER BY 1, 2


SELECT 
	dea.continent,
	dea.location,
	dea.date,
	vac.new_vaccinations,
	SUM(cast(vac.new_vaccinations AS INT)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS rolling_ppl_vaccinated,
	
FROM covid_deaths dea
JOIN covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3


-- CTE METHOD

WITH pop_vs_vac (continent, location, date, population, new_vaccinations, rolling_ppl_vaccinated)
AS
(
	SELECT 
		dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		SUM(cast(vac.new_vaccinations AS INT)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS rolling_ppl_vaccinated
	FROM covid_deaths dea
	JOIN covid_vaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
)
SELECT *,
	(rolling_ppl_vaccinated/population)*100 AS percentage_vaccinated
FROM pop_vs_vac
ORDER BY 2, 3


--TEMP TABLE METHOD

DROP TABLE IF EXISTS #percent_pop_vaccinated
CREATE TABLE #percent_pop_vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_ppl_vaccinated numeric
)

INSERT INTO #percent_pop_vaccinated
SELECT 
		dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		SUM(cast(vac.new_vaccinations AS INT)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS rolling_ppl_vaccinated
	FROM covid_deaths dea
	JOIN covid_vaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL


-- Create a view to store data for later viz

CREATE View percent_pop_vaccinated AS
SELECT 
		dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		SUM(cast(vac.new_vaccinations AS INT)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS rolling_ppl_vaccinated
	FROM covid_deaths dea
	JOIN covid_vaccinations vac
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
