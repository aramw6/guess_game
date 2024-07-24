
-- Preview Data:

SELECT * FROM countries.`countries of the world`;


describe `countries of the world`;

-- Count Rows:
SELECT COUNT(*) FROM `countries of the world` ;


 
 -- DATA CLEANING
 
 -- 1) Decimal cleaning
 
 select Country,`Coastline (coast/area ratio)`,`Literacy (%)`,`Pop. Density (per sq. mi.)`,`Arable (%)`,`Crops (%)`,Service FROM `countries of the world`;
 
 set sql_safe_updates=0;
 
UPDATE `countries of the world` 
SET `Pop. Density (per sq. mi.)`=replace(`Pop. Density (per sq. mi.)`,',','.'),
`Coastline (coast/area ratio)`=replace(`Coastline (coast/area ratio)`,',','.'),
`Net migration`=replace(`Net migration`,',','.'),
`Infant mortality (per 1000 births)`=replace(`Infant mortality (per 1000 births)`,',','.'),
`GDP ($ per capita)`=replace(`GDP ($ per capita)`,',','.'),
`Literacy (%)`=replace(`Literacy (%)`,',','.'),
`Phones (per 1000)`=replace(`Phones (per 1000)`,',','.'),
`Arable (%)`=replace(`Arable (%)`,',','.'),
`Crops (%)`=replace(`Crops (%)`,',','.'),
`Other (%)`=replace(`Other (%)`,',','.'),
Climate=replace(`Climate`,',','.'),
Birthrate=replace(Birthrate,',','.'),
Deathrate=replace(Deathrate,',','.'),
Agriculture=replace(Agriculture,',','.'),
Industry=replace(Industry,',','.'),
Service=replace(Service,',','.');


-- Handling Missing Values/empty string:

UPDATE `countries of the world` 
SET `Pop. Density (per sq. mi.)`=nullif(`Pop. Density (per sq. mi.)`,''),
`Coastline (coast/area ratio)`=nullif(`Coastline (coast/area ratio)`,''),
`Net migration`=nullif(`Net migration`,''),
`Infant mortality (per 1000 births)`=nullif(`Infant mortality (per 1000 births)`,''),
`GDP ($ per capita)`=nullif(`Infant mortality (per 1000 births)`,''),
`Literacy (%)`=nullif(`Literacy (%)`,''),
`Phones (per 1000)`=nullif(`Phones (per 1000)`,''),
`Arable (%)`=nullif(`Arable (%)`,''),
`Crops (%)`=nullif(`Crops (%)`,''),
`Other (%)`=nullif(`Other (%)`,''),
Climate=nullif(`Climate`,''),
Birthrate=nullif(Birthrate,''),
Deathrate=nullif(Deathrate,''),
Agriculture=nullif(Agriculture,''),
Industry=nullif(Industry,''),
Service=nullif(Service,'');

-- convert datatypes


ALTER TABLE `countries of the world`
MODIFY COLUMN Population INT,
MODIFY COLUMN `Area (sq. mi.)` INT,
MODIFY COLUMN `Pop. Density (per sq. mi.)`  FLOAT,
MODIFY COLUMN `Coastline (coast/area ratio)` FLOAT,
MODIFY COLUMN `Net migration` FLOAT,
MODIFY COLUMN `Infant mortality (per 1000 births)` FLOAT,
MODIFY COLUMN `GDP ($ per capita)` FLOAT,
MODIFY COLUMN `Literacy (%)` FLOAT,
MODIFY COLUMN `Phones (per 1000)` FLOAT,
MODIFY COLUMN `Arable (%)` FLOAT,
MODIFY COLUMN `Crops (%)` FLOAT,
MODIFY COLUMN `Other (%)` FLOAT,
MODIFY COLUMN Climate INT,
MODIFY COLUMN Birthrate FLOAT,
MODIFY COLUMN Deathrate FLOAT,
MODIFY COLUMN Agriculture FLOAT,
MODIFY COLUMN Industry FLOAT,
MODIFY COLUMN  Service FLOAT;


-- Feature Engineering:

-- 1)Add a column for GDP per capita:

 ALTER TABLE `countries of the world`
 ADD COLUMN GDP_per_Capita FLOAT;

UPDATE `countries of the world`
SET GDP_per_Capita = `GDP ($ per capita)` / Population;

select Country,`GDP ($ per capita)` from `countries of the world`;

-- 2)Create a categorical column for population density:

ALTER TABLE `countries of the world`
ADD COLUMN Density_Category VARCHAR(50);

UPDATE `countries of the world`
SET Density_Category = CASE
    WHEN `Pop. Density (per sq. mi.)` < 50 THEN 'Low'
    WHEN `Pop. Density (per sq. mi.)` BETWEEN 50 AND 200 THEN 'Medium'
    ELSE 'High'
END;

-- 3)Extract the continent from the region:

ALTER TABLE `countries of the world`
ADD COLUMN Continent VARCHAR(50);

UPDATE `countries of the world`
SET Continent = CASE
    WHEN Region LIKE '%Asia%' or Region LIKE '%Near East%' THEN 'Asia'
    WHEN Region LIKE '%Africa%' THEN 'Africa'
    WHEN Region LIKE '%Europe%' THEN 'Europe'
    WHEN Region LIKE '%Americas%' THEN 'North America'
    WHEN Region LIKE '%Latin Amer. & Carib%' THEN 'South America'
    WHEN Region LIKE '%Oceania%' THEN 'Oceania'
    ELSE 'Other'
END;


-- 4) Climate

ALTER TABLE `countries of the world`
ADD COLUMN Climate_category VARCHAR(50);

