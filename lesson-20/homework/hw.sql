1. Customers who purchased in March 2024 using EXISTS

SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1 FROM #Sales s2 
    WHERE s2.CustomerName = s1.CustomerName 
      AND MONTH(s2.SaleDate) = 3 
      AND YEAR(s2.SaleDate) = 2024
);
2. Product with highest total sales revenue using subquery

SELECT TOP 1 Product
FROM #Sales
GROUP BY Product
ORDER BY SUM(Quantity * Price) DESC;
3. Second highest sale amount using subquery

SELECT MAX(TotalSale) AS SecondHighest
FROM (
    SELECT Quantity * Price AS TotalSale
    FROM #Sales
    GROUP BY Quantity * Price
) t
WHERE TotalSale < (
    SELECT MAX(Quantity * Price) FROM #Sales
);
4. Total quantity sold per month using subquery

SELECT 
    DATEPART(YEAR, SaleDate) AS SaleYear,
    DATEPART(MONTH, SaleDate) AS SaleMonth,
    SUM(Quantity) AS TotalQuantity
FROM #Sales
GROUP BY DATEPART(YEAR, SaleDate), DATEPART(MONTH, SaleDate);
5. Customers who bought same products as others using EXISTS

SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1 FROM #Sales s2
    WHERE s1.CustomerName <> s2.CustomerName AND s1.Product = s2.Product
);
6. Count fruits per person (pivot)

SELECT 
    Name,
    SUM(CASE WHEN Fruit = 'Apple' THEN 1 ELSE 0 END) AS Apple,
    SUM(CASE WHEN Fruit = 'Orange' THEN 1 ELSE 0 END) AS Orange,
    SUM(CASE WHEN Fruit = 'Banana' THEN 1 ELSE 0 END) AS Banana
FROM Fruits
GROUP BY Name;
7. Older people with younger ones (recursive hierarchy)

WITH FamilyCTE (PID, CHID) AS (
    SELECT ParentId, ChildID FROM Family
    UNION ALL
    SELECT f.ParentId, c.ChildID
    FROM Family f
    JOIN FamilyCTE c ON f.ParentId = c.CHID
)
SELECT DISTINCT PID, CHID FROM FamilyCTE ORDER BY PID, CHID;
8. CA→TX customer orders

SELECT * 
FROM #Orders o
WHERE DeliveryState = 'TX'
  AND EXISTS (
    SELECT 1 
    FROM #Orders o2
    WHERE o2.CustomerID = o.CustomerID AND o2.DeliveryState = 'CA'
);
9. Insert missing names from address

UPDATE #residents
SET fullname = 
    SUBSTRING(address, CHARINDEX('name=', address) + 5, 
               CHARINDEX(' ', address + ' ', CHARINDEX('name=', address)) - CHARINDEX('name=', address) - 5)
WHERE fullname NOT LIKE '%name=%'
  AND address LIKE '%name=%';
10. Cheapest and most expensive routes from Tashkent to Khorezm

WITH Paths AS (
    SELECT DepartureCity, ArrivalCity, CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(500)) AS Route, Cost
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'
    
    UNION ALL

    SELECT p.DepartureCity, r.ArrivalCity, CAST(p.Route + ' - ' + r.ArrivalCity AS VARCHAR(500)), p.Cost + r.Cost
    FROM Paths p
    JOIN #Routes r ON p.ArrivalCity = r.DepartureCity
    WHERE CHARINDEX(r.ArrivalCity, p.Route) = 0
)
SELECT Route, Cost
FROM Paths
WHERE ArrivalCity = 'Khorezm';
11. Rank products in insertion groups

WITH Grouped AS (
    SELECT *,
           SUM(CASE WHEN Vals = 'Product' THEN 1 ELSE 0 END) 
           OVER (ORDER BY ID) AS GroupID
    FROM #RankingPuzzle
),
Filtered AS (
    SELECT GroupID, Vals
    FROM Grouped
    WHERE Vals <> 'Product'
)
SELECT GroupID, Vals, 
       ROW_NUMBER() OVER (PARTITION BY GroupID ORDER BY (SELECT NULL)) AS RankInGroup
FROM Filtered;
12. Employees with sales above department average

SELECT *
FROM #EmployeeSales e
WHERE SalesAmount > (
    SELECT AVG(SalesAmount)
    FROM #EmployeeSales
    WHERE Department = e.Department
      AND SalesMonth = e.SalesMonth
      AND SalesYear = e.SalesYear
);
13. Employees with highest sales in any month using EXISTS

SELECT *
FROM #EmployeeSales e
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales x
    WHERE x.SalesMonth = e.SalesMonth AND x.SalesYear = e.SalesYear
    GROUP BY x.SalesMonth, x.SalesYear
    HAVING MAX(SalesAmount) = e.SalesAmount
);
14. Employees who made sales in every month using NOT EXISTS

SELECT DISTINCT e1.EmployeeName
FROM #EmployeeSales e1
WHERE NOT EXISTS (
    SELECT 1
    FROM (
        SELECT DISTINCT SalesMonth FROM #EmployeeSales
    ) m
    WHERE NOT EXISTS (
        SELECT 1 FROM #EmployeeSales e2 
        WHERE e2.EmployeeName = e1.EmployeeName AND e2.SalesMonth = m.SalesMonth
    )
);
15. Products more expensive than the average price

SELECT Name
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);
16. Products with stock less than the maximum stock

SELECT Name
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products);
17. Products in same category as 'Laptop'

SELECT Name
FROM Products
WHERE Category = (
    SELECT Category FROM Products WHERE Name = 'Laptop'
);
18. Products with price > lowest Electronics price

SELECT Name
FROM Products
WHERE Price > (
    SELECT MIN(Price) FROM Products WHERE Category = 'Electronics'
);
19. Products with price > average of their category

SELECT Name
FROM Products p
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
    WHERE Category = p.Category
);
20. Products that have been ordered at least once

SELECT DISTINCT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID;
21. Products ordered more than average quantity

SELECT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
HAVING SUM(o.Quantity) > (
    SELECT AVG(qty) FROM (
        SELECT SUM(Quantity) AS qty
        FROM Orders
        GROUP BY ProductID
    ) x
);
22. Products never ordered

SELECT Name
FROM Products
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM Orders);
23. Product with highest total quantity ordered

SELECT TOP 1 p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
ORDER BY SUM(o.Quantity) DESC;
