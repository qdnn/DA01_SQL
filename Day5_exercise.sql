--- Bai tap 1
SELECT DISTINCT CITY
FROM STATION
WHERE ID % 2 = 0;

--- Bai tap 2
SELECT
COUNT(CITY) - COUNT(DISTINCT(CITY))
FROM STATION;

--- Bai tap 3

--- Bai tap 4
SELECT 
ROUND(CAST(SUM(item_count*order_occurrences)/SUM(order_occurrences) 
AS DECIMAL), 1)
AS mean
FROM items_per_order;

--- Bai tap 5
SELECT candidate_id
FROM candidates
WHERE skill IN('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) = 3
ORDER BY candidate_id;

--- Bai tap 6
SELECT user_id,
MAX(DATE(post_date)) - MIN(DATE(post_date)) AS days_between
FROM posts
WHERE post_date BETWEEN '2021-01-10' AND '2022-01-01'
GROUP BY user_id
HAVING COUNT(post_date) >=2;

--- Bai tap 7
SELECT card_name,
MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;

--- Bai tap 8
SELECT manufacturer,
COUNT(drug) AS drug_count,
ABS(SUM(total_sales - cogs)) AS total_loss
FROM pharmacy_sales
WHERE total_sales - cogs < 0
GROUP BY manufacturer
ORDER BY ABS(SUM(total_sales - cogs)) DESC;

--- Bai tap 9
SELECT * 
FROM Cinema
WHERE (id % 2 !=0) AND (description != 'boring')
ORDER BY rating DESC;

--- Bai tap 10
SELECT teacher_id,
COUNT(DISTINCT(subject_id)) AS cnt
FROM Teacher
GROUP BY teacher_id

--- Bai tap 11
SELECT user_id,
COUNT(follower_id) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id;

--- Bai tap 12
SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(student) >= 5;




