select *
from pproject_Library.dbo.return_status

--Create a new record in Books table

Insert into pproject_Library.dbo.books Values
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

select *
from pproject_Library.dbo.books

--Update an existing member address
Update pproject_Library.dbo.members
Set member_address = '125 Oak St'
where member_id = 'C103'

select *
from pproject_Library.dbo.members

--Delete a record with issue ID = IS107 from issue date table

Delete from pproject_Library.dbo.issued_status
where issued_id = 'IS107'

select *
from pproject_Library.dbo.issued_status

-- Retrieve all books issued by Employee E101
Select * from 
pproject_Library.dbo.issued_status
where issued_emp_id = 'E101'

-- List employees who have issued more than one book.
With CTE_Issue as(
Select issued_emp_id, COUNT(issued_id) as Books_Issued
from pproject_Library.dbo.issued_status
group by issued_emp_id

)
Select issued_emp_id from CTE_Issue
where Books_Issued > 1


--Each book and its issuance repetition; Creating a temp table
With CTE_Books_Count as (
Select books.isbn, books.book_title, COUNT(issued_status.issued_id) as Issued_Times
from pproject_Library.dbo.books
join pproject_Library.dbo.issued_status
	on books.isbn = issued_status.issued_book_isbn
Group By books.isbn, books.book_title
						)
Select * from CTE_Books_Count


--Total Rental Income by Category
Select category, SUM(Rental_price) as Total, COUNT(*)
from pproject_Library.dbo.books
join pproject_Library.dbo.issued_status
	on books.isbn = issued_status.issued_book_isbn
Group By category
Order by 2 desc

--Members who registered in last 365 days
Select * 
from pproject_Library.dbo.members
where reg_date >= GETDATE() - 365

Select * 
from pproject_Library.dbo.members
where reg_date >= CURRENT_TIMESTAMP - 365


--List of employees with Branch Manager Names and their branch details
Select e1.*, e2.emp_id, e2.emp_name as Manager_name
from pproject_Library.dbo.employees as e1
join pproject_Library.dbo.branch
	on e1.branch_id = branch.branch_id
join pproject_Library.dbo.employees as e2
	on branch.manager_id = e2.emp_id

--A table of books with rental price > US$7
--(Way To make a permanent table in SSMS)
Select * into books_price_greater_than_seven
from pproject_Library.dbo.books
where rental_price > 7

Select * from books_price_greater_than_seven

--List of books not yet returned
Select Distinct(issued_book_name) 
from pproject_Library.dbo.issued_status
left join pproject_Library.dbo.return_status
	on issued_status.issued_id = return_status.issued_id
where return_id is NULL




--------------------------------Advanced--------------------------------
-- INSERT INTO book_issued in last 30 days
-- SELECT * from employees;
-- SELECT * from books;
-- SELECT * from members;
-- SELECT * from issued_status


INSERT INTO pproject_Library.dbo.issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
('IS151', 'C118', 'The Catcher in the Rye', CURRENT_TIMESTAMP - 24,  '978-0-553-29698-2', 'E108'),
('IS152', 'C119', 'The Catcher in the Rye', CURRENT_TIMESTAMP - 13,  '978-0-553-29698-2', 'E109'),
('IS153', 'C106', 'Pride and Prejudice', CURRENT_TIMESTAMP - 7 ,  '978-0-14-143951-8', 'E107'),
('IS154', 'C105', 'The Road', CURRENT_TIMESTAMP - 32,  '978-0-375-50167-0', 'E101');

-- Adding new column in return_status

ALTER TABLE pproject_Library.dbo.return_status
ADD book_quality VARCHAR(15);

UPDATE pproject_Library.dbo.return_status
SET book_quality = 'Damaged'
WHERE issued_id 
    IN ('IS112', 'IS117', 'IS118');

UPDATE pproject_Library.dbo.return_status
SET book_quality = 'Good'
WHERE issued_id 
    IN ('IS101', 'IS105', 'IS103', 'IS106', 'IS107', 'IS108', 'IS109', 'IS110', 'IS111', 'IS113', 'IS114', 'IS115', 'IS116', 'IS119', 'IS120');


SELECT * FROM pproject_Library.dbo.return_status
SELECT * from pproject_Library.dbo.issued_status

SELECT * from pproject_Library.dbo.employees
SELECT * from pproject_Library.dbo.books
SELECT * from pproject_Library.dbo.members
SELECT * from pproject_Library.dbo.branch

--Members who have books overdue books (return = 30 days period)
--Return memberID, memberName, Book title, issue date and days overdue

