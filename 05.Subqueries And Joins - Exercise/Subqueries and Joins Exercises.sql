
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

/*
3.	Sales Employee
Create a query that selects:
•	EmployeeID
•	FirstName
•	LastName
•	DepartmentName
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
•	EmployeeID
•	FirstName 
•	Salary
•	DepartmentName
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
•	EmployeeID
•	FirstName
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

/*
6.	Employees Hired After
Create a query that selects:
•	FirstName
•	LastName
•	HireDate
•	DeptName
Filter only employees hired after 1.1.1999 and are from either "Sales" or "Finance" department. Sort them by HireDate (ascending).
Example

			FirstName		LastName			HireDate				DeptName
			Debora     		Poe				2001-01-19 00:00:00			Finance
			Wendy			Kahn			2001-01-26 00:00:00			Finance

*/

SELECT e.FirstName,e.LastName,e.HireDate, dpt.Name AS DeptName FROM Employees AS e
JOIN Departments AS dpt ON e.DepartmentID = dpt.DepartmentID
WHERE e.HireDate > '1999-01-01' AND dpt.Name IN ('Sales', 'Finance')
ORDER BY e.HireDate


/*
7.	Employees with Project
Create a query that selects:
•	EmployeeID
•	FirstName
•	ProjectName
Filter only employees with a project which has started after 13.08.2002 and it is still ongoing (no end date). Return the first 5 rows sorted by EmployeeID in ascending order.
Example
EmployeeID	FirstName	ProjectName
1	Guy	Racing Socks
1	Guy	Road Bottle Cage
…	…	…

*/


SELECT TOP 5 e.EmployeeID, e.FirstName, pr.Name AS ProjectName FROM Employees AS e
JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects AS pr ON ep.ProjectID = pr.ProjectID
WHERE pr.StartDate > '2002-08-13' AND pr.EndDate IS NULL 
ORDER BY e.EmployeeID


/*
8.	Employee 24
Create a query that selects:
•	EmployeeID
•	FirstName
•	ProjectName
Filter all the projects of employee with Id 24. If the project has started during or after 2005 the returned value should be NULL.
Example
EmployeeID	FirstName	ProjectName
24	David	NULL
24	David	Road-650
…	…	…

*/

SELECT
 e.EmployeeID, 
    e.FirstName, 
    CASE 
        WHEN pr.StartDate >= '2005-01-01' THEN NULL -- return null if any of the projects are started during or after 2005
        ELSE pr.Name -- else return the name of the project as expected 
    END AS ProjectName -- show the column as "ProjectName"
	FROM Employees AS e
JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects AS pr ON ep.ProjectID = pr.ProjectID
WHERE e.EmployeeID = 24;

/*
9.	Employee Manager
Create a query that selects:
•	EmployeeID
•	FirstName
•	ManagerID
•	ManagerName
Filter all employees with a manager who has ID equals to 3 or 7. Return all the rows, sorted by EmployeeID in ascending order.
Example

			EmployeeID	FirstName	ManagerID	ManagerName
				4			Rob			3		Roberto
				9			Gail		3		Roberto
*/

SELECT e.EmployeeID, e.FirstName, e.ManagerID, m.FirstName AS ManagerName 
FROM Employees AS e
JOIN Employees AS m 
ON e.ManagerID = m.EmployeeID
WHERE m.EmployeeID IN (3,7)
ORDER BY e.EmployeeID

/*
10.	Employees Summary
Create a query that selects:
•	EmployeeID
•	EmployeeName
•	ManagerName
•	DepartmentName
Show the first 50 employees with their managers and the departments they are in (show the departments of the employees). Order them by EmployeeID.
Example

		EmployeeID	EmployeeName		ManagerName			DepartmentName
			1		Guy Gilbert			Jo Brown			Production
			2		Kevin Brown			David Bradley		Marketing
			3		Roberto Tamburello	Terri Duffy			Engineering
*/

SELECT TOP 50 
e.EmployeeID,
CONCAT_WS(' ', e.FirstName, e.LastName ) as EmployeeName,
CONCAT_WS(' ', m.FirstName, m.LastName ) as ManagerName,
d.Name AS DepartmentName
FROM Employees AS e
JOIN Employees AS m ON e.ManagerID = m.EmployeeID
JOIN Departments as d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID

/*
11.	Min Average Salary
Create a query that returns the value of the lowest average salary of all departments.
Example

MinAverageSalary
10866.6666

*/

SELECT TOP 1
    sub.MinAverageSalary
FROM 
    Departments AS d
JOIN 
    (
        SELECT e.DepartmentID, AVG(e.Salary) AS MinAverageSalary
        FROM Employees AS e
        GROUP BY e.DepartmentID
    ) AS sub ON d.DepartmentID = sub.DepartmentID
ORDER BY 
    sub.MinAverageSalary;

												/* GEOGRAPHY DATABASE */

/*
12.	Highest Peaks in Bulgaria
Create a query that selects:
•	CountryCode
•	MountainRange
•	PeakName
•	Elevation
Filter all the peaks in Bulgaria, which have elevation over 2835. Return all the rows, sorted by elevation in descending order.
Example

CountryCode	MountainRange	PeakName	Elevation
BG	Rila	Musala	2925
BG	Pirin	Vihren	2914


*/


SELECT * FROM Mountains

SELECT c.CountryCode, m.MountainRange, p.PeakName, p.Elevation FROM Countries AS c
JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
JOIN Mountains AS m ON m.Id = mc.MountainId
JOIN Peaks AS p ON p.MountainId = m.Id
WHERE p.Elevation > 2835 AND c.CountryCode = 'BG'
ORDER BY p.Elevation DESC