UPDATE `countries of the world` 
SET 
    Climate_category = CASE
        WHEN Climate = 1 THEN 'Tropical'
        WHEN Climate = 2 THEN 'Arid'
        WHEN Climate = 3 THEN 'Temperate'
        WHEN Climate = 4 THEN 'Cold'
        ELSE 'Unknown'
    END;-- Handle any other values not explicitly mapped
  

select Country,GDP_per_Capita,Density_Category,Continent,Climate_category from `countries of the world`;

-- Analysis


-- 1.Which countries have the highest and lowest populations?
SELECT
Country, Population
FROM
`countries of the world`
ORDER BY Population DESC
LIMIT 1;

-- China 1313973713

SELECT
Country, Population
FROM
`countries of the world`
ORDER BY Population
LIMIT 1;

-- St Pierre & Miquelon 7026

-- 2.What are the largest and smallest countries by land area?

SELECT
Country, `Area (sq. mi.)`
FROM
`countries of the world`
ORDER BY `Area (sq. mi.)` DESC
LIMIT 1;

-- Russia 17075200

SELECT
Country, `Area (sq. mi.)`
FROM
`countries of the world`
ORDER BY `Area (sq. mi.)`
LIMIT 1;

-- Monaco 2

-- 3.What are the top 10 countries by GDP and which country has the maximum GDP growth ?
SELECT
Country, `GDP ($ per capita)`
FROM
`countries of the world`
ORDER BY `GDP ($ per capita)` DESC
LIMIT 10;


-- 4.What is the average population density across all countries?
SELECT
AVG(`Pop. Density (per sq. mi.)`)
FROM
`countries of the world`;
-- 380.71991150442443


-- 5.Which country is having the highest infant mortality rate?
SELECT
Country, `Infant mortality (per 1000 births)`
FROM
`countries of the world`
ORDER BY `Infant mortality (per 1000 births)` DESC
LIMIT 1;
-- Angola 191.19

-- 6.What is the average literacy rate by region?
SELECT
Region, AVG(`Literacy (%)`) AS average_literacy
FROM
`countries of the world`
GROUP BY Region
ORDER BY average_literacy DESC;


-- 7.Which country has the lowest rates of mobile phone usage?
SELECT
Country, `Phones (per 1000)`
FROM
`countries of the world`
where `Phones (per 1000)` is not null
ORDER BY `Phones (per 1000)` limit 1;
-- Congo, Dem. Rep. 0.2

-- 8.What is the birth and Death rate for each Continents, and find the continent with the highest birth and Death rate.
SELECT
Continent,
AVG(Birthrate) AS avg_birth_rate,
AVG(Deathrate) AS avg_death_rate
FROM
`countries of the world`
GROUP BY Continent;


-- 9.Literacy rate varies across different Continents?
SELECT
Continent, AVG(`Literacy (%)`) AS avg_literacy_rate
FROM
`countries of the world`
GROUP BY Continent;


-- 10.How many countries are included in the dataset?
SELECT
COUNT(DISTINCT Country) AS total_countries
FROM
`countries of the world`;
-- 226


-- 11.Total Population by Region
SELECT
Region, SUM(Population) AS Total_population
FROM
`countries of the world`
GROUP BY Region
ORDER BY Total_population DESC;


-- 12.Population Density Analysis
SELECT
Country,
Population,
`Area (sq. mi.)`,
Population / `Area (sq. mi.)` AS population_density
FROM
`countries of the world`
ORDER BY population_density DESC
LIMIT 10;


-- 13. When considering the coastline, find the countries with the LONGEST coastlines.
SELECT
country, `Coastline (coast/area ratio)`
FROM
`countries of the world`
ORDER BY `Coastline (coast/area ratio)` DESC
LIMIT 1;
-- Micronesia, Fed. St. 870.66

-- 14. Find the countries with the most and least migrants.
SELECT
Country, `Net migration`
FROM
`countries of the world`
ORDER BY `Net migration` DESC
LIMIT 1;
-- Afghanistan 23.06

SELECT
Country, `Net migration`
FROM
`countries of the world` where `Net migration` is not null
ORDER BY `Net migration`limit 1;
-- Micronesia, Fed. St. -20.99


-- 15. Find the continent with the most and least migrants.
SELECT
Continent, SUM(`Net migration`) AS total_migrants
FROM
`countries of the world`
GROUP BY Continent
ORDER BY total_migrants DESC limit 1;

-- Europe 85.2299998998642

SELECT
Continent, SUM(`Net migration`) AS total_migrants
FROM
`countries of the world`
GROUP BY Continent
ORDER BY total_migrants ASC
LIMIT 1;
-- South America -67.24999941326678

-- 16) Average GDP per Capita by Continent

SELECT Continent, AVG(GDP_per_Capita) AS avg_GDP_per_Capita
FROM `countries of the world`
GROUP BY Continent
ORDER BY avg_GDP_per_Capita DESC;


-- 17) Highest GDP per Capita in Each Continent

SELECT Continent, Country, GDP_per_Capita
FROM `countries of the world`
WHERE GDP_per_Capita = (
    SELECT MAX(GDP_per_Capita)
    FROM `countries of the world` c2
    WHERE c2.Continent = `countries of the world`.Continent
);

-- 18)Distribution of Density Categories

SELECT Density_Category, COUNT(*) AS count
FROM `countries of the world`
GROUP BY Density_Category;

-- 19) climate

SELECT Continent, Climate_category, COUNT(*) AS Number_of_Countries
FROM `countries of the world`
GROUP BY Continent, Climate_category
ORDER BY Continent, Climate_category;







