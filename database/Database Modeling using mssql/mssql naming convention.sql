USE test
GO

CREATE TABLE UniCourses (
	CourseID INT,
	CourseName VARCHAR(25),
CONSTRAINT UniCoursesPK PRIMARY KEY (CourseID));

INSERT INTO UniCourses (COURSEID, COURSENAME) VALUES (1, 'Politics');
INSERT INTO UniCourses (COURSEID, COURSENAME) VALUES (2, 'Civil Enginerring');
INSERT INTO UniCourses (COURSEID, COURSENAME) VALUES (3, 'Medicine');
INSERT INTO UniCourses (COURSEID, COURSENAME) VALUES (4, 'Psychology');
INSERT INTO UniCourses (COURSEID, COURSENAME) VALUES (5, 'Economics');

SELECT *
FROM UniCourses;

/*
T-SQL Naming Rules for tables, views and columns:
- Name length must be no longer than 128 characters.

- The first character in a name must be a letter of the alphabet or an underscore. However,
  there are two exceptions: variables must begin with @
  and temporary tables must begin with #

- After the first character, the only special non-alphanumeric characters allowed 
  are the hash symbol (#), the underscore (_), the dollar sign ($), and the 'at' symbol (@)
- Names cannot be T-SQL reserved words. For example you cannot call a table SELECT.

In the UniCourses table definition we have used camel case 
for both the table and column names.
(Note: camel case is where the first letter of each word capitalized and there are no spaces between words).

Beaware of what collation the database has been set up with. 
Collation is a set of rules dictating how each group of characters within SQL Server is treated. 
Collation can be set at server, database, or column level.

I set up a database called 'test' which I left on the default collation of 'Latin1_General_CI_AS'.
In the collation name CI stands for 'case-insensitive' and AS stands for 'Accent Sensitive'.
Case insensitive means that the upper case characters and lower case characters are treated as being the same.
For example A = a 

For an accent sensitive collation 'a' does not equal 'á' 


*/

--If you are using a case-insensitive collation then the following query will still work:
SELECT *
FROM uNiCoUrSEs;



---Case sensitive vs. Case insensitive collation:

SELECT CASE WHEN 'a' = 'A' COLLATE Latin1_General_CS_AS --Case Sensitive
				THEN 'Values are the same'
				ELSE 'Values are different' end as COLLATION_TEST;


SELECT CASE WHEN 'a' = 'A' COLLATE Latin1_General_CI_AS --Case Insensitive
				THEN 'Values are the same'
				ELSE 'Values are different' end as COLLATION_TEST;



---Accent sensitive vs. Accent insensitive collation:

SELECT CASE WHEN 'a' = 'á' COLLATE Latin1_General_CI_AS --Accent Sensitive
				THEN 'Values are the same'
				ELSE 'Values are different' end as COLLATION_TEST;


SELECT CASE WHEN 'a' = 'á' COLLATE Latin1_General_CI_AI --Accent Insensitive
				THEN 'Values are the same'
				ELSE 'Values are different' end as COLLATION_TEST;



--In SQL Server it is possible to create a table with an embedded space:

CREATE TABLE "space test" (
  ID int);

INSERT INTO "space test" (ID) VALUES (1);

SELECT *
from "space test";

--or can use square brackets instead of double quotes:

SELECT *
FROM [space test];


/*
I do not recommended using quotation marks to embed empty spaces when naming objects 
such as tables, views and columns. This is because users would need to know that
they would have to use double quotes or square brackets when writing queries.
Instead I recommend using underscores as it is more readable:
*/

DROP TABLE UniCourses;

CREATE TABLE UNI_COURSES (
	COURSE_ID INT,
	COURSE_NAME VARCHAR(25), 
CONSTRAINT UNI_COURSES_COURSE_ID_PK PRIMARY KEY (COURSE_ID));


INSERT INTO UNI_COURSES (COURSE_ID, COURSE_NAME) VALUES (1, 'Politics');
INSERT INTO UNI_COURSES (COURSE_ID, COURSE_NAME) VALUES (2, 'Civil Enginerring');
INSERT INTO UNI_COURSES (COURSE_ID, COURSE_NAME) VALUES (3, 'Medicine');
INSERT INTO UNI_COURSES (COURSE_ID, COURSE_NAME) VALUES (4, 'Psychology');
INSERT INTO UNI_COURSES (COURSE_ID, COURSE_NAME) VALUES (5, 'Economics');

SELECT *
FROM UNI_COURSES;

---

CREATE TABLE course_books (
	book_id INT,
	book_name VARCHAR(50) NOT NULL,
	c_id INT NOT NULL,
CONSTRAINT course_books_book_id_pk PRIMARY KEY (book_id),
CONSTRAINT course_books_c_id_fk FOREIGN KEY (c_id) REFERENCES uni_courses (course_id));

INSERT INTO course_books (book_id, book_name, c_id) VALUES (101, 'Political Discourse in Asia', 1);
INSERT INTO course_books (book_id, book_name, c_id) VALUES (102, 'Games in Politics', 1);
INSERT INTO course_books (book_id, book_name, c_id) VALUES (103, 'Environmental Politics', 1);

SELECT *
FROM course_books;


/*

In this example we have the child table (COURSE_BOOKS) which has a column called C_ID which has foreign key constraint.
This foreign key constraint references back to the COURSE_ID column in the UNI_COURSES table.

Both the C_ID and COURSE_ID columns are referring to the same thing i.e. The unique identifier for each course.
Therefore, to make things easier to understand for people writing queries, I recommend using the same column name.
In other words, giving the column which has the foreign key constraint the same name as the primary key column 
that it references:

*/

DROP TABLE course_books;

CREATE TABLE course_books (
	book_id INT,
	book_name VARCHAR(50) NOT NULL,
	course_id INT NOT NULL,
CONSTRAINT course_books_book_id_pk PRIMARY KEY (book_id),
CONSTRAINT course_books_c_id_fk FOREIGN KEY (course_id) REFERENCES uni_courses (course_id));

INSERT INTO course_books (book_id, book_name, course_id) VALUES (101, 'Political Discourse in Asia', 1);
INSERT INTO course_books (book_id, book_name, course_id) VALUES (102, 'Games in Politics', 1);
INSERT INTO course_books (book_id, book_name, course_id) VALUES (103, 'Environmental Politics', 1);



---Naming of constraints---

/*
I use the following naming conventions for constraints:

First the table name followed by suffix which...

- If it is a primary key constraint then I'll use the suffix _PK. 
- If it is a composite (multi-column) primary key constraint then I'll use the suffix _CPK.
- For foreign keys constraints I'll use the suffix _FK, _FK2, FK3, etc.
- For unique constraints I'll use suffix _UNQ, UNQ2, UNQ3, etc.
- For check constraints I'll use suffix _CHK, _CHK2, _CHK3, etc.

Note: that many people prefer to use a prefix rather than a suffix to indicate the type of constraint
      in the name.

I recommend creating constraints out-of-line so that they can be given a more meaningful name rather
creating constraints in-line whereby SQL Server will assign a system-generated name. 

*/
-----------------------------------------------------


DROP TABLE COURSE_BOOKS;
DROP TABLE UNI_COURSES;
DROP TABLE "space test";




































