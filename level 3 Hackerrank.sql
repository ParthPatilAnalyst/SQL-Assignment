-- Problem	: Revising the Select Query I
-- 	Task: Retrieve all columns for American cities from the CITY table where the population is greater than 100,000. The CountryCode for America is USA
-- Solution 
		SELECT *  FROM CITY  
		WHERE COUNTRYCODE = 'USA'  
		AND POPULATION > 100000;
        
        
        
        
-- 🔹② Problem: Revising the Select Query II
-- 	Task: Retrieve only the city names (NAME field) for American cities with a population greater than 120,000. The CountryCode for America is USA.
-- 	Solution 
		SELECT NAME FROM CITY  
		WHERE COUNTRYCODE = 'USA'  
		AND POPULATION > 120000;



-- 🔹① Problem	: Select All 
-- 	Task:Query all columns (attributes) for every row in the CITY table.
-- 	Solution 
		SELECT *  FROM CITY ;




-- 🔹② Problem: Select By ID
-- 	Task: Query all columns for a city in CITY with the ID 1661.
-- 	Solution 
		SELECT NAME FROM CITY  
		WHERE ID = 1661;
        
        
        
-- 🔹① Problem	: Japanese Cities Attributes
-- 	Task: Query all columns (attributes) of every Japanese city in the CITY table. COUNTRYCODE for Japan is JPN.
-- 	Solution 
		SELECT *  FROM CITY 
		WHERE COUNTRYCODE = 'JPN';
        
        
        
-- 🔹② Problem: Japanese Cities Names
-- 	Task: Query the names of all the Japanese cities in the CITY table.COUNTRYCODE for Japan is JPN.
-- 	Solution 
		SELECT NAME FROM CITY  
		WHERE COUNTRYCODE = 'JPN';
        
        
        
        
-- 🔹① Problem	: Weather Observation Station 1
-- 	Task: Query a list of CITY and STATE from the STATION table
-- 	Solution 
		SELECT CITY, STATE  FROM CITY;
        
        

-- 👉Problem:: Weather Observation Station 3
-- Query a list of CITY names from STATION for cities that have an even ID number. Print the results in any order, but exclude duplicates from the answer.
-- 📰SOLUTION:

SELECT DISTINCT city from station 
WHERE MOD(ID, 2)=0;



-- 🔹① Problem	: Weather Observation Station 4
-- 	Task: Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.
-- 	Solution 
		SELECT COUNT(CITY)-COUNT(DISTINCT CITY) FROM CITY ;
        
        

-- 🔹① Problem: Weather Observation Station 5
-- 	Task: Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths 
-- 	(i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically..
-- 	Solution 
	-- Query for the city with the shortest name and its length
		SELECT CITY, LENGTH(CITY)
		FROM STATION
		ORDER BY LENGTH(CITY), CITY
		LIMIT 1;
  
  

--   🔹① Problem: Weather Observation Station 6
-- 	Task: Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates
-- 	A)Solution-Using like operator

		SELECT CITY FROM STATION
		WHERE 
			CITY LIKE 'a%' OR
			CITY LIKE 'e%' OR
			CITY LIKE 'i%' OR
			CITY LIKE 'o%' OR
			CITY LIKE 'u%' ;
	
    
    
-- 👉Problem:: Weather Observation Station 7
-- 	Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.
-- 📰SOLUTION:
	SELECT DISTINCT CITY FROM STATION 
	WHERE RIGHT(city,1) IN ('a','e','i','o','u');
    
    
    
-- 🔹① Problem8	: Weather Observation Station 8	
-- 	Task: Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. 
-- 		Your result cannot contain duplicates.
		SELECT DISTINCT CITY FROM STATION 
		WHERE 
  			(CITY LIKE 'a%' OR CITY LIKE 'e%' OR CITY LIKE 'i%' OR CITY LIKE 'o%' OR CITY LIKE 'u%')
   		 AND 
    			(CITY LIKE '%a' OR CITY LIKE '%e' OR CITY LIKE '%i' OR CITY LIKE '%o' OR CITY LIKE '%u');


-- 🔹① Problem: Weather Observation Station 9
-- Task: Query the list of CITY names from STATION that do not start with vowels. 
-- Your result cannot contain duplicates.
		SELECT DISTINCT CITY
		FROM STATION
		WHERE CITY NOT LIKE 'A%'
		AND CITY NOT LIKE 'E%'
		AND CITY NOT LIKE 'I%'
		AND CITY NOT LIKE 'O%'
		AND CITY NOT LIKE 'U%';
        
        
        
	
