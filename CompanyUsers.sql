-- CREATE DATABASE DotNetCourseDatabase
-- GO

USE DotNetCourseDatabase
GO

-- CREATE SCHEMA TutorialAppSchema
-- GO

CREATE TABLE TutorialAppSchema.Users
(
    UserId INT
    , FirstName NVARCHAR(255)
    , LastName NVARCHAR(255)
    , Email NVARCHAR(255)
    , Gender NVARCHAR(255)
    , Active BIT
)
GO

CREATE TABLE TutorialAppSchema.UserJobInfo
(
    UserId INT
    , JobTitle NVARCHAR(255)
    , Department NVARCHAR(255)
)
GO

CREATE TABLE TutorialAppSchema.UserSalary
(
    UserId INT
    , Salary DECIMAL(18,3)
)
GO

SELECT * FROM TutorialAppSchema.Users
SELECT * FROM TutorialAppSchema.UserJobInfo
SELECT * FROM TutorialAppSchema.UserSalary

SELECT [Users].[UserId],
    [Users].[FirstName] + ' ' + [Users].[LastName] AS FullName,
    [Users].[Email],
    [Users].[Gender],
    [Users].[Active],
    [UserJobInfo].[JobTitle],
    [UserJobInfo].[Department],
    [UserSalary].[Salary] 
    FROM TutorialAppSchema.Users AS Users
        LEFT JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo
            ON UserJobInfo.UserId = Users.UserID
        JOIN TutorialAppSchema.UserSalary AS UserSalary
            ON UserSalary.UserId = Users.UserId
    WHERE Users.Active = 1

DELETE FROM TutorialAppSchema.UserJobInfo WHERE UserId BETWEEN 250 AND 750