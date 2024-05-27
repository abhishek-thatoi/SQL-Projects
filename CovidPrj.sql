-- Table Data: the tupples consist of dates and cases,death, vacc on each date for different locations
SELECT * FROM PrjSQL..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Data to select
SELECT location, date, total_cases, new_cases, total_deaths, population FROM PrjSQL..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;


-- Total Cases vs Total Deaths Percentage
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage FROM PrjSQL..CovidDeaths
WHERE continent IS NOT NULL
-- WHERE location like '%states%' 
 ORDER BY 1,2;

-- Total Cases vs Population
SELECT location, date, total_cases, population, (total_cases/population)*100 as InfectedPercentage FROM PrjSQL..CovidDeaths
--WHERE location ='India' 
WHERE continent IS NOT NULL
 ORDER BY 1,2;


-- ----------------------------------------------------------- Problems based on Ranking -------------------------------------------------------------------------------

-- P1: Countires desecending order of highest Infection rate

-- since there is no attribute to uniquely identify each tupple, but a group like country/ population
 SELECT location,max(total_cases)as highestInfectionCount,max((total_cases/population)*100) as highestInfectionPercentage FROM PrjSQL..CovidDeaths
 group by location
 ORDER BY highestInfectionPercentage DESC ;



-- P2: country with highest infection rate:
SELECT top 1 with ties location,max(total_cases)as highestInfectionCount,max((total_cases/population)*100) as InfectionPercentage
 FROM PrjSQL..CovidDeaths
 group by location
 ORDER BY InfectionPercentage DESC ;


-- P3: country with 3rd highest infection rate:
-- Using CTE
WITH RankInfectionRate AS
(
	SELECT
	location, MAX((total_cases/population)*100) AS highestInfectionRate,
	ROW_NUMBER() over(ORDER BY MAX((total_cases/population)*100) DESC) AS ROW_NUM -- we to rank we order by inside over
	FROM PrjSQL..CovidDeaths
	GROUP BY location
)
-- RankInfectionRate acts as temp table
SELECT * 
FROM RankInfectionRate
WHERE ROW_NUM=3;


-- P4: Countries with their highest death count per population
SELECT location, MAX(CAST(total_deaths AS INT) )AS TotalDeathCount -- we had to cast it into required data type: do this in case of aggregate function
FROM PrjSQL..CovidDeaths WHERE continent IS NOT NULL 
GROUP BY LOCATION
ORDER BY TotalDeathCount DESC;

-- P5: Continents with their highest death count
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount 
FROM PrjSQL..CovidDeaths WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;
-- Correction:
SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount 
FROM PrjSQL..CovidDeaths WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- Global Numbers
-- 1: New Cases
SELECT DATE, SUM(new_cases) 
FROM PrjSQL..CovidDeaths WHERE continent IS NOT NULL
GROUP BY DATE
ORDER BY 1,2;

-- 2: Death rates
SELECT DATE, SUM(new_cases) AS TOTAL_CASES, SUM(CAST(new_deaths AS INT)) AS TOTAL_DEATHS, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 
FROM PrjSQL..CovidDeaths WHERE CONTINENT IS NOT NULL
GROUP BY DATE
ORDER BY 1,2;

----------------------------------------------------------------- VACCINATIONS

SELECT * FROM PrjSQL..CovidVaccinations;

-- Prob: --------------------------------------------------- Vaccination COUNT PER DAY


-- --------------------------------------------- step1: sync location and date(find the most common and relevant attributes in both table-> make a join )

SELECT DEA.continent, DEA.location, DEA.date, population, VAC.new_vaccinations
FROM PrjSQL..CovidDeaths DEA 
JOIN PrjSQL..CovidVaccinations VAC 
ON DEA.location = VAC.location AND DEA.date=VAC.date WHERE DEA.continent IS NOT NULL  
ORDER BY 2,3; 



-- ------------------------------------------- step2: removing null values and get cummulative sum of vaccines per day OVER different Location:

SELECT DEA.continent, DEA.location, DEA.date, population, VAC.new_vaccinations,
SUM(CAST(new_vaccinations AS INT)) OVER(PARTITION BY DEA.location ORDER BY DEA.location, DEA.DATE) AS Vacination_COUNT -- put partition by date and check whats the result
FROM PrjSQL..CovidDeaths DEA 
JOIN PrjSQL..CovidVaccinations VAC 
ON DEA.location = VAC.location AND DEA.date=VAC.date 
WHERE (DEA.continent IS NOT NULL)  AND DEA.location= 'BELGIUM' 
ORDER BY 2,3;


-- Prob: ----------------------------------------------- Population vs Vaccine count each day


-- Use CTE: 

WITH POPvsVACC (Continent,location, date, population, new_vaccinations,Vaccination_COUNT) -- PARAMETERS have to match, BUT we cant and dont have to use referrence anymore
 AS
(
SELECT DEA.continent, DEA.location, DEA.date, population, VAC.new_vaccinations,
SUM(CAST(new_vaccinations AS INT)) OVER(PARTITION BY DEA.location ORDER BY DEA.location, DEA.DATE) AS Vacination_COUNT 
FROM PrjSQL..CovidDeaths DEA 
JOIN PrjSQL..CovidVaccinations VAC 
ON DEA.location = VAC.location AND DEA.date=VAC.date 
WHERE (DEA.continent IS NOT NULL)  AND DEA.location= 'BELGIUM' 
)

 Select *,(Vaccination_count/population)*100 AS VACC_Percentage
 FROM POPvsVACC
 ORDER BY 1,2;