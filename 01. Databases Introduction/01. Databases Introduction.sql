-- 1. Create DATABASE --

-- You now know how to create databases using the GUI of the SSMS. Now it's time to create it using SQL queries. 
-- In that task (and the several following it) you will be required to create the database from the previous exercise using only SQL queries. 
-- First, just create new database named Minions.

-----------------------------------------------------------------------------------------------------------------------------------------------------

-- 2. Create TABLES --

-- In the newly created database Minions add table Minions (Id, Name, Age). Then add a new table Towns (Id, Name). 
-- Set Id columns of both tables to be primary key as constraint.


SELECT * FROM Minions;
SELECT * FROM Towns;

-----------------------------------------------------------------------------------------------------------------------------------------------------

-- 3. Alter Minions Table

--Change the structure of the Minions table to have a new column TownId that would be of the same type as the Id column in Towns table. 
-- Add a new constraint that makes TownId foreign key and references to Id column in Towns table.


ALTER TABLE Minions
ADD TownId int;

ALTER TABLE Minions
ADD CONSTRAINT FK_TownId FOREIGN KEY (TownId) REFERENCES Towns(Id);

-----------------------------------------------------------------------------------------------------------------------------------------------------

-- 4.	Insert Records in Both Tables
-- Populate both tables with sample records, given in the table below.

--                 Minions						Towns
--	Id		Name		Age		TownId	|	Id		Name
--	1		Kevin		22			1	|   1		Sofia
--	2		Bob			5			3	|	2		Plovdiv
--	3		Steward		NULL		2	|	3		Varna


-- INSERT INFORMATION IN THE TOWNS TABLE
INSERT INTO Towns (Id, [Name]) 
VALUES (1, 'Sofia'),
		(2, 'Plovdiv'),
		(3, 'Varna');

-- INSERT INFORMATION IN THE MINIONS TABLE
INSERT INTO Minions (Id, [Name], Age, TownId)
VALUES 
    (1, 'Kevin', 22, 1),
    (2, 'Bob', 15, 3),
    (3, 'Steward', NULL, 2);

-----------------------------------------------------------------------------------------------------------------------------------------------------

-- 5.	Truncate Table Minions
-- Delete all the data from the Minions table using SQL query.

TRUNCATE TABLE Minions;
TRUNCATE TABLE Towns;

-----------------------------------------------------------------------------------------------------------------------------------------------------

-- 6.	Drop All Tables
-- Delete all tables from the Minions database using SQL query.

DROP TABLE Minions
DROP TABLE Towns

-----------------------------------------------------------------------------------------------------------------------------------------------------

-- 7. Create Table People
-- Using SQL query, create table People with the following columns:
--	�	Id � unique number. For every person there will be no more than 231-1 people (auto incremented).
--	�	Name � full name of the person. There will be no more than 200 Unicode characters (not null).
--	�	Picture � image with size up to 2 MB (allow nulls).
--	�	Height � in meters. Real number precise up to 2 digits after floating point (allow nulls).
--	�   Weight � in kilograms. Real number precise up to 2 digits after floating point (allow nulls).
--	�	Gender � possible states are m or f (not null).
--	�	Birthdate � (not null).
--	�	Biography � detailed biography of the person. It can contain max allowed Unicode characters (allow nulls).
--	Make the Id a primary key. Populate the table with only 5 records. Submit your CREATE and INSERT statements as Run queries & check DB.

CREATE TABLE People (
    Id INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(200) NOT NULL,
    Picture VARBINARY(MAX),
    Height DECIMAL(3, 2),
    [Weight] DECIMAL(3, 2),
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('m', 'f')),
    Birthdate DATE NOT NULL,
    Biography NVARCHAR(MAX)
);
 -- Add five people in the table 
INSERT INTO People ([Name], Gender, Birthdate)
VALUES 
    ('Gosho', 'm', '1999-04-20'),
    ('Pesho', 'm', '2003-02-15'),
    ('Maria', 'f', '2006-12-13'),
	('Darth Vader', 'm', '1962-01-01'),
	('Parvan', 'm', '1993-06-22');



