/*Ở Project này chúng ta sử dụng dataset đã được xử lý ở PROJECT 1*/
SELECT * FROM SALES_DATASET_RFM_PRJ_CLEAN;

--- 1. Doanh thu theo từng ProductLine, Year  và DealSize
SELECT productline, year_id, dealsize,
SUM(priceeach * orderlinenumber) AS revenue
FROM SALES_DATASET_RFM_PRJ_CLEAN
GROUP BY productline, year_id, dealsize
ORDER BY productline, year_id, dealsize;

--- 2. Đâu là tháng có bán tốt nhất mỗi năm
WITH twt_revenue AS 
(SELECT month_id, year_id,
SUM(priceeach * orderlinenumber) AS revenue
FROM SALES_DATASET_RFM_PRJ_CLEAN
GROUP BY year_id, month_id
ORDER BY year_id),
twt_rank AS
(SELECT month_id, revenue, year_id,
RANK () OVER (PARTITION BY year_id ORDER BY revenue DESC) AS order_number
FROM twt_revenue)

SELECT month_id, order_number, revenue
FROM twt_rank
WHERE order_number = 1;

--- 3. Product line nào được bán nhiều ở tháng 11
WITH twt_product AS
(SELECT month_id, year_id, productline,
SUM(priceeach * orderlinenumber) AS revenue
FROM SALES_DATASET_RFM_PRJ_CLEAN
WHERE month_id = 11
GROUP BY productline, month_id, year_id
ORDER BY year_id),
twt_product_rank AS
(SELECT *,
RANK () OVER (PARTITION BY year_id ORDER BY revenue DESC) AS order_number
FROM twt_product)

SELECT month_id, revenue, order_number
FROM twt_product_rank
WHERE order_number = 1;

--- 4. Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm
WITH twt_UK_product AS
(SELECT productline, year_id,
SUM(priceeach * orderlinenumber) AS revenue
FROM SALES_DATASET_RFM_PRJ_CLEAN
WHERE country = 'UK'
GROUP BY productline, year_id
ORDER BY year_id)

SELECT *,
DENSE_RANK() OVER (PARTITION BY year_id ORDER BY revenue DESC) AS rank
FROM twt_UK_product;

--- 5. Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
-- (sử dụng lại bảng customer_segment ở buổi học 23)

