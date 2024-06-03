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

CREATE PROCEDURE usp_GetEmployeesFromTown
    @StringInput NVARCHAR(50) 
AS
BEGIN
    SELECT FirstName, LastName
    FROM Employees AS e
	JOIN Addresses AS addr ON e.AddressID = addr.AddressID	
	JOIN Towns AS t ON addr.TownID = t.TownID 
    WHERE t.[Name] LIKE @StringInput;
END;

EXEC usp_GetEmployeesFromTown @StringInput = 'Sofia';