ProductSales Table Tasks
1. Assign a row number to each sale based on the SaleDate:


SELECT *, ROW_NUMBER() OVER (ORDER BY SaleDate) AS RowNum
FROM ProductSales;
2. Rank products based on the total quantity sold (dense ranking):


SELECT ProductName, SUM(Quantity) AS TotalQty,
       DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS Rank
FROM ProductSales
GROUP BY ProductName;
3.Identify the top sale for each customer based on SaleAmount:


SELECT *
FROM (
    SELECT *, RANK() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS rnk
    FROM ProductSales
) t
WHERE rnk = 1;
4.Display each sale's amount along with the next sale amount by SaleDate:


SELECT SaleID, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount
FROM ProductSales;
5.Display each sale's amount along with the previous sale amount by SaleDate:


SELECT SaleID, SaleAmount,
       LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevSaleAmount
FROM ProductSales;
6.Identify sales amounts greater than the previous sale's amount:


SELECT *
FROM (
    SELECT *, LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevAmount
    FROM ProductSales
) t
WHERE SaleAmount > PrevAmount;
7.Difference in sale amount from the previous sale per product:

ь
SELECT *, 
       LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PrevAmount,
       SaleAmount - LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffFromPrev
FROM ProductSales;
8.Percentage change from current to next sale amount:


SELECT *, 
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextAmount,
       CASE 
           WHEN SaleAmount = 0 THEN NULL
           ELSE (LEAD(SaleAmount) OVER (ORDER BY SaleDate) - SaleAmount) * 100.0 / SaleAmount
       END AS PercentChange
FROM ProductSales;
9.Ratio of current sale amount to previous sale amount within the same product:


SELECT *,
       LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PrevAmount,
       CASE 
           WHEN LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) = 0 THEN NULL
           ELSE SaleAmount * 1.0 / LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate)
       END AS RatioToPrev
FROM ProductSales;
10.Difference in sale amount from the very first sale of that product:

SELECT *,
       FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS FirstSaleAmount,
       SaleAmount - FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffFromFirst
FROM ProductSales;
11.Sales increasing continuously for a product:


WITH RankedSales AS (
    SELECT *, 
           LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PrevAmount
    FROM ProductSales
)
SELECT *
FROM RankedSales
WHERE SaleAmount > PrevAmount;
12."Closing balance" (running total) of sales amounts:


SELECT *, 
       SUM(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM ProductSales;
13.Moving average of sales amounts over the last 3 sales:


SELECT *,
       AVG(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg
FROM ProductSales;
14.Difference between each sale amount and the average sale amount:


SELECT *,
       SaleAmount - AVG(SaleAmount) OVER () AS DiffFromAvg
FROM ProductSales;
Employees1 Table Tasks
15.Employees who have the same salary rank:


SELECT *, DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees1;
16.Top 2 highest salaries in each department:


SELECT *
FROM (
    SELECT *, DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS Rank
    FROM Employees1
) t
WHERE Rank <= 2;
17.Lowest-paid employee in each department:


SELECT *
FROM (
    SELECT *, RANK() OVER (PARTITION BY Department ORDER BY Salary ASC) AS rnk
    FROM Employees1
) t
WHERE rnk = 1;
18.Running total of salaries in each department:


SELECT *, 
       SUM(Salary) OVER (PARTITION BY Department ORDER BY HireDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM Employees1;
19.Total salary of each department without GROUP BY:


SELECT *, 
       SUM(Salary) OVER (PARTITION BY Department) AS DeptTotal
FROM Employees1;
20.Average salary in each department without GROUP BY:


SELECT *, 
       AVG(Salary) OVER (PARTITION BY Department) AS DeptAvg
FROM Employees1;
21.Difference between employee’s salary and department’s average:


SELECT *, 
       Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromDeptAvg
FROM Employees1;
22.Moving average salary over 3 employees (previous, current, next):


SELECT *,
       AVG(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg
FROM Employees1;
23.Sum of salaries for the last 3 hired employees:


SELECT SUM(Salary) AS Last3HiredTotal
FROM (
    SELECT TOP 3 Salary
    FROM Employees1
    ORDER BY HireDate DESC
) t;