-- 🔹① Problem: Weather Observation Station 10
-- Task: Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.
		SELECT DISTINCT CITY
		FROM STATION
		WHERE CITY NOT LIKE '%A'
		AND CITY NOT LIKE '%E'
		AND CITY NOT LIKE '%I'
		AND CITY NOT LIKE '%O'
		AND CITY NOT LIKE '%U';
        
        
        
-- 🔹① Problem: Weather Observation Station 11
-- Task: Query the list of CITY names from STATION that Either Do Not Start or Do Not End with Vowels that do not start with vowels. 
-- Your result cannot contain duplicates.
		SELECT DISTINCT CITY
		FROM STATION
		WHERE LEFT(CITY, 1) NOT IN ('A', 'E', 'I', 'O', 'U')
		OR RIGHT(CITY, 1) NOT IN ('A', 'E', 'I', 'O', 'U');
        
        
        
-- 🔹① Problem: Weather Observation Station 12
-- Task: Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. Your result cannot contain duplicates.
		SELECT DISTINCT CITY
		FROM STATION
		WHERE LEFT(CITY, 1) NOT IN ('A', 'E', 'I', 'O', 'U')
		   AND RIGHT(CITY, 1) NOT IN ('A', 'E', 'I', 'O', 'U');
           
           
           
-- 🔹① Problem: Higher than 75 marks
-- Task: Query the Name of any student in STUDENTS who scored higher than  75 Marks. 
-- Order your output by the last three characters of each name. If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.
SELECT NAME
FROM STUDENTS
WHERE MARKS > 75
ORDER BY RIGHT(NAME, 3) ASC, ID ASC;



-- 🔹① Problem: Employee Names
-- Task: Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.
SELECT Name
FROM Employee
ORDER BY Name ASC;




-- 🔹① Problem: Employee Salaries	
-- Task: Write a query that prints a list of employee names (i.e.: the name attribute) for employees in Employee 
-- having a salary greater than 2000 per month who have been employees for less than  10 months. Sort your result by ascending employee_id. 
SELECT Name
FROM Employee
WHERE Salary > 2000 AND Months < 10
ORDER BY Employee_id ASC;



-- 🔹① Problem: Type of triangle 
SELECT A, B, C,
       CASE 
           WHEN A + B <= C OR A + C <= B OR B + C <= A THEN 'Not A Triangle'
           WHEN A = B AND B = C THEN 'Equilateral'
           WHEN A = B OR B = C OR A = C THEN 'Isosceles'
           ELSE 'Scalene'
       END AS Triangle_Type
FROM TRIANGLES;



-- 🔹① Problem: The PADS
SELECT CONCAT (NAME,'(',LEFT(OCCUPATION,1),')') FROM OCCUPATIONS 
ORDER BY NAME;



-- 🔹① Problem: Occupations
-- SOLUTION
SELECT 
    MAX(CASE WHEN OCCUPATION = 'Doctor' THEN NAME END) AS Doctor,
    MAX(CASE WHEN OCCUPATION = 'Professor' THEN NAME END) AS Professor,
    MAX(CASE WHEN OCCUPATION = 'Singer' THEN NAME END) AS Singer,
    MAX(CASE WHEN OCCUPATION = 'Actor' THEN NAME END) AS Actor
FROM (
    SELECT NAME, OCCUPATION,
           ROW_NUMBER() OVER (PARTITION BY OCCUPATION ORDER BY NAME) as rn
    FROM OCCUPATIONS
) AS Ranked
GROUP BY rn
ORDER BY rn;



-- 🔹① Problem: Binary Tree Nodes
SELECT N,
       CASE 
           WHEN P IS NULL THEN 'Root'
           WHEN N IN (SELECT DISTINCT P FROM BST WHERE P IS NOT NULL) THEN 'Inner'
           ELSE 'Leaf'
       END AS Type
FROM BST
ORDER BY N;



-- 👉Problem: New Companies
SELECT 
    c.company_code, 
    c.founder, 
    COUNT(DISTINCT lm.lead_manager_code) AS total_lead_managers,
    COUNT(DISTINCT sm.senior_manager_code) AS total_senior_managers,
    COUNT(DISTINCT m.manager_code) AS total_managers,
    COUNT(DISTINCT e.employee_code) AS total_employees
