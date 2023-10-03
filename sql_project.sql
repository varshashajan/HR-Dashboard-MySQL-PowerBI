CREATE DATABASE projects

USE projects;
SELECT * FROM hr;

ALTER TABLE hr
CHANGE COLUMN ï»¿id empd_id VARCHAR(20)NULL

DESCRIBE hr;

SELECT birthdate FROM hr;

SET sql_safe_updates = 0;

UPDATE hr
SET birthdate = CASE
  WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
  WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
  ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

UPDATE hr
SET hire_date = CASE
  WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
  WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
  ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

SELECT hire_date FROM hr

UPDATE hr
SET termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate!='';

UPDATE hr
SET termdate = NULL
WHERE termdate = '';

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

SELECT termdate FROM hr



ALTER TABLE hr ADD COLUMN age INT;

UPDATE hr
SET age = timestampdiff(YEAR,birthdate,CURDATE());

SELECT 
    min(age) AS youngest,
	max(age) AS oldest
FROM hr;

SELECT COUNT(*)FROM hr WHERE age<18;

-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
SELECT gender,count(*) AS count
FROM hr
Where age>=18 AND termdate IS NULL
GROUP BY gender;

-- 2. What is the race breakdown of employees in the company
SELECT race,count(*) AS count
FROM hr
Where termdate IS NULL AND age >= 18
GROUP BY race;

 -- 3 What is the age distribution of employees in the company
 SELECT
     CASE 
       WHEN age >=18 AND age <=24 THEN '18-24'
       WHEN age >=25 AND age <=34 THEN '25-34'
       WHEN age >=35 AND age <=44 THEN '35-44'
       WHEN age >=45 AND age <=54 THEN '45-54'
       WHEN age >=55 AND age <=64 THEN '55-64'
       ELSE '65+'
	END AS age_group,
    COUNT(*) AS count
    FROM hr
    Where termdate IS NULL and age >=18
    GROUP BY age_group
    ORDER BY age_group
 
 -- 4 How many employees work at HQ vs Remote
 SELECT location,COUNT(*) AS count
 FROM hr
 WHERE age>=18 AND termdate IS NULL
 GROUP BY location
 
 -- 5.what is the average length of employment who have been terminated
 SELECT ROUND(AVG(year(termdate) - year(hire_date)),0) AS leng_of_emp
 FROM hr
 WHERE termdate IS NOT NULL AND termdate <=curdate()
 
 -- 6 How does gender distribution vary across dept. and job title
 SELECT department,jobtitle,gender,COUNT(*) AS count
 FROM hr
 WHERE termdate IS  NULL AND age >=18
 GROUP BY department,jobtitle,gender
 ORDER BY department,jobtitle,gender
 
 -- 7. What is the distribution of jobtitles across the comapny
 SElECT jobtitle,COUNT(*) AS count
 FROM hr
 WHERE termdate IS NULL AND age>=18
 GROUP BY jobtitle
 
 -- 8. Which dept have the highest termdate
 SELECT department,
        COUNT(*) AS total_count,
        COUNT( CASE
                 WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1
                 END) AS terminated_count,
		ROUND((COUNT( CASE
                 WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1
                 END)/COUNT(*))*100,2) AS termination_rate
		FROM hr
        GROUP BY department
        ORDER BY termination_rate DESC
        
-- 9 What is the distribution of emplooyes across location states
SELECT location_state, COUNT(*) AS count
FROM hr
WHERE termdate IS NULL AND age>=18
GROUP BY location_state

SELECT location_city, COUNT(*) AS count
FROM hr
WHERE termdate IS NULL AND age>=18
GROUP BY location_city

-- 10. How has the companies employee count change over time based on hire and termination date
SELECT * FROM hr

SELECT year,
        hires,
		terminations,
        hires-terminations AS net_change,
        (terminations/hires)*100 AS change_percent
	FROM(
         SELECT	YEAR(hire_date) AS year,
         COUNT(*) AS hires,
         SUM(CASE
                 WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1
		     END) AS terminations
		FROM hr
        GROUP BY YEAR(hire_date)) AS subquery
GROUP BY YEAR
ORDER BY YEAR

-- 11. What is the tenure distribution of each department
SELECT department , round(avg(datediff(termdate,hire_date)/365),0) AS avg_tenure
FROM hr
WHERE termdate IS NOT NULL  AND termdate <=curdate()
GROUP BY department

                 
         
        
        
        

 
 

