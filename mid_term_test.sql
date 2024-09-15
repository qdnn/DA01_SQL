--- Q1:
SELECT DISTINCT(replacement_cost) AS replace_cost FROM film
ORDER BY replacement_cost ASC;

--- Q2:
SELECT
CASE
	WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
	WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'medium'
	ELSE 'high'
END AS category,
COUNT(*)
FROM film
GROUP BY category;

--- Q3:
SELECT c.title AS film_title, c.length, b.name AS category_name
FROM film_category AS a
JOIN category AS b ON a.category_id = b.category_id
JOIN film AS c ON a.film_id = c.film_id
WHERE b.name IN ('Drama', 'Sports')
ORDER BY c.length DESC;

--- Q4:
SELECT b.name AS category_name,
COUNT (*) AS count_film
FROM film_category AS a
JOIN category AS b ON a.category_id = b.category_id
JOIN film AS c ON a.film_id = c.film_id
GROUP BY category_name
ORDER BY count_film DESC;

--- Q5:
SELECT b.first_name || ' ' || b.last_name AS actor_name,
COUNT (*) AS movies_numb
FROM film_actor AS a 
JOIN actor AS b 
ON a.actor_id=b.actor_id
GROUP BY actor_name
ORDER BY movies_numb DESC

--- Q6:
SELECT COUNT (*) AS null_count
FROM (
SELECT b.address
FROM customer AS a
FULL JOIN address AS b
ON b.address_id=a.address_id 
WHERE a.customer_id IS NULL 
) AS null_address;

--- Q7:
SELECT SUM(a.amount) AS revenue, d.city
FROM  payment AS a JOIN customer AS b ON a.customer_id = b.customer_id
JOIN address AS c ON b.address_id = c.address_id
JOIN city AS d ON c.city_id = d.city_id
GROUP BY d.city
ORDER BY revenue DESC;

--- Q8:
SELECT SUM(a.amount) AS revenue, d.city ||', ' || e.country AS city_country
FROM  payment AS a JOIN customer AS b ON a.customer_id = b.customer_id
JOIN address AS c ON b.address_id = c.address_id
JOIN city AS d ON c.city_id = d.city_id
JOIN country AS e ON d.country_id = e.country_id
GROUP BY city_country
ORDER BY revenue ASC;


