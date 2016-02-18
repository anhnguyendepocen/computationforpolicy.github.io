-- 1) The hhandlers table contains registration forms for hazardous waste handlers.
-- You can find a data dictionary <a href="http://www3.epa.gov/epawaste/inforesources/data/br11/hhandler.pdf">here</a>.

-- a) How many forms have been received by the EPA?
select count(*) from hhandler;





















-- b) How many facilities have registered? Hint: use the count(distinct <column>) function
select count(distinct epa_handler_id) from hhandler;
























-- c) How many forms were received per year over the last 5 years? 
select extract(year from receive_date), count(*) from hhandler group by 1 order by 1;

























-- 2) The cmecomp3 table contains a list of evaluations (inspections) of these handlers.
-- You can find a data dictionary <a href="https://rcrainfo.epa.gov/rcrainfo/help/technical/cir_cmecomp3_short.pdf">here</a>. 

-- a) How many evaluations are there?
select count(*) from cmecomp3;

























-- b) How many evaluations found violations?
select count(*) from cmecomp3 
where found_violation_flag = 'Y';

























-- c) What proportion of evaluations found violations?
select sum((found_violation_flag = 'Y')::int)*1.0/count(*) 
from cmecomp3;

























-- d) Which five handler_ids have been found in violation the most times? How many times? Also find these handlers' site names in the hhandlers table.
-- Hint: Use a GROUP BY and an ORDER BY <column> DESC.
select handler_id, count(*) 
from cmecomp3 
where found_violation_flag = 'Y'
group by 1 
order by 2 desc 
limit 5;

select * from hhandler where epa_handler_id = 'KYD053348108';

























-- 3) The North American Industry Classification System is a system used by federal agencies to classify a business according to its industry.
-- The naics table contains this information as retrieved from <a href="https://www.census.gov/econ/cbp/download/NAICS2012.txt">here</a>. Start by skimming this file.

-- a) How many different naics codes are there? How many six-digit industry classifications are there? How many two-digit classifications are there? These determine the sectors as described <a href="http://www.bls.gov/sae/saewhatis.htm">here</a>.
select count(*) from naics;

select count(*) from naics where naics !~ '(-|/)';

select count(distinct substring(naics for 2)) from naics;

























-- b) The hnaics table contains naics codes for some handlers. How many handlers have naics codes? How many don't?
select count(distinct epa_handler_id) from hnaics;




























-- c) Join the hnaics table with the naics table and use a GROUP BY to determine which the number of facilities in each sector. Which sector has the most hazardous-waste handlers? The least?
-- Hint: You can get the digit naics code from the naics_code using this expression: substring(naics_code for 2) || '----'
-- Hint: group by naics_description to get the description instead of the code.
select naics_description, count(distinct epa_handler_id) from
hnaics join naics on naics = substring(naics_code for 2) || '----'
group by 1 order by 2;




























-- d) create a temporary table called hsectors mapping handlers to sector descriptions.
-- Hint: use a group by to ensure that only unique pairs of handlers and descriptions are in the table.
CREATE TEMP TABLE hsectors AS (
	select naics_description, epa_handler_id from
	hnaics join naics on naics = substring(naics_code for 2) || '----'
	group by 1,2
);




























-- d) Join hsectors to cmecomp3, to determine for each sector, the number of handlers evaluated, the number of evaluations and the proportion of evaluations finding violations.
-- Which sector has the most violations? The highest proportion of evaluations finding violations?
select naics_description, 
	count(*) AS evaluation_count, 
	count(distinct epa_handler_id) AS handler_count, 
	sum((found_violation_flag = 'Y')::int) AS violation_count, 
	sum((found_violation_flag = 'Y')::int)*1.0/count(*) AS violation_rate,
from hsectors join cmecomp3 on hsectors.epa_handler_id = cmecomp3.handler_id
group by 1 order by 2;
