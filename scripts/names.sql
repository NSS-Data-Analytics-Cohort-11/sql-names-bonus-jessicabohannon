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
	AND name NOT ILIKE 'Qu%';
	
--Answer: 46

/*13. Which is the more popular spelling between "Stephen" and "Steven"? Use a single query to answer this question.*/

SELECT name,
	SUM(num_registered) AS num_reg
FROM names
WHERE name IN ('Stephen', 'Steven')
GROUP BY name
ORDER BY num_reg DESC;

--Answer: Steven is the more popular spelling

/*14. What percentage of names are "unisex" - that is what percentage of names have been used both for boys and for girls?*/

WITH girl_names AS (
	SELECT DISTINCT name
	FROM names
	WHERE gender = 'F'
), 
boy_names AS (
	SELECT DISTINCT name
	FROM names
	WHERE gender = 'M'
),
unisex_names AS (
SELECT name
FROM girl_names
INTERSECT
SELECT name
FROM boy_names
)
SELECT COUNT(DISTINCT name)	AS num_unisex_names,
	ROUND((COUNT(DISTINCT name)::numeric / (SELECT COUNT(DISTINCT name) FROM names)::numeric) * 100.00, 2) AS perc_unisex_names
FROM unisex_names;

--Answer: 10.95% of names are unisex.

/*15. How many names have made an appearance in every single year since 1880?*/

SELECT COUNT(DISTINCT name) AS num_popular_names
FROM names
WHERE name IN (SELECT name 
			   FROM names
			   GROUP BY name
			   HAVING COUNT(DISTINCT year) = (SELECT MAX(year)-MIN(year) FROM names));

--Answer: 120

/*16. How many names have only appeared in one year?*/

WITH rare_names AS (
	SELECT name
	FROM names
	GROUP BY name
	HAVING COUNT(year) = 1
)
SELECT COUNT(name) AS num_rare_names
FROM rare_names;

--Answer: 21,100

/*17. How many names only appeared in the 1950s?*/

SELECT COUNT(*) AS num_50s_names
FROM (
	SELECT name
	FROM names AS n1
	WHERE year BETWEEN 1950 AND 1959
	EXCEPT
	SELECT name
	FROM names AS n2
	WHERE year < 1950 OR year >= 1960
) AS names_50s;

--Answer: 661

/*18. How many names made their first appearance in the 2010s?*/

SELECT COUNT(name)
FROM names
GROUP BY name
HAVING MIN(year) BETWEEN 2010 AND 2019;

--Answer: 11,270

/*19. Find the names that have not be used in the longest.*/

SELECT name AS old_name,
	MAX(year) AS last_year
FROM names
GROUP BY name
ORDER BY MAX(year)
LIMIT 30;

--Answer: Roll and Zilpah have not been used since 1881.

/*20. Come up with a question that you would like to answer using this dataset. Then write a query to answer this question.*/
--What was the top boy and girl name each decade?

WITH girl_names AS (
	SELECT ROUND(year, -1) AS decade,
		name,
		SUM(num_registered) AS num_reg
	FROM names
	WHERE gender = 'F'
	GROUP BY decade, name
), 
boy_names AS (
	SELECT ROUND(year, -1) AS decade,
		name,
		SUM(num_registered) AS num_reg
	FROM names
	WHERE gender = 'M'
	GROUP BY decade, name
),
SELECT
	