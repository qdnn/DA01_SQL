--- Bai tap 1
WITH duplicate_table
AS (
SELECT company_id, title, description,
COUNT(*) AS dupl_count
FROM job_listings
GROUP BY company_id, title, description)

SELECT COUNT (dupl_count) AS duplicate_companies
FROM duplicate_table
WHERE dupl_count >= 2;

--- Bai tap 2
SELECT category, product, total_spend
FROM (
SELECT category, product, SUM(spend) AS total_spend
FROM product_spend
WHERE EXTRACT(year FROM transaction_date) = 2022
GROUP BY category, product   
) AS category_spend
WHERE (
SELECT COUNT(*)
FROM (
SELECT category, product        
FROM product_spend       
WHERE EXTRACT(year FROM transaction_date) = 2022        
GROUP BY category, product       
) AS inner_query
WHERE inner_query.category = category_spend.category    
AND inner_query.product >= category_spend.product    
) <= 2
ORDER BY category, total_spend DESC;

--- Bai tap 3
WITH policy_calls
AS (
SELECT  policy_holder_id, COUNT(*) AS count_calls
FROM callers
GROUP BY policy_holder_id)
 
SELECT COUNT(count_calls)
FROM policy_calls
WHERE count_calls >= 3;

--- Bai tap 4
WITH new_table
AS (
SELECT b. page_id, a.liked_date
FROM page_likes AS a
FULL JOIN pages AS b
ON a.page_id=b.page_id)
SELECT page_id FROM new_table
WHERE liked_date IS NULL
ORDER BY page_id ;

--- Bai tap 5
SELECT EXTRACT(month FROM event_date) AS month,
COUNT(DISTINCT(user_id)) AS monthly_active_users
FROM user_actions
WHERE (EXTRACT(month FROM event_date) = 7)
AND event_type IN ('comment', 'sign-in', 'like')
AND user_id In 
(
SELECT user_id FROM user_actions
WHERE EXTRACT(month FROM event_date) = 6
)
GROUP BY EXTRACT(month FROM event_date);

--- Bai tap 6
SELECT LEFT(CAST(trans_date AS VARCHAR), 7) AS month, country, 
COUNT(*) AS trans_count,
SUM(amount) AS trans_total_amount,
SUM(CASE
         WHEN state = 'approved' THEN 1 
         WHEN state = 'declined' THEN 0 
END) AS approved_count,
SUM(CASE
         WHEN state = 'approved' THEN amount 
         WHEN state = 'declined' THEN 0 
END) AS approved_total_amount
FROM Transactions
GROUP BY  month, country;

--- Bai tap 7
SELECT quantity , price , product_id , year AS first_year
FROM Sales
WHERE (product_id, year)  IN 
(
SELECT product_id, MIN(year)
FROM Sales GROUP BY product_id
);

--- Bai tap 8
SELECT customer_id 
FROM Customer 
WHERE product_key IN 
(SELECT product_key FROM Product)
GROUP BY customer_id
HAVING COUNT(DISTINCT(product_key)) = (SELECT COUNT(*) FROM Product);

--- Bai tap 9
SELECT emp.employee_id
FROM Employees AS emp
LEFT JOIN Employees AS mng
ON emp.manager_id = mng.employee_id
WHERE emp.salary < 30000 
AND mng.employee_id IS NULL 
AND emp.manager_id IS NOT NULL 
ORDER BY emp.employee_id;

--- Bai tap 10
WITH duplicate_table
AS (
SELECT company_id, title, description,
COUNT(*) AS dupl_count
FROM job_listings
GROUP BY company_id, title, description)

SELECT COUNT (dupl_count) AS duplicate_companies
FROM duplicate_table
WHERE dupl_count >= 2;

--- Bai tap 11
WITH
user_rating AS
(SELECT a.name AS results, a.user_id,
COUNT(b.rating)
FROM Users AS a JOIN MovieRating AS b
ON a.user_id = b.user_id
GROUP BY a.name, a.user_id 
ORDER BY count DESC, results ASC
LIMIT 1)
, rating_score AS
(SELECT c.title AS results, c.movie_id,
AVG(b.rating)
FROM Movies AS c JOIN MovieRating AS b
ON c.movie_id  = b.movie_id 
WHERE EXTRACT(year FROM created_at) = 2020
AND EXTRACT(month FROM created_at) = 2
GROUP BY c.movie_id, c.title
ORDER BY avg DESC, results ASC 
LIMIT 1) 

SELECT results FROM user_rating
UNION ALL
SELECT results FROM rating_score; 

--- Bai tap 12
SELECT id, COUNT(*) AS num
FROM 
(SELECT requester_id AS id FROM requestaccepted
UNION ALL
SELECT accepter_id AS id FROM requestaccepted)
GROUP BY id
ORDER BY num DESC
LIMIT 1;

















