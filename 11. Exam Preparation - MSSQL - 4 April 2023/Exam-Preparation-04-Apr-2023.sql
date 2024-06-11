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







