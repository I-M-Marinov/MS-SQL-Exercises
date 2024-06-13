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
