
														/* USING THE SOFTUNI DATABASE */

/*
01. Create a query that selects:
�	EmployeeId
�	JobTitle
�	AddressId
�	AddressText
Return the first 5 rows sorted by AddressId in ascending order.
Example

			EmployeeId		JobTitle				AddressId		AddressText
			142				Production Technician			1			108 Lakeside Court
			30				Human Resources Manager			2			1341 Prospect St

*/

SELECT * FROM Employees
SELECT * FROM Addresses

SELECT TOP 5 e.EmployeeID, e.JobTitle, e.AddressID, a.AddressText FROM Employees AS e
JOIN Addresses AS a ON e.AddressID = a.AddressID
ORDER BY e.AddressID

/*
2.	Addresses with Towns
Write a query that selects:
�	FirstName
�	LastName
�	Town
�	AddressText
Sort them by FirstName in ascending order, then by LastName. Select the first 50 employees.
Example
				FirstName		LastName		Town				AddressText
				A.Scott			Wright			Newport Hills		1400 Gate Drive
				Alan			Brewer			Kenmore				8192 Seagull Court

*/

SELECT TOP 50 FirstName,LastName, t.Name AS Town, ad.AddressText FROM Employees AS e
JOIN Addresses as ad ON e.AddressID = ad.AddressID
JOIN Towns as t ON ad.TownID = t.TownID
ORDER BY e.FirstName, e.LastName

/*
3.	Sales Employee
Create a query that selects:
�	EmployeeID
�	FirstName
�	LastName
�	DepartmentName
Sort them by EmployeeID in ascending order. Select only employees from the "Sales" department.
Example

		EmployeeID		FirstName		LastName		DepartmentName
		268				Stephen			Jiang				Sales
		273				Brian			Welcker				Sales

*/

SELECT e.EmployeeID,e.FirstName,e.LastName, d.Name as DepartmentName FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'
ORDER BY e.EmployeeID


/*
4.	Employee Departments
Create a query that selects:
�	EmployeeID
�	FirstName 
�	Salary
�	DepartmentName
Filter only employees with a salary higher than 15000. Return the first 5 rows, sorted by DepartmentID in ascending order.
Example

		EmployeeID			FirstName			Salary			DepartmentName
			3     			Roberto				43300.00		Engineering
			9				Gail				32700.00		Engineering

*/

SELECT TOP 5 e.EmployeeID, e.FirstName, e.Salary, d.Name AS DepartmentName FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 15000
ORDER BY d.DepartmentID

/*
5.	Employees Without Project
Create a query that selects:
�	EmployeeID
�	FirstName
Filter only employees without a project. Return the first 3 rows, sorted by EmployeeID in ascending order.
Example
					EmployeeID		FirstName
						2			  Kevin
						6			  David

*/


SELECT TOP 3 
    e.EmployeeID, 
    e.FirstName 
FROM 
    Employees AS e
LEFT JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
WHERE ep.EmployeeID IS NULL
ORDER BY e.EmployeeID ASC;

