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

SELECT * FROM Animals
SELECT * FROM Owners
SELECT * FROM Volunteers
SELECT * FROM VolunteersDepartments


SELECT TOP 5
o.[Name] AS [Owner],
COUNT(a.OwnerId) AS CountOfAnimals
FROM Owners AS o
JOIN Animals AS a ON a.OwnerId = o.Id
GROUP BY o.[Name]
ORDER BY COUNT(a.OwnerId) DESC, o.[Name]