FROM Company c
LEFT JOIN Lead_Manager lm ON c.company_code = lm.company_code
LEFT JOIN Senior_Manager sm ON c.company_code = sm.company_code
LEFT JOIN Manager m ON c.company_code = m.company_code
LEFT JOIN Employee e ON c.company_code = e.company_code
GROUP BY c.company_code, c.founder
ORDER BY c.company_code;




-- 👉Problem: Revising Aggregations - The Count Function
-- 👉SOLUTION
SELECT COUNT(*) AS City_Count
FROM CITY
WHERE Population > 100000;




-- 👉Problem: Revising Aggregations - The Sum Function
-- Query the total population of all cities in CITY where District is California.
-- 👉SOLUTION: 
SELECT SUM(Population) AS Total_California_Population
FROM CITY
WHERE District = 'California';




-- 👉Problem: Revising Aggregations - Averages
-- Query the average population of all cities in CITY where District is California.
-- 👉SOLUTION: 
SELECT AVG(Population) AS Average_California_Population
FROM CITY
WHERE District = 'California';



-- 👉Problem: Average Population
-- Query the average population for all cities in CITY, rounded down to the nearest integer.
-- 👉SOLUTION: 
SELECT FLOOR (AVG(Population)) FROM CITY ;


-- 👉Problem: Japan Population
-- Query the sum of the populations for all Japanese cities in CITY. The COUNTRYCODE for Japan is JPN.
-- 👉SOLUTION: 
SELECT SUM(Population) FROM CITY
WHERE COUNTRYCODE='JPN' ;



-- 👉Problem: Population Density Difference
SELECT MAX(Population)-MIN(Population) as diff FROM CITY;




-- 👉Problem: The blunder
SELECT 
    CEIL(
        AVG(SALARY) - 
        AVG(REPLACE(SALARY, '0', ''))
    ) AS salary_error
FROM EMPLOYEES;




-- 👉Problem: Top Earners
WITH temp AS (
    SELECT (months * salary) AS earnings
    FROM Employee
)
SELECT MAX(earnings), COUNT(*)
FROM temp
WHERE earnings = (SELECT MAX(earnings) FROM temp);





-- 👉Problem: Weather Observation Station 2
SELECT 
    ROUND(SUM(LAT_N), 2) AS total_latitude,
    ROUND(SUM(LONG_W), 2) AS total_longitude
FROM STATION;




-- 👉Problem 1: Weather Observation Station 2
SELECT 
    ROUND(SUM(LAT_N),2) AS LAT,
    ROUND(SUM(LONG_W),2) AS LON
FROM STATION




-- 👉Problem: Weather Observation Station 18
SELECT 
    ROUND(
        ABS(MIN(LAT_N) - MAX(LAT_N)) + 
        ABS(MIN(LONG_W) - MAX(LONG_W)), 
    4) AS manhattan_distance
FROM 
    STATION;
    
    
    
-- 👉Problem: Weather Observation Station 19
SELECT 
    ROUND(SQRT(
        POWER(MAX(LAT_N) - MIN(LAT_N), 2) + 
        POWER(MAX(LONG_W) - MIN(LONG_W), 2)
    ), 4) AS euclidean_distance
FROM STATION;




-- 👉Problem: Weather Observation Station 20
SELECT 
    ROUND(AVG(LAT_N), 4) AS median_lat
FROM (
    SELECT LAT_N,
           ROW_NUMBER() OVER (ORDER BY LAT_N) AS rn,
           COUNT(*) OVER () AS total
    FROM STATION
) AS ordered
WHERE rn IN (FLOOR((total + 1) / 2), CEIL((total + 1) / 2));






-- 👉Problem 1️⃣: Population Census
SELECT 
    SUM(c.POPULATION) AS total_population
FROM 
    CITY c
JOIN 
    COUNTRY co
ON 
    c.COUNTRYCODE = co.CODE
WHERE 
    co.CONTINENT = 'Asia';




-- 👉Problem:- Top competitors 
SELECT s.hacker_id, h.name
FROM Submissions s
JOIN Challenges c ON s.challenge_id = c.challenge_id
JOIN Difficulty d ON c.difficulty_level = d.difficulty_level
JOIN Hackers h ON s.hacker_id = h.hacker_id
WHERE s.score = d.score
GROUP BY s.hacker_id, h.name
HAVING COUNT(DISTINCT s.challenge_id) > 1
ORDER BY COUNT(DISTINCT s.challenge_id) DESC, s.hacker_id;




