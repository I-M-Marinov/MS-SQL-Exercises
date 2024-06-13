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