-- Issued status == members == books == return status
-- filter by books which are returned
-- check for overdue > 30 days for books not returned yet


SELECT 
	issued_member_id,
	member_name, 
	book_title, 
	issued_date, 
	return_date,
	(CURRENT_TIMESTAMP) - issued_date as overdue_days
FROM pproject_Library.dbo.issued_status
Join pproject_Library.dbo.members
	on issued_status.issued_member_id = members.member_id
join pproject_Library.dbo.books
	on books.isbn = issued_status.issued_book_isbn
left join pproject_Library.dbo.return_status
	on return_status.issued_id = issued_status.issued_id
Where return_date is NULL
	and (CURRENT_TIMESTAMP) - issued_date > 30


--Select CAST(GETDATE() AS DATE)

Select * from pproject_Library.dbo.return_status
SELECT * from pproject_Library.dbo.employees
SELECT * from pproject_Library.dbo.books
SELECT * from pproject_Library.dbo.members
SELECT * from pproject_Library.dbo.branch

--Query to change status of book to 'Yes"
--Manual way of doing so (Cumbersome)
SELECT * from pproject_Library.dbo.issued_status
where issued_book_isbn = '978-0-451-52994-2'

Select *
from pproject_Library.dbo.books
where isbn = '978-0-451-52994-2'

Update pproject_Library.dbo.books
Set status = 'No'
where isbn = '978-0-451-52994-2'

Select *
from pproject_Library.dbo.return_status
where issued_id = 'IS130'

Insert into pproject_Library.dbo.return_status (return_id, issued_id, return_date, book_quality)
Values ('RS125', 'IS130', CURRENT_TIMESTAMP, 'Good')
Select *
from pproject_Library.dbo.return_status
where issued_id = 'IS130'

Update pproject_Library.dbo.books
Set status = 'Yes'
where isbn = '978-0-451-52994-2'

Select *
from pproject_Library.dbo.books
where isbn = '978-0-451-52994-2'

--Branch performance report
--Using left join while joining return table because return table only has 15 entries and this will not give a clear picture.
select * from pproject_Library.dbo.branch
select * from pproject_Library.dbo.issued_status
Select * from pproject_Library.dbo.return_status
SELECT * from pproject_Library.dbo.employees
SELECT * from pproject_Library.dbo.books

Select 
	branch.branch_id, 
	branch.manager_id,
	SUM(books.rental_price) as Rental_income,
	COUNT(issued_status.issued_id) as Issued_books,
	COUNT(return_status.return_id) as Returned_books
from pproject_Library.dbo.issued_status
join pproject_Library.dbo.employees
	on employees.emp_id = issued_status.issued_emp_id
join pproject_Library.dbo.branch
	on branch.branch_id = employees.branch_id
left join pproject_Library.dbo.return_status
	on return_status.issued_id = issued_status.issued_id
join pproject_Library.dbo.books
	on books.isbn = issued_status.issued_book_isbn
GROUP BY
	branch.branch_id, branch.manager_id



--Members who have issued atleast one book in last two month = Active members

SELECT * from pproject_Library.dbo.members
where member_id in
		(select Distinct(issued_member_id)
		from pproject_Library.dbo.issued_status
		where issued_date >= CURRENT_TIMESTAMP - 60)



--Select (CURRENT_TIMESTAMP) - 60


--Top 3 Employees with most book issued processed
select * from pproject_Library.dbo.branch
select * from pproject_Library.dbo.issued_status
SELECT * from pproject_Library.dbo.employees
SELECT * from pproject_Library.dbo.books

select TOP(3)
	emp_name,
	branch.branch_id,
	COUNT(issued_id) as Number_of_Books_Issued_By_Employee
from pproject_Library.dbo.issued_status
join pproject_Library.dbo.employees
	on issued_status.issued_emp_id = employees.emp_id
join pproject_Library.dbo.branch
	on branch.branch_id = employees.branch_id
GROUP BY emp_name, branch.branch_id
ORDER BY Number_of_Books_Issued_By_Employee desc





--Identifying members using High-Risk or Damaged Books

select * from pproject_Library.dbo.issued_status
SELECT * from pproject_Library.dbo.members
Select * from pproject_Library.dbo.return_status

Select 
	member_name, 
	issued_book_name,
	COUNT(book_quality) as Damaged_Books_Count
from pproject_Library.dbo.members
join pproject_Library.dbo.issued_status
	on issued_status.issued_member_id = members.member_id
left join pproject_Library.dbo.return_status
	on issued_status.issued_id = return_status.issued_id
Where book_quality = 'Damaged'
GROUP BY member_name, issued_book_name