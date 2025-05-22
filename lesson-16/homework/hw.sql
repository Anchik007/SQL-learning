Easy Tasks
1. Recursive numbers table from 1 to 1000

WITH Numbers AS (
    SELECT 1 AS num
    UNION ALL
    SELECT num + 1 FROM Numbers WHERE num < 1000
)
SELECT * FROM Numbers;
2. Total sales per employee using derived table

SELECT e.id, e.name, s.total_sales
FROM employees e
JOIN (
    SELECT employee_id, SUM(amount) AS total_sales
    FROM sales
    GROUP BY employee_id
) s ON e.id = s.employee_id;
3. CTE to find average salary of employees

WITH AvgSalary AS (
    SELECT AVG(salary) AS avg_salary FROM employees
)
SELECT * FROM AvgSalary;
4. Derived table: highest sales per product

SELECT p.product_name, s.max_sale
FROM products p
JOIN (
    SELECT product_id, MAX(amount) AS max_sale
    FROM sales
    GROUP BY product_id
) s ON p.id = s.product_id;
5. Double number until max < 1,000,000

WITH Doubles AS (
    SELECT 1 AS val
    UNION ALL
    SELECT val * 2 FROM Doubles WHERE val * 2 < 1000000
)
SELECT * FROM Doubles;
6. CTE: employees with more than 5 sales

WITH SalesCount AS (
    SELECT employee_id, COUNT(*) AS sale_count
    FROM sales
    GROUP BY employee_id
)
SELECT e.name
FROM SalesCount sc
JOIN employees e ON sc.employee_id = e.id
WHERE sc.sale_count > 5;
7. CTE: products with sales > $500

WITH ProductSales AS (
    SELECT product_id, SUM(amount) AS total_sales
    FROM sales
    GROUP BY product_id
)
SELECT p.product_name
FROM ProductSales ps
JOIN products p ON ps.product_id = p.id
WHERE ps.total_sales > 500;
8. CTE: employees with salaries above average

WITH AvgSalary AS (
    SELECT AVG(salary) AS avg_salary FROM employees
)
SELECT *
FROM employees
WHERE salary > (SELECT avg_salary FROM AvgSalary);
 Medium Tasks
1. Top 5 employees by number of orders (derived table)

SELECT TOP 5 e.name, sales_count
FROM (
    SELECT employee_id, COUNT(*) AS sales_count
    FROM sales
    GROUP BY employee_id
) s
JOIN employees e ON e.id = s.employee_id
ORDER BY sales_count DESC;
2. Sales per product category (derived table)
ь
SELECT p.category_id, SUM(s.amount) AS total_sales
FROM sales s
JOIN products p ON s.product_id = p.id
GROUP BY p.category_id;
3. Factorial per number (recursive CTE on Numbers1)

WITH Factorial AS (
    SELECT number, 1 AS fact FROM Numbers1 WHERE number = 1
    UNION ALL
    SELECT n.number, n.number * f.fact
    FROM Numbers1 n
    JOIN Factorial f ON n.number = f.number + 1
)
SELECT * FROM Factorial;
4. Recursion: split string into characters

DECLARE @str NVARCHAR(MAX) = 'Hello';

WITH SplitChars AS (
    SELECT 1 AS pos, SUBSTRING(@str, 1, 1) AS char
    UNION ALL
    SELECT pos + 1, SUBSTRING(@str, pos + 1, 1)
    FROM SplitChars
    WHERE pos + 1 <= LEN(@str)
)
SELECT * FROM SplitChars;
5. Sales difference between current and previous month (CTE)

WITH MonthlySales AS (
    SELECT 
        FORMAT(sale_date, 'yyyy-MM') AS month,
        SUM(amount) AS total_sales
    FROM sales
    GROUP BY FORMAT(sale_date, 'yyyy-MM')
),
Diffs AS (
    SELECT 
        month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY month) AS prev_sales
    FROM MonthlySales
)
SELECT month, total_sales, prev_sales, total_sales - ISNULL(prev_sales, 0) AS difference
FROM Diffs;
6. Employees with sales > $45000 per quarter
ь
SELECT e.name, qtr, total_sales
FROM (
    SELECT 
        employee_id,
        DATEPART(QUARTER, sale_date) AS qtr,
        SUM(amount) AS total_sales
    FROM sales
    GROUP BY employee_id, DATEPART(QUARTER, sale_date)
) s
JOIN employees e ON s.employee_id = e.id
WHERE total_sales > 45000;
 Difficult Tasks
1. Recursive Fibonacci numbers

WITH Fibonacci AS (
    SELECT 0 AS n, 0 AS fib
    UNION ALL
    SELECT 1, 1
    UNION ALL
    SELECT n + 1, 
           (SELECT fib FROM Fibonacci f WHERE f.n = fibo.n - 1) +
           (SELECT fib FROM Fibonacci f WHERE f.n = fibo.n - 2)
    FROM Fibonacci fibo
    WHERE n < 20
)
SELECT * FROM Fibonacci;
2. Find string with same characters and length > 1

SELECT *
FROM FindSameCharacters
WHERE LEN(value) > 1 AND LEN(REPLACE(value, LEFT(value, 1), '')) = 0;
3. Create sequence like 1, 12, 123... to n=5

WITH SequenceCTE AS (
    SELECT 1 AS num, '1' AS seq
    UNION ALL
    SELECT num + 1, seq + CAST(num + 1 AS VARCHAR)
    FROM SequenceCTE
    WHERE num < 5
)
SELECT * FROM SequenceCTE;
4. Most sales in last 6 months (derived table)

SELECT e.name, total_sales
FROM (
    SELECT employee_id, SUM(amount) AS total_sales
    FROM sales
    WHERE sale_date >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY employee_id
) s
JOIN employees e ON e.id = s.employee_id
WHERE total_sales = (
    SELECT MAX(total_sales)
    FROM (
        SELECT SUM(amount) AS total_sales
        FROM sales
        WHERE sale_date >= DATEADD(MONTH, -6, GETDATE())
        GROUP BY employee_id
    ) x
);
5. Remove duplicate and single-digit integers from a string

-- Assume a table: RemoveDuplicateIntsFromNames(name NVARCHAR(MAX))
-- This will remove single-digit integers and duplicates in a string like '123341' → '234'

-- This requires string parsing logic; implementation depends on SQL Server version.
-- Basic approach using recursive CTE + filtering

-- Sample implementation logic
-- Step 1: Split into characters, count occurrences
-- Step 2: Remove chars with count = 1 or not digit
