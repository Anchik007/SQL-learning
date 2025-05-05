Easy-Level Tasks
1. Orders after 2022 with Customer Names


SELECT o.OrderID, c.CustomerName, o.OrderDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) > 2022;
2. Employees in Sales or Marketing


SELECT e.EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('Sales', 'Marketing');
3. Highest Salary by Department


SELECT d.DepartmentName, MAX(e.Salary) AS MaxSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;
4. USA Customers Orders in 2023


SELECT c.CustomerName, o.OrderID, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA' AND YEAR(o.OrderDate) = 2023;
5. Total Orders per Customer


SELECT c.CustomerName, COUNT(o.OrderID) AS TotalOrders
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName;
6. Products from Specific Suppliers

SELECT p.ProductName, s.SupplierName
FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.SupplierName IN ('Gadget Supplies', 'Clothing Mart');
7. Most Recent Order per Customer (include those without orders)

SELECT c.CustomerName, MAX(o.OrderDate) AS MostRecentOrderDate
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName;

 Medium-Level Tasks
8. Customers with Orders Over 500

SELECT c.CustomerName, o.TotalAmount AS OrderTotal
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.TotalAmount > 500;
9. Product Sales from 2022 or Amount > 400

SELECT p.ProductName, s.SaleDate, s.SaleAmount
FROM Products p
INNER JOIN Sales s ON p.ProductID = s.ProductID
WHERE YEAR(s.SaleDate) = 2022 OR s.SaleAmount > 400;
10. Total Sales Amount by Product


SELECT p.ProductName, SUM(s.SaleAmount) AS TotalSalesAmount
FROM Products p
INNER JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName;
11. HR Employees Earning > 60000


SELECT e.EmployeeName, d.DepartmentName, e.Salary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'HR' AND e.Salary > 60000;
12. Products Sold in 2023 with Stock > 100


SELECT p.ProductName, s.SaleDate, p.StockQuantity
FROM Products p
INNER JOIN Sales s ON p.ProductID = s.ProductID
WHERE YEAR(s.SaleDate) = 2023 AND p.StockQuantity > 100;
13. Sales Employees or Hired After 2020


SELECT e.EmployeeName, d.DepartmentName, e.HireDate
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Sales' OR YEAR(e.HireDate) > 2020;
 Hard-Level Tasks
14. USA Customers with 4-digit Address Orders


SELECT c.CustomerName, o.OrderID, c.Address, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA' AND c.Address LIKE '[0-9][0-9][0-9][0-9]%';
15. Electronics or Sale > 350

SELECT p.ProductName, p.Category, s.SaleAmount
FROM Products p
INNER JOIN Sales s ON p.ProductID = s.ProductID
WHERE p.Category = 'Electronics' OR s.SaleAmount > 350;
16. Product Count per Category


SELECT c.CategoryName, COUNT(p.ProductID) AS ProductCount
FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;
17. Los Angeles Customers with Orders > 300


SELECT c.CustomerName, c.City, o.OrderID, o.Amount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.City = 'Los Angeles' AND o.Amount > 300;
18. HR or Finance or Name with 4+ Vowels

SELECT e.EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('HR', 'Finance')
   OR LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(e.EmployeeName), 'a', ''), 'e', ''), 'i', ''), 'o', ''), 'u', '')) <= LEN(e.EmployeeName) - 4;
19. Sales/Marketing with Salary > 60000


SELECT e.EmployeeName, d.DepartmentName, e.Salary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('Sales', 'Marketing') AND e.Salary > 60000;
