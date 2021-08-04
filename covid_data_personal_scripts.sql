USE covid_data;

-- Searching for the total amount of vaccinations in Canada per day
SELECT 
	location,
	date,
	SUM(cast(new_vaccinations AS INT)) OVER (PARTITION BY location ORDER BY location, date) AS total_vaccinations
FROM covid_vaccinations
WHERE location = 'Canada'
ORDER BY 2, 3



-- Looking at new cases, deaths, and vaccinations in Canada per day
SELECT
	dea.location,
	dea.date,
	dea.new_cases,
	dea.new_deaths,
	vac.new_vaccinations
FROM covid_deaths dea
JOIN covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.location = 'Canada'
ORDER BY 2


-- -- Looking at new cases, deaths, and vaccinations by Continent per day
SELECT 
	dea.location,
	dea.date,
	dea.total_cases,
	dea.total_deaths,
	vac.people_vaccinated,
	vac.people_fully_vaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
	AND dea.location NOT IN ('World', 'European Union', 'International') 
ORDER BY 1, 2


-- Window functions to find rolling totals of cases, deaths and vaccination numbers 
SELECT
	dea.location,
	dea.date,
	SUM(cast(dea.new_cases AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS total_cases,
	SUM(cast(dea.new_deaths AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS total_deaths,
	SUM(cast(vac.new_vaccinations AS INT)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS total_people_vaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	
	
-- Window function for rolling total of just vaccination numbers
SELECT 
	dea.location,
	dea.date,
	SUM(cast(vac.new_vaccinations AS INT)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS total_people_vaccinated
FROM covid_deaths dea
JOIN covid_vaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NULL
	AND dea.location NOT IN ('World', 'European Union', 'International') 
