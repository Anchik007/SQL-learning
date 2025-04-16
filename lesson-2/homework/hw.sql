1. Create a table Employees
CREATE TABLE Employees (
    EmpID INT,
    Name VARCHAR(50),
    Salary DECIMAL(10,2)
);
2. Insert three records using different INSERT INTO approaches
Single-row insert:

INSERT INTO Employees (EmpID, Name, Salary)
VALUES (1, 'Alice Johnson', 60000.00);
Another single-row insert:

INSERT INTO Employees (EmpID, Name, Salary)
VALUES (2, 'Bob Smith', 55000.50);
Multiple-row insert:

INSERT INTO Employees (EmpID, Name, Salary)
VALUES 
    (3, 'Charlie Davis', 72000.75);
3. Update Salary where EmpID = 1
UPDATE Employees
SET Salary = 65000.00
WHERE EmpID = 1;
4. Delete record where EmpID = 2

DELETE FROM Employees
WHERE EmpID = 2;
 5. Demonstrate DELETE, TRUNCATE, and DROP on a test table
-- Create a test table
CREATE TABLE TestTable (
    ID INT,
    Value VARCHAR(20)
);

-- Insert sample data
INSERT INTO TestTable VALUES (1, 'A'), (2, 'B');

-- DELETE removes rows but keeps structure (can use WHERE clause)
DELETE FROM TestTable WHERE ID = 1;

-- TRUNCATE removes all rows, faster than DELETE, no WHERE clause
TRUNCATE TABLE TestTable;

-- DROP deletes the entire table structure
DROP TABLE TestTable;
6. Modify Name column to VARCHAR(100)
ALTER TABLE Employees
MODIFY Name VARCHAR(100);
-- Or in some RDBMS: ALTER COLUMN Name TYPE VARCHAR(100);
7. Add Department column (VARCHAR(50))

ALTER TABLE Employees
ADD Department VARCHAR(50);
8. Change Salary column type to FLOAT
ALTER TABLE Employees
MODIFY Salary FLOAT;
-- Or: ALTER COLUMN Salary TYPE FLOAT; (based on DBMS)
9. Create Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);
10. Remove all records from Employees without deleting structure
DELETE FROM Employees;
-- Or: TRUNCATE TABLE Employees;

Intermediate-Level Tasks (6)
11. Insert 5 records into Departments using INSERT INTO SELECT
Assuming you have another table like this for source data:

CREATE TABLE TempDepartments (
    DeptID INT,
    DeptName VARCHAR(50)
);

INSERT INTO TempDepartments VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT'),
(4, 'Marketing'),
(5, 'Operations');
Now insert into Departments:

INSERT INTO Departments (DepartmentID, DepartmentName)
SELECT DeptID, DeptName FROM TempDepartments;
12. Update the Department of all employees where Salary > 5000 to 'Management'
UPDATE Employees
SET Department = 'Management'
WHERE Salary > 5000;
(Make sure the Salary column is of numeric type like FLOAT or DECIMAL, and Department column exists.)

13. Write a query that removes all employees but keeps the table structure
DELETE FROM Employees;
-- OR
TRUNCATE TABLE Employees;
(Both commands will remove data but keep the table structure. Use DELETE if you need to log each deletion or use conditions.)

14. Drop the Department column from Employees
ALTER TABLE Employees
DROP COLUMN Department;
15. Rename the Employees table to StaffMembers
ALTER TABLE Employees
RENAME TO StaffMembers;
(For SQL Server, use: EXEC sp_rename 'Employees', 'StaffMembers';)

16. Remove the Departments table from the database
DROP TABLE Departments;
Advanced-Level Tasks (9)
17. Create Products table with at least 5 columns

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Description TEXT
);
18. Add a CHECK constraint to ensure Price > 0
ALTER TABLE Products
ADD CONSTRAINT chk_Price_Positive CHECK (Price > 0);
19. Add StockQuantity column with a DEFAULT value of 50
ALTER TABLE Products
ADD StockQuantity INT DEFAULT 50;
20. Rename Category to ProductCategory
ALTER TABLE Products
RENAME COLUMN Category TO ProductCategory;
EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';
21. Insert 5 records into Products
INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, Description)
VALUES 
(1, 'Laptop', 'Electronics', 899.99, '15-inch screen'),
(2, 'Coffee Maker', 'Appliances', 79.99, 'Brews fast'),
(3, 'Desk Chair', 'Furniture', 120.50, 'Ergonomic design'),
(4, 'Bluetooth Speaker', 'Electronics', 45.00, 'Portable and waterproof'),
(5, 'Water Bottle', 'Fitness', 15.75, 'Stainless steel');
22. Use SELECT INTO to create Products_Backup
SELECT * INTO Products_Backup
FROM Products;
23. Rename Products to Inventory
ALTER TABLE Products
RENAME TO Inventory;
EXEC sp_rename 'Products', 'Inventory';
24. Change Price from DECIMAL(10,2) to FLOAT
ALTER TABLE Inventory
MODIFY Price FLOAT;
ALTER TABLE Inventory
ALTER COLUMN Price TYPE FLOAT;
25. Add an IDENTITY column ProductCode starting from 1000, incrementing by 5
This depends on the RDBMS. Most require creating a new column with identity logic. Here's a SQL Server version:
ALTER TABLE Inventory
ADD ProductCode INT IDENTITY(1000, 5);
