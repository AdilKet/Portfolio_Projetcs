SELECT
	*
FROM 
	PortofolioProjet.CovidDeaths
WHERE
	continent is not NULL 

ORDER BY 3,4

--SELECT*
--FROM PortofolioProjet..CovidVaccinations

--ORDER BY 3,4

--selection de la date que je veux utiliser 

SELECT 
	location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population

FROM 
	PortofolioProjet..CovidDeaths

ORDER BY
	1,2

--explorer le Total des cas VS Total des decès
-- pourcentage des decès des personnes touchées pas le Covid

--SELECT location, date, total_cases, total_deaths, (total_deaths/ total_cases)

--FROM PortofolioProjet..CovidDeaths

--ORDER BY 1,2

SELECT
	location, 
	date, 
	total_cases,
	total_deaths, 
	(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS death_percentage
FROM 
	PortofolioProjet..CovidDeaths
WHERE
	location ='Morocco' 
order by 
	1,2


 --Explorer le Total des cas VS Population	
 --montre le pourcentage de la populationa atteint de Covid

 SELECT
	location, 
	date, 
	population,
	total_cases, 
	(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS percent_population_infected
FROM 
	PortofolioProjet..CovidDeaths
--WHERE location ='Morocco' 
ORDER BY
	1,2

--Explorer les pays les plus impactées 
--Pourcentage impacté de la population 

SELECT
	Location, 
	Population, 
	MAX(total_cases) as HighestInfectionCount, 
	Max((CONVERT (float, total_cases/NULLIF (CONVERT( float, population), 0))))*100 AS percent_population_infected
From 
	PortofolioProjet..CovidDeaths
--WHERE location ='Morocco' 
GROUP BY 
	Location, 
	Population

ORDER BY 
	percent_population_infected DESC

-- Pays avec le max de nbr de decès par population 

SELECT 
    Location, 
    MAX(CAST(NULLIF(ISNULL(REPLACE(total_deaths, '.', ''), ''), 'NA') AS INT)) AS total_death_count
FROM 
    PortofolioProjet..CovidDeaths
-- WHERE location = 'Morocco'
WHERE 
	continent is not NULL 
GROUP BY 
    Location
ORDER BY 
    total_death_count DESC

	
-- Explorer les données par Continent 
-- Les continents avec plus de decès par population 
SELECT 
   continent, 
    MAX(CAST(NULLIF(ISNULL(REPLACE(total_deaths, '.', ''), ''), 'NA') AS INT)) AS total_death_count
FROM 
    PortofolioProjet..CovidDeaths
-- WHERE location = 'Morocco'
WHERE 
	continent IS NOT NULL 
GROUP BY 
    continent
ORDER BY 
    total_death_count DESC

-- SOMMES DES DONNEES

SELECT
    SUM(CAST(new_cases AS float)) AS total_cases, -- quand c'est un chiffre Float pour chiffre avec décimale
    SUM(CAST(new_deaths AS float)) AS total_deaths, 
    CASE WHEN SUM(CAST(new_cases AS float)) > 0 
         THEN (SUM(CAST(new_deaths AS float)) / SUM(CAST(new_cases AS float))) * 100 
         ELSE 0 
    END AS death_percentage
FROM 
    PortofolioProjet..CovidDeaths
WHERE 
    continent IS NOT NULL
-- GROUP BY date
ORDER BY 
    1, 2;

-- VACCINATIONS 
-- fusion des deux tables
SELECT
*
FROM
	PortofolioProjet..CovidDeaths   dea
JOIN
	PortofolioProjet..CovidVaccinations vac
	ON 
		dea.location = vac.location
	AND
		dea.date = vac.date;

-- Nbr Total de personnes vaccinées dans le monde 

SELECT
	 dea.continent,
	 dea.location, 
	 dea.date, 
	 dea.population,
	 vac.new_vaccinations,
	 SUM(CAST (vac.new_vaccinations AS float)) OVER ( PARTITION BY dea.location ORDER BY dea.location, dea.date )-- SUM calculée par location, et trié par locatione & date
							AS rolling_people_vaccinated
FROM
	PortofolioProjet..CovidDeaths   dea
JOIN
	PortofolioProjet..CovidVaccinations  vac
	ON 
		dea.location = vac.location
	AND
		dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
	--AND	dea.location = 'canada'
	--AND dea.location ='Albania'

-- vaccinés par location 
--creation d'abord d'un CTE = une table temporaire
WITH PopVsVac AS ( 
    SELECT
        dea.continent,
        dea.location, 
        dea.date, 
        dea.population,
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS float)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated,
        (SUM(CAST(vac.new_vaccinations AS float)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) / dea.population) * 100 AS percentage_vaccinated
    FROM
        PortofolioProjet..CovidDeaths dea
    JOIN
        PortofolioProjet..CovidVaccinations vac
    ON 
        dea.location = vac.location
        AND dea.date = vac.date
    WHERE 
        dea.continent IS NOT NULL
)
SELECT
    *
FROM
    PopVsVac;


-- Using Temp Table to perform Calculation on Partition By in previous query

-- Using Temp Table to perform Calculation on Partition By in previous query

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

--INSERT INTO  #PercentPopulationVaccinated

--SELECT 
--	dea.continent


--CREATION DE FICHIER POUR VISUALISATION 
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(TRY_CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortofolioProjet..CovidDeaths dea
Join PortofolioProjet..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

SELECT
	*
FROM 
	PercentPopulationVaccinated
	
SELECT DISTINCT vac.new_vaccinations
FROM PortofolioProjet..CovidVaccinations vac
WHERE ISNUMERIC(vac.new_vaccinations) = 0;

Recherche des tables avec le nom 'PercentPopulationVaccinated'
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'PercentPopulationVaccinated';

-- Recherche des procédures stockées avec le nom 'PercentPopulationVaccinated'
SELECT *
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_NAME = 'PercentPopulationVaccinated';


-- Recherche des tables avec le nom 'PercentPopulationVaccinated'
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'PercentPopulationVaccinated';

-- Recherche des vues avec le nom 'PercentPopulationVaccinated'
SELECT *
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME = 'PercentPopulationVaccinated';
