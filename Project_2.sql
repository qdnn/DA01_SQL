--- Ad-hoc tasks
-- 1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng 
SELECT FORMAT_DATE('%Y-%m', delivered_at) AS month_year,
COUNT(order_id) AS total_orde,
COUNT(user_id) AS total_user
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE delivered_at IS NOT NULL
AND FORMAT_DATE('%Y-%m', delivered_at) BETWEEN '2019-01' AND '2022-04'
GROUP BY month_year
ORDER BY 1;

/* =>> Insights: Tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng có sự dao động lên xuống nhẹ 
nhưng vẫn tăng dần theo thời gian (trong từng năm) và đạt giá trị cao nhất vào tháng 12 */


--- 2. Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
SELECT FORMAT_DATE('%Y-%m', delivered_at) AS month_year,
SUM(DISTINCT(user_id)) AS distinct_users,
ROUND(AVG(sale_price), 2) AS average_order_value
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE delivered_at IS NOT NULL
AND FORMAT_DATE('%Y-%m', delivered_at) BETWEEN '2019-01' AND '2022-04'
GROUP BY month_year 
ORDER BY month_year; 

/* =>> Insights: 
- Số lượng người mua tuy có dao động lên xuống nhưng có xu hướng tăng dần đều theo thời gian qua từng tháng và từng năm
- Giá trị đơn hàng trung bình mỗi tháng có xu hướng dao động lên xuống nhưng không tăng theo số lượng người mua 
cho thấy lượng KH tăng nhưng số tiền KH dành cho các đơn hàng không tăng*/


--- 3. Nhóm khách hàng theo độ tuổi
WITH temp_user_info AS
(SELECT first_name, last_name, gender, age,
CASE 
  WHEN age = MIN(age) OVER (PARTITION BY gender) THEN 'youngest' 
  WHEN age = MAX(age) OVER (PARTITION BY gender) THEN 'oldest'
  ELSE 'NONE'
END AS category
FROM bigquery-public-data.thelook_ecommerce.users
WHERE created_at IS NOT NULL
AND FORMAT_DATE('%Y-%m', created_at) BETWEEN '2019-01' AND '2022-04'
ORDER BY age DESC)

SELECT gender, COUNT(*) AS so_luong
FROM temp_user_info
WHERE category = 'youngest'
GROUP BY gender;
/* Hoặc SELECT gender, COUNT(*) AS so_luong
FROM temp_user_info
WHERE category = 'oldest'
GROUP BY gender; */

/* =>> Insights
- Trẻ nhất là 12 tuổi và già nhất là 70 tuổi
- Nhóm KH trẻ nhất có số Nam là 494 và số Nữ là 472 
- Nhóm KH già nhất có số Nam là 486 và số Nữ là 472 */


--- 4.Top 5 sản phẩm mỗi tháng.
WITH twt_rank AS 
(SELECT FORMAT_DATE('%Y-%m', b.delivered_at) AS month_year,
b.product_id, a.name AS product_name, a.cost, a.retail_price AS sales, 
ROUND((a.retail_price - a.cost), 2) AS profit,
DENSE_RANK () OVER (PARTITION BY FORMAT_DATE('%m', b.delivered_at) ORDER BY ROUND((a.retail_price - a.cost), 2)) AS rank_per_month
FROM bigquery-public-data.thelook_ecommerce.products AS a
JOIN bigquery-public-data.thelook_ecommerce.order_items AS b
ON a.id = b.id)
SELECT month_year, product_id, product_name, sales, cost, profit, rank_per_month
FROM twt_rank
WHERE rank_per_month IN (1, 2, 3, 4, 5);


--- 5. Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
SELECT FORMAT_DATE('%Y-%m-%d', b.delivered_at) AS dates, a.category AS product_categories, 
ROUND(SUM(a.retail_price), 2) AS revenue
FROM bigquery-public-data.thelook_ecommerce.products AS a
JOIN bigquery-public-data.thelook_ecommerce.order_items AS b
ON a.id = b.id
WHERE FORMAT_DATE('%Y-%m-%d', b.delivered_at) BETWEEN '2022-01-15' AND '2022-04-16'
GROUP BY FORMAT_DATE('%Y-%m-%d', b.delivered_at), a.category
ORDER BY ROUND(SUM(a.retail_price), 2) DESC;


