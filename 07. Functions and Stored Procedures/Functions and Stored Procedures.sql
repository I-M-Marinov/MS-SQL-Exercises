
										/*			Queries for SoftUni Database			*/

/*
1.	Employees with Salary Above 35000
Create stored procedure usp_GetEmployeesSalaryAbove35000 that returns all employees' first and last names, whose salary above 35000. 
Example

		First Name		Last Name

		 Roberto		Tamburello
		  David			Bradley
		  Terri			Duffy
*/

CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
BEGIN
    SELECT FirstName, LastName
    FROM Employees
    WHERE Salary > 35000;
END;

EXEC usp_GetEmployeesSalaryAbove35000

/*
2.	Employees with Salary Above Number
Create a stored procedure usp_GetEmployeesSalaryAboveNumber that accepts a number (of type DECIMAL(18,4)) 
as parameter and returns all employees' first and last names, whose salary is above or equal to the given number. 

Example

Supplied number for that example is 48100.

		First Name	Last Name
		  Terri		Duffy
		  Jean		Trenary
		  Ken		Sanchez
*/

CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber
@SalaryInput DECIMAL(18,4)
AS
BEGIN
    SELECT FirstName, LastName
    FROM Employees
    WHERE Salary >= @SalaryInput;
END;

EXEC usp_GetEmployeesSalaryAboveNumber @SalaryInput = 123.4567;

/*
3.	Town Names Starting With
Create a stored procedure usp_GetTownsStartingWith that accepts a string as parameter and returns all town names starting with that string. 

Example

Here is the list of all towns starting with "b".

		Town
		Bellevue
		Bothell
		Bordeaux
		Berlin
*/

CREATE PROCEDURE usp_GetTownsStartingWith
    @StringInput NVARCHAR(50) 
AS
BEGIN
    SELECT [Name] AS Town
    FROM Towns
    WHERE [Name] LIKE @StringInput + '%';
END;

DROP PROC usp_GetTownsStartingWith

EXEC usp_GetTownsStartingWith @StringInput = 'C';

/*
4.	Employees from Town
Create a stored procedure usp_GetEmployeesFromTown that accepts town name as parameter and returns the first and last name of those employees, who live in the given town. 
Example
Here it is a list of employees, living in Sofia.

		First Name	Last Name
		 Svetlin	 Nakov
		 Martin		 Kulov
		 George		 Denchev
*/

CREATE OR ALTER PROCEDURE usp_GetEmployeesFromTown
    @stringInput NVARCHAR(50) 
AS
BEGIN
    SELECT FirstName, LastName
    FROM Employees AS e
	JOIN Addresses AS addr ON e.AddressID = addr.AddressID	
	JOIN Towns AS t ON addr.TownID = t.TownID 
    WHERE t.[Name] LIKE @StringInput;
END;

EXEC usp_GetEmployeesFromTown @StringInput = 'Sofia';

/*
5.	Salary Level Function
Create a function udf_GetSalaryLevel(@salary DECIMAL(18,4)) that receives salary of an employee and returns the level of the salary.
•	If salary is < 30000, return "Low"
•	If salary is between 30000 and 50000 (inclusive), return "Average"
•	If salary is > 50000, return "High"
Example
		Salary			Salary Level
		13500.00			Low
		43300.00			Average
		125500.00			High
*/

CREATE FUNCTION dbo.ufn_GetSalaryLevel (@salary DECIMAL(18,4))  -- SoftUni Judge does not like the convention which is dbo.udf_GetSalaryLevel
RETURNS NVARCHAR(10)
AS 
BEGIN
	DECLARE @result NVARCHAR(10)
	IF (@salary < 30000)
	BEGIN
		SET @result = 'Low'
	END
	ELSE IF (@salary BETWEEN 30000 AND 50000)
	BEGIN
		SET @result = 'Average'
	END
	ELSE
	BEGIN
		SET @result = 'High'
	END
	RETURN @result
END

SELECT Salary, dbo.ufn_GetSalaryLevel(Salary) AS [Salary Level] FROM Employees
ORDER BY Salary


/*
6.	Employees by Salary Level
Create a stored procedure usp_EmployeesBySalaryLevel that receives as parameter level of salary (low, average, or high) and print the names of all employees, 
who have the given level of salary. 

You should use the function - "dbo.ufn_GetSalaryLevel(@Salary)", which was part of the previous task, inside your "CREATE PROCEDURE …" query.
Example
Here is the list of all employees with a high salary.

		First Name		Last Name
		  Terri			  Duffy
		  Jean			  Trenary
		   Ken			  Sanchez
*/

CREATE PROCEDURE usp_EmployeesBySalaryLevel(@levelOfSalary NVARCHAR(10))
AS
BEGIN
		SELECT FirstName AS [First Name], LastName AS [Last Name] FROM Employees AS e
		WHERE @levelOfSalary = dbo.ufn_GetSalaryLevel(e.Salary);
