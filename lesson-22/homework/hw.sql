Easy Questions
1. Running Total Sales per Customer

SELECT 
    customer_id,
    order_date,
    total_amount,
    SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM sales_data;
2. Count the Number of Orders per Product Category

SELECT 
    product_category,
    COUNT(*) AS order_count
FROM sales_data
GROUP BY product_category;
3. Maximum Total Amount per Product Category

SELECT 
    product_category,
    MAX(total_amount) AS max_total
FROM sales_data
GROUP BY product_category;
4. Minimum Price of Products per Product Category

SELECT 
    product_category,
    MIN(unit_price) AS min_price
FROM sales_data
GROUP BY product_category;
5. Moving Average of 3 Days (prev, curr, next)

SELECT 
    order_date,
    AVG(total_amount) OVER (ORDER BY order_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_avg
FROM sales_data;
6. Total Sales per Region

SELECT 
    region,
    SUM(total_amount) AS total_sales
FROM sales_data
GROUP BY region;
7. Rank of Customers by Total Purchase Amount

SELECT 
    customer_id,
    SUM(total_amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(total_amount) DESC) AS customer_rank
FROM sales_data
GROUP BY customer_id;
8. Difference Between Current and Previous Sale Amount per Customer

SELECT 
    customer_id,
    order_date,
    total_amount,
    total_amount - LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS diff_from_prev
FROM sales_data;
9. Top 3 Most Expensive Products in Each Category

SELECT *
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY product_category ORDER BY unit_price DESC) AS rnk
    FROM sales_data
) t
WHERE rnk <= 3;
10. Cumulative Sales Per Region by Order Date

SELECT 
    region,
    order_date,
    SUM(total_amount) OVER (PARTITION BY region ORDER BY order_date) AS cumulative_sales
FROM sales_data;

Medium Questions
11. Cumulative Revenue per Product Category

    product_category,
    order_date,
    SUM(total_amount) OVER (PARTITION BY product_category ORDER BY order_date) AS cumulative_revenue
FROM sales_data;
12. Sum of Previous Values to Current Value

SELECT 
    Value,
    SUM(Value) OVER (ORDER BY Value ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [Sum of Previous]
FROM OneColumn;
13. Odd Starting Row Number per Partition

WITH Numbered AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Vals) AS rn
    FROM Row_Nums
),
OffsetBase AS (
    SELECT Id, MIN(ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Vals)) * 2 - 1 AS start_row
    FROM Row_Nums
    GROUP BY Id
)
SELECT 
    r.Id,
    r.Vals,
    o.start_row + r.rn - 1 AS RowNumber
FROM Numbered r
JOIN OffsetBase o ON r.Id = o.Id;
14. Customers with Purchases in More Than One Category

SELECT customer_id
FROM sales_data
GROUP BY customer_id
HAVING COUNT(DISTINCT product_category) > 1;
15. Customers with Above-Average Spending in Their Region

WITH RegionalAvg AS (
    SELECT region, AVG(total_amount) AS avg_spend
    FROM sales_data
    GROUP BY region
)
SELECT s.*
FROM sales_data s
JOIN RegionalAvg r ON s.region = r.region
WHERE s.total_amount > r.avg_spend;
16. Rank Customers by Total Spending in Their Region

SELECT 
    region,
    customer_id,
    SUM(total_amount) AS total_spent,
    RANK() OVER (PARTITION BY region ORDER BY SUM(total_amount) DESC) AS rank_in_region
FROM sales_data
GROUP BY region, customer_id;
17. Running Total per Customer by Date

SELECT 
    customer_id,
    order_date,
    total_amount,
    SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS cumulative_sales
FROM sales_data;
18. Monthly Sales Growth Rate

WITH MonthlySales AS (
    SELECT 
        FORMAT(order_date, 'yyyy-MM') AS month,
        SUM(total_amount) AS monthly_total
    FROM sales_data
    GROUP BY FORMAT(order_date, 'yyyy-MM')
)
SELECT 
    month,
    monthly_total,
    LAG(monthly_total) OVER (ORDER BY month) AS prev_month_total,
    CAST(monthly_total - LAG(monthly_total) OVER (ORDER BY month) AS FLOAT) / 
    NULLIF(LAG(monthly_total) OVER (ORDER BY month), 0) AS growth_rate
FROM MonthlySales;
19. Customers with Increased Spending Over Last Order

WITH Ranked AS (
    SELECT *,
           LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_amount
    FROM sales_data
)
SELECT *
FROM Ranked
WHERE total_amount > prev_amount;
 Hard Questions
20. Products with Prices Above Average

SELECT *
FROM sales_data
WHERE unit_price > (SELECT AVG(unit_price) FROM sales_data);
21. Group Sum at First Row

SELECT *,
    CASE WHEN ROW_NUMBER() OVER (PARTITION BY Grp ORDER BY Id) = 1 
         THEN SUM(Val1 + Val2) OVER (PARTITION BY Grp)
         ELSE NULL
    END AS Tot
FROM MyData;
22. Summing Cost and Quantity with Rules

SELECT 
    ID,
    SUM(Cost) AS Cost,
    SUM(CASE WHEN rn = 1 THEN Quantity ELSE 0 END) AS Quantity
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ID, Quantity ORDER BY Cost) AS rn
    FROM TheSumPuzzle
) t
GROUP BY ID;
23. Find Seat Gaps

WITH AllSeats AS (
    SELECT ROW_NUMBER() OVER (ORDER BY SeatNumber) AS rn, SeatNumber
    FROM Seats
),
Gaps AS (
    SELECT 
        a.SeatNumber + 1 AS GapStart,
        LEAD(a.SeatNumber) OVER (ORDER BY a.SeatNumber) - 1 AS GapEnd
    FROM AllSeats a
    WHERE LEAD(a.SeatNumber) OVER (ORDER BY a.SeatNumber) - a.SeatNumber > 1
)
SELECT * FROM Gaps;
24. Even Starting Row Number per Partition

WITH Numbered AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Vals) AS rn
    FROM Row_Nums
),
OffsetBase AS (
    SELECT Id, MIN(ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Vals)) * 2 AS start_row
    FROM Row_Nums
    GROUP BY Id
)
SELECT 
    r.Id,
    r.Vals,
    o.start_row + r.rn - 1 AS Changed
FROM Numbered r
JOIN OffsetBase o ON r.Id = o.Id;
