--- Bai tap 1
SELECT Name
FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT(Name, 3), ID;

--- Bai tap 2
SELECT user_id, 
UPPER(LEFT(name, 1)) || 
LOWER(RIGHT(name, LENGTH(name) -1)) AS name
FROM Users
ORDER BY user_id;

--- Bai tap 3
SELECT manufacturer,
'$' || ROUND(SUM(total_sales)/ 10^6 ) || ' million' AS sales_mil
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY ROUND(SUM(total_sales)/ 10^6 ) DESC, manufacturer DESC;

--- Bai tap 4
SELECT EXTRACT(month FROM submit_date) AS mth,
product_id AS product,
ROUND(AVG(stars), 2) AS avg_stars
FROM reviews
GROUP BY EXTRACT(month FROM submit_date), product_id
ORDER BY mth, product;

--- Bai tap 5
-- C1:
SELECT sender_id,
COUNT(message_id) AS message_count
FROM messages
WHERE sent_date BETWEEN '2022-08-01' AND '2022-09-01'
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;

-- C2:
SELECT sender_id,
COUNT(message_id) AS message_count
FROM messages
WHERE EXTRACT(month FROM sent_date) = 8 
AND EXTRACT(year FROM sent_date) = 2022
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;

--- Bai tap 6
SELECT tweet_id
FROM Tweets
WHERE LENGTH(content) > 15;

--- Bai tap 7
SELECT activity_date AS day,
COUNT(DISTINCT(user_id)) AS active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date;

--- Bai tap 8
select count(id) as employee_numbs
from employees
where (extract(month from joining_date) between 1 and 7) 
and extract(year from joining_date) = 2022;

--- Bai tap 9
select position('a' in first_name) 
from worker
where first_name = 'Amitah';

--- Bai tap 10
select title, 
substring(title from(length(winery) + 2) for 4) as vintage_year
from winemag_p2
where country = 'Macedonia';