SELECT * FROM People; -- Show the whole table 
DROP TABLE People; -- Drop the table 

-----------------------------------------------------------------------------------------------------------------------------------------------------

-- 8. Create Table Users
-- Using SQL query create table Users with columns:
-- �	Id � unique number for every user. There will be no more than 263-1 users (auto incremented).
-- �	Username � unique identifier of the user. It will be no more than 30 characters (non Unicode)  (required).
-- �	Password � password will be no longer than 26 characters (non Unicode) (required).
-- �	ProfilePicture � image with size up to 900 KB. 
-- �	LastLoginTime
-- �	IsDeleted � shows if the user deleted his/her profile. Possible states are true or false.
-- Make the Id a primary key. Populate the table with exactly 5 records. Submit your CREATE and INSERT statements as Run queries & check DB.


-- Create a table USERS with all the constraints

CREATE TABLE Users (
    Id INT PRIMARY KEY IDENTITY,
    Username VARCHAR(30) NOT NULL,
    [Password] VARCHAR(26) NOT NULL,
    ProfilePicture VARBINARY(MAX),
    LastLoginTime DATETIME2,
	isDeleted VARCHAR(5) NOT NULL CHECK (isDeleted IN ('true', 'false')),
);
 -- Add five users in the table 
INSERT INTO Users (Username, [Password], isDeleted)
VALUES 
    ('Gosho_G', 'password1234', 'true'),
    ('Pesho-PeT', 'password4567', 'false'),
    ('Maria_deva', 'password145644', 'false'),
	('Dark_Side_Vader', 'pass1234word', 'false'),
	('Par[a]van', '5656231adasda', 'false');

SELECT * FROM Users; -- Show the whole table 
DROP TABLE Users; -- Drop the table // DELETE information and the table 
TRUNCATE TABLE Users; -- Clean the information in the table, BUT NOT DROP THE WHOLE TABLE 

-----------------------------------------------------------------------------------------------------------------------------------------------------

-- 9. Change Primary Key
-- Using SQL queries modify table Users from the previous task. 
-- First remove the current primary key and then create a new primary key that would be a combination of fields Id and Username.

ALTER TABLE Users
DROP CONSTRAINT PK_Users; -- Drop the existing primary key constraint

ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY (Id, Username); -- Add a new primary key constraint that combines Id and Username

-----------------------------------------------------------------------------------------------------------------------------------------------------

-- 10.	Add Check Constraint
-- Using SQL queries modify table Users. Add check constraint to ensure that the values in the Password field are at least 5 symbols long. 

ALTER TABLE Users
ADD CONSTRAINT CK_PasswordLength CHECK (LEN([Password]) >= 5);

-----------------------------------------------------------------------------------------------------------------------------------------------------

-- 11. Set Default Value of a Field
-- Using SQL queries modify table Users. Make the default value of LastLoginTime field to be the current time.

-- add a constaint that would get the current date and time and put it in the LastLoginTime column for NEW ENTRIES !!!
ALTER TABLE Users
ADD CONSTRAINT DF_LastLoginTime DEFAULT GETDATE() FOR LastLoginTime; 

-----------------------------------------------------------------------------------------------------------------------------------------------------

-- 12. Set Unique Field
-- Using SQL queries modify table Users. Remove Username field from the primary key so only the field Id would be primary key. 
-- Now add unique constraint to the Username field to ensure that the values there are at least 3 symbols long.

ALTER TABLE Users
DROP CONSTRAINT PK_Users; -- Drop the existing primary key constraint

ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY (Id); -- Add a new primary key constraint just the ID ONLY 

ALTER TABLE Users
ADD CONSTRAINT CK_UsernameLength CHECK (LEN(Username) >= 3);

-----------------------------------------------------------------------------------------------------------------------------------------------------

												-- 13. Movies Database
