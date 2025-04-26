-- ==========================================
-- QA Learning SQL Queries Script
-- Author: Wisdom Academy (Extended and Polished)
-- Notes: Practicing basic to advanced SQL for QA
-- Target: SQL Server syntax
-- ==========================================

-- ==========================================
-- DDL (Data Definition Language) - TABLES
-- ==========================================

-- Create table example
CREATE TABLE CustomerInfo (
    CustID INT PRIMARY KEY,
    CustName NVARCHAR(50),
    CustAge INT,
    CustMobile NVARCHAR(20)
);

-- Alter table - add a new column
ALTER TABLE CustomerInfo ADD Gender NVARCHAR(10);

-- Alter table - rename a column
EXEC sp_rename 'CustomerInfo.CustMobile', 'MobileNumber', 'COLUMN';

-- Drop column
ALTER TABLE CustomerInfo DROP COLUMN Gender;

-- Rename table
EXEC sp_rename 'CustomerInfo', 'CustomerInfoDetails';

-- Drop table
DROP TABLE CustomerInfoDetails;

-- ==========================================
-- DML (Data Manipulation Language) - INSERT, UPDATE, DELETE
-- ==========================================

-- Insert rows
INSERT INTO CustomerInfo (CustID, CustName, CustAge, CustMobile)
VALUES (1, 'Alice', 28, '9876543210'),
       (2, 'Bob', 31, '8765432109'),
       (3, 'Charlie', 25, '7654321098');

-- Update a field
UPDATE CustomerInfo
SET CustMobile = '9999999999'
WHERE CustID = 2;

-- Delete a row
DELETE FROM CustomerInfo
WHERE CustID = 3;

-- ==========================================
-- SELECT Queries
-- ==========================================

-- Select all
SELECT * FROM CustomerInfo;

-- Select specific fields
SELECT CustName, CustAge FROM CustomerInfo;

-- Conditional select
SELECT * FROM CustomerInfo WHERE CustAge > 30;

-- ORDER BY ascending
SELECT * FROM CustomerInfo ORDER BY CustName ASC;

-- ORDER BY descending
SELECT * FROM CustomerInfo ORDER BY CustAge DESC;

-- BETWEEN operator
SELECT * FROM CustomerInfo WHERE CustAge BETWEEN 25 AND 35;

-- LIKE operator examples
SELECT * FROM CustomerInfo WHERE CustName LIKE 'A%'; -- Starts with A
SELECT * FROM CustomerInfo WHERE CustName LIKE '%e'; -- Ends with e
SELECT * FROM CustomerInfo WHERE CustName LIKE '%ar%'; -- Contains 'ar'

-- IN operator
SELECT * FROM CustomerInfo WHERE CustAge IN (25, 28);

-- DISTINCT keyword
SELECT DISTINCT CustAge FROM CustomerInfo;

-- TOP keyword (SQL Server way of limiting rows)
SELECT TOP 3 * FROM CustomerInfo;

-- ==========================================
-- Aggregation Functions
-- ==========================================

-- Aggregate examples
SELECT MIN(CustAge) AS MinAge FROM CustomerInfo;
SELECT MAX(CustAge) AS MaxAge FROM CustomerInfo;
SELECT AVG(CustAge) AS AverageAge FROM CustomerInfo;
SELECT SUM(CustAge) AS TotalAge FROM CustomerInfo;
SELECT COUNT(*) AS TotalRecords FROM CustomerInfo;

-- Group by City example
CREATE TABLE SalesData (
    SaleID INT,
    City NVARCHAR(50),
    Amount INT
);

INSERT INTO SalesData (SaleID, City, Amount)
VALUES (1, 'Mumbai', 5000),
       (2, 'Delhi', 3000),
       (3, 'Mumbai', 7000),
       (4, 'Bangalore', 4000);

SELECT City, SUM(Amount) AS TotalSales
FROM SalesData
GROUP BY City;

-- Having clause
SELECT City, SUM(Amount) AS TotalSales
FROM SalesData
GROUP BY City
HAVING SUM(Amount) > 5000;

-- ==========================================
-- Joins
-- ==========================================

-- Create Employee and Department tables
CREATE TABLE Employee (
    EmpID INT,
    EmpName NVARCHAR(50),
    DeptID INT
);

CREATE TABLE Department (
    DeptID INT,
    DeptName NVARCHAR(50)
);

INSERT INTO Employee (EmpID, EmpName, DeptID) VALUES (1, 'John', 1), (2, 'Jane', 2), (3, 'Doe', NULL);
INSERT INTO Department (DeptID, DeptName) VALUES (1, 'HR'), (2, 'Finance'), (3, 'IT');

-- INNER JOIN
SELECT e.EmpName, d.DeptName
FROM Employee e
INNER JOIN Department d ON e.DeptID = d.DeptID;

-- LEFT JOIN
SELECT e.EmpName, d.DeptName
FROM Employee e
LEFT JOIN Department d ON e.DeptID = d.DeptID;

-- RIGHT JOIN
SELECT e.EmpName, d.DeptName
FROM Employee e
RIGHT JOIN Department d ON e.DeptID = d.DeptID;

-- ==========================================
-- Advanced SQL - UNION
-- ==========================================

-- UNION example
SELECT CustName FROM CustomerInfo
UNION
SELECT EmpName FROM Employee;

-- UNION ALL example
SELECT CustName FROM CustomerInfo
UNION ALL
SELECT EmpName FROM Employee;

-- ==========================================
-- Advanced SQL - Row Number (Window Function)
-- ==========================================

-- Using ROW_NUMBER() to rank rows
SELECT EmpName, ROW_NUMBER() OVER (ORDER BY EmpName) AS RowNum
FROM Employee;

-- ==========================================
-- End of File
-- ==========================================
