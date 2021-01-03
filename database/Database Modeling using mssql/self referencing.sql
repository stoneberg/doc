
USE test
GO

---Self-referencing one-to-many relationship example between EMP_ID and MANAGER_ID--- 

CREATE TABLE EMP (
  EMP_ID INT,
  EMP_NAME VARCHAR(20) NOT NULL,
  MANAGER_ID INT,
  POSITION VARCHAR(20) NOT NULL,
CONSTRAINT EMP_EMP_ID_PK PRIMARY KEY (EMP_ID),
CONSTRAINT EMP_MANAGER_ID_FK FOREIGN KEY (MANAGER_ID)
  REFERENCES EMP (EMP_ID));
  
INSERT INTO EMP (EMP_ID, EMP_NAME, MANAGER_ID, POSITION) VALUES (1, 'Judy', null, 'CEO');
INSERT INTO EMP (EMP_ID, EMP_NAME, MANAGER_ID, POSITION) VALUES (2, 'James', 1, 'Sales Manager');
INSERT INTO EMP (EMP_ID, EMP_NAME, MANAGER_ID, POSITION) VALUES (3, 'Amanda', 1, 'Accountant');
INSERT INTO EMP (EMP_ID, EMP_NAME, MANAGER_ID, POSITION) VALUES (4, 'Bob', 2, 'Sales Rep');

SELECT *
FROM EMP;

/*
In the EMP table we have a Self-Referencing Foreign Key placed on the MANAGER_ID column 
which is referencing the EMP_ID column in the same table. 
For example, Bob's manager is employee id 2, which is James.
The foreign key constraint prevents someone from adding a MANAGER_ID that is not also an EMP_ID.
*/

--We can join the table itself to see the manager name for each employee:

SELECT 
  E.EMP_ID, 
  E.EMP_NAME, 
  E.MANAGER_ID,
  E2.EMP_NAME AS MANAGER_NAME
FROM EMP E JOIN EMP E2
ON E.MANAGER_ID = E2.EMP_ID;

/*
However, in the query above we are missing Judy. Judy does not have a manager because
she is the CEO and she has a null value for MANAGER_ID. 
To return all employees, regardless of whether or not they have MANAGER_ID then we 
can re-write the above query using an outer join:
*/

SELECT 
  E.EMP_ID, 
  E.EMP_NAME, 
  E.MANAGER_ID,
  E2.EMP_NAME AS MANAGER_NAME
FROM EMP E LEFT OUTER JOIN EMP E2
ON E.MANAGER_ID = E2.EMP_ID;

DROP TABLE EMP;











