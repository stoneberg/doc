

CREATE TABLE EMPLOYEES_TEST 
(
	SSN VARCHAR(11),
	EMP_ID INT, --i.e. integer whole numbers which can range from -2^31 (-2,147,483,648) to 2^31-1 (2,147,483,647)
	FIRST_NAME VARCHAR(50), --variable character field (VARCHAR) can contain alphanumeric and other types of characters.
	LAST_NAME VARCHAR(50) 
);

--Note that indenting is not required in SQL. It is only used to help with readability.




---Inserting rows into the table using the insert statement:

INSERT INTO EMPLOYEES_TEST (SSN, EMP_ID, FIRST_NAME, LAST_NAME) VALUES ('751-03-1503', 1, 'Andrew', 'Rivers');
INSERT INTO EMPLOYEES_TEST (SSN, EMP_ID, FIRST_NAME, LAST_NAME) VALUES ('039-54-4183', 2, 'Vera', 'Hill');
INSERT INTO EMPLOYEES_TEST (SSN, EMP_ID, FIRST_NAME, LAST_NAME) VALUES ('520-05-0425', 3, 'Ben', 'Jones');
INSERT INTO EMPLOYEES_TEST (SSN, EMP_ID, FIRST_NAME, LAST_NAME) VALUES ('662-10-5060', 4, 'Ben', 'Jones');
INSERT INTO EMPLOYEES_TEST (SSN, EMP_ID, FIRST_NAME, LAST_NAME) VALUES ('257-34-8033', 5, 'Chelsea', 'Walsh');


---Selecting specific columns from the table:

SELECT SSN, EMP_ID, FIRST_NAME, last_name
FROM EMPLOYEES_TEST;



---We can also use the asterisk symbol (*) to select all columns:

SELECT *
FROM EMPLOYEES_TEST;


/*
Note:
We can also insert data into SQL Server from various formats
such as csv files using SQL Server Management Studio.

However, for this course, all data will be inserted using
SQL insert statements
*/




/*
At this point we have a simple table called EMPLOYEES_TEST which has no constraints on it.
Employee Chelsea Walsh has just got married and has now changed her last name to 'Miller'.
Let's now update Chelsea's last name. Since we are modifying an existing row we use the UPDATE statement to do this:
*/

UPDATE EMPLOYEES_TEST
SET LAST_NAME = 'Miller'
WHERE EMP_ID = 5;

SELECT *
FROM EMPLOYEES_TEST;


/*
Employee Andrew Rivers (employee id: 1) has now retired and therefore we want to remove this row.
We therefore use the DELETE statement to do this:
*/

DELETE FROM EMPLOYEES_TEST
WHERE EMP_ID = 1;

SELECT *
FROM EMPLOYEES_TEST;





/*
CREATE TABLE and DROP TABLE are examples of Data Definition Language (DDL).

INSERT, UPDATE and DELETE are examples of Data Manipulation Language (DML).
Note that in SQL Server the default behaviour is set to autocommit.
For example, in the default autocommit mode, if an INSERT/UPDATE/DELETE statement is issued 
then this is automatically saved to the database.

There are other options for managing transactions. One method is to issue
a BEGIN TRANSACTION command before executing DML statements then you
have option of saving (COMMIT TRANSACTION) or undo the changes (ROLLBACK):
*/

BEGIN TRANSACTION;

INSERT INTO EMPLOYEES_TEST (SSN, EMP_ID, FIRST_NAME, LAST_NAME) VALUES ('257-35-8088', 6, 'Niigel', 'Williams');


SELECT *
FROM EMPLOYEES_TEST;

---Nigel's name is spelt wrong. Because we used BEGIN TRANSACTION and have not committed the transaction we can rollback the insert:

ROLLBACK; 

--undo the insert to return the table back to its former state before the transaction began.

SELECT *
FROM EMPLOYEES_TEST;

----------------------------------------

BEGIN TRANSACTION;

INSERT INTO EMPLOYEES_TEST (SSN, EMP_ID, FIRST_NAME, LAST_NAME) VALUES ('257-35-8088', 6, 'Nigel', 'Williams');

SELECT *
FROM EMPLOYEES_TEST;

COMMIT TRANSACTION; --ends the transaction and saves (commits) to the database.


--To delete the whole table (remove from the database) we use the DROP statement:

DROP TABLE EMPLOYEES_TEST;












