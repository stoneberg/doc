
/*
In this example we are going to create two tables: EMPLOYEES and DEPARTMENTS.
Also in this organisation we are assuming that each employee can be assigned 
to only one department and one department can have many employees.
Therefore we say that the departments table is the parent table 
and the employees table is the child table.
*/

USE test
GO

CREATE TABLE DEPARTMENTS
(
  DEPT_ID INT,
  DEPT_NAME VARCHAR(30) NOT NULL,
  PHONE VARCHAR(20),
CONSTRAINT DEPARTMENTS_DEPT_ID_PK PRIMARY KEY (DEPT_ID),
CONSTRAINT DEPARTMENTS_DEPT_NAME_UK UNIQUE (DEPT_NAME)
);

INSERT INTO DEPARTMENTS (DEPT_ID, DEPT_NAME, PHONE) VALUES (101, 'Accounting', '843-124-09');
INSERT INTO DEPARTMENTS (DEPT_ID, DEPT_NAME, PHONE) VALUES (102, 'Marketing', '843-189-10');
INSERT INTO DEPARTMENTS (DEPT_ID, DEPT_NAME, PHONE) VALUES (103, 'Sales', '843-254-11');
INSERT INTO DEPARTMENTS (DEPT_ID, DEPT_NAME, PHONE) VALUES (104, 'IT', '843-128-04');

SELECT *
FROM DEPARTMENTS;

CREATE TABLE EMPLOYEES (
  EMP_ID INT,
  DEPARTMENT_ID INT, 
  FIRST_NAME VARCHAR(50) NOT NULL,
  LAST_NAME VARCHAR(50) NOT NULL,
CONSTRAINT EMPLOYEES_EMP_ID_PK PRIMARY KEY (EMP_ID),
CONSTRAINT EMPLOYEES_DEPT_ID_FK FOREIGN KEY (DEPARTMENT_ID)
REFERENCES DEPARTMENTS (DEPT_ID));

/*
Now we have added a foreign key constraint (called EMPLOYEES_DEPT_ID_FK) 
on the DEPARTMENT_ID column in the EMPLOYEES table.
This foreign key references the DEPT_ID column in the DEPARTMENTS table.
This foreign key constraint restricts the values that we can enter 
into the DEPARTMENT_ID column in the EMPLOYEES table: 
We can only enter values into the DEPARTMENT_ID column that first exist 
in the DEPT_ID column in the DEPARTMENTS table or are null.
*/

INSERT INTO EMPLOYEES (EMP_ID, DEPARTMENT_ID, FIRST_NAME, LAST_NAME) VALUES (1, 101, 'Andrew', 'Rivers');

SELECT *
FROM EMPLOYEES;

INSERT INTO EMPLOYEES (EMP_ID, DEPARTMENT_ID, FIRST_NAME, LAST_NAME) VALUES (2, 808, 'Vera', 'Hill');

/*
SQL Error: The INSERT statement conflicted with the FOREIGN KEY constraint "EMPLOYEES_DEPT_ID_FK".
Cause:    A foreign key value has no matching primary key value. 
			There is no department id of 808 in the DEPARTMENTS table.
*/

INSERT INTO EMPLOYEES (EMP_ID, DEPARTMENT_ID, FIRST_NAME, LAST_NAME) VALUES (2, 101, 'Vera', 'Hill');
INSERT INTO EMPLOYEES (EMP_ID, DEPARTMENT_ID, FIRST_NAME, LAST_NAME) VALUES (3, 102, 'Ben', 'Jones');
INSERT INTO EMPLOYEES (EMP_ID, DEPARTMENT_ID, FIRST_NAME, LAST_NAME) VALUES (4, 103, 'Ben', 'Jones');
INSERT INTO EMPLOYEES (EMP_ID, DEPARTMENT_ID, FIRST_NAME, LAST_NAME) VALUES (5, 103, 'Chelsea', 'Walsh');

SELECT *
FROM EMPLOYEES;

