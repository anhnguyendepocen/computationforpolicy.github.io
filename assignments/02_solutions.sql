--Question 1: Crime counts and socioeconomics
--Download the crime data for all of the year 2015. Also download the socioeconomic data.

-- (a) Calculate the number of crimes in each Community Area in 2015.
SELECT community_area, count(*)
FROM crimes
GROUP BY 1;


-- (b) Sort the Community Areas by 2015 crime count. Which Community Area (by name) has the highest crime count. The lowest?
SELECT community_area_name, count(*)
FROM crimes
JOIN socio ON crimes.community_area = socio.community_area_number
GROUP BY 1
ORDER BY 2;

-- (c) Create a table whose rows are days in the year and columns are the 77 Community Area crime counts. 
-- Select a few Communities that you are interested and plot time series.

SELECT community_area, date::date, count(*)
FROM crimes JOIN socio ON crimes.community_area = socio.community_area_number
GROUP BY 1,2

-- (d) By joining with the socioeconomic data, create a scatter plot of crime counts against per capita income. Summarize the relationship in words.


SELECT community_area_name, count(*), avg(per_capita_income)
FROM crimes
JOIN socio ON crimes.community_area = socio.community_area_number
group by 1;

-- Question 2: Community Area populations
-- Download the census block population data and the Community Area tracts mapping.

-- (a) Join these together using the fact that the last six digits of the tract id in the mapping 
-- data correspond to the first six digits of the block id. However, the data portal has a bug: if the block starts with a zero, that digit is missing!

SELECT *
FROM community_tracts c
JOIN block_population b
ON substring(c.tract_id::text from 6 for 6) =
   substring(lpad(b.census_block::text, 10, '0') for 6);

-- (b) Calculate the total population in each Community Area.

SELECT community_id, sum(population)
FROM community_tracts c
JOIN block_population b
ON substring(c.tract_id::text from 6 for 6) =
   substring(lpad(b.census_block::text, 10, '0') for 6)
GROUP BY 1;