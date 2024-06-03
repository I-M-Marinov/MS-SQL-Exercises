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