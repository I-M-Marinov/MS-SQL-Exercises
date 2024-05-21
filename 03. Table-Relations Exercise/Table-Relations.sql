USE [Table-Relations]

SELECT * FROM Persons
SELECT * FROM Passports

DROP TABLE Persons
DROP TABLE Passports

----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
/*
1.	One-To-One Relationship
Create two tables and use appropriate data types.
Example
				Persons														Passports
PersonID		FirstName		Salary						PassportID		PassportID	PassportNumber
	1  			Roberto			43300.00						102				101			N34FG21B
	2			Tom				56100.00						103				102			K65LO4R7
	3			Yana			60200.00						101				103			ZE657QP2

Insert the data from the example above. Alter the Persons table and make PersonID a primary key. 
Create a foreign key between Persons and Passports by using the PassportID column.


*/



CREATE TABLE Passports(
PassportID INT PRIMARY KEY IDENTITY(101,1),
PassportNumber VARCHAR(8)
)

CREATE TABLE Persons(
  PersonID INT IDENTITY PRIMARY KEY,
  FirstName VARCHAR(20) NOT NULL,
  Salary DECIMAL(7,2),
  PassportID INT,
  CONSTRAINT FK_Persons_Passports FOREIGN KEY (PassportID)
  REFERENCES Passports(PassportID)
)


INSERT INTO Passports (PassportNumber)
VALUES ('N34FG21B'),
	   ('K65LO4R7'),
	   ('ZE657QP2')

INSERT INTO Persons (FirstName, Salary, PassportID)
VALUES ('Roberto', 43300.00, 102),
	   ('Tom', 56100.00, 103),
	   ('Yana', 60200.00, 101)


----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------

/* 
2.	One-To-Many Relationship
Create two tables and use appropriate data types.
Example

				Models												Manufacturers
ModelID			Name		ManufacturerID			ManufacturerID			Name		EstablishedOn
	101			X1				1							1				BMW				07/03/1916
	102			i6				1							2				Tesla			01/01/2003
	103			Model S			2							3				Lada			01/05/1966
	104			Model X			2		
	105			Model 3			2		
	106			Nova			3		

Insert the data from the example above and add primary keys and foreign keys.


*/

CREATE TABLE Manufacturers(
  ManufacturerID INT IDENTITY PRIMARY KEY,
  [Name] VARCHAR(30) NOT NULL,
  EstablishedOn DATE NOT NULL FORMAT('MM/dd/yyyy'),
)

CREATE TABLE Models(
ModelID INT PRIMARY KEY IDENTITY(101,1),
[Name] VARCHAR(30),
ManufacturerID INT
CONSTRAINT FK_Models_Manufacturers FOREIGN KEY (ManufacturerID)
  REFERENCES Manufacturers(ManufacturerID)
)


INSERT INTO Manufacturers ([Name], EstablishedOn)
VALUES ('BMW', '07-03-1916'),
	   ('Tesla', '01-01-2003'),
	   ('Lada', '01-05-1966')

INSERT INTO Models ([Name], ManufacturerID)
VALUES ('X1', 1),
	   ('i6', 1),
	   ('Model S', 2),
	   ('Model X', 2),
	   ('Model 3', 2),
	   ('Nova', 3)

SELECT * FROM Models

SELECT 
ManufacturerID, [Name], FORMAT(EstablishedOn, 'MM/dd/yyyy') as EstablishedOn -- change the way the date is formatted when shown from the selection
FROM Manufacturers

DROP TABLE Models
DROP TABLE Manufacturers


----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------

/* 
3.	Many-To-Many Relationship
Create three tables and use appropriate data types.
Example
	Students								Exams								StudentsExams

StudentID		Name					ExamID		Name						StudentID		ExamID
	1  			Mila					101			SpringMVC						1			101
	2			Toni					102			Neo4j							1			102
	3			Ron						103			Oracle 11g						2			101
																					3			103
																					2			102
																					2			103

Insert the data from the example above and add primary keys and foreign keys. 
Keep in mind that the table "StudentsExams" should have a composite primary key.

*/

CREATE TABLE Students(
  StudentID INT IDENTITY PRIMARY KEY,
  [Name] VARCHAR(30) NOT NULL,
)

CREATE TABLE Exams(
  ExamID INT PRIMARY KEY IDENTITY(101,1),
  [Name] VARCHAR(30) NOT NULL,
)

CREATE TABLE StudentsExams(
StudentID INT ,
ExamID INT,
PRIMARY KEY (StudentID, ExamID),
CONSTRAINT FK_StudentsExams_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
CONSTRAINT FK_StudentsExams_Exams FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
)

INSERT INTO Students ([Name])
VALUES ('Mila'),
	   ('Toni'),
	   ('Ron')

INSERT INTO Exams ([Name])
VALUES ('SpringMVC'),
	   ('Neo4j'),
	   ('Oracle 11g')

INSERT INTO StudentsExams (StudentID,ExamID)
VALUES (1,101),
	   (1,102),
	   (2,101),
	   (3,103),
	   (2,102),
	   (2,103)


SELECT * FROM StudentsExams
SELECT * FROM Students
SELECT * FROM Exams

DROP TABLE StudentsExams
DROP TABLE Students
DROP TABLE Exams

----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------

/* 
4.	Self-Referencing 
Create one table and use appropriate data types.
				Example:

							Teachers

			TeacherID			Name			ManagerID

				101				John			NULL
				102				Maya			106
				103				Silvia			106
				104				Ted				105
				105				Mark			101
				106				Greta			101

Insert the data from the example above and add primary keys and foreign keys. 
The foreign key should be between ManagerId and TeacherId.

*/


CREATE TABLE Teachers(
TeacherID INT PRIMARY KEY IDENTITY(101,1),
[Name] VARCHAR(30) NOT NULL,
ManagerID INT 
CONSTRAINT FK_Teachers FOREIGN KEY (ManagerID) REFERENCES Teachers(TeacherID),
)

INSERT INTO Teachers ([Name], ManagerID)
VALUES ('John', NULL),
	   ('Maya', 106),
	   ('Silvia', 106),
	   ('Ted', 105),
	   ('Mark', 101),
	   ('Greta', 101)

SELECT * FROM Teachers
