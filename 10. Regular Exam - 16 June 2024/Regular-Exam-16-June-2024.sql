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

/*
				Section 2. DML (10 pts)
				Before you start, you have to import "Dataset.sql ". If you have created the structure correctly, the data should be successfully inserted.
				In this section, you have to do some data manipulations:

2.	Insert

Let's insert some sample data into the database. Write a query to add the following records to the corresponding tables. All IDs (Primary Keys) should be auto-generated.


						Contacts
Id	Email	PhoneNumber	PostAddress	Website
21	NULL	NULL	NULL	NULL
22	NULL	NULL	NULL	NULL
23	'stephen.king@example.com'	'+4445556666'	'15 Fiction Ave, Bangor, ME'	'www.stephenking.com'
24	'suzanne.collins@example.com'	'+7778889999'	'10 Mockingbird Ln, NY, NY'	'www.suzannecollins.com'

						Authors
Id	Name	ContactId
16	'George Orwell'	21
17	'Aldous Huxley'	22
18	'Stephen King'	23
19	'Suzanne Collins'	24

							Books
Id	Title	YearPublished	ISBN	AuthorId	GenreId
36	'1984'	1949	'9780451524935'	16	2
37	'Animal Farm'	1945	'9780451526342'		16	2
38	'Brave New World'	1932	'9780060850524'	17	2
39	'The Doors of Perception'	1954	'9780060850531'	17	2
40	'The Shining'	1977	'9780307743657'	18	9
41	'It'	1986	'9781501142970'	18	9
42	'The Hunger Games'	2008	'9780439023481'	19	7
43	'Catching Fire'	2009	'9780439023498'	19	7
44	'Mockingjay'	2010	'9780439023511'	19	7

LibrariesBooks
LibraryId	BookId
	1		  36
	1		  37
	2		  38
	2		  39
	3		  40
	3		  41
	4		  42
	4		  43
	5		  44


*/


INSERT INTO Contacts (Email, PhoneNumber, PostAddress, Website)
VALUES (NULL, NULL, NULL, NULL),
	   (NULL, NULL, NULL, NULL),
	   ('stephen.king@example.com', '+4445556666', '15 Fiction Ave, Bangor, ME', 'www.stephenking.com'),
	   ('suzanne.collins@example.com', '+7778889999', '10 Mockingbird Ln, NY, NY', 'www.suzannecollins.com')


INSERT INTO Authors([Name], ContactId)
VALUES ('George Orwell', 21),
	   ('Aldous Huxley', 22),
	   ('Stephen King', 23),
	   ('Suzanne Collins', 24)

INSERT INTO Books(Title, YearPublished, ISBN, AuthorId, GenreId)
VALUES ('1984', 1949, '9780451524935', 16 ,2),
       ('Animal Farm', 1945, '9780451526342', 16 ,2),
       ('Brave New World', 1932, '9780060850524', 17 ,2),
       ('The Doors of Perception', 1954, '9780060850531', 17, 2),
       ('The Shining', 1977, '9780307743657', 18, 9),
	   ('It', 1986, '9781501142970', 18, 9),
	   ('The Hunger Games', 2008, '9780439023481', 19, 7),
	   ('Catching Fire', 2009, '9780439023498', 19, 7),
	   ('Mockingjay', 2010, '9780439023511', 19, 7)



INSERT INTO LibrariesBooks(LibraryId, BookId)
VALUES (1, 36),
       (1, 37),
	   (2, 38),
	   (2, 39),
	   (3, 40),
	   (3, 41),
	   (4, 42),
	   (4, 43),
	   (5, 44);

/*
3.	Update
For all authors who do not have a website listed in their contact information, update their contact information to include a website. 
The website should be in the format: "www." + "authorname" + ".com"

'authorname' -> in lowercase without spaces

'George Orwell' -> www.georgeorwell.com

*/

UPDATE c
SET c.Website = CONCAT('www.', LOWER(REPLACE(a.Name, ' ', '')), '.com')
FROM Contacts AS c
JOIN Authors a ON a.ContactId = c.Id
WHERE c.Website IS NULL;

/*
4.	Delete
You are required to delete 'Alex Michaelides' from the Authors table. 
This is challenging because the Authors table is referenced by the Books table, which in turn is referenced by the LibrariesBooks table. 
Therefore, you need to handle these references correctly to maintain the integrity of the database.

*/

DELETE FROM LibrariesBooks WHERE BookId = 1 
DELETE FROM Books WHERE AuthorId = 1 -- Alex Michaelides's Id is 1
DELETE FROM Authors WHERE Name = 'Alex Michaelides';

