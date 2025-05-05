Easy-Level Tasks (7)
1. Orders after 2022 with customer names

SELECT o.OrderID, c.CustomerName, o.OrderDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) > 2022;
2. Employees in Sales or Marketing

SELECT e.EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('Sales', 'Marketing');
3. Highest salary per department

SELECT d.DepartmentName, MAX(e.Salary) AS MaxSalary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;
4. USA customers who placed orders in 2023

SELECT c.CustomerName, o.OrderID, o.OrderDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.Country = 'USA' AND YEAR(o.OrderDate) = 2023;
5. Number of orders per customer

SELECT c.CustomerName, COUNT(o.OrderID) AS TotalOrders
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName;
6. Products supplied by Gadget Supplies or Clothing Mart

SELECT p.ProductName, s.SupplierName
FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.SupplierName IN ('Gadget Supplies', 'Clothing Mart');
7. Most recent order for each customer (including those with none)

SELECT c.CustomerName, MAX(o.OrderDate) AS MostRecentOrderDate
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName;

Medium-Level Tasks (6)

8. Customers with orders > 500

SELECT c.CustomerName, o.TotalAmount AS OrderTotal
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.TotalAmount > 500;
9. Product sales in 2022 or amount > 400

SELECT p.ProductName, s.SaleDate, s.SaleAmount
FROM Sales s
INNER JOIN Products p ON s.ProductID = p.ProductID
WHERE YEAR(s.SaleDate) = 2022 OR s.SaleAmount > 400;
10. Total sales per product

SELECT p.ProductName, SUM(s.SaleAmount) AS TotalSalesAmount
FROM Sales s
INNER JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.ProductName;
11. HR employees with salary > 60000

SELECT e.EmployeeName, d.DepartmentName, e.Salary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'HR' AND e.Salary > 60000;
12. Products sold in 2023 with stock > 100

SELECT p.ProductName, s.SaleDate, p.StockQuantity
FROM Sales s
INNER JOIN Products p ON s.ProductID = p.ProductID
WHERE YEAR(s.SaleDate) = 2023 AND p.StockQuantity > 100;
13. Sales department employees OR hired after 2020

SELECT e.EmployeeName, d.DepartmentName, e.HireDate
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Sales' OR YEAR(e.HireDate) > 2020;
 Hard-Level Tasks (7)
14. USA customers whose address starts with 4 digits

SELECT c.CustomerName, o.OrderID, c.Address, o.OrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.Country = 'USA' AND c.Address LIKE '[0-9][0-9][0-9][0-9]%';
15. Product sales: Electronics category OR sale > 350

SELECT p.ProductName, p.Category, s.SaleAmount
FROM Sales s
INNER JOIN Products p ON s.ProductID = p.ProductID
WHERE p.Category = 'Electronics' OR s.SaleAmount > 350;
16. Product count per category

SELECT c.CategoryName, COUNT(p.ProductID) AS ProductCount
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName;
17. Orders from Los Angeles > $300

SELECT c.CustomerName, c.City, o.OrderID, o.TotalAmount AS Amount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.City = 'Los Angeles' AND o.TotalAmount > 300;
18. Employees in HR or Finance, or names with ≥4 vowels

SELECT e.EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('HR', 'Finance')
   OR LEN(e.EmployeeName) - LEN(REPLACE(LOWER(e.EmployeeName), 'a', '')) 
      + LEN(e.EmployeeName) - LEN(REPLACE(LOWER(e.EmployeeName), 'e', ''))
      + LEN(e.EmployeeName) - LEN(REPLACE(LOWER(e.EmployeeName), 'i', ''))
      + LEN(e.EmployeeName) - LEN(REPLACE(LOWER(e.EmployeeName), 'o', ''))
      + LEN(e.EmployeeName) - LEN(REPLACE(LOWER(e.EmployeeName), 'u', '')) >= 4;
19. Sales or Marketing employees with salary > 60000

SELECT e.EmployeeName, d.DepartmentName, e.Salary
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('Sales', 'Marketing') AND e.Salary > 60000;