END;

EXEC usp_EmployeesBySalaryLevel @levelOfSalary = 'Low';


/*
7.	Define Function
Define a function ufn_IsWordComprised(@setOfLetters, @word) that returns true or false, depending on that if the word is comprised of the given set of letters. 
Example

		SetOfLetters		Word		Result
		 oistmiahf			Sofia			1
		 oistmiahf			halves			0
			bobr			Rob				1
			pppp			Guy				0
*/

CREATE OR ALTER FUNCTION dbo.ufn_IsWordComprised(@setOfLetters VARCHAR(20), @word VARCHAR(30))
RETURNS BIT
AS
BEGIN
	DECLARE @WordLenght INT = LEN(@word)
    DECLARE @i INT = 1
	DECLARE @result BIT = 1  

	WHILE(@i <= @WordLenght)
		BEGIN
			IF(CHARINDEX(SUBSTRING(@word, @i, 1), @setOfLetters) = 0)
			BEGIN
				RETURN 0
			END
			SET @i += 1
		END 
	RETURN 1
END;


SELECT 'oistmiahf' AS SetOfLetters, 'Sofia' AS Word, dbo.ufn_IsWordComprised('oistmiahf', 'Sofia') AS Result,
	   'oistmiahf' AS SetOfLetters, 'halves' AS Word, dbo.ufn_IsWordComprised('oistmiahf', 'halves') AS Result,
	   'bobr' AS SetOfLetters, 'Rob' AS Word, dbo.ufn_IsWordComprised('bobr', 'Rob') AS Result,
	   'oalak' AS SetOfLetters, 'Koalaa' AS Word, dbo.ufn_IsWordComprised('bobr', 'Rob') AS Result,
	   'pppp' AS SetOfLetters, 'Guy' AS Word, dbo.ufn_IsWordComprised('pppp', 'Guy') AS Result;

SELECT  dbo.ufn_IsWordComprised('oistmiahf', 'Sofia') AS Result
SELECT  dbo.ufn_IsWordComprised('oistmiahf', 'halves') AS Result
SELECT  dbo.ufn_IsWordComprised('bobr', 'Rob') AS Result
SELECT  dbo.ufn_IsWordComprised('pppp', 'Guy') AS Result
SELECT  dbo.ufn_IsWordComprised('tbober', 'Robert') AS Result

/*
8.	Delete Employees and Departments
Create a procedure with the name usp_DeleteEmployeesFromDepartment (@departmentId INT) which deletes all Employees from a given department.
Delete these departments from the Departments table too. Finally, SELECT the number of employees from the given department. 
If the delete statements are correct the select query should return 0.
After completing that exercise restore your database to revert all changes.

Hint:
You may set ManagerID column in Departments table to nullable (using query "ALTER TABLE …").
*/


CREATE PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
BEGIN
	DECLARE @deletedEmployees TABLE (Id INT)

	INSERT INTO @deletedEmployees 
	SELECT EmployeeID
	FROM Employees
	WHERE DepartmentID = @departmentId

	ALTER TABLE Departments
	ALTER COLUMN ManagerID INT 

	UPDATE Departments
	SET ManagerID = NULL
	WHERE ManagerID IN ( SELECT Id FROM @deletedEmployees )

	UPDATE Employees
	SET ManagerID = NULL
	WHERE ManagerID IN ( SELECT Id FROM @deletedEmployees )

	DELETE FROM EmployeesProjects
	WHERE EmployeeID IN ( SELECT Id FROM @deletedEmployees )

	DELETE FROM Employees
	WHERE DepartmentID = @departmentId

	DELETE FROM Departments
	WHERE DepartmentID = @departmentId

	SELECT COUNT(*) FROM Employees
	WHERE DepartmentID = @departmentId

END;

				/*                   Part II – Queries for Bank Database                     */


/*
9.	Find Full Name

You are given a database schema with tables:
AccountHolders(Id (PK), FirstName, LastName, SSN) and Accounts(Id (PK), AccountHolderId (FK), Balance).  
Write a stored procedure usp_GetHoldersFullName that selects the full name of all people. 

Example
			Full Name
			Susan Cane
			Kim Novac
			Jimmy Henderson
*/


CREATE PROCEDURE usp_GetHoldersFullName 
AS
BEGIN
	SELECT FirstName + ' ' + LastName AS [Full Name]
    FROM AccountHolders
END;

EXEC usp_GetHoldersFullName 

/*
10.	People with Balance Higher Than
Your task is to create a stored procedure usp_GetHoldersWithBalanceHigherThan that accepts 
a number as a parameter and returns all the people, who have more money in total in all their accounts than the supplied number. 
Order them by their first name, then by their last name.
Example

			First Name		Last Name
			  Monika	     Miteva
			  Petar	         Kirilov
*/

