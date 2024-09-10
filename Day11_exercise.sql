--- Bai tap 1
SELECT b.CONTINENT, FLOOR(AVG(a.POPULATION))
FROM CITY AS a
INNER JOIN COUNTRY AS b
ON a.COUNTRYCODE = b.CODE
GROUP BY b.CONTINENT;

--- Bai tap 2
SELECT ROUND( 
CAST(SUM(CASE
  WHEN b.signup_action = 'Confirmed' THEN 1 ELSE 0
END) AS DECIMAL)
/ CAST(COUNT(b.signup_action) AS DECIMAL) , 2)
  AS confirm_rate
FROM emails AS a
INNER JOIN texts AS b
ON a.email_id=b.email_id;

--- Bai tap 3
SELECT  a.age_bucket,
ROUND(100.0* SUM(CASE
  WHEN b.activity_type = 'open' THEN b.time_spent
END)/ SUM(b.time_spent) , 2) AS open_perc,
ROUND(100.0* SUM(CASE
  WHEN b.activity_type = 'send' THEN b.time_spent
END)/ SUM(b.time_spent) , 2)  AS send_perc
FROM age_breakdown AS a
INNER JOIN activities AS b 
ON a.user_id=b.user_id
WHERE b.activity_type IN('open', 'send')
GROUP BY a.age_bucket;

--- Bai tap 4
SELECT 
b.customer_id
FROM products AS a
INNER JOIN customer_contracts AS b
ON a.product_id=b.product_id
GROUP BY b.customer_id
HAVING COUNT(DISTINCT(a.product_category))
= (SELECT COUNT(DISTINCT(product_category)) FROM products);

--- Bai tap 5
SELECT 
mng.employee_id AS employee_id, mng.name, 
COUNT(emp.reports_to) AS reports_count,
ROUND(AVG(emp.age)) AS average_age 
FROM Employees AS emp
LEFT JOIN Employees AS mng
ON emp.reports_to=mng.employee_id
WHERE emp.reports_to IS NOT NULL 
GROUP BY mng.employee_id, mng.name
ORDER BY employee_id;

--- Bai tap 6
SELECT 
a.product_name,
SUM(b.unit) AS unit
FROM Products AS a
INNER JOIN Orders AS b
ON a.product_id=b.product_id
WHERE EXTRACT(month FROM b.order_date) = 2 
AND EXTRACT(year FROM b.order_date) = 2020 
GROUP BY a.product_name
HAVING SUM(b.unit) >= 100;

--- Bai tap 7
SELECT b.page_id AS page_id
FROM page_likes AS a
FULL JOIN pages AS b
ON a.page_id=b.page_id
WHERE a.liked_date IS NULL
ORDER BY page_id;