--- Dashboard
WITH vw_ecommerce_analyst AS 
(SELECT FORMAT_DATE('%Y-%m', a.created_at) AS month, FORMAT_DATE('%Y', a.created_at) AS year,
c.category AS Product_category,
SUM(b.sale_price) OVER (PARTITION BY FORMAT_DATE('%Y-%m', a.created_at), c.category) AS TPV,
COUNT(b.order_id) OVER (PARTITION BY FORMAT_DATE('%Y-%m', a.created_at), c.category) AS TPO,
SUM(c.cost) OVER (PARTITION BY FORMAT_DATE('%Y-%m', a.created_at), c.category) AS Total_cost,
(SUM(b.sale_price) OVER (PARTITION BY FORMAT_DATE('%Y-%m', a.created_at), c.category) - SUM(c.cost) OVER (PARTITION BY FORMAT_DATE('%Y-%m', a.created_at), c.category)) AS Total_profit,
(SUM(b.sale_price) OVER (PARTITION BY FORMAT_DATE('%Y-%m', a.created_at), c.category) - SUM(c.cost) OVER (PARTITION BY FORMAT_DATE('%Y-%m', a.created_at), c.category))/SUM(c.cost) OVER (PARTITION BY FORMAT_DATE('%Y-%m', a.created_at), c.category) AS Profit_to_cost_ratio
FROM bigquery-public-data.thelook_ecommerce.orders AS a
JOIN bigquery-public-data.thelook_ecommerce.order_items AS b ON a.order_id = b.order_id
JOIN bigquery-public-data.thelook_ecommerce.products AS c ON b.id = c.id
ORDER BY month, year)

SELECT *, LEAD(TPV) OVER (PARTITION BY year ORDER BY month) - TPV AS Revenue_growth,
LEAD(TPO) OVER (PARTITION BY year ORDER BY month) - TPO AS Order_growth,
MIN(month) OVER (PARTITION BY year) AS first_day
FROM vw_ecommerce_analyst;

--- Tạo retention cohort analysis
/* Ngày mua hàng đầu tiên của từng KH => cohort_date
Tìm index = tháng (ngày mua hàng - ngày đầu tiên) + 1
Count số lượng KH tại mỗi cohort_date và index tương ứng
Pivot table */

WITH a AS 
(SELECT user_id, order_id, 
FORMAT_DATE('%Y-%m',first_purchase_date) AS cohort_date, purchase_date,
((EXTRACT (year FROM purchase_date) - EXTRACT (year FROM first_purchase_date))*12)
+ (EXTRACT (month FROM purchase_date) - EXTRACT (month FROM first_purchase_date)) 
AS index
FROM(
SELECT user_id, MIN(DATE(created_at)) OVER (PARTITION BY user_id) AS first_purchase_date,
DATE(created_at) AS purchase_date, order_id
FROM bigquery-public-data.thelook_ecommerce.order_items
ORDER BY user_id)) ,
b AS 
(SELECT cohort_date, index,
COUNT(DISTINCT(user_id)) AS cnt FROM a
GROUP BY cohort_date, index),
customer_cohort AS
(SELECT cohort_date, 
SUM(CASE WHEN index = 0 THEN cnt ELSE 0 END) AS m0,
SUM(CASE WHEN index = 1 THEN cnt ELSE 0 END) AS m1,
SUM(CASE WHEN index = 2 THEN cnt ELSE 0 END) AS m2,
SUM(CASE WHEN index = 3 THEN cnt ELSE 0 END) AS m3
FROM b
GROUP BY cohort_date)
SELECT cohort_date,
ROUND(100.00* m0/m0, 2) ||'%' AS m0,
ROUND(100.00* m1/m0, 2) ||'%' AS m1,
ROUND(100.00* m2/m0, 2) ||'%' AS m2,
ROUND(100.00* m3/m0, 2) ||'%' AS m3
FROM customer_cohort;