/*
13.	Count Mountain Ranges
Create a query that selects:
•	CountryCode
•	MountainRanges
Filter the count of the mountain ranges in the United States, Russia and Bulgaria.
Example

		CountryCode		MountainRanges
			BG				6
			RU				1

*/

SELECT c.CountryCode, COUNT(m.MountainRange) AS MountainRanges FROM Countries AS c
JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
JOIN Mountains AS m ON m.Id = mc.MountainId
WHERE c.CountryCode IN ('BG', 'US','RU')
GROUP BY c.CountryCode


/*
14.	Countries With or Without Rivers
Create a query that selects:
•	CountryName
•	RiverName
Find the first 5 countries with or without rivers in Africa. Sort them by CountryName in ascending order.
Example
			CountryName			RiverName
			Algeria				Niger
			Angola				Congo
			Benin				Niger
			Botswana			NULL
			Burkina Faso		Niger

*/

SELECT * FROM Rivers
SELECT * FROM Countries

SELECT TOP 5 c.CountryName, r.RiverName FROM Countries AS c
FULL OUTER JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
FULL OUTER JOIN Rivers AS r ON r.Id = cr.RiverId
WHERE c.ContinentCode ='AF'
ORDER BY c.CountryName

/*
15.	*Continents and Currencies
Create a query that selects:
•	ContinentCode
•	CurrencyCode
•	CurrencyUsage
Find all continents and their most used currency. Filter any currency, which is used in only one country. Sort your results by ContinentCode.
Example

ContinentCode	CurrencyCode	CurrencyUsage
	AF				XOF				8
	AS				AUD				2
	AS				ILS				2
	EU				EUR				26
	NA				XCD				8
	OC				USD				8

*/

SELECT * FROM Continents
SELECT * FROM Currencies
SELECT * FROM Countries



WITH CurrencyUsage AS (
    SELECT
        c.ContinentCode,
        c.CurrencyCode,
        COUNT(*) AS CurrencyUsage
    FROM Countries AS c
    JOIN Currencies AS curr ON c.CurrencyCode = curr.CurrencyCode
    JOIN Continents AS cont ON c.ContinentCode = cont.ContinentCode
    GROUP BY c.ContinentCode, c.CurrencyCode
    HAVING COUNT(*) > 1
),
MaxUsage AS (
    SELECT
        ContinentCode,
        MAX(CurrencyUsage) AS MaxUsageCount
    FROM CurrencyUsage
    GROUP BY ContinentCode
)
SELECT
    cu.ContinentCode,
    cu.CurrencyCode,
    cu.CurrencyUsage
FROM CurrencyUsage cu
JOIN MaxUsage mu ON cu.ContinentCode = mu.ContinentCode AND cu.CurrencyUsage = mu.MaxUsageCount
ORDER BY cu.ContinentCode;


/*
16.	Countries Without Any Mountains
Create a query that returns the count of all countries, which don’t have a mountain.
Example

Count
231

*/


SELECT COUNT(c.CountryCode) AS [Count] 
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m ON m.Id = mc.MountainId
WHERE mc.CountryCode IS NULL;

/*
17.	Highest Peak and Longest River by Country
For each country, find the elevation of the highest peak and the length of the longest river, sorted by the highest peak elevation (from highest to lowest), then by the longest river length (from longest to smallest), then by country name (alphabetically). Display NULL when no data is available in some of the columns. Limit only the first 5 rows.
Example

CountryName			HighestPeakElevation		LongestRiverLength
	China					8848					6300
	India					8848					3180
	Nepal					8848					2948
	Pakistan				8611					3180
	Argentina				6962					4880

*/

WITH HighestPeaks AS (
    SELECT
        c.CountryCode,
        c.CountryName,
        MAX(p.Elevation) AS HighestPeakElevation
    FROM
        Countries AS c
    FULL OUTER JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
	FULL OUTER JOIN Mountains AS m ON mc.MountainId = m.Id
    FULL OUTER JOIN Peaks AS p ON m.Id = p.MountainId
    GROUP BY
        c.CountryCode, c.CountryName
),
LongestRivers AS (
    SELECT
        c.CountryCode,
        MAX(r.Length) AS LongestRiverLength
    FROM
        Countries AS c
    FULL OUTER JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
   FULL OUTER JOIN Rivers AS r ON cr.RiverId = r.Id
    GROUP BY
        c.CountryCode
)
SELECT TOP 5
    c.CountryName,
    hp.HighestPeakElevation,
    lr.LongestRiverLength
FROM
    Countries AS c
FULL OUTER JOIN HighestPeaks AS hp ON c.CountryCode = hp.CountryCode
FULL OUTER JOIN LongestRivers AS lr ON c.CountryCode = lr.CountryCode
ORDER BY
    hp.HighestPeakElevation DESC,
    lr.LongestRiverLength DESC,
    c.CountryName;

/*
	18.	Highest Peak Name and Elevation by Country
For each country, find the name and elevation of the highest peak, along with its mountain. When no peaks are available in some countries, display elevation 0, "(no highest peak)" as peak name and "(no mountain)" as a mountain name. When multiple peaks in some countries have the same elevation, display all of them. Sort the results by country name alphabetically, then by highest peak name alphabetically. Limit only the first 5 rows.
Example
Country	Highest Peak Name	Highest Peak Elevation	Mountain
Afghanistan	(no highest peak)	0	(no mountain)
…	…	…	…
Argentina	Aconcagua	6962	Andes
…	…	…	…
Bulgaria	Musala	2925	Rila
Burkina Faso	(no highest peak)	0	(no mountain)
…	…	…	…
United States	Mount McKinley	6194	Alaska Range

*/