-- Using SQL queries create Movies database with the following entities:
-- �	Directors (Id, DirectorName, Notes)
-- �	Genres (Id, GenreName, Notes)
-- �	Categories (Id, CategoryName, Notes)
-- �	Movies (Id, Title, DirectorId, CopyrightYear, Length, GenreId, CategoryId, Rating, Notes)
-- Set the most appropriate data types for each column. Set a primary key to each table. 
-- Populate each table with exactly 5 records. Make sure the columns that are present in 2 tables would be of the same data type. 
-- Consider which fields are always required and which are optional. 
-- Submit your CREATE TABLE and INSERT statements as Run queries & check DB.

USE Movies

CREATE TABLE Directors (
    Id INT PRIMARY KEY IDENTITY,
    DirectorName VARCHAR(30) NOT NULL,
    Notes VARCHAR(200),
);

CREATE TABLE Genres (
    Id INT PRIMARY KEY IDENTITY,
    GenreName VARCHAR(30) NOT NULL,
    Notes VARCHAR(200),
);

CREATE TABLE Categories (
    Id INT PRIMARY KEY IDENTITY,
    CategoryName VARCHAR(30) NOT NULL,
    Notes VARCHAR(200),
);

CREATE TABLE Movies (
    Id INT PRIMARY KEY IDENTITY,
    Title VARCHAR(30) NOT NULL,
    DirectorId INT,
	CopyrightYear DATETIME2, 
	[Length] INT, 
	GenreId INT, 
	CategoryId INT, 
	Rating DECIMAL (2,1), 
	Notes VARCHAR(200)
);


INSERT INTO Directors (DirectorName)
	 VALUES 
			('Copolla'),
			('Martin Scorsese'),
			('Steven Spielberg'),
			('Tim Burton'),
			('Quentin Tarantino');

INSERT INTO Genres (GenreName)
	 VALUES 
			('Horror'),
			('Science fiction'),
			('Drama'),
			('Action'),
			('Thriller');

INSERT INTO Categories (CategoryName)
	 VALUES 
			('Documentaries'),
			('Fantasy films'),
			('Political films'),
			('Comedy films'),
			('Apocalyptic films');

INSERT INTO Movies (Title)
	 VALUES 
			('The Dark Knight'),
			('The Godfather'),
			('The Shawshank Redemption'),
			('Inception'),
			('The Matrix');

SELECT * FROM Directors;
SELECT * FROM Genres;
SELECT * FROM Categories;
SELECT * FROM Movies;

DROP TABLE Directors;
DROP TABLE Genres;
DROP TABLE Categories;
DROP TABLE Movies;

-----------------------------------------------------------------------------------------------------------------------------------------------------

															-- 14. Car Rental Database

