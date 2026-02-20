
-- ConsecutiveNumbers
SELECT 
    Num AS ConsecutiveNums
FROM (
    SELECT 
        Num,
        LAG(Num, 1) OVER(ORDER BY Id ASC) lag1,
        LAG(Num, 2) OVER(ORDER BY Id ASC) lag2
    FROM 
        logs
) LAGS
WHERE  
    Num - lag1 = 0
AND
    Num - lag2 = 0
GROUP BY 1
;


-- customers-who-never-order
SELECT name As Customers
FROM Customers
WHERE Customers.Id NOT IN
(SELECT DISTINCT(CustomerId)
 FROM Orders);


-- DeptHighestSalary 
SELECT 
    D.Name AS Department,
    E.Name As Employee,
    E.Salary
FROM (
    SELECT 
        Name,
        DepartmentId,
        Salary,
        RANK() OVER(PARTITION BY DepartmentId ORDER BY Salary DESC) rnk
    FROM
        Employee 
) AS E
JOIN Department As D
ON 
    E.DepartmentId = D.Id
WHERE 
    E.rnk = 1
;



-- duplicate-emails
SELECT Email
FROM 
(SELECT Email, COUNT(Email) AS CNT
FROM Person
GROUP BY Email)
WHERE CNT > 1;


-- rising-temperature
SELECT W1.Id
FROM Weather AS W1
LEFT JOIN Weather AS W2
ON DATE_ADD(W2.RecordDate, INTERVAL 1 DAY ) = W1.RecordDate
WHERE W1.Temperature > W2.Temperature
;


-- department-top-three-salaries
SELECT 
    Department,
    Employee,
    Salary
FROM (
    SELECT
        L.Name As Employee,
        L.Salary,
        R.Name AS Department,
        DENSE_RANK() OVER (
           PARTITION BY L.DepartmentId
           ORDER BY L.Salary DESC) rnk
    FROM 
        Employee AS L
    JOIN
        Department AS R
    ON 
        L.DepartmentId = R.Id
) base
WHERE 
        base.rnk <= 3
;


-- Rank Score
SELECT 
    Score as score,
    DENSE_RANK() OVER(ORDER BY Score DESC) AS `Rank`
FROM
    Scores
;

-- Not boring Movies

SELECT 
    id,
    movie,
    description,
    rating
FROM
    cinema
WHERE 
    (id % 2 = 1) 
    AND
    (description != 'boring')
ORDER BY 
    rating DESC
;


-- Exchange  
SELECT
    CASE WHEN MOD(id, 2) = 0 THEN id - 1
         WHEN id < (SELECT MAX(id) FROM Seat) THEN id + 1
         ELSE id
    END AS id,
    student
FROM
     Seat
ORDER BY 
    id ASC
;



-- human-traffic-of-stadium
SELECT 
    id,
    visit_date,
    people
FROM (
    SELECT 
        id,
        LAG(id,1) OVER(ORDER BY id ASC) AS lag_id,
        LAG(id,2) OVER(ORDER BY id ASC) AS lag2_id,
        LEAD(id,1) OVER(ORDER BY id ASC) AS lead_id,
        LEAD(id,2) OVER(ORDER BY id ASC) AS lead2_id,
        visit_date,
        people
    FROM 
        Stadium
    WHERE
        people >= 100
) A
WHERE (
    ((id = lead_id - 1) AND (id = lead2_id - 2))
OR
    ((id = lag_id + 1) AND (id = lag2_id + 2))
OR 
    ((id = lag_id + 1)  AND (id = lead_id - 1))
)
ORDER BY 
    visit_date;



-- trips-and-users
SELECT 
    L.request_at AS Day,
    ROUND(SUM(CASE
                WHEN L.status != 'completed' THEN 1
                ELSE 0
            END) / COUNT(1),
            2) AS 'Cancellation Rate'
FROM
    Trips AS L
        JOIN
    (SELECT 
        users_id AS client_id
    FROM
        Users
    WHERE
        banned = 'No' AND role IN ('client')) R1 ON L.client_id = R1.client_id
        JOIN
    (SELECT 
        users_id AS driver_id
    FROM
        Users
    WHERE
        role IN ('driver') AND banned = 'No') R2 ON L.driver_id = R2.driver_id
