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

CREATE CLUSTERED INDEX cix_UserSalary_UserId ON TutorialAppSchema.UserSalary(UserId)

CREATE NONCLUSTERED INDEX fix_Users_Active ON TutorialAppSchema.Users(Active) 
    INCLUDE (Email, FirstName, LastName)
        WHERE Active = 1

SELECT * FROM TutorialAppSchema.UserJobInfo AS UserJobInfo
    WHERE EXISTS (
        SELECT * FROM TutorialAppSchema.Users AS Users
            WHERE Users.UserId = UserJobInfo.UserId
        AND UserId <> 7
    )

-- UNION
SELECT * FROM TutorialAppSchema.UserSalary
    WHERE UserId < 500
UNION ALL
SELECT * FROM TutorialAppSchema.UserSalary
    WHERE UserId > 300 AND UserId < 800

-- Aggregate Functions
SELECT ISNULL([UserJobInfo].[Department], 'No Department') AS Department,
    SUM([UserSalary].[Salary]) AS Salary,
    MIN([UserSalary].[Salary]) AS MinSalary,
    MAX([UserSalary].[Salary]) AS MaxSalary,
    AVG([UserSalary].[Salary]) AS AvgSalary,
    COUNT(*) AS PeopleInDepartment,
    STRING_AGG(Users.UserId, ', ') AS UserIds
    FROM TutorialAppSchema.UserSalary AS UserSalary
        JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo
            ON UserSalary.UserId = UserJobInfo.UserId
        JOIN TutorialAppSchema.Users AS Users
            ON UserSalary.UserId = Users.UserId
    WHERE Users.Active = 1
    GROUP BY [UserJobInfo].[Department]
    ORDER BY Salary DESC

SELECT [Users].[UserId],
    [Users].[FirstName] + ' ' + [Users].[LastName] AS FullName,
    [Users].[Active],
    [UserJobInfo].[JobTitle],
    [UserJobInfo].[Department],
    [UserSalary].[Salary],
    DepartmentAverage.AvgSalary
    FROM TutorialAppSchema.Users AS Users
        LEFT JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo
            ON UserJobInfo.UserId = Users.UserID
        JOIN TutorialAppSchema.UserSalary AS UserSalary
            ON UserSalary.UserId = Users.UserId
        -- OUTER APPLY (
        CROSS APPLY (
            SELECT ISNULL([UserJobInfo2].[Department], 'No Department') AS Department,
                AVG([UserSalary2].[Salary]) AS AvgSalary
                FROM TutorialAppSchema.UserSalary AS UserSalary2
                    JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo2
                        ON UserSalary2.UserId = UserJobInfo2.UserId
                WHERE ISNULL([UserJobInfo2].[Department], 'No Department') = ISNULL([UserJobInfo].[Department], 'No Department')
                GROUP BY [UserJobInfo2].[Department]
        ) AS DepartmentAverage
    WHERE Users.Active = 1

SELECT DATEDIFF(YEAR, GETDATE(), DATEADD(YEAR, 3, GETDATE())) AS DifferenceInYears

ALTER TABLE TutorialAppSchema.UserSalary 
    ADD AvgSalary DECIMAL(18,2)

SELECT * FROM TutorialAppSchema.UserSalary

UPDATE UserSalary
    SET UserSalary.AvgSalary = DepartmentAverage.AvgSalary
FROM TutorialAppSchema.UserSalary AS UserSalary
    JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo
            ON UserJobInfo.UserId = UserSalary.UserId
    CROSS APPLY (
            SELECT ISNULL([UserJobInfo2].[Department], 'No Department') AS Department,
                AVG([UserSalary2].[Salary]) AS AvgSalary
                FROM TutorialAppSchema.UserSalary AS UserSalary2
                    JOIN TutorialAppSchema.UserJobInfo AS UserJobInfo2
                        ON UserSalary2.UserId = UserJobInfo2.UserId
                WHERE ISNULL([UserJobInfo2].[Department], 'No Department') = ISNULL([UserJobInfo].[Department], 'No Department')
                GROUP BY [UserJobInfo2].[Department]
        ) AS DepartmentAverage

