-- 1. Creation of Tables 

CREATE TABLE Books (
BookID INT PRIMARY KEY,
Title VARCHAR(255),
Author VARCHAR(255),
Category VARCHAR(100)
);

CREATE TABLE Students (
StudentID INT PRIMARY KEY,
Name VARCHAR(255),
Email VARCHAR(255),
JoinDate DATE,
LastActiveDate DATE
);

CREATE TABLE IssuedBooks (
IssueID INT PRIMARY KEY,
BookID INT,
StudentID INT,
IssueDate DATE,
ReturnDate DATE,
FOREIGN KEY (BookID) REFERENCES Books(BookID),
FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

-- 2. Sample Data

INSERT INTO Books VALUES
(1, 'The Alchemist', 'Paulo Coelho', 'Fiction'),
(2, 'Brief History of Time', 'Stephen Hawking', 'Science'),
(3, 'Sapiens', 'Yuval Noah Harari', 'History');

INSERT INTO Students VALUES
(101, 'Amit', '[amit@email.com](mailto:amit@email.com)', '2022-01-10', '2025-01-01'),
(102, 'Priya', '[priya@email.com](mailto:priya@email.com)', '2021-05-12', '2022-02-01'),
(103, 'Rahul', '[rahul@email.com](mailto:rahul@email.com)', '2020-03-15', '2021-01-01');

INSERT INTO IssuedBooks VALUES
(1, 1, 101, DATEADD(DAY, -20, GETDATE()), NULL),
(2, 2, 102, DATEADD(DAY, -5, GETDATE()), NULL),
(3, 3, 103, DATEADD(DAY, -30, GETDATE()), '2024-01-01');

-- 3. Overdue Books (more than 14 days and not returned)

SELECT
s.StudentID,
s.Name,
b.Title,
ib.IssueDate,
DATEDIFF(DAY, ib.IssueDate, GETDATE()) AS DaysOverdue
FROM IssuedBooks ib
JOIN Students s ON ib.StudentID = s.StudentID
JOIN Books b ON ib.BookID = b.BookID
WHERE ib.ReturnDate IS NULL
AND DATEDIFF(DAY, ib.IssueDate, GETDATE()) > 14;

-- 4. Most Borrowed Categories

SELECT
b.Category,
COUNT(*) AS BorrowCount
FROM IssuedBooks ib
JOIN Books b ON ib.BookID = b.BookID
GROUP BY b.Category
ORDER BY BorrowCount DESC;

-- 5. Data Cleanup (inactive students)

DELETE FROM IssuedBooks
WHERE StudentID IN (
SELECT StudentID
FROM Students
WHERE LastActiveDate < DATEADD(YEAR, -3, GETDATE())
);

DELETE FROM Students
WHERE LastActiveDate < DATEADD(YEAR, -3, GETDATE());

-- 6. Simple Enhancement: Fine Calculation

SELECT
s.Name,
b.Title,
DATEDIFF(DAY, ib.IssueDate, GETDATE()) - 14 AS DaysLate,
(DATEDIFF(DAY, ib.IssueDate, GETDATE()) - 14) * 5 AS FineAmount
FROM IssuedBooks ib
JOIN Students s ON ib.StudentID = s.StudentID
JOIN Books b ON ib.BookID = b.BookID
WHERE ib.ReturnDate IS NULL
AND DATEDIFF(DAY, ib.IssueDate, GETDATE()) > 14;
