1. Define and explain the purpose of BULK INSERT in SQL Server
BULK INSERT is a command in SQL Server used to import large amounts of data quickly from a data file (like CSV or TXT) into a table.


Improves performance when loading large datasets.

Common for ETL (Extract, Transform, Load) processes.

Example:

BULK INSERT Products
FROM 'C:\Data\products.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
2. List four file formats that can be imported into SQL Server
.CSV (Comma-Separated Values)

.TXT (Text file)

.DAT (Data file)

.XML (with appropriate XML schema)

SQL Server can also import Excel files via SSIS, OPENROWSET, or linked servers.
3. Create a Products table

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10,2)
);
4. Insert three records into the Products table

INSERT INTO Products (ProductID, ProductName, Price)
VALUES
(1, 'Keyboard', 25.99),
(2, 'Mouse', 15.49),
(3, 'Monitor', 150.00);
5. Explain the difference between NULL and NOT NULL
NULL: Indicates the absence of a value.

NOT NULL: Ensures that a column must have a value; it cannot be left blank.

Example:

-- NULL allowed
CREATE TABLE Employees (
    ID INT,
    Name VARCHAR(50) NULL
);

-- NOT NULL constraint
CREATE TABLE Orders (
    OrderID INT,
    OrderDate DATE NOT NULL
);

6. Add a UNIQUE constraint to ProductName

ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);
7. Write a comment in a SQL query explaining its purpose

-- This query retrieves all products with a price greater than $50
SELECT * FROM Products
WHERE Price > 50.00;
8. Create a Categories table with CategoryID as PRIMARY KEY and CategoryName as UNIQUE
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE
);
9. Explain the purpose of the IDENTITY column in SQL Server
IDENTITY is used to auto-generate unique numbers for a column (commonly used for primary keys).

Eliminates the need to manually insert values.

Ensures sequential uniqueness.

Syntax Example:

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName VARCHAR(50)
);

Medium-Level Tasks (10)

10. Use BULK INSERT to import data from a text file into the Products table
Assume you have a file like C:\Data\products.txt with comma-separated values:

BULK INSERT Products
FROM 'C:\Data\products.txt'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2  -- Skip header row
);
11. Create a FOREIGN KEY in the Products table referencing the Categories table
Assuming Categories(CategoryID) is the primary key and Products has a column CategoryID:


ALTER TABLE Products
ADD CategoryID INT;

ALTER TABLE Products
ADD CONSTRAINT FK_Product_Category
FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);
12. Explain the differences between PRIMARY KEY and UNIQUE KEY

Feature	PRIMARY KEY	UNIQUE KEY
Uniqueness	Ensures all values are unique	Ensures all values are unique
Nullability	Cannot be NULL	Can have one NULL (in SQL Server)
Number allowed	Only one per table	Multiple allowed
Purpose	Main identifier for a row	Enforce uniqueness of a field
Example:

-- PRIMARY KEY
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    Email VARCHAR(100) UNIQUE  -- UNIQUE KEY
);
13. Add a CHECK constraint to ensure Price > 0

ALTER TABLE Products
ADD CONSTRAINT chk_Price_Positive CHECK (Price > 0);
14. Modify Products to add Stock column (INT, NOT NULL)

ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0;
Setting a DEFAULT helps when adding a NOT NULL column to a table with existing data.

15. Use ISNULL to replace NULL values in a column with a default
Example: Show product names and substitute “Unknown” where ProductName is NULL.

SELECT ProductID, ISNULL(ProductName, 'Unknown') AS ProductName, Price
FROM Products;
16. Describe the purpose and usage of FOREIGN KEY constraints in SQL Server
Purpose: A FOREIGN KEY enforces referential integrity by ensuring that a value in one table matches a value in another.

Usage:

Prevents invalid data entry.

Ensures consistent and reliable relationships between tables.

Example:

-- Products.CategoryID must match Categories.CategoryID
FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);
 
 Hard-Level Tasks (10)

 17. Create a Customers table with a CHECK constraint ensuring Age >= 18

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT CHECK (Age >= 18)
);
18. Create a table with an IDENTITY column starting at 100 and incrementing by 10

CREATE TABLE AutoNumbers (
    AutoID INT IDENTITY(100, 10) PRIMARY KEY,
    Description VARCHAR(100)
);
IDENTITY(100, 10) means: start at 100, increase by 10 with each new row.

19. Write a query to create a composite PRIMARY KEY in OrderDetails

CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID)
);

20. Explain with examples the use of COALESCE and ISNULL for handling NULL values
 ISNULL(value, replacement)
Replaces NULL with a specified replacement.

Only accepts two arguments.
SELECT ISNULL(NULL, 'N/A') AS Result;  -- Output: N/A
COALESCE(value1, value2, ..., valuen)
Returns the first non-NULL value from a list.

More flexible; accepts multiple arguments.


SELECT COALESCE(NULL, NULL, 'Backup', 'Fallback') AS Result;  -- Output: Backup
Use Case:

SELECT 
    ISNULL(Email, 'no-email@example.com') AS EmailWithDefault,
    COALESCE(Phone, AlternatePhone, 'No contact') AS ContactInfo
FROM Customers;
21. Create an Employees table with PRIMARY KEY on EmpID and UNIQUE KEY on Email

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100) UNIQUE
);
22. Create a FOREIGN KEY with ON DELETE CASCADE and ON UPDATE CASCADE

-- Parent table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

-- Child table with cascade options
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    Name VARCHAR(100),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID)
        REFERENCES Departments(DepartmentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
