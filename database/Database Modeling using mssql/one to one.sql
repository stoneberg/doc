
USE test
GO

CREATE TABLE EMPLOYEES2 (
  EMP_ID INT,
  FIRST_NAME VARCHAR(30) NOT NULL,
  LAST_NAME VARCHAR(30) NOT NULL,
CONSTRAINT EMPLOYEES2_EMP_ID_PK PRIMARY KEY (EMP_ID));



INSERT INTO EMPLOYEES2 (EMP_ID, FIRST_NAME, LAST_NAME) VALUES (1, 'Andrew', 'Smale');
INSERT INTO EMPLOYEES2 (EMP_ID, FIRST_NAME, LAST_NAME) VALUES (2, 'Vera', 'Hill');
INSERT INTO EMPLOYEES2 (EMP_ID, FIRST_NAME, LAST_NAME) VALUES (3, 'Ben', 'Jones');
INSERT INTO EMPLOYEES2 (EMP_ID, FIRST_NAME, LAST_NAME) VALUES (4, 'Ben', 'Jones');
INSERT INTO EMPLOYEES2 (EMP_ID, FIRST_NAME, LAST_NAME) VALUES (5, 'Chelsea', 'Miller');
INSERT INTO EMPLOYEES2 (EMP_ID, FIRST_NAME, LAST_NAME) VALUES (6, 'Jessica', 'Shaw');

SELECT *
FROM EMPLOYEES2;



---COMPENSATION table has been selected as the child table to EMPLOYEES table---

CREATE TABLE COMPENSATION (
	EMP_ID INT,
	SALARY DECIMAL(12,2) NOT NULL,
	HEALTH_INSURANCE_PLAN VARCHAR(50) NOT NULL,
CONSTRAINT COMPENSATION_EMP_ID_PK PRIMARY KEY (EMP_ID),
CONSTRAINT COMPENSATIONS_EMP_ID_FK FOREIGN KEY (EMP_ID)
  REFERENCES EMPLOYEES2 (EMP_ID));


INSERT INTO COMPENSATION (EMP_ID, SALARY, HEALTH_INSURANCE_PLAN) VALUES (1, 70000, 'Medical Basic');
INSERT INTO COMPENSATION (EMP_ID, SALARY, HEALTH_INSURANCE_PLAN) VALUES (2, 70000, 'Full Medical');
INSERT INTO COMPENSATION (EMP_ID, SALARY, HEALTH_INSURANCE_PLAN) VALUES (3, 65000, 'Medical Basic');
INSERT INTO COMPENSATION (EMP_ID, SALARY, HEALTH_INSURANCE_PLAN) VALUES (4, 80000.45, 'Full Medical');
INSERT INTO COMPENSATION (EMP_ID, SALARY, HEALTH_INSURANCE_PLAN) VALUES (5, 65000, 'Medical Basic');
INSERT INTO COMPENSATION (EMP_ID, SALARY, HEALTH_INSURANCE_PLAN) VALUES (6, 69000, 'Health Plus');

SELECT *
FROM COMPENSATION;


/*
In SQL Server, we also use primary and foreign keys to enforce a one-to-one relationship.
On one side of the relationship we have a table with a primary key constraint (i.e. the parent table).
On the other side of the relationship we have a child table that has a foreign key constraint
referencing the other table's primary key. This column - with the foreign key - also has a primary key constraint on it.

In this example, the EMPLOYEES2 table has been selected as the parent table and has a primary key constraint placed on the
EMP_ID column. 

The COMPENSATION table is the child table and its primary key column also has a foreign key constraint which references
the EMP_ID column in the EMPLOYEES2. This ensures that EMP_ID values entered into the COMPENSATION table are valid in that
they first exist in EMPLOYEES2 table. 

The EMP_ID column also has a primary constraint on it. This ensures that the relationship
between the two tables is always one-to-one. Each parent record can only have one child record.
*/


---ADDING NEW EMPLOYEES---