--Now we will insert some employees who do not have department id's yet:
INSERT INTO EMPLOYEES (EMP_ID, DEPARTMENT_ID, FIRST_NAME, LAST_NAME) VALUES (6, null, 'Jessica', 'Shaw');
INSERT INTO EMPLOYEES (EMP_ID, DEPARTMENT_ID, FIRST_NAME, LAST_NAME) VALUES (7, null, 'Emily', 'Anderson');
--2 rows inserted.


SELECT *
FROM EMPLOYEES;

/*
Notice that we were able to insert employees Jessica Shaw and Emily Anderson 
even though department_id is set to null.Therefore in the majority of cases you want 
to make sure that the column that has the foreign key constraint is also given a not null constraint.

In cases where a foreign key column does not also have a not null constraint then 
often people querying the database will need to ensure they use an outer join rather than an inner join.
*/


---INNER JOIN example---

SELECT
  E.EMP_ID,
  E.FIRST_NAME,
  E.LAST_NAME,
  E.DEPARTMENT_ID,
  D.DEPT_NAME
FROM EMPLOYEES E INNER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPT_ID;

/*
In the SELECT query above we are joining the EMPLOYEES table onto the DEPARTMENTS table using an inner join.
An inner join only connects rows in both tables if there are matched rows between the tables.

Note that the INNER keyword is optional.
Also note that we have given the EMPLOYEES table an alias name of "E" and the DEPARTMENTS table an alias name of "D".
Therefore in the select query we then specify from which table to get the column from 
e.g. D.DEPT_NAME from the DEPARTMENTS table.

In this case we are missing employees Jessica Shaw and Emily Anderson because they have null values for department_id.
Therefore, in order to return all the employees from the employees table
regardless of whether they have a matching department id in the DEPARTMENTS table 
then the person writing the query needs to use an outer join instead:
*/

--Outer join example---

SELECT
  E.EMP_ID,
  E.FIRST_NAME,
  E.LAST_NAME,
  E.DEPARTMENT_ID,
  D.DEPT_NAME
FROM EMPLOYEES E LEFT OUTER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPT_ID;

/*
The revised query above returns all employees and if data exists in the EMPLOYEES table that
has no matching value in the DEPARTMENTS table then any unmatched employees will still
be included in the query output. In this case, Jessica Shaw and Emily Anderson are returned in
the query even though they have null values for the DEPARTMENT_ID column (i.e. non-matched).
*/


--Deleting employees which have not been assigned a department i.e. where dept_id is null.
DELETE FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NULL;


--Altering the EMPLOYEES table to ensure that the DEPARTMENT_ID column has a NOT NULL constraint added to it:

ALTER TABLE EMPLOYEES 
  ALTER COLUMN DEPARTMENT_ID INT NOT NULL;


INSERT INTO EMPLOYEES (EMP_ID, DEPARTMENT_ID, FIRST_NAME, LAST_NAME) VALUES (6, null, 'Jessica', 'Shaw');
---SQL Error: Cannot insert the value NULL into column 'DEPARTMENT_ID'


INSERT INTO EMPLOYEES (EMP_ID, DEPARTMENT_ID, FIRST_NAME, LAST_NAME) VALUES (6, 103, 'Jessica', 'Shaw');
INSERT INTO EMPLOYEES (EMP_ID, DEPARTMENT_ID, FIRST_NAME, LAST_NAME) VALUES (7, 103, 'Emily', 'Anderson');

SELECT *
FROM EMPLOYEES;


/*
Creating a view which joins columns from both tables based on the department ID.
A view is a database object which is essentially a stored query which has a name.
*/

CREATE VIEW EMPLOYEES_DEPT AS
SELECT
  E.EMP_ID,
  E.FIRST_NAME,
  E.LAST_NAME,
  E.DEPARTMENT_ID,
  D.DEPT_NAME,
  D.PHONE
FROM EMPLOYEES E INNER JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPT_ID;


SELECT *
FROM EMPLOYEES_DEPT;


DROP TABLE EMPLOYEES;
DROP TABLE DEPARTMENTS;
DROP VIEW EMPLOYEES_DEPT;











  



















































	




