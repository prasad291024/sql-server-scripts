
-- Project: QA_Testing_DB Setup and Sample Queries

-- 1. Create Database
CREATE DATABASE QA_Testing_DB;
GO

-- 2. Use Database
USE QA_Testing_DB;
GO

-- 3. Create Schema
CREATE SCHEMA qa;
GO

-- 4. Create Tables
CREATE TABLE qa.Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    UserName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) UNIQUE NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);

CREATE TABLE qa.Projects (
    ProjectID INT PRIMARY KEY IDENTITY(1,1),
    ProjectName NVARCHAR(150) NOT NULL,
    StartDate DATE,
    EndDate DATE
);

CREATE TABLE qa.Bugs (
    BugID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    Status NVARCHAR(50) DEFAULT 'Open',
    CreatedBy INT FOREIGN KEY REFERENCES qa.Users(UserID),
    ProjectID INT FOREIGN KEY REFERENCES qa.Projects(ProjectID),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 5. Insert Sample Data
INSERT INTO qa.Users (UserName, Email) VALUES
('Alice Tester', 'alice@example.com'),
('Bob QA', 'bob@example.com');

INSERT INTO qa.Projects (ProjectName, StartDate, EndDate) VALUES
('Project Alpha', '2024-01-01', '2024-12-31'),
('Project Beta', '2024-03-01', '2024-09-30');

INSERT INTO qa.Bugs (Title, Description, CreatedBy, ProjectID) VALUES
('Login page crash', 'App crashes when wrong password is entered.', 1, 1),
('Profile picture upload fails', '500 error when uploading large images.', 2, 2);

-- 6. Select Queries
-- Fetch all users
SELECT * FROM qa.Users;

-- Fetch all projects
SELECT * FROM qa.Projects;

-- Fetch all bugs with user and project info
SELECT b.BugID, b.Title, b.Status, u.UserName, p.ProjectName
FROM qa.Bugs b
JOIN qa.Users u ON b.CreatedBy = u.UserID
JOIN qa.Projects p ON b.ProjectID = p.ProjectID;

-- 7. Update Queries
-- Update bug status
UPDATE qa.Bugs
SET Status = 'Resolved'
WHERE BugID = 1;

-- 8. Delete Queries
-- Delete a user (after setting bugs to NULL or cascade)
-- Example: Set CreatedBy to NULL before delete if needed
ALTER TABLE qa.Bugs
DROP CONSTRAINT [FK__Bugs__CreatedBy];

ALTER TABLE qa.Bugs
ADD CONSTRAINT FK_Bugs_CreatedBy FOREIGN KEY (CreatedBy)
REFERENCES qa.Users(UserID)
ON DELETE SET NULL;

DELETE FROM qa.Users
WHERE UserName = 'Bob QA';

-- 9. Create a View
CREATE VIEW qa.vw_BugSummary AS
SELECT b.BugID, b.Title, b.Status, u.UserName AS Reporter, p.ProjectName
FROM qa.Bugs b
LEFT JOIN qa.Users u ON b.CreatedBy = u.UserID
LEFT JOIN qa.Projects p ON b.ProjectID = p.ProjectID;

-- 10. Create a Stored Procedure
CREATE PROCEDURE qa.usp_GetBugsByStatus
    @Status NVARCHAR(50)
AS
BEGIN
    SELECT * FROM qa.Bugs
    WHERE Status = @Status;
END;
GO

-- 11. Create a Scalar Function
CREATE FUNCTION qa.ufn_GetOpenBugCount()
RETURNS INT
AS
BEGIN
    DECLARE @OpenBugs INT;
    SELECT @OpenBugs = COUNT(*) FROM qa.Bugs WHERE Status = 'Open';
    RETURN @OpenBugs;
END;
GO

-- 12. Testing the Function
SELECT qa.ufn_GetOpenBugCount() AS OpenBugs;

-- 13. Testing the Procedure
EXEC qa.usp_GetBugsByStatus @Status = 'Open';

-- End of Script.