/*
If we have a new employee we would first need to insert their details into the EMPLOYEES2 table. 
We always need to insert records into the parent table before the child table.
Then we would need to ensure that we add the new employee's salary
and health insurance plan into the COMPENSATION table:
*/



INSERT INTO EMPLOYEES2 (EMP_ID, FIRST_NAME, LAST_NAME) VALUES (7, 'Erica', 'Garvin');

SELECT *
FROM EMPLOYEES2;



----

INSERT INTO COMPENSATION (EMP_ID, SALARY, HEALTH_INSURANCE_PLAN) VALUES (7, 95000, 'Hospital Care');

SELECT *
FROM COMPENSATION



-----------------------------------------------
---Query to join the columns from both tables--

SELECT 
  EMP.EMP_ID, 
  EMP.FIRST_NAME,
  EMP.LAST_NAME,
  COMP.SALARY,
  COMP.HEALTH_INSURANCE_PLAN
FROM EMPLOYEES2 EMP JOIN COMPENSATION COMP
ON EMP.EMP_ID = COMP.EMP_ID;

/*
In this situation rather than put all information about an employee in the EMPLOYEES table
for privacy reasons we separated out sensitive information such as salary and insurance into 
a table called COMPENSATION. We could then restrict access to the COMPENSATION table in different
ways.

An alternative to separating out employee information into two tables with one table containing
information on compensation is to instead hold all attributes in a single employees table
which has restricted access. Then create a view which selects only columns we allow others in
the organisation to see:
*/



CREATE TABLE EMPLOYEES3 (
  EMP_ID INT,
  FIRST_NAME VARCHAR(30) NOT NULL,
  LAST_NAME VARCHAR(30) NOT NULL,
  SALARY DECIMAL(12,2) NOT NULL,
  HEALTH_INSURANCE_PLAN VARCHAR(50) NOT NULL,
CONSTRAINT EMPLOYEES3_PK PRIMARY KEY (EMP_ID));


INSERT INTO EMPLOYEES3 (EMP_ID, FIRST_NAME, LAST_NAME, SALARY, HEALTH_INSURANCE_PLAN) VALUES (1, 'Andrew', 'Smale', 70000, 'Medical Basic');
INSERT INTO EMPLOYEES3 (EMP_ID, FIRST_NAME, LAST_NAME, SALARY, HEALTH_INSURANCE_PLAN) VALUES (2, 'Vera', 'Hill', 70000, 'Full Medical');
INSERT INTO EMPLOYEES3 (EMP_ID, FIRST_NAME, LAST_NAME, SALARY, HEALTH_INSURANCE_PLAN) VALUES (3, 'Ben', 'Jones', 65000, 'Medical Basic');
INSERT INTO EMPLOYEES3 (EMP_ID, FIRST_NAME, LAST_NAME, SALARY, HEALTH_INSURANCE_PLAN) VALUES (4, 'Ben', 'Jones', 80000.45, 'Full Medical');
INSERT INTO EMPLOYEES3 (EMP_ID, FIRST_NAME, LAST_NAME, SALARY, HEALTH_INSURANCE_PLAN) VALUES (5, 'Chelsea', 'Miller', 65000, 'Medical Basic');
INSERT INTO EMPLOYEES3 (EMP_ID, FIRST_NAME, LAST_NAME, SALARY, HEALTH_INSURANCE_PLAN) VALUES (6, 'Jessica', 'Shaw', 69000, 'Health Plus');

SELECT *
FROM EMPLOYEES3;




SELECT 
	EMP_ID, FIRST_NAME, LAST_NAME
FROM EMPLOYEES3;


CREATE VIEW EMPLOYEE_DETAILS
AS
SELECT
 EMP_ID, 
 FIRST_NAME, 
 LAST_NAME
FROM EMPLOYEES3;

SELECT *
FROM EMPLOYEE_DETAILS;


DROP TABLE COMPENSATION;
DROP TABLE EMPLOYEES2;
DROP TABLE EMPLOYEES3;
DROP VIEW EMPLOYEE_DETAILS;

















































