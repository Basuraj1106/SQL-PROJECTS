-- Libarary Management System --

CREATE DATABASE Library;

USE Library;

-- Creating Branch Table --

CREATE TABLE Branch (
		Branch_ID VARCHAR(10) PRIMARY KEY,	
		Manager_ID VARCHAR(10),
		Branch_Address VARCHAR(50),
		Contact_No CHAR(10));

-- Creating Employee Table --

CREATE TABLE Employee (
		Emp_ID VARCHAR(10) PRIMARY KEY,
		Emp_Name VARCHAR(10),	
		position VARCHAR(50),	
		Salary FLOAT,	
		Branch_ID VARCHAR(10),
		FOREIGN KEY (Branch_ID) REFERENCES Branch (Branch_ID));

-- Creating Books Table --

CREATE TABLE Books (
		Isbn VARCHAR(50),
		Book_Title VARCHAR(50),	
		Category VARCHAR(50),
		Rental_Price FLOAT,	
		Status CHAR(10), 	
		Author VARCHAR(50),	
		Publisher VARCHAR(50),
		PRIMARY KEY (Isbn));

		alter table books
		alter column book_title varchar(80);
-- Creating Return_Status Table --

CREATE TABLE Return_Status (
		Return_ID VARCHAR(10) PRIMARY KEY ,	
		Issued_ID VARCHAR(10),	
		Return_Book_Name VARCHAR(80),	
		Return_Date DATE,	
		Return_Book_Isbn VARCHAR(50),
		FOREIGN KEY (Return_Book_Isbn) REFERENCES Books (Isbn));

-- Creating Members Table --

CREATE TABLE Members (
		Member_ID VARCHAR(10) PRIMARY KEY ,	
		Member_Name VARCHAR(50),	
		Member_Address VARCHAR(50),	
		Reg_Date DATE);

-- Creating Issued Status Table --

CREATE TABLE Issued_Status (
		Issued_ID VARCHAR(10) PRIMARY KEY,	
		issued_Member_ID VARCHAR(10),	
		Issued_Book_Name VARCHAR(50),	
		Issued_Date DATE,	
		Issued_Book_Isbn VARCHAR(50),	
		Issued_Emp_ID VARCHAR(10),
		FOREIGN KEY (Issued_Book_Isbn) REFERENCES Books(Isbn),
		FOREIGN KEY (issued_Member_ID) REFERENCES Members(Member_ID),
		FOREIGN KEY (Issued_Emp_ID) REFERENCES Employee(Emp_ID));












