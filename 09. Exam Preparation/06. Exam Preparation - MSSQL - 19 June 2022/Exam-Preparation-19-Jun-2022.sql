/*
Section 1. DDL (30 pts)
You have been given the E/R Diagram of the Zoo
 
Create a database called Zoo. You need to create 7 tables:
-	Owners - contains information about the owners of the animals;
-	AnimalTypes - contains information about the different animal types in the zoo;
-	Cages - contains information about the animal cages;
-	Animals - contains information about the animals;
-	AnimalsCages - a many-to-many mapping table between the animals and the cages;
-	VolunteersDepartments - contains information about the departments of the volunteers;
-	Volunteers - contains information about the volunteers.

*/


CREATE DATABASE Zoo
GO
USE Zoo
GO 

CREATE TABLE Owners (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
PhoneNumber VARCHAR(15) NOT NULL,
[Address] VARCHAR(50) 
)

CREATE TABLE AnimalTypes (
Id INT PRIMARY KEY IDENTITY,
AnimalType VARCHAR(30) NOT NULL
)

CREATE TABLE Cages (
Id INT PRIMARY KEY IDENTITY,
AnimalTypeId INT NOT NULL,
CONSTRAINT FK_Cages_AnimalTypes FOREIGN KEY (AnimalTypeId) REFERENCES AnimalTypes(Id)
)

CREATE TABLE Animals (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(30) NOT NULL,
BirthDate DATE NOT NULL,
OwnerId INT,
AnimalTypeId INT NOT NULL
CONSTRAINT FK_Animals_Owners FOREIGN KEY (OwnerId) REFERENCES Owners(Id),
CONSTRAINT FK_Animals_AnimalTypes FOREIGN KEY (AnimalTypeId) REFERENCES AnimalTypes(Id)
)

CREATE TABLE AnimalsCages (
CageId INT NOT NULL,
AnimalId INT NOT NULL,
CONSTRAINT PK_AnimalsCages PRIMARY KEY (CageId, AnimalId),
CONSTRAINT FK_AnimalsCages_Cages FOREIGN KEY (CageId) REFERENCES Cages(Id),
CONSTRAINT FK_AnimalsCages_Animals FOREIGN KEY (AnimalId) REFERENCES Animals(Id)
)

CREATE TABLE VolunteersDepartments (
Id INT PRIMARY KEY IDENTITY,
DepartmentName VARCHAR(30) NOT NULL
)

CREATE TABLE Volunteers (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
PhoneNumber VARCHAR(15) NOT NULL,
[Address] VARCHAR(50),
AnimalId INT,
DepartmentId INT NOT NULL,
CONSTRAINT FK_Volunteers_Animals FOREIGN KEY (AnimalId) REFERENCES Animals(Id),
CONSTRAINT FK_Volunteers_VolunteersDepartments FOREIGN KEY (DepartmentId) REFERENCES VolunteersDepartments(Id)
)


/*
															Section 2. DML (10 pts)
Before you start you have to import "01. DDL_Dataset.sql ". 
If you have created the structure correctly the data should be successfully inserted. 
In this section, you have to do some data manipulations:

2.	Insert
Let's insert some sample data into the database. Write a query to add the following records into the corresponding tables. All Ids should be auto-generated.



				Volunteers
				Name				PhoneNumber			Address						AnimalId			DepartmentId
				Anita Kostova		0896365412			Sofia, 5 Rosa str.				15					1
				Dimitur Stoev		0877564223			null							42					4
				Kalina Evtimova		0896321112			Silistra, 21 Breza str.			9					7
				Stoyan Tomov		0898564100			Montana, 1 Bor str.				18					8
				Boryana Mileva		0888112233			null							31					5


				Animals
				Name						BirthDate			OwnerId			AnimalTypeId
				Giraffe						2018-09-21			   21				1
				Harpy Eagle					2015-04-17			   15				3
				Hamadryas Baboon			2017-11-02			   null			    1
				Tuatara						2021-06-30			   2				4

*/


