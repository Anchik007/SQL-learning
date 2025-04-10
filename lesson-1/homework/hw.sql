Easy Tasks
Define the following terms:

Data: Raw facts or values that are collected, stored, and processed. Data can be in the form of numbers, text, or other types of information, and by itself, it may not provide much meaning until it is analyzed or processed.

Database: An organized collection of data that can be stored, managed, and retrieved electronically. It allows for efficient access and manipulation of data.

Relational Database: A type of database that stores data in tables with rows and columns. Relationships between tables are maintained using keys (primary and foreign), and SQL is used to manage and query the data.

Table: A structure within a database that organizes data into rows and columns. Each table represents a specific entity (e.g., customers, orders) and stores related information.

List five key features of SQL Server:

Scalability: Handles both small and large-scale data, and can scale vertically and horizontally.

Security: SQL Server offers features such as encryption, authentication, and user permission management to ensure data protection.

High Availability: Features like Always On Availability Groups and Failover Clustering ensure databases remain available even during system failures.

Data Recovery: SQL Server allows point-in-time recovery and transaction log backups for protecting data from loss.

Integration Services (SSIS): Provides a framework for integrating data across different systems, handling extraction, transformation, and loading (ETL) processes.

What are the different authentication modes available when connecting to SQL Server?

Windows Authentication: Uses Windows login credentials to authenticate users.

SQL Server Authentication: Uses a SQL Server-specific username and password for authentication.
Medium Tasks
Create a new database in SSMS named SchoolDB:
CREATE DATABASE SchoolDB;
Write and execute a query to create a table called Students with columns:
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT);
Describe the differences between SQL Server, SSMS, and SQL:
 SQL Server: A relational database management system (RDBMS) developed by Microsoft. It is used to store, manage, and retrieve data from databases. SQL Server processes SQL queries and provides database management tools.

SSMS (SQL Server Management Studio): A graphical interface provided by Microsoft to manage SQL Server instances. It allows database administrators and developers to manage databases, write queries, and execute them. It's essentially a tool for interacting with SQL Server.

SQL (Structured Query Language): A language used to communicate with databases. SQL is used to define, manipulate, and retrieve data. It provides a standard way to interact with relational databases, whether in SQL Server, MySQL, Oracle, etc.
Research and explain the different SQL commands:
 SELECT * FROM Students;
  DML (Data Manipulation Language): This deals with manipulating the data within tables, such as inserting, updating, and deleting data.
 INSERT INTO Students (StudentID, Name, Age) VALUES (1, 'John Doe', 20);
  DDL (Data Definition Language): This is used to define and manage database structures, like tables, indexes, and schemas.
CREATE TABLE Students (StudentID INT PRIMARY KEY, Name VARCHAR(50), Age INT);
DCL (Data Control Language): This is used to control access to data, defining user permissions.
  GRANT SELECT ON Students TO user_name;
  TCL (Transaction Control Language): This deals with transactions and ensures data consistency by allowing for commit or rollback.
BEGIN TRANSACTION;
  Write a query to insert three records into the Students table:
  INSERT INTO Students (StudentID, Name, Age) VALUES
(1, 'John Doe', 20),
(2, 'Jane Smith', 22),
(3, 'Alice Johnson', 21);
Create a backup of your SchoolDB database and restore it:
  Steps to back up a database in SSMS:

Right-click on the database (SchoolDB) in Object Explorer.

Select Tasks > Back Up.

In the Backup Database window, select Full as the backup type.

Choose a destination for the backup file (e.g., a disk file).

Click OK to start the backup.

Steps to restore a database:

Right-click on the Databases node in Object Explorer.

Select Restore Database.

Choose the Device option and select the backup file you created.

Click OK to restore the database from the backup.