-- Using SQL queries create CarRental database with the following entities:
--	�	Categories (Id, CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
--	�	Cars (Id, PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Picture, Condition, Available)
--	�	Employees (Id, FirstName, LastName, Title, Notes)
--	�	Customers (Id, DriverLicenceNumber, FullName, Address, City, ZIPCode, Notes)
--	�	RentalOrders (Id, EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage, StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus, Notes)
-- Set the most appropriate data types for each column. Set a primary key to each table. Populate each table with only 3 records. 
-- Make sure the columns that are present in 2 tables would be of the same data type. 
-- Consider which fields are always required and which are optional. Submit your CREATE TABLE and INSERT statements as Run queries & check DB.

CREATE DATABASE CarRental
USE CarRental

SELECT * FROM Categories;
SELECT * FROM Cars;
SELECT * FROM Employees;
SELECT * FROM Customers;
SELECT * FROM RentalOrders;

DROP TABLE Categories;
DROP TABLE Cars;
DROP TABLE Employees;
DROP TABLE Customers;
DROP TABLE RentalOrders;

CREATE TABLE Categories  (
    Id INT PRIMARY KEY IDENTITY,
    CategoryName VARCHAR(30) NOT NULL,
    DailyRate DECIMAL(4,2),
	WeeklyRate DECIMAL(5,2),
	MonthlyRate DECIMAL(6,2),
	WeekendRate DECIMAL(4,2)
);

CREATE TABLE Cars (
    Id INT PRIMARY KEY IDENTITY,
    PlateNumber VARCHAR(8),
    Manufacturer VARCHAR(200) NOT NULL,
	Model VARCHAR(50) NOT NULL,
	CarYear INT,
	CategoryId INT,
	Doors INT,
	Picture VARBINARY(MAX),
	Condition VARCHAR(50),
	Available CHAR(1) 
);

CREATE TABLE Employees  (
    Id INT PRIMARY KEY IDENTITY,
    FirstName VARCHAR(15) NOT NULL,
    LastName VARCHAR(30) NOT NULL,
	Title VARCHAR(30) NOT NULL,
	Notes VARCHAR(200)
);

CREATE TABLE Customers  (
    Id INT PRIMARY KEY IDENTITY,
    DriverLicenceNumber BIGINT NOT NULL,
    FullName VARCHAR(50) NOT NULL,
	[Address] VARCHAR(50), 
	City VARCHAR(30), 
	ZIPCode INT,  
	Notes VARCHAR(200)
);

CREATE TABLE RentalOrders (
    Id INT PRIMARY KEY IDENTITY,
    EmployeeId INT,
    CustomerId INT NOT NULL,
	CarId INT NOT NULL, 
	TankLevel INT, 
	KilometrageStart INT NOT NULL,  
	KilometrageEnd INT NOT NULL,  
	TotalKilometrage INT,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,  
	TotalDays INT,
	RateApplied DECIMAL(6,2) NOT NULL,
	TaxRate DECIMAL(5,2) NOT NULL,
	OrderStatus CHAR(1),
	Notes VARCHAR(200)
);

INSERT INTO Categories (CategoryName)
	 VALUES 
			('Business Class'),
			('Sport'),
			('OffRoad');

INSERT INTO Cars (Manufacturer, Model)
	 VALUES 
			('Mitsubishi', 'Outlander'),
			('Toyota', 'Celica'),
			('WV', 'Golf');

INSERT INTO Employees (FirstName, LastName, Title)
	 VALUES 
			('Ivan', 'Ivanov', 'CEO'),
			('Sofia', 'Tudjarova', 'Sales Representative'),
			('Ivo', 'Andonov', 'Operations Manager');

INSERT INTO Customers (DriverLicenceNumber, FullName)
	 VALUES 
			('1234566789', 'Goshko Todorov'),
			('9635842890', 'Pesho Mahlenski'),
			('4564565645', 'Krum Pulev');

INSERT INTO RentalOrders (CustomerId, CarId, KilometrageStart, KilometrageEnd, StartDate, EndDate, RateApplied, TaxRate)
	 VALUES 
			(1, 1, 25000, 32000, '2008-11-11', '2008-11-21', 2500.00, 250.00),
			(2, 3, 150000, 150050, '2008-12-08', '2008-12-09', 600.00, 80.00),
			(3, 2, 215659, 216967, '2012-03-03', '2012-04-03', 5175.00, 485.00 );

-----------------------------------------------------------------------------------------------------------------------------------------------------

												-- 15.	Hotel Database --

--Using SQL queries create Hotel database with the following entities:
--	�	Employees (Id, FirstName, LastName, Title, Notes)
--	�	Customers (AccountNumber, FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber, Notes)
--	�	RoomStatus (RoomStatus, Notes)
--	�	RoomTypes (RoomType, Notes)
--	�	BedTypes (BedType, Notes)
--	�	Rooms (RoomNumber, RoomType, BedType, Rate, RoomStatus, Notes)
--	�	Payments (Id, EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, TotalDays, AmountCharged, TaxRate, TaxAmount, PaymentTotal, Notes)
--	�	Occupancies (Id, EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge, Notes)
-- Set the most appropriate data types for each column. Set a primary key to each table. Populate each table with only 3 records. 
-- Make sure the columns that are present in 2 tables would be of the same data type. Consider which fields are always required and which are optional. Submit your CREATE TABLE and INSERT statements as Run queries & check DB.

CREATE DATABASE Hotel
USE Hotel

SELECT * FROM Employees;
SELECT * FROM Customers;
SELECT * FROM RoomStatus;
SELECT * FROM RoomTypes;
SELECT * FROM BedTypes;
SELECT * FROM Rooms;
SELECT * FROM Payments;
SELECT * FROM Occupancies;

DROP TABLE Employees;
DROP TABLE Customers;
DROP TABLE RoomStatus;
DROP TABLE RoomTypes;
DROP TABLE BedTypes;
DROP TABLE Rooms;
DROP TABLE Payments;
DROP TABLE Occupancies;


CREATE TABLE Employees  (
    Id INT PRIMARY KEY IDENTITY,
    FirstName VARCHAR(15) NOT NULL,
    LastName VARCHAR(30) NOT NULL,
	Title VARCHAR(30) NOT NULL,
	Notes VARCHAR(200)
);

CREATE TABLE Customers  (
    AccountNumber INT PRIMARY KEY NOT NULL,
	FirstName VARCHAR(15) NOT NULL,
    LastName VARCHAR(30) NOT NULL,
	PhoneNumber BIGINT NOT NULL, 
	EmergencyName VARCHAR(30), 
	EmergencyNumber BIGINT,  
	Notes VARCHAR(200)
);

CREATE TABLE RoomStatus   (
	Id INT PRIMARY KEY IDENTITY,
    RoomStatus VARCHAR(8) NOT NULL CHECK (RoomStatus IN ('occupied', 'empty')),
	Notes VARCHAR(200)
);

CREATE TABLE RoomTypes    (
    RoomType VARCHAR(30) PRIMARY KEY NOT NULL,
	Notes VARCHAR(200)
);

CREATE TABLE BedTypes    (
    BedType VARCHAR(30) PRIMARY KEY NOT NULL,
	Notes VARCHAR(200)
);

CREATE TABLE Rooms  (
    RoomNumber INT PRIMARY KEY NOT NULL,
	RoomType VARCHAR(30),
    BedType  VARCHAR(30),
	Rate DECIMAL(5,2) NOT NULL, 
	RoomStatus VARCHAR(8) NOT NULL CHECK (RoomStatus IN ('occupied', 'empty')),
	Notes VARCHAR(200)
);

CREATE TABLE Payments  (
    Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT NOT NULL,
    PaymentDate  DATE NOT NULL,
	AccountNumber INT NOT NULL, 
	FirstDateOccupied DATE, 
	LastDateOccupied DATE,
	TotalDays INT NOT NULL,
	AmountCharged DECIMAL(7,2),
	TaxRate DECIMAL(5,2) NOT NULL,
	TaxAmount DECIMAL(5,2),
	PaymentTotal DECIMAL(8,2) NOT NULL, 
	Notes VARCHAR(350)
);

CREATE TABLE Occupancies   (
    Id INT PRIMARY KEY IDENTITY,
	EmployeeId INT NOT NULL,
	DateOccupied DATE NOT NULL, 
	AccountNumber INT NOT NULL, 
	RoomNumber INT NOT NULL,
	PhoneCharge DECIMAL(5,2),
	Notes VARCHAR(350)
);



INSERT INTO Employees (FirstName, LastName, Title)
	 VALUES 
			('Ivan', 'Ivanov', 'Hotel Manager'),
			('Petar', 'Petrov', 'Groundskeeper'),
			('Georgi', 'Georgiev', 'Piccolo');

INSERT INTO Customers (AccountNumber, FirstName, LastName, PhoneNumber)
	 VALUES 
			(565423181, 'Pesho', 'Petrov', 0884565491),
			(564658133, 'Kiril', 'Stoyanov', 0883613689),
			(951357146, 'Michael', 'Dudikov', 0878894623);

INSERT INTO RoomStatus (RoomStatus)
	 VALUES 
			('occupied'),
			('empty'),
			('occupied');

INSERT INTO RoomTypes (RoomType)
	 VALUES 
			('Ocean-View Room'),
			('First Floor Room'),
			('Second Floor Room');

INSERT INTO BedTypes (BedType)
	 VALUES 
			('Queen-Sized Bed'),
			('King-Sized Bed'),
			('Couch Bed');

INSERT INTO Rooms (RoomNumber, Rate, RoomStatus )
	 VALUES 
			(303, 499.59, 'empty'),
			(501, 749.99, 'occupied'),
			(106, 255.75, 'empty');

INSERT INTO Payments(EmployeeId, PaymentDate, AccountNumber, TotalDays, TaxRate, PaymentTotal )
	 VALUES 
			(123456, '2008-11-23', 565423181, 6, 15.00, 2555.89),
			(789459, '2023-12-23', 564658133, 3, 15.00, 1277.94),
			(965412, '2008-06-11', 951357146, 10, 15.00, 4189.65);

INSERT INTO Occupancies(EmployeeId, DateOccupied, AccountNumber, RoomNumber)
	 VALUES 
			(123456, '2008-11-23', 565423181, 106),
			(789459, '2023-12-23', 565423181,  303),
			(965412, '2008-06-11', 565423181, 501);

-----------------------------------------------------------------------------------------------------------------------------------------------------
													-- 16.	Create SoftUni Database --
	-- Now create bigger database called SoftUni. You will use the same database in the future tasks. It should hold information about
	--	� Towns (Id, Name)
	--	� Addresses (Id, AddressText, TownId)
	--	� Departments (Id, Name)
	--	� Employees (Id, FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary, AddressId)
	-- The Id columns are auto incremented, starting from 1 and increased by 1 (1, 2, 3, 4�). 
	-- Make sure you use appropriate data types for each column. Add primary and foreign keys as constraints for each table. 
	-- Use only SQL queries. Consider which fields are always required and which are optional.

CREATE DATABASE SoftUni 
			USE SoftUni 

SELECT * FROM Towns;
SELECT * FROM Addresses;
SELECT * FROM Departments;
SELECT * FROM Employees;

DROP TABLE Towns;
DROP TABLE Addresses;
DROP TABLE Departments;
DROP TABLE Employees;

CREATE TABLE Towns   (
    Id INT PRIMARY KEY IDENTITY(1,1),
    [Name] VARCHAR(30) NOT NULL
);

CREATE TABLE Addresses    (
    Id INT PRIMARY KEY IDENTITY(1,1),
    AddressText VARCHAR(30),
	TownId INT
);

CREATE TABLE Departments     (
    Id INT PRIMARY KEY IDENTITY(1,1),
    [Name] VARCHAR(30) NOT NULL
);

CREATE TABLE Employees      (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(30) NOT NULL,
	MiddleName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	JobTitle VARCHAR(30) NOT NULL,
	DepartmentId INT,
	HireDate VARCHAR(10),
	Salary DECIMAL(6,2),
	AddressId INT
);

-- Adding Foreign Key to Addresses table

ALTER TABLE Addresses
ADD CONSTRAINT FK_Addresses_TownId FOREIGN KEY (TownId)
REFERENCES Towns(Id);

-- Adding Foreign Keys to Employees table

ALTER TABLE Employees
ADD CONSTRAINT FK_Employees_DepartmentId FOREIGN KEY (DepartmentId)
REFERENCES Departments(Id);

ALTER TABLE Employees
ADD CONSTRAINT FK_Employees_AddressId FOREIGN KEY (AddressId)
REFERENCES Addresses(Id);
-----------------------------------------------------------------------------------------------------------------------------------------------------
										--17.	Backup Database --
--		Backup the database SoftUni from the previous task into a file named "softuni-backup.bak". 
--		Delete your database from SQL Server Management Studio. 
--		Then restore the database from the created backup.
 

BACKUP DATABASE SoftUni
TO DISK = 'W:\softuni-backup.bak'
WITH FORMAT, INIT, 
NAME = 'SoftUni-Full Backup';


----------------------------------------------------------------------------------------------------------------------------------------------------


/*												18.	Basic Insert
Use the SoftUni database and insert some data using SQL queries.
�	Towns: Sofia, Plovdiv, Varna, Burgas
�	Departments: Engineering, Sales, Marketing, Software Development, Quality Assurance
�	Employees:
	Name					Job Title				Department				Hire Date			Salary
Ivan Ivanov Ivanov		.NET Developer			Software Development		01/02/2013			3500.00
Petar Petrov Petrov		Senior Engineer				Engineering				02/03/2004			4000.00
Maria Petrova Ivanova		Intern				Quality Assurance			28/08/2016			525.25
Georgi Teziev Ivanov		 CEO					  Sales					09/12/2007			3000.00
Peter Pan Pan				Intern					Marketing				28/08/2016			599.88   */ 



INSERT INTO Towns ([Name])
	 VALUES 
			('Sofia'),
			('Plovdiv'),
			('Varna'),
			('Burgas');

INSERT INTO Departments ([Name])
	 VALUES 
			('Engineering'),
			('Sales'),
			('Marketing'),
			('Software Development'),
			('Quality Assurance');

INSERT INTO Employees (FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary)
	 VALUES 
			('Ivan ', 'Ivanov', 'Ivanov', '.NET Developer', 4, '01/02/2013', 3500.00),
			('Petar  ', 'Petrov ', 'Petrov ', 'Senior Engineer', 1, '02/03/2004', 4000.00),
			('Maria  ', 'Petrova ', 'Ivanova', 'Intern', 5, '28/08/2016', 525.25),
			('Georgi  ', 'Terziev', 'Ivanov', 'CEO', 2, '09/12/2007', 3500.00),
			('Peter  ', 'Pan', 'Pan', 'Intern', 3, '28/08/2016', 599.88);

----------------------------------------------------------------------------------------------------------------------------------------------------
/* 19.	Basic Select All Fields
Use the SoftUni database and first select all records from the Towns, then from Departments and finally from Employees table. 
Use SQL queries and submit them to Judge at once. Submit your query statements as Prepare DB & Run queries. */

SELECT * FROM Towns;
SELECT * FROM Departments;
SELECT * FROM Employees;


----------------------------------------------------------------------------------------------------------------------------------------------------

/*									20.	Basic Select All Fields and Order Them
		Modify the queries from the previous problem by sorting:
		�	Towns - alphabetically by name
		�	Departments - alphabetically by name
		�	Employees - descending by salary    */

SELECT * FROM Towns
	 ORDER BY [Name];

SELECT * FROM Departments
     ORDER BY [Name];

SELECT * FROM Employees
	 ORDER BY Salary DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------------------

/*										21.	Basic Select Some Fields
		Modify the queries from the previous problem to show only some of the columns. For table:
		�	Towns � Name
		�	Departments � Name
		�	Employees � FirstName, LastName, JobTitle, Salary
		Keep the ordering from the previous problem. Submit your query statements as Prepare DB & Run queries. */

SELECT [Name] FROM Towns
	 ORDER BY [Name];

SELECT [Name] FROM Departments
     ORDER BY [Name];

SELECT FirstName, LastName, JobTitle, Salary FROM Employees
	 ORDER BY Salary DESC;

----------------------------------------------------------------------------------------------------------------------------------------------------

/* 22.	Increase Employees Salary
Use SoftUni database and increase the salary of all employees by 10%. 
Then show only Salary column for all the records in the Employees table. 
Submit your query statements as Prepare DB & Run queries. */

UPDATE Employees 
SET Salary  += Salary*0.10

SELECT Salary FROM Employees

----------------------------------------------------------------------------------------------------------------------------------------------------

/* 23.	Decrease Tax Rate
Use Hotel database and decrease tax rate by 3% to all payments. 
Then select only TaxRate column from the Payments table. 
Submit your query statements as Prepare DB & Run queries. */

USE Hotel

UPDATE Payments 
   SET TaxRate -= TaxRate*0.03

SELECT TaxRate FROM Payments

----------------------------------------------------------------------------------------------------------------------------------------------------

/* 24.	Delete All Records
Use Hotel database and delete all records from the Occupancies table. 
Use SQL query. Submit your query statements as Run skeleton, run queries & check DB. */

	 USE Hotel
TRUNCATE TABLE Occupancies


----------------------------------------------------------------------------------------------------------------------------------------------------

