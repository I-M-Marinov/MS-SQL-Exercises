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

/*
															Section 3. Querying (40 pts)
						You need to start with a fresh dataset, so recreate your DB and import the sample data again ("Dataset.sql").

5.	Books by Year of Publication

Select all books, ordered by year of publication – descending, and then by title - alphabetically.
Required columns:

•	Book Title
•	ISBN
•	YearReleased

Example

			Book Title						ISBN			YearReleased
			'The Silent Patient'		'9781250301697'			2019
			'Becoming'					'9781524763138'			2018
			'Educated'					'9780399590504'			2018
			'The Great Alone'			'9780312577230'			2018
			'Where the Crawdads Sing'	'9780735219090'			2018
			'A Storm of Swords'			'9780553106633'			2000

*/

SELECT 
Title AS 'Book Title',
ISBN,
YearPublished AS 'YearReleased'
FROM Books
ORDER BY YearPublished DESC, Title 

/*
6.	Books by Genre
Select all books with 'Biography' or 'Historical Fiction' genres. Order results by Genre, and then by book title – alphabetically.

Required columns:
•	Id
•	Title
•	ISBN
•	Genre
Example

		Id			Title					ISBN			Genre
		3		Becoming				9781524763138	Biography
		25		Anna Karenina			9780143035008	Historical Fiction
		33		Crime and Punishment	9780140449136	Historical Fiction
*/

SELECT 
b.Id,
b.Title,
b.ISBN,
g.[Name]
FROM Books AS b
JOIN Genres AS g ON g.Id = b.GenreId
WHERE g.[Name] = 'Biography' OR  g.[Name] = 'Historical Fiction' 
ORDER BY g.[Name], b.Title

/*
7.	Libraries Missing Specific Genre
Select all libraries that do not have any books of a specific genre ('Mystery'). 
Order the results by the name of the library in ascending order.

Required columns:
•	Library
•	Email

Example
		       Library					Email
		Politics and Prose		politics@example.com
		Powell's City of Books	powells@example.com
		Strand Bookstore		strand@example.com
		Tattered Cover			tattered@example.com

*/

SELECT 
l.[Name],
c.Email
FROM Libraries AS l
JOIN Contacts c ON c.Id = l.ContactId
WHERE NOT EXISTS (
    SELECT 1
    FROM LibrariesBooks AS lb
    JOIN Books AS b ON b.Id = lb.BookId
    WHERE lb.LibraryId = l.Id
    AND b.GenreId = 1
)
ORDER BY l.[Name];

/*
8.	First 3 Books
Your task is to write a query to select the first 3 books from the library database (LibraryDb) that meet the following criteria:
•	The book was published after the year 2000 and contains the letter 'a' in the book title, 
•	OR
•	The book was published before 1950 and the genre name contains the word 'Fantasy'.

The results should be ordered by the book title in ascending order, and then by the year published in descending order.

Required columns:

•	Title
•	Year
•	Genre
Example

	Title				Year	Genre
	Educated			2018	Memoir
	The Great Alone		2018	Historical Fiction
	The Hobbit			1937	Fantasy

*/

SELECT TOP 3
b.Title,
b.YearPublished AS [Year],
g.[Name] AS Genre
FROM Books AS b
JOIN Genres AS g ON g.Id = b.GenreId
WHERE b.YearPublished > 2000 AND b.Title LIKE '%a%'
OR b.YearPublished < 1950 AND g.[Name] LIKE '%Fantasy%'
ORDER BY b.Title, b.YearPublished DESC

/*
9.	Authors from the UK
Your task is to write a query to select all authors from the UK (their PostAddress contains 'UK'). 
The address information is stored in the Contacts table under the PostAddress column. 
The results should be ordered by the author's name in ascending order.

Required columns:
•	Author
•	Email
•	Address

Example

Author					Email				Address
J.K. Rowling	jk@example.com	100 Kings Rd, London, UK
J.R.R. Tolkien	jrr@example.com	221B Baker St, London, UK

*/

SELECT 
a.[Name] AS Author,
c.Email,
c.PostAddress AS [Address]
FROM Authors AS a
JOIN Contacts AS c ON c.Id = a.ContactId
WHERE c.PostAddress LIKE '%UK%'
ORDER BY a.[Name]

/*
10.	Fictions in Denver
Your task is to write a query to select details for books of a specific genre -'Fiction', 
and are sold in libraries located in Denver - their PostAddress contains 'Denver'. 
Order the result by book title – alphabetically.

Required columns:
•	Author
•	Title
•	Library
•	Library Addres

Example

    Author					Title				Library				Library Address
Charles Dickens		A Tale of Two Cities	Tattered Cover	2526 E Colfax Ave, Denver, CO
Charles Dickens		Great Expectations		Tattered Cover	2526 E Colfax Ave, Denver, CO

*/

SELECT 
a.[Name] AS Author,
b.Title AS Title,
l.[Name] AS [Library],
c.PostAddress AS 'Library Address'
FROM Books AS b
JOIN Genres	AS g ON g.Id = b.GenreId
JOIN LibrariesBooks AS lb ON lb.BookId = b.Id
JOIN Libraries AS l ON l.Id = lb.LibraryId
JOIN Contacts AS c ON c.Id = l.ContactId
JOIN Authors AS a ON a.Id = b.AuthorId
WHERE g.Name = 'Fiction' AND c.PostAddress LIKE '%Denver%'
ORDER BY b.Title

/*
																Section 4. Programmability (20 pts)


11.	Authors with Books
Create a user-defined function, named udf_AuthorsWithBooks(@name) that receives an author's name.
•	The function will accept an author's name as a parameter
•	It will join the relevant tables to count the total number of books by that author available in all libraries
Example

										Query
					SELECT dbo.udf_AuthorsWithBooks('J.K. Rowling')

										Output
										  3

*/

CREATE FUNCTION udf_AuthorsWithBooks(@name VARCHAR(40))
RETURNS INT
AS
BEGIN
	DECLARE @numberOfBooks INT;
    SELECT @numberOfBooks = COUNT(b.AuthorId)
    FROM Books AS b
	JOIN Authors AS a ON a.Id = b.AuthorId
    WHERE a.[Name] = @name;
	RETURN @numberOfBooks
END;

SELECT dbo.udf_AuthorsWithBooks('J.K. Rowling') AS [Output] -- Output: 3
SELECT dbo.udf_AuthorsWithBooks('Kristin Hannah') AS [Output] -- Output: 1
SELECT dbo.udf_AuthorsWithBooks('Mark Twain') AS [Output] -- Output: 3

