--- Ad-hoc tasks
-- 1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng 
SELECT FORMAT_DATE('%Y-%m', delivered_at) AS month_year,
COUNT(order_id) AS total_orde,
COUNT(user_id) AS total_user
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE delivered_at IS NOT NULL
AND FORMAT_DATE('%Y-%m', delivered_at) BETWEEN '2019-01' AND '2022-04'
GROUP BY month_year
ORDER BY 1

/* =>> Insights: tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng có sự dao động lên xuống nhẹ nhưng vẫn tăng dần theo thời gian */