CREATE OR ALTER PROCEDURE usp_GetHoldersWithBalanceHigherThan 
    @numberInput DECIMAL(18,2)
AS
BEGIN
    SELECT FirstName AS [First Name], LastName AS [Last Name]
    FROM AccountHolders AS a
	JOIN Accounts AS acc ON a.Id = acc.AccountHolderId
	GROUP BY a.FirstName, a.LastName
    HAVING SUM(acc.Balance) > @numberInput
	ORDER BY a.FirstName, a.LastName
END;

EXEC usp_GetHoldersWithBalanceHigherThan 35000.23

/*
11.	Future Value Function
Your task is to create a function ufn_CalculateFutureValue that accepts as parameters – sum (decimal), yearly interest rate (float), and the number of years (int). 
It should calculate and return the future value of the initial sum rounded up to the fourth digit after the decimal delimiter.Use the following formula:

FV = I×((1+R)^T)  ( ^T = POWER )

•	I – Initial sum
•	R – Yearly interest rate
•	T – Number of years

Input	Output
Initial sum: 1000
Yearly Interest rate: 10%
years: 5
ufn_CalculateFutureValue(1000, 0.1, 5)	1610.5100

*/

CREATE OR ALTER FUNCTION ufn_CalculateFutureValue (
    @sum DECIMAL(10,4), 
    @yearlyInterestRate FLOAT, 
    @numberOfYears INT
)
RETURNS DECIMAL(10,4)
AS
BEGIN
    DECLARE @result DECIMAL(18,4); 

    SET @result = @sum * POWER((1 + @yearlyInterestRate), @numberOfYears); -- FV = I×((1+R)^T) 

    RETURN ROUND(@result, 4); -- Round to the fourth digit after the decimal delimiter
END;

DECLARE @futureValue DECIMAL(18,4); -- declare a variable 
SET @futureValue = dbo.ufn_CalculateFutureValue(1000, 0.1, 5); -- use the function to store the result in the varible 
SELECT @futureValue AS FutureValue; -- Visualize the variable by selecting its value

/*
12.	Calculating Interest
Your task is to create a stored procedure usp_CalculateFutureValueForAccount that uses the function from the 
previous problem to give an interest to a person's account for 5 years, along with information about 
their account id, first name, last name and current balance as it is shown in the example below. 
It should take the AccountId and the interest rate as parameters. Again, you are provided with the dbo.ufn_CalculateFutureValue function, 
which was part of the previous task.

Example

Account Id	First Name	Last Name	Current Balance	 Balance in 5 years
     1			Susan	   Cane			123.12			  198.2860
*/

CREATE OR ALTER PROCEDURE dbo.usp_CalculateFutureValueForAccount(@accountId INT, @interestRate FLOAT)
AS
    SELECT 
        a.Id AS [Account Id], 
        FirstName, LastName,
        Balance AS [Current Balance],
        dbo.ufn_CalculateFutureValue(Balance, @interestRate, 5) AS [Balance in 5 years]
    FROM AccountHolders AS ah
    JOIN Accounts AS a ON  a.AccountHolderId = ah.Id 
    WHERE a.Id = @accountId;


EXEC usp_CalculateFutureValueForAccount 11, 0.1;

											/*              Queries for Diablo Database             */

/*
13.	*Scalar Function: Cash in User Games Odd Rows
Create a function ufn_CashInUsersGames that sums the cash of the odd rows. 
Rows must be ordered by cash in descending order. 
The function should take a game name as a parameter and return the result as a table. 
Submit only your function in.

Execute the function over the following game names, ordered exactly like: "Love in a mist".
Output

								SumCash
								8585.00
Hint
Use ROW_NUMBER to get the rankings of all rows based on order criteria.
*/

CREATE FUNCTION dbo.ufn_CashInUsersGames (@gameName VARCHAR(30))
RETURNS TABLE 
AS
RETURN
(
    SELECT SUM(Cash) AS SumCash
    FROM (
        SELECT Cash, 
        ROW_NUMBER() OVER (ORDER BY Cash DESC) AS RowNumber -- Get the row number and order by CASH DESC 
        FROM UsersGames AS ug
        JOIN Games AS g ON g.Id = ug.GameId 
        WHERE g.[Name] = @gameName -- match the game with the parameter name 
    ) AS Subquery
		WHERE RowNumber % 2 = 1 -- check if the row number is odd 
);

SELECT * FROM UsersGames
WHERE GameId = 49
ORDER BY Cash DESC

SELECT * FROM Games

SELECT * FROM dbo.ufn_CashInUsersGames('Love in a mist');