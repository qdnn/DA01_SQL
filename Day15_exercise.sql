--- Bai tap 1:
SELECT 
EXTRACT(year FROM transaction_date) AS year,
product_id, spend AS curr_year_spend,
LAG(spend) OVER (PARTITION BY product_id 
ORDER BY EXTRACT(year FROM transaction_date)) 
AS prev_year_spend,
ROUND(100.0 *(spend - LAG(spend) OVER (PARTITION BY product_id 
ORDER BY EXTRACT(year FROM transaction_date)))
/(LAG(spend) OVER (PARTITION BY product_id 
ORDER BY EXTRACT(year FROM transaction_date))) ,2)
AS yoy_rate
FROM user_transactions;

--- Bai tap 2:
SELECT card_name, issued_amount
FROM
(SELECT *,
RANK() OVER (PARTITION BY card_name
ORDER BY issue_year, issue_month, issued_amount) AS stt
FROM monthly_cards_issued)AS rank_table
WHERE rank_table.stt = 1
ORDER BY issued_amount DESC;

--- Bai tap 3:
SELECT user_id, spend, transaction_date
FROM
(SELECT *,
ROW_NUMBER() OVER (PARTITION BY user_id
ORDER BY transaction_date) AS stt
FROM transactions) AS a
WHERE a.stt = 3;

--- Bai tap 4:
SELECT user_id, transaction_date,purchase_count
FROM
(SELECT user_id, transaction_date, 
COUNT(*) OVER (PARTITION BY user_id 
ORDER BY transaction_date DESC) AS purchase_count,
ROW_NUMBER() OVER (PARTITION BY user_id 
ORDER BY transaction_date DESC) AS stt
FROM user_transactions) AS twt
WHERE twt.stt = 1
ORDER BY transaction_date;

--- Bai tap 5:
SELECT user_id, tweet_date,
ROUND(CAST(twt.tweet_count + twt.pre_day_1 + twt.pre_day_2 AS DECIMAL)
/CAST(twt.division AS DECIMAL), 2) 
AS rolling_avg_3d
FROM
(SELECT user_id, tweet_date, tweet_count,
COALESCE(LAG(tweet_count, 1) OVER(PARTITION BY user_id ORDER BY tweet_date), 0) AS pre_day_1,
COALESCE(LAG(tweet_count, 2) OVER(PARTITION BY user_id ORDER BY tweet_date), 0) AS pre_day_2,
CASE 
WHEN (COALESCE(LAG(tweet_count, 1) OVER(PARTITION BY user_id ORDER BY tweet_date), 0)) = 0
AND (COALESCE(LAG(tweet_count, 2) OVER(PARTITION BY user_id ORDER BY tweet_date), 0)) = 0
THEN 1
WHEN (COALESCE(LAG(tweet_count, 2) OVER(PARTITION BY user_id ORDER BY tweet_date), 0)) = 0
THEN 2
ELSE 3
END AS division
FROM tweets) AS twt;


--- Bai tap 6:
SELECT COUNT(DISTINCT(amount)) FROM  
(SELECT *,
LEAD(transaction_timestamp) 
OVER (PARTITION BY merchant_id, credit_card_id ORDER BY transaction_id),
EXTRACT(hour FROM 
(LEAD(transaction_timestamp) 
OVER (PARTITION BY merchant_id, credit_card_id ORDER BY transaction_id)) 
- transaction_timestamp )* 60 +
EXTRACT(minute FROM 
(LEAD(transaction_timestamp) 
OVER (PARTITION BY merchant_id, credit_card_id ORDER BY transaction_id)) 
- transaction_timestamp ) AS diff
FROM transactions) AS twt
WHERE twt.diff <=10 and twt.diff IS NOT NULL;

--- Bai tap 7
SELECT category, product, total_spend 
FROM
(SELECT category, product,
SUM(spend) AS total_spend,
RANK() OVER(PARTITION BY category ORDER BY SUM(spend) DESC) AS stt
FROM product_spend
WHERE EXTRACT(year FROM transaction_date) = 2022
GROUP BY category, product) AS twt
WHERE twt.stt <= 2;

--- Bai tap 8:
SELECT artist_name, artist_rank 
FROM
(SELECT a.artist_id, a.artist_name,
COUNT (c.rank),
DENSE_RANK() OVER(ORDER BY COUNT (c.rank) DESC) AS artist_rank
FROM artists AS a 
JOIN songs AS b ON a.artist_id=b.artist_id
JOIN global_song_rank AS c ON b.song_id=c.song_id
WHERE c.rank <=10
GROUP BY a.artist_id, a.artist_name) AS twt
WHERE twt.artist_rank <= 5;