-- 👉Problem 1️⃣:The Report
with cte1 as(
select 
    s.name,
    G.grade, 
    S.marks 
FROM students AS S
JOIN grades AS G ON S.marks BETWEEN G.min_mark AND G.max_mark
),
cte2 as(
select 
    case when grade>=8 then name else null end as name ,
    grade, 
    marks 
from cte1
)
select 
    name, grade, marks 
from cte2 
ORDER BY 
    Grade DESC,
    CASE  WHEN Grade >= 8 THEN Name ELSE NULl END ASC,
    CASE  WHEN Grade < 8 THEN Marks ELSE NULL END ASC;
   
   
   
    
-- 👉Problem 1️⃣: Ollivander's Inventory
SELECT w.id, wp.age, w.coins_needed, w.power
FROM Wands w
JOIN Wands_Property wp ON w.code = wp.code
WHERE wp.is_evil = 0
  AND w.coins_needed = (
      SELECT MIN(w2.coins_needed)
      FROM Wands w2
      WHERE w2.code = w.code AND w2.power = w.power
  )
ORDER BY w.power DESC, wp.age DESC;




-- 👉Problem 1️⃣: Challenges
WITH challenge_counts AS (
    SELECT
        c.hacker_id,
        h.name,
        COUNT(*) AS challenges_created
    FROM
        Challenges c
    JOIN Hackers h ON c.hacker_id = h.hacker_id
    GROUP BY
        c.hacker_id, h.name
),
filtered_counts AS (
    SELECT
        hacker_id,
        name,
        challenges_created
    FROM
        challenge_counts
    WHERE
        challenges_created = 
            (SELECT MAX(challenges_created) AS max_created
             FROM challenge_counts)
    
        OR challenges_created IN (
            SELECT challenges_created
            FROM challenge_counts
            GROUP BY challenges_created
            HAVING COUNT(*) = 1
        )
)
SELECT
    hacker_id,
    name,
    challenges_created
FROM
    filtered_counts
ORDER BY
    challenges_created DESC,
    hacker_id;




-- 👉Problem 1️⃣: Contest Leaderboard
WITH MaxScores AS (
    SELECT 
        hacker_id, 
        challenge_id, 
        MAX(score) AS max_score
    FROM Submissions
    GROUP BY hacker_id, challenge_id
),
TotalScores AS (
    SELECT 
        h.hacker_id, 
        h.name, 
        SUM(ms.max_score) AS total_score
    FROM  Hackers h
    JOIN MaxScores ms 
        ON h.hacker_id = ms.hacker_id
    GROUP BY h.hacker_id, h.name
)
SELECT 
    hacker_id, 
    name, 
    total_score
FROM TotalScores
WHERE total_score > 0
ORDER BY total_score DESC, hacker_id ASC;


-- 👉Problem 1️⃣: SQL PROJECT PLANNING
WITH OrderedProjects AS (
    SELECT *,
        ROW_NUMBER() OVER (ORDER BY Start_Date) AS rn
    FROM Projects
),
GroupedProjects AS (
    SELECT *,
        DATEADD(DAY, -rn, Start_Date) AS grp
    FROM OrderedProjects
)
SELECT 
    MIN(Start_Date) AS Start_Date,
    MAX(End_Date) AS End_Date
FROM GroupedProjects
GROUP BY grp
ORDER BY 
    DATEDIFF(DAY, MIN(Start_Date), MAX(End_Date)),  
    MIN(Start_Date);
    
    
    
-- 👉Problem 1️⃣: Placements
with temp1 as (
select 
    s.id, 
    s.name, 
    f.friend_id    
from students as s 
join friends as f on s.id=f.id
),

temp2 as(
select 
    t1.id,
    t1.name, 
    t1.friend_id, 
    p1.salary as student_salary, 
    p2.salary as friend_salary
from temp1 as t1
join packages as p1 on t1.id = p1.id
join packages as p2 on t1.friend_id = p2.id
)
select 
    name
from temp2
where friend_salary > student_salary
order by friend_salary;



-- 👉Problem:: Symmetric Pairs
SELECT 
    f1.x,f1.y FROM functions as f1 
JOIN functions as f2
ON f1.x=f2.y and f2.x=f1.y 
GROUP BY f1.x,f1.y 
HAVING COUNT(f1.x)>1 OR f1.X<f1.Y ORDER BY f1.x 



