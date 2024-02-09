/*1. How many rows are in the names table?*/

SELECT COUNT(*)
FROM names;

--Answer: 1,957,046

/*2. How many total registered people appear in the dataset?*/

SELECT SUM(num_registered)
FROM names;

--Answer: 351,653,025

/*3. Which name had the most appearances in a single year in the dataset?*/

SELECT name
FROM names
ORDER BY num_registered DESC
LIMIT 1;

--Answer: Linda

/*4. What range of years are included?*/

SELECT MIN(year) AS min_year,
	MAX(year) AS max_year,
	MAX(year)-MIN(year) AS num_years
FROM names;

--Answer: 1880 to 2018 (138 years)

/*5. What year has the largest number of registrations?*/

SELECT year,
	SUM(num_registered) AS total_registrations
FROM names
GROUP BY year
ORDER BY total_registrations DESC
LIMIT 1;

--Answer: 1957

/*6. How many different (distinct) names are contained in the dataset?*/

SELECT COUNT(DISTINCT name)
FROM names;

--Answer: 98,400

/*7. Are there more males or more females registered?*/

SELECT gender,
	SUM(num_registered) AS num_registered
FROM names
GROUP BY gender;

--Answer: There are more males registered

/*8. What are the most popular male and female names overall (i.e., the most total registrations)?*/

WITH top_names AS (
    SELECT name,
		gender,
        RANK() OVER (PARTITION BY gender ORDER BY SUM(num_registered) DESC) AS name_rank
    FROM names
    GROUP BY name, gender
)
SELECT name,
	gender
FROM top_names
WHERE name_rank = 1;
	
--Answer: The most popular male and female names are James and Mary

/*9. What are the most popular boy and girl names of the first decade of the 2000s (2000 - 2009)?*/

WITH top_names_genz AS (
    SELECT name,
		gender,
        RANK() OVER (PARTITION BY gender ORDER BY SUM(num_registered) DESC) AS name_rank
    FROM (
		SELECT * 
		FROM names 
		WHERE year BETWEEN 2000 AND 2009
		)
    GROUP BY name, gender
)
SELECT name,
	gender
FROM top_names_genz
WHERE name_rank = 1;

--Answer: The most popular male and female names 2000-2009 were Jacob and Emily

/*10. Which year had the most variety in names (i.e. had the most distinct names)?*/

SELECT year,
	COUNT(DISTINCT name) AS num_names
FROM names
GROUP BY year
ORDER BY num_names DESC
LIMIT 1;

--Answer: 2008

/*11. What is the most popular name for a girl that starts with the letter X?*/

SELECT DISTINCT name AS x_name,
	SUM(num_registered) AS num_reg
FROM names
WHERE name ILIKE 'X%'
	AND gender = 'F'
GROUP BY name
ORDER BY num_reg DESC
LIMIT 1;

--Answer: Ximena

/*12. How many distinct names appear that start with a 'Q', but whose second letter is not 'u'?*/

SELECT COUNT(DISTINCT name) AS num_q_names_not_qu
FROM names
WHERE name ILIKE 'Q%'
	AND name NOT ILIKE 'Qu%'
	
--Answer: 46

/*13. Which is the more popular spelling between "Stephen" and "Steven"? Use a single query to answer this question.*/

SELECT name,
	SUM(num_registered) AS num_reg
FROM names
WHERE name IN ('Stephen', 'Steven')
GROUP BY name
ORDER BY num_reg DESC;

--Answer: Steven is the more popular spelling