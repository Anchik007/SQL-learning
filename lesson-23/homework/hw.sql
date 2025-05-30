Puzzle 1: Extracting and Formatting Month
To extract the month from the Dt column and format it as a two-digit string:


SELECT
  Id,
  Dt,
  RIGHT('0' + CAST(MONTH(Dt) AS VARCHAR(2)), 2) AS MonthPrefixedWithZero
FROM Dates;
This approach ensures that single-digit months are prefixed with a zero (e.g., '04' for April).

Puzzle 2: Summing Maximum Values per Id and rID
To find the count of distinct Ids and the sum of maximum Vals for each Id and rID combination:


SELECT
  COUNT(DISTINCT Id) AS Distinct_Ids,
  rID,
  SUM(MaxVal) AS TotalOfMaxVals
FROM (
  SELECT
    Id,
    rID,
    MAX(Vals) AS MaxVal
  FROM MyTabel
  GROUP BY Id, rID
) AS MaxValsPerGroup
GROUP BY rID;
This query first computes the maximum Vals for each Id and rID, then aggregates these maxima per rID.

Puzzle 3: Filtering Strings by Length
To select records from TestFixLengths where the Vals column has a length between 6 and 10 characters:

SELECT Id, Vals
FROM TestFixLengths
WHERE LEN(Vals) BETWEEN 6 AND 10;
This filters out entries with Vals shorter than 6 or longer than 10 characters, including NULL and empty strings.

Puzzle 4: Retrieving Items with Maximum Values per ID
To find the Item with the maximum Vals for each ID:


SELECT t.ID, t.Item, t.Vals
FROM TestMaximum t
INNER JOIN (
  SELECT ID, MAX(Vals) AS MaxVal
  FROM TestMaximum
  GROUP BY ID
) AS MaxVals
  ON t.ID = MaxVals.ID AND t.Vals = MaxVals.MaxVal;
This joins the original table with a subquery that determines the maximum Vals per ID, retrieving the corresponding Item.

Puzzle 5: Summing Maximum Values per DetailedNumber and Id
To compute the sum of maximum Vals for each DetailedNumber within each Id:
SELECT Id, SUM(MaxVal) AS SumofMax
FROM (
  SELECT Id, DetailedNumber, MAX(Vals) AS MaxVal
  FROM SumOfMax
  GROUP BY Id, DetailedNumber
) AS MaxValsPerGroup
GROUP BY Id;
This calculates the maximum Vals for each DetailedNumber and Id pair, then sums these maxima per Id.

Puzzle 6: Calculating Differences and Handling Zero Results
To compute the difference between columns a and b, displaying the result only when the difference is non-zero:
SELECT
  Id,
  a,
  b,
  CASE
    WHEN a - b <> 0 THEN CAST(a - b AS VARCHAR)
    ELSE ''
  END AS OUTPUT
FROM TheZeroPuzzle;

 Sales Analysis
7. Total revenue generated from all sales:

SELECT SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales;
8 Average unit price of products:

SELECT AVG(UnitPrice) AS AverageUnitPrice
FROM Sales;
9. Number of sales transactions:

SELECT COUNT(*) AS TotalTransactions
FROM Sales;
10. Highest number of units sold in a single transaction:

SELECT MAX(QuantitySold) AS MaxUnitsSold
FROM Sales;
11. Products sold in each category:

SELECT Category, SUM(QuantitySold) AS TotalUnitsSold
FROM Sales
GROUP BY Category;
12. Total revenue for each region:

SELECT Region, SUM(QuantitySold * UnitPrice) AS Revenue
FROM Sales
GROUP BY Region;
13. Product that generated the highest total revenue:

SELECT TOP 1 Product, SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Product
ORDER BY TotalRevenue DESC;
14. Running total of revenue ordered by sale date:

SELECT SaleDate,
       Product,
       QuantitySold * UnitPrice AS Revenue,
       SUM(QuantitySold * UnitPrice) OVER (ORDER BY SaleDate) AS RunningTotalRevenue
FROM Sales;
15. Category-wise contribution to total sales revenue:

SELECT Category,
       SUM(QuantitySold * UnitPrice) AS Revenue,
       ROUND(100.0 * SUM(QuantitySold * UnitPrice) / SUM(SUM(QuantitySold * UnitPrice)) OVER (), 2) AS RevenuePercent
FROM Sales
GROUP BY Category;
 Customer Analysis
16. All sales with customer names:

SELECT S.*, C.CustomerName
FROM Sales S
JOIN Customers C ON S.CustomerID = C.CustomerID;
17. Customers with no purchases:

SELECT C.*
FROM Customers C
LEFT JOIN Sales S ON C.CustomerID = S.CustomerID
WHERE S.CustomerID IS NULL;
18. Total revenue from each customer:

SELECT C.CustomerName, SUM(S.QuantitySold * S.UnitPrice) AS TotalRevenue
FROM Sales S
JOIN Customers C ON S.CustomerID = C.CustomerID
GROUP BY C.CustomerName;
20. Customer with the most revenue contribution:

SELECT TOP 1 C.CustomerName, SUM(S.QuantitySold * S.UnitPrice) AS TotalRevenue
FROM Sales S
JOIN Customers C ON S.CustomerID = C.CustomerID
GROUP BY C.CustomerName
ORDER BY TotalRevenue DESC;
21. Total sales (quantity) per customer:

SELECT C.CustomerName, SUM(S.QuantitySold) AS TotalQuantitySold
FROM Sales S
JOIN Customers C ON S.CustomerID = C.CustomerID
GROUP BY C.CustomerName;
 Product Insights
22. Products sold at least once:

SELECT DISTINCT P.ProductName
FROM Products P
JOIN Sales S ON P.ProductName = S.Product;
23. Most expensive product (by SellingPrice):

SELECT TOP 1 *
FROM Products
ORDER BY SellingPrice DESC;
24. Products priced higher than category average:

SELECT *
FROM Products P
WHERE SellingPrice > (
    SELECT AVG(SellingPrice)
    FROM Products
    WHERE Category = P.Category
);