-- 👉Problem:: Interviews
WITH ViewAgg AS (
    SELECT challenge_id,
           SUM(total_views) AS total_views,
           SUM(total_unique_views) AS total_unique_views
    FROM View_Stats
    GROUP BY challenge_id
),
SubmissionAgg AS (
    SELECT challenge_id,
           SUM(total_submissions) AS total_submissions,
           SUM(total_accepted_submissions) AS total_accepted_submissions
    FROM Submission_Stats
    GROUP BY challenge_id
)
SELECT c.contest_id,
       c.hacker_id,
       c.name,
       SUM(s.total_submissions) AS total_submissions,
       SUM(s.total_accepted_submissions) AS total_accepted_submissions,
       SUM(v.total_views) AS total_views,
       SUM(v.total_unique_views) AS total_unique_views
FROM Contests c
JOIN Colleges col ON c.contest_id = col.contest_id
JOIN Challenges ch ON col.college_id = ch.college_id
LEFT JOIN ViewAgg v ON ch.challenge_id = v.challenge_id
LEFT JOIN SubmissionAgg s ON ch.challenge_id = s.challenge_id
GROUP BY c.contest_id, c.hacker_id, c.name
HAVING 
    (SUM(s.total_submissions) +
    SUM(s.total_accepted_submissions) +
    SUM(total_views) +
    SUM(v.total_unique_views)) > 0
ORDER BY c.contest_id;





-- 👉Problem:: Interviews
-- Step 1: Get all contest dates
WITH all_dates AS (
    SELECT DISTINCT submission_date
    FROM Submissions
),

-- Step 2: Map which hacker submitted on which date
hacker_days AS (
    SELECT DISTINCT submission_date, hacker_id
    FROM Submissions
),

-- Step 3: For each hacker and each date, check if they submitted on all dates up to that day
cumulative_hackers AS (
    SELECT d.submission_date, h.hacker_id
    FROM all_dates d
    CROSS JOIN (
        SELECT DISTINCT hacker_id FROM hacker_days
    ) h
    WHERE NOT EXISTS (
        SELECT 1
        FROM all_dates d2
        WHERE d2.submission_date <= d.submission_date
        AND NOT EXISTS (
            SELECT 1
            FROM hacker_days hd
            WHERE hd.submission_date = d2.submission_date
              AND hd.hacker_id = h.hacker_id
        )
    )
),

-- Step 4: Count daily submissions & Rank hackers per day by number of submission 
ranked_hackers AS (
    SELECT 
        submission_date,
        hacker_id,
        COUNT(*) AS submission_count,
        RANK() OVER (
            PARTITION BY submission_date 
            ORDER BY COUNT(*) DESC, hacker_id ASC
        ) AS rnk
    FROM Submissions
    GROUP BY submission_date, hacker_id
),

-- Step 5: Pick the top hacker for each day
top_hacker_per_day AS (
    SELECT submission_date, hacker_id
    FROM ranked_hackers
    WHERE rnk = 1
)
-- Step 6: Final result
SELECT 
    ch.submission_date,
    COUNT(DISTINCT ch.hacker_id) AS total_hackers,
    th.hacker_id,
    h.name
FROM cumulative_hackers ch
JOIN top_hacker_per_day th
    ON ch.submission_date = th.submission_date
JOIN Hackers h
    ON th.hacker_id = h.hacker_id
GROUP BY ch.submission_date, th.hacker_id, h.name
ORDER BY ch.submission_date;




-- 👉Problem:: Print Prime Numbers
WITH RECURSIVE temp AS (
    SELECT 2 AS n
    UNION ALL 
    SELECT n + 1 FROM temp 
    WHERE n + 1 <= 1000
),
prime AS (
    SELECT n FROM temp 
    WHERE NOT EXISTS (
        SELECT 1 FROM temp AS d
        WHERE d.n > 1 AND d.n < temp.n AND temp.n % d.n = 0
    )
)
SELECT GROUP_CONCAT(n SEPARATOR '&') AS prime_numbers FROM prime;





-- 👉Problem:: Draw The Triangle 1 
WITH RECURSIVE temp AS (
    SELECT 20 as n
    UNION ALL
    SELECT n - 1 FROM temp
    WHERE n > 1
)
SELECT REPEAT('* ', n) AS pattern
FROM temp;



-- 👉Problem:: Draw The Triangle 2 
WITH RECURSIVE temp AS (
    SELECT 1 as n
    UNION ALL
    SELECT n + 1 FROM temp
    WHERE n < 20
)
SELECT REPEAT('* ', n) AS pattern
FROM temp;
-- -- -- 
