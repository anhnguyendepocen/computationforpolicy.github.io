-- Question 2: How often did a crime result in an arrest?
SELECT
	sum(arrest::int)*1.0 / count(*) AS arrest_prop 
FROM crimes;



-- Question 3: Which types of crimes most often result in arrest?
SELECT primary_type, count(*), min(date), 
	sum(arrest::int)*1.0 / count(*) AS arrest_prop
FROM crimes
GROUP BY primary_type;




-- Question 4: What are the number of weapons violations (one of the Primary Types) per district?
SELECT 
	district, count(*)
FROM crimes
WHERE primary_type = 'WEAPONS VIOLATION'
GROUP BY 1
ORDER BY 2;




-- Question 5: What are the number of arrests per days of the week? 
-- Which day of the week has the most arrests?
SELECT extract(dow from date) AS dayofweek, 
	count(*) as count, sum(arrest::int) as num_arrests
FROM crimes
GROUP BY extract(dow from date);
