WHERE
    request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY 1
;


-- capital_gain_loss 

SELECT 
    stock_name,
    SUM(CASE
        WHEN operation = 'Buy' THEN - price
        ELSE price
    END) AS capital_gain_loss
FROM
    Stocks
GROUP BY 1
;


-- Market Analysis
SELECT
    L.user_id AS buyer_id,
    L.join_date,
    COALESCE(R.orders_in_2019, 0) orders_in_2019
FROM
    Users AS L
LEFT JOIN (
    SELECT 
         buyer_id,
         COUNT(1) AS orders_in_2019
    FROM
        Orders
    WHERE 
       YEAR(order_date) = 2019
    GROUP BY 1
) R
ON
    L.user_id = R.buyer_id
GROUP BY 1, 2
;



-- Tree node 
SELECT 
    id,
    CASE
        WHEN child_ct = 0 AND type = 'Not Root' THEN 'Leaf'
        WHEN child_ct > 0 AND type = 'Not Root' THEN 'Inner'
        ELSE type
    END AS type
FROM
    (SELECT 
        L.id,
            CASE
                WHEN L.p_id IS NULL THEN 'Root'
                ELSE 'Not Root'
            END AS type,
            SUM(CASE
                WHEN R.id IS NULL THEN 0
                ELSE 1
            END) AS child_ct
    FROM
        Tree AS L
    LEFT JOIN Tree AS R ON L.id = R.p_id
    GROUP BY 1 , 2) Base
;



-- avg-review-ratings. 
SELECT
  EXTRACT(MONTH FROM submit_date) AS mth,
  product_id AS product,
  ROUND(AVG(stars), 2) AS avg_stars
FROM
  reviews
GROUP BY 1, 2 
ORDER BY 1, 2
;



-- Matching Skill 
SELECT
  candidate_id
FROM  (
SELECT 
  candidate_id,
  ARRAY_AGG(skill) AS skills
FROM 
  candidates
GROUP BY 1
) A 
WHERE 
  'Python'=ANY(skills)
AND
  'Tableau'=ANY(skills)
AND
  'PostgreSQL'=ANY(skills)
;


-- odd-even-measurements
SELECT 
    measurement_day,
    SUM(CASE WHEN day_rnk % 2 != 0 THEN measurement_value ELSE 0 END) AS odd_sum,
    SUM(CASE WHEN day_rnk % 2 = 0 THEN measurement_value ELSE 0 END) AS even_sum
FROM (
    SELECT
        DATE(measurement_time) AS measurement_day,
        measurement_value,
        ROW_NUMBER() OVER (
            PARTITION BY DATE(measurement_time)
            ORDER BY measurement_time ASC
        ) AS day_rnk
    FROM measurements
) AS base
GROUP BY measurement_day;


-- Y-O-Y Growth Rate

SELECT 
  year,
  product_id,
  curr_year_spend,
  prev_year_spend,
  ROUND(100 * (curr_year_spend - prev_year_spend ) / prev_year_spend, 2) AS yoy_rate
FROM 
    product_by_year
;


-- page-with-no-likes
SELECT 
    L.page_id
FROM
    pages AS L
        LEFT JOIN
    page_likes AS R ON L.page_id = R.page_id
WHERE
    R.liked_date IS NULL
ORDER BY page_id
;


-- frequently-purchased-pairs
SELECT
  COUNT(DISTINCT(product_pairs))
FROM (
SELECT 
  transaction_id, 
  ARRAY_AGG(product_id) AS product_pairs
FROM 
  transactions
GROUP BY transaction_id
) BASE
WHERE
  ARRAY_LENGTH(product_pairs,1) > 1
;

-- supercloud-customer 
WITH cat_combos AS (
SELECT
  L.customer_id,
  R.product_category
FROM 
  customer_contracts AS L
LEFT JOIN
  products AS R
ON
  L.product_id = R.product_id
GROUP BY 1, 2
)
SELECT 
  customer_id
