--- Ad-hoc tasks
-- 1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng 
SELECT * FROM
(SELECT EXTRACT(year FROM DATE(delivered_at))||'-'||EXTRACT(month FROM DATE(delivered_at)) AS month_year,
COUNT(order_id) AS total_orde,
COUNT(user_id) AS total_user
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE delivered_at IS NOT NULL 
GROUP BY month_year
ORDER BY month_year) AS a
WHERE month_year BETWEEN '2019-1' AND '2022-4';

