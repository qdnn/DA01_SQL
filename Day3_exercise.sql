--- Bai tap 1
SELECT NAME FROM CITY
WHERE POPULATION > 120000
AND COUNTRYCODE = 'USA';

-- Bai tap 2
SELECT * FROM CITY
WHERE COUNTRYCODE = 'JPN';

--- Bai tap 3
SELECT CITY, STATE FROM STATION;

--- Bai tap 4
SELECT DISTINCT CITY FROM STATION 
WHERE CITY LIKE 'u%' 
OR CITY LIKE 'e%'
OR CITY LIKE 'o%'
OR CITY LIKE 'a%'
OR CITY LIKE 'i%';

--- Bai tap 5
SELECT DISTINCT CITY FROM STATION 
WHERE CITY LIKE '%u' 
OR CITY LIKE '%e'
OR CITY LIKE '%o'
OR CITY LIKE '%a'
OR CITY LIKE '%i';

--- Bai tap 6
SELECT DISTINCT CITY FROM STATION 
WHERE CITY NOT LIKE 'u%' 
AND CITY NOT LIKE 'e%'
AND CITY NOT LIKE 'o%'
AND CITY NOT LIKE 'a%'
AND CITY NOT LIKE 'i%';

--- Bai tap 7
SELECT name FROM Employee 
ORDER BY name;

--- Bai tap 8
SELECT name FROM Employee
WHERE salary > 2000
AND months < 10
ORDER BY employee_id;

--- Bai tap 9
SELECT product_id FROM Products
WHERE low_fats = 'Y'
AND recyclable = 'Y'; 

--- Bai tap 10
SELECT name FROM Customer
WHERE referee_id != 2 
OR referee_id IS null;

--- Bai tap 11
SELECT name, population, area FROM World
WHERE area >= 300000
AND population >= 25000000;

--- Bai tap 12
SELECT DISTINCT author_id AS id FROM Views
WHERE  author_id = viewer_id
ORDER BY author_id;

--- Bai tap 13
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL;

--- Bai tap 14
select * from lyft_drivers
where yearly_salary <= 30000 
or yearly_salary >= 70000;

--- Bai tap 15
select advertising_channel from uber_advertising
where money_spent > 100000
and year = 2019;























