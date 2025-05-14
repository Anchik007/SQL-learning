Easy Tasks

1. Write a SQL query to split the Name column by a comma into two separate columns: Name and Surname.(TestMultipleColumns)
SELECT
    LTRIM(RTRIM(PARSENAME(REPLACE(Name, ',', '.'), 2))) AS Name,
    LTRIM(RTRIM(PARSENAME(REPLACE(Name, ',', '.'), 1))) AS Surname
FROM TestMultipleColumns;
2. Write a SQL query to find strings from a table where the string itself contains the % character.(TestPercent)
SELECT *
FROM TestPercent
WHERE ColumnName LIKE '%[%]%';
3. In this puzzle you will have to split a string based on dot(.).(Splitter)
SELECT
    value,
    PARSENAME(REPLACE(value, '.', '#'), 3) AS Part1,
    PARSENAME(REPLACE(value, '.', '#'), 2) AS Part2,
    PARSENAME(REPLACE(value, '.', '#'), 1) AS Part3
FROM Splitter;
4. Write a SQL query to replace all integers (digits) in the string with 'X'.(1234ABC123456XYZ1234567890ADS)
DECLARE @str VARCHAR(MAX) = '1234ABC123456XYZ1234567890ADS';

SELECT 
    @str AS Original,
    TRANSLATE(@str, '0123456789', REPLICATE('X', 10)) AS Replaced;
5. Write a SQL query to return all rows where the value in the Vals column contains more than two dots (.).(testDots)
SELECT *
FROM testDots
WHERE LEN(ColumnName) - LEN(REPLACE(ColumnName, '.', '')) > 2;
6. Write a SQL query to count the spaces present in the string.(CountSpaces)
SELECT *,
    LEN(ColumnName) - LEN(REPLACE(ColumnName, ' ', '')) AS SpaceCount
FROM CountSpaces;
7. write a SQL query that finds out employees who earn more than their managers.(Employee)
SELECT E.*
FROM Employee E
JOIN Employee M ON E.ManagerId = M.Id
WHERE E.Salary > M.Salary;
8. Find the employees who have been with the company for more than 10 years, but less than 15 years. Display their Employee ID, First Name, Last Name, Hire Date, and the Years of Service (calculated as the number of years between the current date and the hire date).(Employees)
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    HireDate,
    DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsOfService
FROM Employees
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 11 AND 14;

Medium Tasks

1. Write a SQL query to separate the integer values and the character values into two different columns.(rtcfvty34redt)
SELECT
    val,
    LEFT(val, PATINDEX('%[0-9]%', val) - 1) AS Characters,
    SUBSTRING(val, PATINDEX('%[0-9]%', val), LEN(val)) AS Integers
FROM your_table;
DECLARE @val VARCHAR(100) = 'rtcfvty34redt';

SELECT
    @val AS Original,
    LEFT(@val, PATINDEX('%[0-9]%', @val) - 1) AS Characters,
    SUBSTRING(@val, PATINDEX('%[0-9]%', @val), LEN(@val)) AS Integers;
2. write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.(weather)
SELECT w1.id
FROM weather w1
JOIN weather w2
  ON DATEDIFF(DAY, w2.recordDate, w1.recordDate) = 1
WHERE w1.temperature > w2.temperature;
3. Write an SQL query that reports the first login date for each player.(Activity)
SELECT 
    player_id,
    MIN(login_date) AS FirstLogin
FROM Activity
GROUP BY player_id;
4. Your task is to return the third item from that list.(fruits)
SELECT fruit
FROM (
    SELECT fruit, ROW_NUMBER() OVER (ORDER BY fruit) AS rn
    FROM fruits
) AS ranked
WHERE rn = 3;
5. Write a SQL query to create a table where each character from the string will be converted into a row.(sdgfhsdgfhs@121313131)
WITH nums AS (
    SELECT TOP (LEN('sdgfhsdgfhs@121313131')) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects
)
SELECT 
    SUBSTRING('sdgfhsdgfhs@121313131', n, 1) AS Character
