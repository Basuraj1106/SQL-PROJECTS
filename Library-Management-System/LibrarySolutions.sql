-- Project TASK


-- ### 2. CRUD Operations


-- Task 1. Create a New Book Record
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO Books VALUES (
		'978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM Books;

-- Task 2: Update an Existing Member's Address

UPDATE Members
SET Member_Address = '1106 Main st'
WHERE Member_ID = 'C101';


-- Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM ISSUED_STATUS
WHERE ISSUED_ID='IS121'


-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT Issued_Book_Name,Issued_Emp_ID,Issued_ID,issued_Member_ID
FROM Issued_Status
WHERE Issued_Emp_ID = 'E101';


-- Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT Issued_Emp_ID,COUNT(Issued_ID) No_Books_Issued
FROM Issued_Status
GROUP BY Issued_Emp_ID
HAVING COUNT(Issued_ID) > 1;


-- ### 3. CTAS (Create Table As Select)

-- Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
SELECT 
    B.Isbn, 
    IST.Issued_Book_Name, 
    COUNT(IST.Issued_id) AS Issued_count
INTO Book_Counts
FROM Books B
INNER JOIN Issued_Status IST
    ON B.Isbn = IST.Issued_book_Isbn
GROUP BY B.Isbn, IST.Issued_Book_Name;

SELECT * FROM Book_Counts;


-- ### 4. Data Analysis & Findings

-- Task 7. **Retrieve All Books in a Specific Category:

SELECT Book_Title,Category
FROM Books
WHERE Category = 'Fantasy';


-- Task 8: Find Total Rental Income by Category:

SELECT Category,SUM(Rental_Price) Total_Price,COUNT(*) Issue_Count
FROM Books B
JOIN Issued_Status IST
ON B.Isbn = IST.Issued_Book_Isbn
GROUP BY Category;


-- Task 9. **List Members Who Registered in the Last 270 Days**:

SELECT * FROM Members
WHERE Reg_Date >= DATEADD(DAY,-270,GETDATE());

-- Task 10: List Employees with Their Branch Manager's Name and their branch details**:

SELECT E1.Emp_Name,B.Branch_Id,Manager_ID,E2.Emp_Name AS Manager_Name 
FROM Employee E1
JOIN Branch B
ON E1.Branch_ID = B.Branch_ID
JOIN Employee E2
ON B.Manager_ID = E2.Emp_ID;


-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold(gt5)

SELECT Book_Title,Rental_Price INTO Book_Price_Gt5 FROM 
Books WHERE Rental_Price > 5


-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT IST.Issued_Book_Name,IST.Issued_ID,RT.Return_ID 
FROM Return_Status RT
RIGHT JOIN Issued_Status IST
ON RT.Issued_ID = IST.Issued_ID
WHERE RT.Return_ID IS NULL;  


-- ### Advanced SQL Operations

-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's name, book title, issue date, and days overdue.

SELECT Member_Name,Issued_book_Name,Issued_Date,Return_Date,DATEDIFF(DAY,IST.Issued_Date,GETDATE()) Overdue 
FROM Members M
JOIN Issued_Status IST
ON M.Member_ID = IST.Issued_Member_ID
LEFT JOIN Return_Status RS
ON RS.Issued_ID = IST.Issued_ID
WHERE Return_Date IS NULL
AND DATEDIFF(DAY,IST.Issued_Date,GETDATE())>30;

-- Task 14: Update Book Status on Return
-- Write a query to update the status of books in the books table to "available" when they are returned (based on entries in the return_status table).
SELECT * FROM issued_status;

select * from return_status

update  books set status='no'
where isbn = '978-0-553-29698-2';

select * from Books
where isbn = '978-0-553-29698-2';


CREATE PROCEDURE Add_return_Product 
    @P_Return_ID VARCHAR(10),
    @P_Issued_ID VARCHAR(10),
    @Book_Quality VARCHAR(15)
AS
BEGIN
    DECLARE @v_isbn VARCHAR(50);
    DECLARE @v_book_name VARCHAR(80);

    -- Insert into Return_Status
    INSERT INTO Return_Status (Return_ID, Issued_ID, Return_Date, Book_Quality)
    VALUES (@P_Return_ID, @P_Issued_ID,GETDATE(), @Book_Quality);

    -- Retrieve the ISBN and Book Name from Issued_Status
    SELECT 
        @v_isbn = Issued_Book_Isbn,
        @v_book_name = Issued_Book_Name
    FROM Issued_Status
    WHERE Issued_ID = @P_Issued_ID;

    -- Update the book's status to 'yes'
    UPDATE Books
    SET Status = 'yes'
    WHERE Isbn = @v_isbn;

    -- Print a thank you message
    PRINT 'Thank you for returning the book: ' + @v_book_name;
END;



Add_return_Product 'RS120','IS132','GOOD';

Add_return_Product 'RS121','IS151','GOOD';


--Task 15: Branch Performance Report
--Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.


SELECT B.Branch_ID,B.Manager_ID,
COUNT(IST.Issued_ID) Total_Books_Isseud,COUNT(Return_ID) Total_Books_returned,
SUM(BK.Rental_Price) Total_Revenue INTO Branch_Report FROM Issued_Status IST
JOIN Employee E
ON IST.Issued_Emp_ID = E.Emp_ID
JOIN Branch B
ON B.Branch_ID = E.Branch_ID
LEFT JOIN Return_Status RS
ON IST.Issued_ID = RS.Issued_ID
JOIN Books BK
ON BK.Isbn = IST.Issued_Book_Isbn
GROUP BY B.Branch_ID,B.Manager_ID;

SELECT * FROM Branch_Report;


-- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 6 months.

SELECT Member_ID,Member_Name INTO Active_Members 
FROM Members
WHERE Member_ID IN (SELECT Issued_Member_ID 
							FROM Issued_Status
							WHERE Issued_Date >= DATEADD(MONTH,-6,GETDATE()));

SELECT * FROM Active_Members;

-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

SELECT TOP 3 E.Emp_Name,B.Branch_ID,COUNT(IST.Issued_ID) No_Of_Books_Issued FROM Employee E
JOIN Issued_Status IST
ON E.Emp_ID = IST.Issued_Emp_ID
JOIN Branch B
ON B.Branch_ID = E.Branch_ID
GROUP BY E.Emp_Name,B.Branch_ID
ORDER BY 3 DESC;

-- Task 18: Identify Members Issuing High-Risk Books
-- Write a query to identify members who have issued books  with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.    


SELECT Member_Name,Issued_Book_Name,COUNT(IST.Issued_ID) No_Of_Books_Issued FROM Issued_Status IST
JOIN Members M
ON IST.issued_Member_ID = M.Member_ID
JOIN Return_Status RS
ON RS.Issued_ID = IST.Issued_ID
WHERE book_quality = 'Damaged'
GROUP BY Member_Name,Issued_Book_Name;



/* Task 19: Stored Procedure
Objective: Create a stored procedure to manage the status of books in a library system.
    Description: Write a stored procedure that updates the status of a book based on its issuance or return. Specifically:
    If a book is issued, the status should change to 'no'.
    If a book is returned, the status should change to 'yes'.*/

	
CREATE PROCEDURE Issue_Book 
@P_Issued_ID VARCHAR(10),
@P_Issued_Member_ID VARCHAR(10),
@P_Issued_Book_Isbn VARCHAR(80),
@P_Issued_Emp_ID VARCHAR(10)

AS
BEGIN
DECLARE @V_Status CHAR(10);

SELECT @V_Status = Status
FROM Books
WHERE Isbn = @P_Issued_Book_Isbn;

IF @V_Status = 'YES'

BEGIN

INSERT INTO Issued_Status (Issued_ID,Issued_Member_ID,Issued_Date,Issued_Book_Isbn,Issued_Emp_ID)
VALUES (@P_Issued_ID,@P_Issued_Member_ID,GETDATE(),@P_Issued_Book_Isbn,@P_Issued_Emp_ID);

UPDATE Books
SET Status = 'NO'
WHERE Isbn = @P_Issued_Book_Isbn

PRINT 'Book records added successfully for book isbn : %' + @p_issued_book_isbn;
END

ELSE
BEGIN

PRINT 'Sorry to inform you the book you have requested is unavailable book_isbn: %' + @p_issued_book_isbn;
END
END;

Issue_Book 'IS155','C110','978-0-06-025492-6','E104'

Issue_Book 'IS156','C110','978-0-307-58837-1','E104';





/*Task 20: Create Table As Select (CTAS)
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of books returned After 30 Days
	Overdue Days
    Total fines
*/

SELECT issued_Member_ID,COUNT(*) Books_Returned_After_30Days,
DATEDIFF(DAY,Issued_Date,Return_Date) Overdue_days,(DATEDIFF(DAY,Issued_Date,Return_Date)*43.15) Total_Fine Into Book_Overdue_Fine_Status
FROM Issued_Status IST
LEFT JOIN Return_Status RS
ON IST.Issued_ID = RS.Issued_ID
WHERE DATEDIFF(DAY,Issued_Date,Return_Date) > 30
GROUP BY issued_Member_ID,Issued_Date,Return_Date;

SELECT * FROM Book_Overdue_Fine_Status;

