1. All Distributors’ Sales by Region (Missing as 0)

WITH Regions AS (
    SELECT DISTINCT Region FROM #RegionSales
),
Distributors AS (
    SELECT DISTINCT Distributor FROM #RegionSales
),
AllCombos AS (
    SELECT r.Region, d.Distributor
    FROM Regions r CROSS JOIN Distributors d
)
SELECT 
    a.Region,
    a.Distributor,
    ISNULL(rs.Sales, 0) AS Sales
FROM AllCombos a
LEFT JOIN #RegionSales rs
    ON rs.Region = a.Region AND rs.Distributor = a.Distributor
ORDER BY a.Distributor, a.Region;
2. Managers with at least 5 direct reports

SELECT name
FROM Employee
WHERE id IN (
    SELECT managerId
    FROM Employee
    WHERE managerId IS NOT NULL
    GROUP BY managerId
    HAVING COUNT(*) >= 5
);
3. Products with ≥100 Units Ordered in Feb 2020

SELECT p.product_name, SUM(o.unit) AS unit
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
WHERE o.order_date >= '2020-02-01' AND o.order_date < '2020-03-01'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;
4. Vendor with Most Orders per Customer

WITH VendorCount AS (
    SELECT CustomerID, Vendor, COUNT(*) AS OrderCount
    FROM Orders
    GROUP BY CustomerID, Vendor
),
Ranked AS (
    SELECT *, 
           RANK() OVER (PARTITION BY CustomerID ORDER BY OrderCount DESC) AS rnk
    FROM VendorCount
)
SELECT CustomerID, Vendor
FROM Ranked
WHERE rnk = 1;
5. Prime Number Checker

DECLARE @Check_Prime INT = 91;
DECLARE @i INT = 2;
DECLARE @IsPrime BIT = 1;

WHILE @i * @i <= @Check_Prime
BEGIN
    IF @Check_Prime % @i = 0
    BEGIN
        SET @IsPrime = 0;
        BREAK;
    END
    SET @i = @i + 1;
END

IF @Check_Prime <= 1
    PRINT 'This number is not prime';
ELSE IF @IsPrime = 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';
6. Signal Stats by Device

WITH Signals AS (
    SELECT Device_id, Locations, COUNT(*) AS SignalCount
    FROM Device
    GROUP BY Device_id, Locations
),
Aggregated AS (
    SELECT 
        Device_id,
        COUNT(DISTINCT Locations) AS no_of_location,
        SUM(SignalCount) AS no_of_signals,
        MAX(SignalCount) AS MaxSignal
    FROM Signals
    GROUP BY Device_id
),
TopLocation AS (
    SELECT Device_id, Locations
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY Device_id ORDER BY SignalCount DESC) AS rn
        FROM Signals
    ) x
    WHERE rn = 1
)
SELECT 
    a.Device_id,
    a.no_of_location,
    t.Locations AS max_signal_location,
    a.no_of_signals
FROM Aggregated a
JOIN TopLocation t ON a.Device_id = t.Device_id;
7. Employees Earning More Than Department Avg

WITH DeptAvg AS (
    SELECT DeptID, AVG(Salary) AS AvgSal
    FROM Employee
    GROUP BY DeptID
)
SELECT e.EmpID, e.EmpName, e.Salary
FROM Employee e
JOIN DeptAvg d ON e.DeptID = d.DeptID
WHERE e.Salary > d.AvgSal;
8. Lottery Winnings
ь
-- Assume WinningNumbers and Tickets tables exist
WITH Matches AS (
    SELECT t.TicketID, COUNT(*) AS MatchCount
    FROM Tickets t
    JOIN WinningNumbers w ON t.Number = w.Number
    GROUP BY t.TicketID
)
SELECT SUM(
    CASE 
        WHEN MatchCount = 3 THEN 100
        WHEN MatchCount > 0 THEN 10
        ELSE 0
    END
) AS Total_Winnings
FROM Matches;
9. Spending by Platform per Day

WITH Platforms AS (
    SELECT DISTINCT User_id, Spend_date,
        MAX(CASE WHEN Platform = 'Mobile' THEN 1 ELSE 0 END) AS HasMobile,
        MAX(CASE WHEN Platform = 'Desktop' THEN 1 ELSE 0 END) AS HasDesktop
    FROM Spending
    GROUP BY User_id, Spend_date
),
Categories AS (
    SELECT Spend_date,
        CASE 
            WHEN HasMobile = 1 AND HasDesktop = 1 THEN 'Both'
            WHEN HasMobile = 1 THEN 'Mobile'
            WHEN HasDesktop = 1 THEN 'Desktop'
        END AS Platform,
        User_id
    FROM Platforms
),
Amounts AS (
    SELECT Spend_date, User_id, SUM(Amount) AS TotalAmount
    FROM Spending
    GROUP BY Spend_date, User_id
),
Final AS (
    SELECT c.Spend_date, c.Platform, COUNT(DISTINCT c.User_id) AS Total_users, SUM(a.TotalAmount) AS Total_Amount
    FROM Categories c
    JOIN Amounts a ON c.User_id = a.User_id AND c.Spend_date = a.Spend_date
    GROUP BY c.Spend_date, c.Platform
)
-- Add missing 'Both' rows if needed
SELECT Spend_date, Platform, Total_Amount, Total_users
FROM Final
UNION ALL
SELECT DISTINCT Spend_date, 'Both', 0, 0
FROM Spending
WHERE Spend_date NOT IN (
    SELECT Spend_date FROM Final WHERE Platform = 'Both'
)
ORDER BY Spend_date, 
    CASE Platform 
        WHEN 'Mobile' THEN 1 
        WHEN 'Desktop' THEN 2 
        WHEN 'Both' THEN 3 
    END;
10. Degroup Table Data

WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < 100
),
Expanded AS (
    SELECT g.Product, 1 AS Quantity
    FROM Grouped g
    JOIN Numbers n ON n.n <= g.Quantity
)
SELECT * FROM Expanded
ORDER BY Product
OPTION (MAXRECURSION 100);
