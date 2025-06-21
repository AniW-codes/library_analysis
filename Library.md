# Library Management System using SQL Project

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `pproject_Library`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](https://github.com/najirh/Library-System-Management---P2/blob/main/library.jpg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

- **Database Creation**: Created a database named `pproject_Library`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.


```sql


--------Schemas---------


CREATE DATABASE pproject_Library;

DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);



-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);



-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);



-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
Insert into pproject_Library.dbo.books
Values
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

```
**Task 2: Update an Existing Member's Address**

```sql
Update pproject_Library.dbo.members
Set member_address = '125 Oak St'
where member_id = 'C103';
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql

Delete from pproject_Library.dbo.issued_status
where issued_id = 'IS107';

```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql

Select * from 
pproject_Library.dbo.issued_status
where issued_emp_id = 'E101';

```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
With CTE_Issue as(
Select      issued_emp_id,
            COUNT(issued_id) as Books_Issued
from pproject_Library.dbo.issued_status
group by issued_emp_id
)


Select issued_emp_id from CTE_Issue
where Books_Issued > 1

```

- **Task 6: Create Summary Tables**: Used CTE to generate new tables based on query results - each book and total book_issued_cnt**

```sql
With CTE_Books_Count as (

Select      books.isbn,
            books.book_title,
            COUNT(issued_status.issued_id) as Issued_Times
from pproject_Library.dbo.books
join pproject_Library.dbo.issued_status
	on books.isbn = issued_status.issued_book_isbn
Group By 1, 2
)

Select * from CTE_Books_Count

```


### 3. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
SELECT * FROM books
WHERE category = 'Classic';
```

8. **Task 8: Find Total Rental Income by Category**:

```sql

Select      category,
            SUM(Rental_price) as Total,
            COUNT(*)
from pproject_Library.dbo.books
join pproject_Library.dbo.issued_status
	on books.isbn = issued_status.issued_book_isbn
Group By category
Order by 2 desc

```

9. **List Members Who Registered in the Last 180 Days**:
```sql

Select * 
from pproject_Library.dbo.members
where reg_date >= GETDATE() - 365

-------

Select * 
from pproject_Library.dbo.members
where reg_date >= CURRENT_TIMESTAMP - 365

```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql

Select      e1.*,
            e2.emp_id,
            e2.emp_name as Manager_name
from pproject_Library.dbo.employees as e1
join pproject_Library.dbo.branch
	on e1.branch_id = branch.branch_id
join pproject_Library.dbo.employees as e2
	on branch.manager_id = e2.emp_id

```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql

Select * into books_price_greater_than_seven
from pproject_Library.dbo.books
where rental_price > 7;


Select * from books_price_greater_than_seven

```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql

Select Distinct(issued_book_name) 
from pproject_Library.dbo.issued_status
left join pproject_Library.dbo.return_status
	on issued_status.issued_id = return_status.issued_id
where return_id is NULL;

```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
SELECT 
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    -- rs.return_date,
    CURRENT_DATE - ist.issued_date as over_dues_days
FROM issued_status as ist
JOIN 
members as m
    ON m.member_id = ist.issued_member_id
JOIN 
books as bk
ON bk.isbn = ist.issued_book_isbn
LEFT JOIN 
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE 
    rs.return_date IS NULL
    AND
    (CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1
```


**Task 14: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql

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


**Task 15: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql

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

**Task 16: Identify Members Issuing High-Risk Books**  
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.    

```sql

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
GROUP BY member_name, issued_book_name;

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
