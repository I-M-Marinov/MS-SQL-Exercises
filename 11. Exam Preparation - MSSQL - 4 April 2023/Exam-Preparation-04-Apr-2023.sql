/*
Section 1. DDL (30 pts)
You have been given the E/R Diagram of the Accounting database.
 
Create a database called Accounting. You need to create 8 tables:

-	Products - contains information about each product;
-	Categories - containts information about each product's category;
-	Vendors - contains information about the products' vendors;
-	Clients - contains information about the clients, which the products have been sold to;
-	Addresses - contains information about the clients' and vendors' addresses;
-	Countries - contains information about the countries, in which the addresses are located;
-	Invoices  - contains information about the invoices, issued to the clients;
-	ProductsClients - mapping table between products and clients.

*/

CREATE DATABASE Accounting;
GO
USE Accounting
GO

CREATE TABLE Countries (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(10) NOT NULL
)

CREATE TABLE Addresses (
Id INT PRIMARY KEY IDENTITY,
StreetName NVARCHAR(20) NOT NULL,
StreetNumber INT,
PostCode INT NOT NULL,
City VARCHAR(25) NOT NULL,
CountryId INT NOT NULL
CONSTRAINT FK_Addresses_Countries FOREIGN KEY (CountryId) REFERENCES Countries(Id)
)

CREATE TABLE Vendors (
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(25) NOT NULL,
NumberVAT NVARCHAR(15) NOT NULL,
AddressId INT NOT NULL,
CONSTRAINT FK_Vendors_Addresses FOREIGN KEY (AddressId) REFERENCES Addresses(Id)
)

CREATE TABLE Clients (
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(25) NOT NULL,
NumberVAT NVARCHAR(15) NOT NULL,
AddressId INT NOT NULL,
CONSTRAINT FK_Clients_Addresses FOREIGN KEY (AddressId) REFERENCES Addresses(Id)
)

CREATE TABLE Categories (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(10) NOT NULL
)

CREATE TABLE Products (
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(35) NOT NULL,
Price DECIMAL(18,2) NOT NULL,
CategoryId INT NOT NULL,
VendorId INT NOT NULL,
CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
CONSTRAINT FK_Products_Vendors FOREIGN KEY (VendorId) REFERENCES Vendors(Id)
)


CREATE TABLE Invoices (
Id INT PRIMARY KEY IDENTITY,
Number INT UNIQUE,
IssueDate DATETIME2 NOT NULL,
DueDate DATETIME2 NOT NULL,
Amount DECIMAL(18,2) NOT NULL,
Currency VARCHAR(5) NOT NULL,
ClientId INT NOT NULL,
CONSTRAINT FK_Invoices_Clients FOREIGN KEY (ClientId) REFERENCES Clients(Id),
)

CREATE TABLE ProductsClients (
ProductId INT NOT NULL,
ClientId INT NOT NULL,
CONSTRAINT PK_ProductsClients PRIMARY KEY (ProductId, ClientId),
CONSTRAINT FK_ProductsClients_Products FOREIGN KEY (ProductId) REFERENCES Products(Id),
CONSTRAINT FK_ProductsClients_Clients FOREIGN KEY (ClientId) REFERENCES Clients(Id)
)


/*
Section 2. DML (10 pts)
Before you start, you have to import "Dataset.sql ". 
If you have created the structure correctly, the data should be successfully inserted.
In this section, you have to do some data manipulations:

2.	Insert
Let's insert some sample data into the database. Write a query to add the following records into the corresponding tables. All IDs should be auto-generated.
													
													Products

				Name							Price			CategoryId		VendorId
				SCANIA Oil Filter XD01			78.69				1				1
				MAN Air Filter XD01				97.38				1				5
				DAF Light Bulb 05FG87			55.00				2				13
				ADR Shoes 47-47.5				49.85				3				5
				Anti-slip pads S				5.87				5				7


													Invoices

				Number			IssueDate			DueDate				Amount		Currency	ClientId
				1219992181		2023-03-01			2023-04-30			180.96			BGN			3
				1729252340		2022-11-06			2023-01-04			158.18			EUR			13
				1950101013		2023-02-17			2023-04-18			615.15			USD			19

*/


INSERT INTO Products ([Name],Price,CategoryId,VendorId)
VALUES ('SCANIA Oil Filter XD01', 78.69, 1, 1),
	   ('MAN Air Filter XD01', 97.38, 1, 5),
	   ('DAF Light Bulb 05FG87', 55.00, 2, 13),
	   ('ADR Shoes 47-47.5', 49.85, 3, 5),
	   ('Anti-slip pads S', 5.87, 5, 7)

INSERT INTO Invoices (Number,IssueDate,DueDate,Amount,Currency,ClientId)
VALUES (1219992181, '2023-03-01', '2023-04-30', 180.96, 'BGN', 3),
	   (1729252340, '2022-11-06', '2023-01-04', 158.18, 'EUR', 13),
	   (1950101013, '2023-02-17', '2023-04-18', 615.15, 'USD', 19)


/*
3.	Update

We've decided to change the due date of the invoices, issued in November 2022. 
Update the due date and change it to 2023-04-01.
Then, you have to change the addresses of the clients, which contain "CO" in their names. 
The new value of the addresses should be Industriestr, 79, 2353, Guntramsdorf, Austria.

*/

UPDATE Invoices
SET DueDate = '2023-04-01'
WHERE IssueDate BETWEEN '2022-11-01' AND '2022-11-30'

UPDATE Clients 
SET AddressId = 3
WHERE [Name] LIKE '%CO%'


/*
4.	Delete
In table Clients, delete every client, whose VAT number starts with "IT". 
Keep in mind that there could be foreign key constraint conflicts.

*/


DELETE FROM Invoices
WHERE ClientId IN (SELECT Id FROM Clients  WHERE NumberVAT LIKE 'IT%');

DELETE FROM ProductsClients
WHERE ClientId IN (SELECT Id FROM Clients  WHERE NumberVAT LIKE 'IT%');

DELETE FROM Clients WHERE NumberVAT LIKE 'IT%'

/*
Section 3. Querying (40 pts)
You need to start with a fresh dataset, so recreate your DB and import the sample data again ("Dataset.sql").

5.	Invoices by Amount and Date
Select all invoices, ordered by amount (descending), then by due date (ascending). 
Required columns:
•	Number
•	Currency

Example
			  Number		  Currency
			213573806			BGN
			219066487			EUR
			320983369			USD
			349121203			BGN
*/

SELECT * FROM sys.dm_exec_sessions WHERE database_id = DB_ID('Accounting') -- Check active connections 


SELECT Number, Currency FROM Invoices
ORDER BY Amount DESC, DueDate

