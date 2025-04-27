# Library Management System using SQL Project

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `pproject_Library`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project]
## Objectives

1. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
2. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.
3. **Data Analysis & Findings**: Generating Insights from data

## Project Structure

### 1. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
Insert into pproject_Library.dbo.books Values
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

select *
from pproject_Library.dbo.books

```
**Task 2: Update an Existing Member's Address**

```sql
Update pproject_Library.dbo.members
Set member_address = '125 Oak St'
where member_id = 'C103'

select *
from pproject_Library.dbo.members
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
Delete from pproject_Library.dbo.issued_status
where issued_id = 'IS107'

select *
from pproject_Library.dbo.issued_status
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
Select * from 
pproject_Library.dbo.issued_status
where issued_emp_id = 'E101'
```


**Task 5: List Members Who Have Issued More Than One Book using CTE**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
With CTE_Issue as(
Select issued_emp_id, COUNT(issued_id) as Books_Issued
from pproject_Library.dbo.issued_status
group by issued_emp_id

)
Select issued_emp_id from CTE_Issue
where Books_Issued > 1
```

### 2. Advanced SQL Queries

**Task 6: Create Summary Tables**: Used CTE to generate new tables based on query results - each book and total book_issued_cnt**

```sql
With CTE_Books_Count as (
Select books.isbn, books.book_title, COUNT(issued_status.issued_id) as Issued_Times
from pproject_Library.dbo.books
join pproject_Library.dbo.issued_status
	on books.isbn = issued_status.issued_book_isbn
Group By books.isbn, books.book_title
						)
Select * from CTE_Books_Count

```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

**Task 7: Find Total Rental Income by Category**:

```sqlSelect category, SUM(Rental_price) as Total, COUNT(*)
from pproject_Library.dbo.books
join pproject_Library.dbo.issued_status
	on books.isbn = issued_status.issued_book_isbn
Group By category
Order by 2 desc
```

**Task 8: List Members Who Registered in the Last 365 Days**:
```sql
Select * 
from pproject_Library.dbo.members
where reg_date >= GETDATE() - 365

Select * 
from pproject_Library.dbo.members
where reg_date >= CURRENT_TIMESTAMP - 365
```

**Task 9 : List Employees with Their Branch Manager's Name and their branch details**:

```sqlSelect e1.*, e2.emp_id, e2.emp_name as Manager_name
from pproject_Library.dbo.employees as e1
join pproject_Library.dbo.branch
	on e1.branch_id = branch.branch_id
join pproject_Library.dbo.employees as e2
	on branch.manager_id = e2.emp_id


```

10. **Task 10: Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
Select * into books_price_greater_than_seven
from pproject_Library.dbo.books
where rental_price > 7

Select * from books_price_greater_than_seven
```

Task 11: **Retrieve the List of Books Not Yet Returned**
```sql

Select Distinct(issued_book_name) 
from pproject_Library.dbo.issued_status
left join pproject_Library.dbo.return_status
	on issued_status.issued_id = return_status.issued_id
where return_id is NULL



```

## Advanced SQL Operations
**Inserting few data fields**

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

**Task 12: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
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


```


**Task 13 : Update Book Status on Return (Manual Way)**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql

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

```




**Task 14: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
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


```

**Task 15: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql

SELECT * from pproject_Library.dbo.members
where member_id in
		(select Distinct(issued_member_id)
		from pproject_Library.dbo.issued_status
		where issued_date >= CURRENT_TIMESTAMP - 60)


```


**Task 16: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
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




```

**Task 17: Identify Members Issuing High-Risk Books**  
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.    


```
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

```

## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.


## Author - Aniruddha Warang

This project showcases SQL skills essential for database management and analysis. For more content on SQL and data analysis, connect with me through the following channels:

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/aniruddhawarang/)

Thank you for your interest in this project!
