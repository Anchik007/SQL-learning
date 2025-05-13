Easy Tasks
1. You need to write a query that outputs "100-Steven King", meaning emp_id + first_name + last_name in that format using employees table.
SELECT 
    CONCAT(employee_id, '-', first_name, ' ', last_name) AS result
FROM 
    employees
WHERE 
    employee_id = 100;
	SELECT 
    CAST(employee_id AS VARCHAR) + '-' + first_name + ' ' + last_name AS result
FROM 
    employees
WHERE 
    employee_id = 100;

2. Update the portion of the phone_number in the employees table, within the phone number the substring '124' will be replaced by '999'

Update employees set phone_number = replace(phone_number, '124', '999') where phone_number like '%124%'


3. That displays the first name and the length of the first name for all employees whose name starts with the letters 'A', 'J' or 'M'. Give each column an appropriate label. Sort the results by the employees' first names.(Employees)
SELECT 
    first_name AS [First Name],
    LEN(first_name) AS [Name Length]
FROM 
    employees
WHERE 
    first_name LIKE 'A%' OR 
    first_name LIKE 'J%' OR 
    first_name LIKE 'M%'
ORDER BY 
    first_name;

4. Write an SQL query to find the total salary for each manager ID.(Employees table)
SELECT 
    manager_id AS [Manager ID],
    SUM(salary) AS [Total Salary]
FROM 
    employees
GROUP BY 
    manager_id;

5. Write a query to retrieve the year and the highest value from the columns Max1, Max2, and Max3 for each row in the TestMax table
SELECT 
    year1,
    MaxValue
FROM 
    TestMax
CROSS APPLY (
    SELECT MAX(v) AS MaxValue
    FROM (VALUES (Max1), (Max2), (Max3)) AS value_table(v)
) AS max_result;

6. Find me odd numbered movies and description is not boring.(cinema)
SELECT *
FROM cinema
WHERE id % 2 = 1
  AND description != 'boring';

7. You have to sort data based on the Id but Id with 0 should always be the last row. Now the question is can you do that with a single order by column.(SingleOrder)
SELECT *
FROM SingleOrder
ORDER BY (CASE WHEN id = 0 THEN 1 ELSE 0 END), id;
8. Write an SQL query to select the first non-null value from a set of columns. If the first column is null, move to the next, and so on. If all columns are null, return null.(person)
SELECT 
    COALESCE(phone, email, address) AS FirstNonNullContact
FROM   person;
1. Split column FullName into 3 part ( Firstname, Middlename, and Lastname).(Students Table)
SELECT
    FullName,
    PARSENAME(REPLACE(FullName, ' ', '.'), 3) AS FirstName,
    PARSENAME(REPLACE(FullName, ' ', '.'), 2) AS MiddleName,
    PARSENAME(REPLACE(FullName, ' ', '.'), 1) AS LastName
FROM 
    Students;
2. For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas. (Orders Table)
Medium 
SELECT *
FROM Orders
WHERE 
    customer_id IN (
        SELECT customer_id
        FROM Orders
        WHERE delivery_state = 'California'
    )
    AND delivery_state = 'Texas';
3.Write an SQL statement that can group concatenate the following values.(DMLTable)
SELECT 
    GroupID,
    STRING_AGG(ValueColumn, ', ') AS ConcatenatedValues
FROM 
    DMLTable
GROUP BY 
    GroupID;
4.Find all employees whose names (concatenated first and last) contain the letter "a" at least 3 times.
SELECT *
FROM Employees
WHERE LEN(REPLACE(LOWER(first_name + last_name), 'a', '')) <= 
      LEN(LOWER(first_name + last_name)) - 3;
5.The total number of employees in each department and the percentage of those employees who have been with the company for more than 3 years(Employees)
SELECT 
    department_id,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN DATEDIFF(YEAR, hire_date, GETDATE()) > 3 THEN 1 ELSE 0 END) AS Over3Years,
    CAST(SUM(CASE WHEN DATEDIFF(YEAR, hire_date, GETDATE()) > 3 THEN 1 ELSE 0 END) * 100.0 
         / COUNT(*) AS DECIMAL(5,2)) AS PercentageOver3Years
FROM 
    Employees
GROUP BY 
    department_id;
6. Write an SQL statement that determines the most and least experienced Spaceman ID by their job description.(Personal)
SELECT 
    job_description,
    MIN_BY(spaceman_id, experience_years) AS LeastExperiencedID,
    MAX_BY(spaceman_id, experience_years) AS MostExperiencedID
FROM Personal
GROUP BY job_description;

Difficult task
1. Write an SQL query that separates the uppercase letters, lowercase letters, numbers, and other characters from the given string 'tf56sd#%OqH' into separate columns.
WITH Numbers AS (
    SELECT TOP (LEN('tf56sd#%OqH')) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects -- large system table to generate rows
),
Chars AS (
    SELECT 
        SUBSTRING('tf56sd#%OqH', n, 1) AS ch
    FROM Numbers
)
SELECT 
    STRING_AGG(CASE WHEN ch COLLATE Latin1_General_BIN LIKE '[A-Z]' THEN ch END, '') AS Uppercase,
    STRING_AGG(CASE WHEN ch COLLATE Latin1_General_BIN LIKE '[a-z]' THEN ch END, '') AS Lowercase,
    STRING_AGG(CASE WHEN ch LIKE '[0-9]' THEN ch END, '') AS Numbers,
    STRING_AGG(CASE WHEN ch NOT LIKE '[a-zA-Z0-9]' THEN ch END, '') AS SpecialChars
FROM Chars;

2. Write an SQL query that replaces each row with the sum of its value and the previous rows' value. (Students table)
SELECT 
    student_id,
    student_name,
    marks,
    SUM(marks) OVER (ORDER BY student_id) AS RunningTotal
FROM 
    Students;

3. You are given the following table, which contains a VARCHAR column that contains mathematical equations. Sum the equations and provide the answers in the output.(Equations)
CREATE TABLE Equations (
    id INT,
    equation VARCHAR(100)
);
DECLARE @equation NVARCHAR(MAX), @sql NVARCHAR(MAX), @result FLOAT;

DECLARE equation_cursor CURSOR FOR 
SELECT equation FROM Equations;

OPEN equation_cursor;
FETCH NEXT FROM equation_cursor INTO @equation;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = N'SELECT @res_out = ' + @equation;
    EXEC sp_executesql @sql, N'@res_out FLOAT OUTPUT', @res_out=@result OUTPUT;
    PRINT 'Equation: ' + @equation + ' = ' + CAST(@result AS VARCHAR);
    FETCH NEXT FROM equation_cursor INTO @equation;
END

CLOSE equation_cursor;
DEALLOCATE equation_cursor;

4. Given the following dataset, find the students that share the same birthday.(Student Table)
SELECT *
FROM Student
WHERE birthday IN (
    SELECT birthday
    FROM Student
    GROUP BY birthday
    HAVING COUNT(*) > 1
)
ORDER BY birthday;
5. You have a table with two players (Player A and Player B) and their scores. If a pair of players have multiple entries, aggregate their scores into a single row for each unique pair of players. Write an SQL query to calculate the total score for each unique player pair(PlayerScores)

SELECT
    CASE WHEN player_a < player_b THEN player_a ELSE player_b END AS Player1,
    CASE WHEN player_a < player_b THEN player_b ELSE player_a END AS Player2,
    SUM(score) AS TotalScore
FROM 
    PlayerScores
GROUP BY
    CASE WHEN player_a < player_b THEN player_a ELSE player_b END,
    CASE WHEN player_a < player_b THEN player_b ELSE player_a END;