FROM nums;
6. You are given two tables: p1 and p2. Join these tables on the id column. The catch is: when the value of p1.code is 0, replace it with the value of p2.code.(p1,p2)
SELECT 
    p1.id,
    CASE 
        WHEN p1.code = 0 THEN p2.code 
        ELSE p1.code 
    END AS final_code
FROM p1
JOIN p2 ON p1.id = p2.id;
7. Write an SQL query to determine the Employment Stage for each employee based on their HIRE_DATE. The stages are defined as follows:
If the employee has worked for less than 1 year → 'New Hire'
If the employee has worked for 1 to 5 years → 'Junior'
If the employee has worked for 5 to 10 years → 'Mid-Level'
If the employee has worked for 10 to 20 years → 'Senior'
If the employee has worked for more than 20 years → 'Veteran'(Employees)
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    HIRE_DATE,
    DATEDIFF(YEAR, HIRE_DATE, GETDATE()) AS YearsWorked,
    CASE 
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 1 THEN 'New Hire'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 1 AND 5 THEN 'Junior'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 6 AND 10 THEN 'Mid-Level'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 11 AND 20 THEN 'Senior'
        ELSE 'Veteran'
    END AS EmploymentStage
FROM Employees;

8. Write a SQL query to extract the integer value that appears at the start of the string in a column named Vals.(GetIntegers)
SELECT 
    Vals,
    LEFT(Vals, PATINDEX('%[^0-9]%', Vals + 'X') - 1) AS StartingInteger
FROM GetIntegers
WHERE Vals LIKE '[0-9]%';
Difficult Tasks
1. In this puzzle you have to swap the first two letters of the comma separated string.(MultipleVals)
WITH SplitChars AS (
    SELECT 
        id,
        value,
        LEFT(value, 1) AS FirstChar,
        SUBSTRING(value, 2, 1) AS SecondChar,
        STUFF(value, 1, 2, SUBSTRING(value, 2, 1) + LEFT(value, 1)) AS Swapped
    FROM (
        SELECT id, 
               TRIM(value) AS value
        FROM MultipleVals
        CROSS APPLY STRING_SPLIT(val, ',')
    ) AS split
),
Recombined AS (
    SELECT id,
           STRING_AGG(Swapped, ',') AS SwappedString
    FROM SplitChars
    GROUP BY id
)
SELECT * FROM Recombined;
2. Write a SQL query that reports the device that is first logged in for each player.(Activity)
WITH Ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY login_date) AS rn
    FROM Activity
)
SELECT player_id, device_id AS FirstDevice
FROM Ranked
WHERE rn = 1;
3. You are given a sales table. Calculate the week-on-week percentage of sales per area for each financial week. For each week, the total sales will be considered 100%, and the percentage sales for each day of the week should be calculated based on the area sales for that week.(WeekPercentagePuzzle)
WITH SalesWithWeek AS (
    SELECT 
        area,
        sale_date,
        amount,
        DATEPART(ISO_WEEK, sale_date) AS week_number,
        DATEPART(YEAR, sale_date) AS year
    FROM Sales
),
WeeklyAreaSales AS (
    SELECT 
        year,
        week_number,
        area,
        SUM(amount) AS area_weekly_sales
    FROM SalesWithWeek
    GROUP BY year, week_number, area
),
WeeklyTotalSales AS (
    SELECT 
        year,
        week_number,
        SUM(amount) AS total_weekly_sales
    FROM SalesWithWeek
    GROUP BY year, week_number
),
PercentageSales AS (
    SELECT 
        w.year,
        w.week_number,
        w.area,
        w.area_weekly_sales,
        t.total_weekly_sales,
        CAST(w.area_weekly_sales * 100.0 / t.total_weekly_sales AS DECIMAL(5, 2)) AS percentage
    FROM WeeklyAreaSales w
    JOIN WeeklyTotalSales t 
      ON w.year = t.year AND w.week_number = t.week_number
)
SELECT * FROM PercentageSales
ORDER BY year, week_number, area;
