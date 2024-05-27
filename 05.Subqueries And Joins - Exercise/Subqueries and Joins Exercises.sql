
														/* USING THE SOFTUNI DATABASE */

/*
01. Create a query that selects:
•	EmployeeId
•	JobTitle
•	AddressId
•	AddressText
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
•	FirstName
•	LastName
•	Town
•	AddressText
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

