--- Bai tap 1
SELECT
SUM(CASE
  WHEN device_type = 'laptop' THEN 1 ELSE 0
END) AS laptop_views,
SUM(CASE
  WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0
END) AS mobile_views
FROM viewership;

--- Bai tap 2
SELECT *,
CASE
    WHEN x + y > z AND x + z > y AND y + z > x THEN 'Yes'
    ELSE 'No'
END AS triangle 
FROM Triangle;

--- Bai tap 3
-- C1
SELECT 
ROUND(100.0 *
SUM(CASE
  WHEN call_category IS NULL OR call_category = 'n/a'
  THEN 1 ELSE 0
END)/ COUNT(*) , 1) AS uncategorised_call_pct
FROM callers;

-- C2:
SELECT 
ROUND (
100 * CAST(SUM(CASE
  WHEN call_category IS NULL OR call_category = 'n/a'
  THEN 1 ELSE 0
END) AS DECIMAl)/ CAST(COUNT(*) AS DECIMAl) , 1)
AS uncategorised_call_pct
FROM callers;

--- Bai tap 4
SELECT name
FROM Customer
WHERE COALESCE(referee_id, 0) !=2 OR referee_id !=2;

--- Bai tap 5
SELECT
CASE 
    WHEN pclass = 1 THEN 'first_class'
    WHEN pclass = 2 THEN 'second_classs'
    ELSE 'third_class'
END AS class,
SUM(CASE
    WHEN survived = 0 THEN 1 ELSE 0
END) AS survived,
SUM(CASE
    WHEN survived = 1 THEN 1 ELSE 0
END) AS non_survived
FROM titanic
GROUP BY class;



