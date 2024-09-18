--- Bai tap 1:
SELECT 
ROUND (100.0 * SUM(twt2.case)/SUM(twt2.stt) ,2) AS immediate_percentage
FROM
(SELECT twt.stt,
CASE
    WHEN twt.order_date = twt.customer_pref_delivery_date THEN 1
    ELSE 0
END AS case
FROM
(SELECT *,
RANK() OVER (PARTITION BY customer_id ORDER BY order_date) AS stt
FROM Delivery) AS twt
WHERE twt.stt = 1) AS twt2;

--- Bai tap 2:
SELECT
ROUND(CAST(SUM(twt2.case) AS DECIMAL)/CAST(COUNT(DISTINCT(twt2.player_id)) AS DECIMAL) 
, 2) AS fraction
FROM
(SELECT twt.*,
CASE
    WHEN next_day = event_date + 1 THEN 1
    ELSE 0
END AS case
FROM
(SELECT *,
LEAD(event_date) OVER (PARTITION BY player_id ORDER BY event_date) AS next_day,
MIN(event_date) OVER (PARTITION BY player_id ORDER BY event_date) AS first_day
FROM Activity) AS twt) AS twt2
WHERE twt2.event_date = twt2.first_day;

--- Bai tap 3:
WITH 
twt AS
(SELECT a.* FROM
(SELECT *,
CASE
    WHEN (id%2) = 0 THEN LAG(student) OVER (ORDER BY id) 
    WHEN (id%2) != 0 THEN LEAD(student) OVER (ORDER BY id)
END AS even
FROM Seat) AS a
WHERE a.even IS NOT NULL),
last_stu AS 
(SELECT * FROM Seat 
WHERE id = (SELECT MAX(id) FROM Seat) AND (SELECT COUNT(*) FROM Seat) % 2 != 0)

SELECT id, even AS student FROM twt
UNION ALL
SELECT id, student FROM last_stu 
ORDER BY id;

--- Bai tap 4:


--- Bai tap 8:
-- C1:
SELECT product_id, new_price AS price
FROM Products
WHERE (product_id, change_date) IN
(
SELECT product_id, MAX(change_date) 
FROM Products
WHERE change_date <= '2019-08-16'
GROUP BY product_id
)
UNION ALL
SELECT product_id, 10 AS price
FROM Products
GROUP BY product_id
HAVING MIN(change_date) > '2019-08-16';

-- C2: 
SELECT DISTINCT(a.*) FROM
(SELECT product_id, 
FIRST_VALUE(new_price) OVER (PARTITION BY product_id ORDER BY change_date DESC) 
AS price 
FROM Products
WHERE change_date <= '2019-08-16') AS a
UNION ALL
SELECT product_id, 10 AS price
FROM Products
GROUP BY product_id
HAVING MIN(change_date) > '2019-08-16';










