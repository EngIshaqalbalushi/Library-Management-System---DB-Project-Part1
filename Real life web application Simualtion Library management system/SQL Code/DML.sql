CREATE DATABASE LibraryManagementSystem ;
use LibraryManagementSystem;


-- Create the database (uncomment if needed)
-- CREATE DATABASE LibraryManagementSystem;
-- USE LibraryManagementSystem;

-- Create Library table
CREATE TABLE Library (
    LibraryID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(200) NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL,
	--Ensures the year is less than or equal to the current year (using YEAR(GETDATE())).
    EstablishedYear INT NOT NULL CHECK (EstablishedYear > 1800 AND EstablishedYear <= YEAR(GETDATE()))
);

-- Create Staff table
CREATE TABLE Staff (
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL,
    LibraryID INT NOT NULL,
    CONSTRAINT FK_Staff_Library FOREIGN KEY (LibraryID) 
        REFERENCES Library(LibraryID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create Member table
CREATE TABLE Member (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
	-- get date funaction to add today  in data by default
    MembershipStartDate DATE NOT NULL DEFAULT GETDATE()
);

-- Create Book table with genre constraint
CREATE TABLE Book (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    ISBN VARCHAR(20) UNIQUE NOT NULL,
    Title VARCHAR(200) NOT NULL,
	-- check if grnre in set of Science book or Biography , Acation, Anime
    Genre VARCHAR(20) NOT NULL CHECK (Genre IN ('Science', 'Biography', 'Acation', 'Anime')),
   -- check if price of book not equla to 0
   Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    AvailabilityStatus BIT NOT NULL DEFAULT 1,
    ShelfLocation VARCHAR(50) NOT NULL,
    LibraryID INT NOT NULL,
    CONSTRAINT FK_Book_Library FOREIGN KEY (LibraryID) 
        REFERENCES Library(LibraryID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create Loan table with status constraint
CREATE TABLE Loan (
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    LoanDate DATE NOT NULL DEFAULT GETDATE(),
    DueDate DATE NOT NULL,
    ReturnDate DATE,

	-- add default is Issued and check if status in Issued or Returned 
    Status VARCHAR(10) NOT NULL DEFAULT 'Issued' CHECK (Status IN ('Issued', 'Returned', 'Overdue')),
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    CONSTRAINT FK_Loan_Member FOREIGN KEY (MemberID) 
        REFERENCES Member(MemberID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_Loan_Book FOREIGN KEY (BookID) 
        REFERENCES Book(BookID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create Payment table
CREATE TABLE Payment (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
	-- 
    PaymentDate DATE NOT NULL DEFAULT GETDATE(),
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount > 0),
    Method VARCHAR(20) NOT NULL,
    LoanID INT NOT NULL,
    CONSTRAINT FK_Payment_Loan FOREIGN KEY (LoanID) 
        REFERENCES Loan(LoanID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create Review table with rating constraint
CREATE TABLE Review (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
	-- check if Rating between 1 and 5 not less or more 
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
	-- comments default no comments
    Comments VARCHAR(500) NOT NULL DEFAULT 'No comments',
	-- add review date default today date
    ReviewDate DATE NOT NULL DEFAULT GETDATE(),
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    CONSTRAINT FK_Review_Member FOREIGN KEY (MemberID) 
        REFERENCES Member(MemberID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_Review_Book FOREIGN KEY (BookID) 
        REFERENCES Book(BookID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- Insert Libraries
INSERT INTO Library (Name, Location, ContactNumber, EstablishedYear)
VALUES 
('Central Public Library', '123 Main St, New York, NY', '212-555-1001', 1895),
('Westside Community Library', '456 Oak Ave, Los Angeles, CA', '310-555-2002', 1960),
('Downtown Branch Library', '789 Pine Rd, Chicago, IL', '312-555-3003', 1925);

-- Insert Staff
INSERT INTO Staff (FullName, Position, ContactNumber, LibraryID)
VALUES 
('Sarah Johnson', 'Head Librarian', '212-555-1101', 1),
('Michael Chen', 'Assistant Librarian', '212-555-1102', 1),
('Emily Wilson', 'Library Director', '310-555-2101', 2),
('David Rodriguez', 'Circulation Manager', '312-555-3101', 3),
('Jessica Kim', 'Children''s Librarian', '312-555-3102', 3);

-- Insert Members
INSERT INTO Member (FullName, Email, PhoneNumber, MembershipStartDate)
VALUES 
('Robert Smith', 'robert.smith@email.com', '917-555-4001', '2020-01-15'),
('Jennifer Lee', 'jennifer.lee@email.com', '917-555-4002', '2021-03-22'),
('Thomas Brown', 'thomas.brown@email.com', '917-555-4003', '2022-05-10'),
('Amanda Wilson', 'amanda.wilson@email.com', '917-555-4004', '2022-07-18'),
('James Garcia', 'james.garcia@email.com', '917-555-4005', '2023-01-05'),
('Elizabeth Taylor', 'elizabeth.taylor@email.com', '917-555-4006', '2023-02-14');

-- Insert Books
INSERT INTO Book (ISBN, Title, Genre, Price, AvailabilityStatus, ShelfLocation, LibraryID)
VALUES
('978-0061120084', 'To Kill a Mockingbird', 'Fiction', 12.99, 1, 'Fiction A12', 1),
('978-0451524935', '1984', 'Fiction', 9.99, 1, 'Fiction B34', 1),
('978-0743273565', 'The Great Gatsby', 'Fiction', 10.50, 0, 'Fiction C56', 2),
('978-0307474278', 'The Da Vinci Code', 'Fiction', 14.95, 1, 'Fiction D78', 2),
('978-0143127550', 'Sapiens: A Brief History of Humankind', 'Non-fiction', 18.99, 1, 'Non-fiction E12', 3),
('978-0062315007', 'The Alchemist', 'Fiction', 11.25, 1, 'Fiction F34', 3),
('978-0544003415', 'The Lord of the Rings', 'Fiction', 22.50, 0, 'Fiction G56', 1),
('978-0743477109', 'Gone with the Wind', 'Fiction', 13.75, 1, 'Fiction H78', 2),
('978-0399501487', 'Lord of the Flies', 'Fiction', 8.99, 1, 'Fiction I12', 3),
('978-0060850524', 'Charlotte''s Web', 'Children', 7.99, 1, 'Children J34', 1),
('978-0439023481', 'The Hunger Games', 'Fiction', 12.50, 1, 'Fiction K56', 2),
('978-0545010221', 'Harry Potter and the Sorcerer''s Stone', 'Children', 15.99, 0, 'Children L78', 3);

-- Insert Loans
INSERT INTO Loan (LoanDate, DueDate, ReturnDate, Status, MemberID, BookID)
VALUES
('2023-01-10', '2023-02-10', '2023-02-08', 'Returned', 1, 1),
('2023-01-15', '2023-02-15', '2023-02-20', 'Overdue', 2, 3),
('2023-02-01', '2023-03-01', NULL, 'Issued', 3, 7),
('2023-02-05', '2023-03-05', '2023-03-01', 'Returned', 4, 5),
('2023-02-10', '2023-03-10', NULL, 'Issued', 5, 12),
('2023-02-15', '2023-03-15', '2023-03-10', 'Returned', 6, 9),
('2023-02-20', '2023-03-20', NULL, 'Issued', 1, 4),
('2023-03-01', '2023-04-01', NULL, 'Issued', 2, 6),
('2023-03-05', '2023-04-05', NULL, 'Issued', 3, 2),
('2023-03-10', '2023-04-10', '2023-04-05', 'Returned', 4, 8);

-- Insert Payments
INSERT INTO Payment (PaymentDate, Amount, Method, LoanID)
VALUES
('2023-02-25', 5.00, 'Credit Card', 2),
('2023-03-05', 3.50, 'Cash', 2),
('2023-03-15', 2.00, 'Debit Card', 6),
('2023-04-10', 7.50, 'Credit Card', 10);

-- Insert Reviews
INSERT INTO Review (Rating, Comments, ReviewDate, MemberID, BookID)
VALUES
(5, 'A timeless classic that everyone should read!', '2023-02-09', 1, 1),
(4, 'Thought-provoking but somewhat depressing.', '2023-02-22', 2, 3),
(5, 'Absolutely fascinating look at human history.', '2023-03-02', 4, 5),
(3, 'Good story but the ending was predictable.', '2023-03-12', 6, 9),
(5, 'My children loved this book!', '2023-04-06', 4, 10),
(4, 'Engaging plot with memorable characters.', '2023-04-08', 5, 12);


-- View all Libraries
SELECT * FROM Library;

-- View all Staff members
SELECT * FROM Staff;

-- View all Members
SELECT * FROM Member;

-- View all Books
SELECT * FROM Book;

-- View all Loans
SELECT * FROM Loan;

-- View all Payments
SELECT * FROM Payment;

-- View all Reviews
SELECT * FROM Review;

DELETE FROM Member WHERE MemberID = 1;