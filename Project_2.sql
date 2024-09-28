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