FROM (
  SELECT 
    customer_id,
    COUNT(1) AS category_ct
  FROM
    cat_combos
  GROUP BY 1
  HAVING COUNT(1)  = (SELECT COUNT(DISTINCT(product_category)) FROM products)
) base;



-- spent-snaps

SELECT
  R.age_bucket,
  ROUND(100 * SUM(CASE WHEN L.activity_type = 'send' 
                       THEN L.time_spent 
                       ELSE 0 END) / SUM(time_spent), 2) AS send_perc,
  ROUND(100 * SUM(CASE WHEN L.activity_type = 'open' 
                      THEN L.time_spent 
                      ELSE 0 END) / SUM(time_spent), 2) AS open_prec
FROM 
  activities AS L   
JOIN 
  age_breakdown AS R   
ON
  L.user_id = R.user_id
WHERE
  L.activity_type IN ('open', 'send')
GROUP BY 1
;


-- third-transaction
SELECT
  user_id,
  spend,
  transaction_date
FROM (
SELECT
  user_id,
  spend,
  transaction_date,
  ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date ASC) AS trans_rank
FROM 
  transactions
) base
WHERE
  base.trans_rank = 3
;


-- repeated-payments 

WITH crossjoin AS ( 
    SELECT
        L.merchant_id,
        L.credit_card_id,
        L.amount,
        ABS(TIMESTAMPDIFF(
            MINUTE,
            R.transaction_timestamp,
            L.transaction_timestamp
        )) AS diff
    FROM transactions AS L
    LEFT JOIN transactions AS R
        ON L.merchant_id = R.merchant_id
        AND L.credit_card_id = R.credit_card_id
        AND L.amount = R.amount
)
SELECT 
    COUNT(1) AS payment_count
FROM (
    SELECT
        merchant_id,
        credit_card_id,
        amount,
        ROW_NUMBER() OVER (
            PARTITION BY merchant_id, credit_card_id, amount, diff
            ORDER BY diff ASC
        ) AS txn_num
    FROM crossjoin
    WHERE diff > 0      -- exclude same transaction
      AND diff < 10     -- within 10 minutes
) AS base
WHERE txn_num != 1;



-- alibaba-compressed-mode
SELECT
  item_count 
FROM (
  SELECT
    item_count,
    DENSE_RANK() OVER(ORDER BY order_occurrences DESC) AS rnk 
  FROM 
    items_per_order
) BASE
WHERE rnk = 1
ORDER BY 1
;


-- RicherThanUK.
SELECT name 
FROM world
WHERE continent LIKE 'Europe'
AND gdp / population > 
(SELECT gdp / population 
 FROM world
 WHERE name LIKE 'United Kingdom');


-- TeamsThatHaveCoach
SELECT game.mdate, eteam.teamname
FROM game 
JOIN eteam
ON game.team1 = eteam.id
WHERE eteam.coach like 'Fernando Santos';


-- Neighbors Of Argentina And Australia 
SELECT name, continent 
FROM world
WHERE continent LIKE
(SELECT continent FROM world WHERE name LIKE 'Argentina')
OR
continent LIKE
(SELECT continent FROM world WHERE name LIKE 'Australia')
ORDER BY name; 

-- Busy Years John Travolta
SELECT yr,COUNT(title) 
FROM movie 
JOIN casting 
	ON movie.id=movieid
JOIN actor 
	ON actorid=actor.id
where name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=
(SELECT MAX(c) 
 FROM
	(SELECT yr,COUNT(title) AS c 
	 FROM movie 
	 JOIN casting 
	 ON movie.id=movieid
	 JOIN actor
	 ON actorid=actor.id
 WHERE name='John Travolta'
 GROUP BY yr) AS t
);


-- Bigger Than Europe
SELECT name 
FROM world
WHERE gdp > 
	  (SELECT 
	   MAX(gdp) 
	   FROM world 
	   WHERE continent LIKE 'Europe');



 -- NthHighestSalary
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      SELECT 
        Salary
      FROM (
      SELECT 
        Salary,
        DENSE_RANK() OVER(ORDER BY Salary DESC) AS rnk
      FROM Employee
      ) base
      WHERE rnk = N
      GROUP BY 1 ;
	
      
