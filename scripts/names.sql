SELECT *
FROM names
ORDER BY name
LIMIT 10

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

/*9. What are the most popular boy and girl names of the first decade of the 2000s (2000 - 2009)?*/

/*10. Which year had the most variety in names (i.e. had the most distinct names)?*/

/*11. What is the most popular name for a girl that starts with the letter X?*/

/*12. How many distinct names appear that start with a 'Q', but whose second letter is not 'u'?*/

/*13. Which is the more popular spelling between "Stephen" and "Steven"? Use a single query to answer this question.*/