INSERT INTO Volunteers ([Name], PhoneNumber, [Address], AnimalId, DepartmentId)
VALUES ('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
	   ('Dimitur Stoev', '0877564223', NULL, 42, 4),
	   ('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
	   ('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
	   ('Boryana Mileva', '0888112233', NULL, 31, 5)

INSERT INTO Animals ([Name], BirthDate, OwnerId, AnimalTypeId)
VALUES ('Giraffe', '2018-09-21', 21, 1),
	   ('Harpy Eagle', '2015-04-17', 15, 3),
	   ('Hamadryas Baboon', '2017-11-02', NULL, 1),
	   ('Tuatara', '2021-06-30', 2, 4)


/*
3.	Update
Kaloqn Stoqnov (a current owner, present in the database) came to the zoo to adopt all the animals,
who don't have an owner. Update the records by putting to those animals the correct OwnerId.

*/

UPDATE Animals
SET OwnerId = 4
WHERE OwnerId IS NULL

/*
4.	Delete
The Zoo decided to close one of the Volunteers Departments - Education program assistant.
Your job is to delete this department from the database. 

NOTE: Keep in mind that there could be foreign key constraint conflicts!
*/


DELETE FROM Volunteers WHERE DepartmentId = 2;
DELETE FROM VolunteersDepartments WHERE DepartmentName = 'Education program assistant';


/*
																	Section 3. Querying (40 pts)
You need to start with a fresh dataset, so recreate your DB and import the sample data again (01. DDL_Dataset.sql). 
DO NOT CHANGE OR INCLUDE DATA FROM DELETE, INSERT AND UDATE TASKS!!!

5.	Volunteers
Extract information about all the Volunteers – name, phone number, address, id of the animal, 
they are responsible to and id of the department they are involved into. 
Order the result by name of the volunteer (ascending), then by the id of the animal (ascending) and then by the id of the department (ascending).

Example

				Name					PhoneNumber		Address							AnimalId		DepartmentId
				Anton Antonov			0877456123		Varna, 2 Dobrotitsa str.			11				3
				Boyan Boyanov			0896321546		Plovdiv, 15 Arda str.				14				1
				Darina Petrova			0889654236		Sofia, 39 Bratya Buxton str.		31				3
				Dilyana Stoeva			0889412025		Sofia, 15 Lyulyak str.				NULL			2
				Dimitrichka Stateva	    0888632123		Sofia, 26 Vasil Levski str.			7				8
				Gabriel Radkov			0889745102		Sliven, 6 Krim str.					18				5
*/


SELECT 
[Name],
PhoneNumber,
[Address],
AnimalId,
DepartmentId
FROM Volunteers 
ORDER BY [Name], AnimalId, DepartmentId

/*
6.	Animals data
Select all animals and their type. Extract name, animal type and birth date (in format 'dd.MM.yyyy'). Order the result by animal's name (ascending).
Example

					Name							AnimalType				BirthDate
					African Penguin					Birds					17.07.2017
					African Spurred Tortoise		Reptiles				26.09.2009
					American Kestrel				Birds					27.04.2019
					Anaconda						Reptiles				13.07.2016
					Axolotl							Amphibians				21.01.2019
					Bald Eagle						Birds					29.06.2014
*/

SELECT
a.[Name],
[at].AnimalType,
FORMAT(a.Birthdate,'dd.MM.yyyy') AS Birthdate
FROM Animals AS a
JOIN AnimalTypes AS [at] ON at.Id = a.AnimalTypeId
ORDER BY a.[Name]

/*
7.	Owners and Their Animals
Extract the animals for each owner. Find the top 5 owners, who have the biggest count of animals. 
Select the owner's name and the count of the animals he owns. 
Order the result by the count of animals owned (descending) and then by the owner's name.

Example

			Owner				CountOfAnimals
			Kaloqn Stoqnov				4
			Kiril Peshev				4
			Kamelia Yancheva			3
			Martin Genchev				3
			Metodi Dimitrov				3

*/


SELECT TOP 5
o.[Name] AS [Owner],
COUNT(a.OwnerId) AS CountOfAnimals
FROM Owners AS o
JOIN Animals AS a ON a.OwnerId = o.Id
GROUP BY o.[Name]
ORDER BY COUNT(a.OwnerId) DESC, o.[Name]

/*
8.	Owners, Animals and Cages
Extract information about the owners of mammals, the name of their animal and in which cage these animals are. 
Select owner's name and animal's name (in format 'owner-animal'), owner's phone number and the id of the cage. 
Order the result by the name of the owner (ascending) and then by the name of the animal (descending).

Example

			OwnersAnimals						PhoneNumber			  CageId
			Anelia Mihova-Koala					0897856147				16
			Borislava Kamenova-Fennec Fox		0877477112				21
			Gergana Mancheva-Brown bear			0897412123				26
			Kaloqn Stoqnov-Leopard				0878325642				32
			Kaloqn Stoqnov-Elephant				0878325642				37
			Kamelia Yancheva-Lion				0876213799				7
*/


SELECT 
CONCAT(o.[Name],'-',a.[Name]) AS OwnersAnimals,
o.PhoneNumber,
c.Id AS CageId
FROM Owners AS o
JOIN Animals AS a ON a.OwnerId = o.Id
JOIN AnimalsCages AS ac ON ac.AnimalId = a.Id
JOIN Cages AS c ON c.Id = ac.CageId
JOIN AnimalTypes AS at ON at.Id = a.AnimalTypeId
WHERE at.AnimalType = 'Mammals'
GROUP BY o.[Name], a.[Name], o.PhoneNumber, c.Id
ORDER BY o.[Name], a.[Name] DESC


/*
9.	Volunteers in Sofia
Extract information about the volunteers, involved in 'Education program assistant' department, who live in Sofia. 
Select their name, phone number and their address in Sofia (skip city's name). 
Order the result by the name of the volunteers (ascending).
Example

			Name					PhoneNumber			Address
			Dilyana Stoeva			0889412025			15 Lyulyak str.
			Kiril Kostadinov		0896541233			213 Tsarigradsko shose str.
			Yanko Totev				0896369258			54 Hristo Botev str.
			Zdravko Asenov			0889652365			6 Neven str.

*/

SELECT
v.[Name],
v.PhoneNumber,
SUBSTRING(v.[Address], CHARINDEX(', ', v.[Address]) + 1, LEN(v.[Address])) AS [Address]
FROM Volunteers AS v
WHERE v.[Address] LIKE '%Sofia%' AND v.DepartmentId = 2
ORDER BY v.[Name]

/*
10.	Animals for Adoption
Extract all animals, who does not have an owner and are younger than 5 years (5 years from '01/01/2022'), except for the Birds. 
Select their name, year of birth and animal type. Order the result by animal's name.
Example

				Name					BirthYear			AnimalType
				Banded Archer Fish	      2022				Fish
				Chameleon			      2018				Reptiles
				Desert Hairy Scorpion     2020				Invertebrates
				Goliath Frog		      2020				Amphibians
				Koi					      2021				Fish
				Poison Frog			      2020				Amphibians

*/

SELECT 
a.[Name],
YEAR(a.BirthDate) AS BirthYear,
[at].AnimalType
FROM Animals AS a
JOIN AnimalTypes AS [at] ON [at].Id = a.AnimalTypeId
WHERE a.OwnerId IS NULL 
AND DATEDIFF(YEAR, a.Birthdate, '2022-01-01') < 5 
AND [at].AnimalType <> 'Birds'
ORDER BY a.[Name]

/*
																Section 4. Programmability (20 pts)
11.	All Volunteers in a Department
Create a user-defined function named udf_GetVolunteersCountFromADepartment (@VolunteersDepartment) 
that receives a department and returns the count of volunteers, who are involved in this department.

Examples
																		Query

									SELECT dbo.udf_GetVolunteersCountFromADepartment ('Education program assistant')

																		Output

																		  6
*/


SELECT * FROM Animals
SELECT * FROM AnimalsCages
SELECT * FROM AnimalTypes
SELECT * FROM Owners
SELECT * FROM Volunteers
SELECT * FROM VolunteersDepartments

CREATE FUNCTION udf_GetVolunteersCountFromADepartment(@VolunteersDepartment VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @countOfParticipants INT;
    SELECT @countOfParticipants = COUNT(v.DepartmentId)
    FROM Volunteers AS v
	JOIN VolunteersDepartments AS vd ON vd.Id = v.DepartmentId
    WHERE vd.DepartmentName = @VolunteersDepartment;
	RETURN @countOfParticipants
END;

SELECT dbo.udf_GetVolunteersCountFromADepartment ('Education program assistant') AS [Output] -- Output: 6
SELECT dbo.udf_GetVolunteersCountFromADepartment ('Guest engagement') AS [Output] -- Output: 4
SELECT dbo.udf_GetVolunteersCountFromADepartment ('Zoo events') AS [Output] -- Output: 5