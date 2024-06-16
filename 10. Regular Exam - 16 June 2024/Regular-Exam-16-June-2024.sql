/*
Section 1. DDL (30 pts)
You have been given the E/R Diagram of the LibraryDb database.
 
Create a database called LibraryDb. You need to create 6 tables:
-	Books - contains information about each book;
-	Authors - contains information about the authors of the books;
-	Libraries - contains information about each library;
-	Genres - contains information about the book’s category;
-	Contacts - contains information about the contact methods with the libraries or the authors;
-	LibrariesBooks - manages the many-to-many relationship between libraries and books, indicating which libraries store specific books and which books are stored in a specific library;

*/

CREATE DATABASE LibraryDb 
GO
USE LibraryDb
GO

CREATE TABLE Genres (
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(30) NOT NULL
)

CREATE TABLE Contacts (
Id INT PRIMARY KEY IDENTITY,
Email NVARCHAR(100),
PhoneNumber NVARCHAR(20),
PostAddress NVARCHAR(200),
Website NVARCHAR(50)
)

CREATE TABLE Authors (
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(100) NOT NULL,
ContactId INT NOT NULL,
CONSTRAINT FK_Authors_Contacts FOREIGN KEY (ContactId) REFERENCES Contacts(Id)
)

CREATE TABLE Libraries (
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL,
ContactId INT NOT NULL,
CONSTRAINT FK_Libraries_Contacts FOREIGN KEY (ContactId) REFERENCES Contacts(Id)
)

CREATE TABLE Books (
Id INT PRIMARY KEY IDENTITY,
Title NVARCHAR(100) NOT NULL,
YearPublished INT NOT NULL,
ISBN NVARCHAR(13) UNIQUE NOT NULL,
AuthorId INT NOT NULL,
GenreId INT NOT NULL,
CONSTRAINT FK_Books_Authors FOREIGN KEY (AuthorId) REFERENCES Authors(Id),
CONSTRAINT FK_Books_Genres FOREIGN KEY (GenreId) REFERENCES Genres(Id)
)


CREATE TABLE LibrariesBooks (
LibraryId INT NOT NULL,
BookId INT NOT NULL,
CONSTRAINT PK_LibrariesBooks PRIMARY KEY (LibraryId, BookId),
CONSTRAINT FK_LibrariesBooks_Libraries FOREIGN KEY (LibraryId) REFERENCES Libraries(Id),
CONSTRAINT FK_LibrariesBooks_Books FOREIGN KEY (BookId) REFERENCES Books(Id)
)