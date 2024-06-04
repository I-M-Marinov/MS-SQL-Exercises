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
		WHERE @levelOfSalary = ufn_GetSalaryLevel(e.Salary);
END