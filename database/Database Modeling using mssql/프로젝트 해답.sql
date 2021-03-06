USE test
GO

--Departments:

CREATE TABLE DEPARTMENTS 
(
DEPARTMENT_ID INT,
DEPARTMENT_NAME VARCHAR(30),
CONSTRAINT DEPARTMENTS_DEPARTMENT_ID_PK PRIMARY KEY (DEPARTMENT_ID)
);

INSERT INTO DEPARTMENTS
SELECT DISTINCT DEPARTMENT_ID, DEPARTMENT_NAME
FROM PROJECT_INFO;


--Projects
CREATE TABLE PROJECTS 
(
PROJECT_ID INT,
PROJECT_NAME VARCHAR(30),
PROJECT_BUDGET INT,
CONSTRAINT PROJECTS_PROJECT_ID_PK PRIMARY KEY (PROJECT_ID)
);

INSERT INTO PROJECTS
SELECT DISTINCT PROJECT_ID, PROJECT_NAME, PROJECT_BUDGET
FROM PROJECT_INFO;


--Employees
CREATE TABLE EMPLOYEES
(
	EMPLOYEE_ID INT, 
	EMPLOYEE_NAME VARCHAR(50), 
	SALARY INT, 
	DEPARTMENT_ID INT,
CONSTRAINT EMPLOYEES_EMPLOYEE_ID_PK PRIMARY KEY (EMPLOYEE_ID),
CONSTRAINT EMPLOYEES_DEPARTMENT_ID_FK FOREIGN KEY (DEPARTMENT_ID)
	REFERENCES DEPARTMENTS(DEPARTMENT_ID)
);

INSERT INTO EMPLOYEES 
SELECT DISTINCT EMPLOYEE_ID, EMPLOYEE_NAME, SALARY, DEPARTMENT_ID
FROM PROJECT_INFO;


--Employee Projects association (linking) table:
CREATE TABLE EMPLOYEE_PROJECTS 
(
EMPLOYEE_ID INT,
PROJECT_ID INT,
CONSTRAINT EMPLOYEE_PROJECTS_EMP_ID_PROJ_ID_CPK PRIMARY KEY (EMPLOYEE_ID, PROJECT_ID),
CONSTRAINT EMPLOYEE_PROJECTS_EMP_ID_FK FOREIGN KEY (EMPLOYEE_ID)
	REFERENCES EMPLOYEES (EMPLOYEE_ID),
CONSTRAINT EMPLOYEE_PROJECTS_PROJ_ID_FK FOREIGN KEY (PROJECT_ID)
	REFERENCES PROJECTS (PROJECT_ID)
);

INSERT INTO EMPLOYEE_PROJECTS
SELECT DISTINCT EMPLOYEE_ID, PROJECT_ID
FROM PROJECT_INFO;


/*
DROP TABLE EMPLOYEE_PROJECTS;
DROP TABLE EMPLOYEES;
DROP TABLE DEPARTMENTS;
DROP TABLE PROJECTS;
DROP TABLE PROJECT_INFO;
*/




