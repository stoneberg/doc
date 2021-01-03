

CREATE TABLE STUDENT_GRADES1 (
  STUDENT_ID INT,
  SUBJECT_ID SMALLINT,
  GRADE_YEAR SMALLINT,
  SUBJECT VARCHAR(30) NOT NULL,
  STUDENT_FIRST_NAME VARCHAR(30) NOT NULL,
  STUDENT_LAST_NAME VARCHAR(30) NOT NULL,
  GRADE VARCHAR(2) NOT NULL,
CONSTRAINT STUDENT_GRADES1_CPK PRIMARY KEY (STUDENT_ID, SUBJECT_ID, GRADE_YEAR)); --composite primary key.


INSERT INTO STUDENT_GRADES1 (STUDENT_ID, SUBJECT_ID, GRADE_YEAR, SUBJECT, STUDENT_FIRST_NAME, STUDENT_LAST_NAME, GRADE) VALUES (11, 801, 2016, 'Science', 'Bill', 'Coleman', 'A');
INSERT INTO STUDENT_GRADES1 (STUDENT_ID, SUBJECT_ID, GRADE_YEAR, SUBJECT, STUDENT_FIRST_NAME, STUDENT_LAST_NAME, GRADE) VALUES (8, 802, 2016, 'Math', 'Janet', 'Yates', 'A');
INSERT INTO STUDENT_GRADES1 (STUDENT_ID, SUBJECT_ID, GRADE_YEAR, SUBJECT, STUDENT_FIRST_NAME, STUDENT_LAST_NAME, GRADE) VALUES (11, 802, 2016, 'Math', 'Bill', 'Coleman', 'B');
INSERT INTO STUDENT_GRADES1 (STUDENT_ID, SUBJECT_ID, GRADE_YEAR, SUBJECT, STUDENT_FIRST_NAME, STUDENT_LAST_NAME, GRADE) VALUES (8, 806, 2016, 'French', 'Janet', 'Yates', 'B');
INSERT INTO STUDENT_GRADES1 (STUDENT_ID, SUBJECT_ID, GRADE_YEAR, SUBJECT, STUDENT_FIRST_NAME, STUDENT_LAST_NAME, GRADE) VALUES (5, 806, 2015, 'French', 'Ali', 'Olsen', 'A');
INSERT INTO STUDENT_GRADES1 (STUDENT_ID, SUBJECT_ID, GRADE_YEAR, SUBJECT, STUDENT_FIRST_NAME, STUDENT_LAST_NAME, GRADE) VALUES (5, 806, 2016, 'French', 'Ali', 'Olsen', 'F');

SELECT *
FROM STUDENT_GRADES1;





/*
The prime attributes that make up the composite primary key are STUDENT_ID and SUBJECT_ID and GRADE_YEAR.

The non-prime attributes are SUBJECT, STUDENT_FIRST_NAME, STUDENT_LAST_NAME, and GRADE.

The non-prime attribute of GRADE is functionally dependent on the whole of the primary key. 
In other words, to know a student's grade for a particular year 
you would need to know the student's id, the subject id, and the year that the grade is for.

STUDENT_FIRST_NAME and STUDENT_LAST_NAME are functionally dependent on part of 
the composite primary key i.e. STUDENT_ID. 
Therefore, this table is not in second normal form. 
The STUDENT_FIRST_NAME and STUDENT_LAST_NAME are liable to become inconsistent over time:
*/

--Inserting an incorrect record:
INSERT INTO STUDENT_GRADES1 (STUDENT_ID, SUBJECT_ID, GRADE_YEAR, SUBJECT, STUDENT_FIRST_NAME, STUDENT_LAST_NAME, GRADE) 
  VALUES (8, 802, 2017, 'Math', 'Janet', 'Yeates', 'B');



SELECT *
FROM STUDENT_GRADES1;

/*
The insert statement above is incorrect because it has spelt Janet Yates name wrong i.e. Janet Yeates.
This might seem like it is not a big deal but in a real-world scenario there might be thousands of students 
each taking many subject over many years.
The larger the table the more likely it is that errors like this will occur 
and the knock-on effects are incorrect queries and reports and time spent cleaning up errors. 

In addition, with this table's current structure extra work is created by having to enter
repeated information for each row i.e. having to enter each student's first and last name in each row.
*/

--correcting the incorrect record:
UPDATE STUDENT_GRADES1
SET STUDENT_LAST_NAME = 'Yates'
WHERE STUDENT_ID = 8;

SELECT *
FROM STUDENT_GRADES1;




----normalizing data structure---

--First we will separate out the unique (distinct) students to a new table called STUDENTS:

CREATE TABLE STUDENTS (
  STUDENT_ID INT,
  STUDENT_FIRST_NAME VARCHAR(30) NOT NULL,
  STUDENT_LAST_NAME VARCHAR(30) NOT NULL,
CONSTRAINT STUDENTS_STUDENT_ID_PK PRIMARY KEY (STUDENT_ID));

SELECT *
FROM STUDENTS;

---Populate the STUDENTS table with distict (unique) students:

SELECT 
  DISTINCT STUDENT_ID, STUDENT_FIRST_NAME, STUDENT_LAST_NAME --distinct combinations of these 3 attributes
FROM STUDENT_GRADES1
ORDER BY STUDENT_ID;

INSERT INTO STUDENTS
SELECT 
  DISTINCT STUDENT_ID, STUDENT_FIRST_NAME, STUDENT_LAST_NAME
FROM STUDENT_GRADES1
ORDER BY STUDENT_ID;


SELECT *
FROM STUDENTS;


---each unique student has only a single row in the STUDENTS table.


--Now we will separate out the unique subjects into a SUBJECTS table:

CREATE TABLE SUBJECTS (
	SUBJECT_ID SMALLINT,
	SUBJECT VARCHAR(30) NOT NULL,
CONSTRAINT SUBJECTS_SUBJECT_ID_PK PRIMARY KEY (SUBJECT_ID),
CONSTRAINT SUBJECTS_SUBJECT_UK UNIQUE (SUBJECT));	

---Populating the SUBJECTS table:
SELECT 
	DISTINCT SUBJECT_ID, SUBJECT
FROM STUDENT_GRADES1
ORDER BY SUBJECT_ID;


INSERT INTO SUBJECTS
SELECT 
	DISTINCT SUBJECT_ID, SUBJECT
FROM STUDENT_GRADES1
ORDER BY SUBJECT_ID;


SELECT *
FROM SUBJECTS;




----------------------------

--Last we will create the linking table STUDENT_GRADES2.

CREATE TABLE STUDENT_GRADES2 (
	STUDENT_ID INT,
	SUBJECT_ID SMALLINT,
	GRADE_YEAR SMALLINT,
	GRADE VARCHAR(2) NOT NULL,
CONSTRAINT STUDENT_GRADES2_CPK PRIMARY KEY (STUDENT_ID, SUBJECT_ID, GRADE_YEAR),
CONSTRAINT STUDENTS_GRADES2_GRADE_CK CHECK ((GRADE) IN ('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D', 'E', 'F')),
CONSTRAINT STUDENT_GRADES2_STUDENT_ID_FK FOREIGN KEY (STUDENT_ID) REFERENCES STUDENTS (STUDENT_ID),
CONSTRAINT STUDENT_GRADES2_SUBJECT_ID_FK FOREIGN KEY (SUBJECT_ID) REFERENCES SUBJECTS (SUBJECT_ID));


/*
Note that this table (STUDENT_GRADES2) supports the many-to-many relationship between students and subjects:
one student can take many subjects and one subject has many students taking the subject.


In the syntax for the STUDENT_GRADES2 table a CHECK constraint has been applied to the GRADE column.
This ensures that values entered into the GRADE column can only be as specified in the constraint e.g. A+, A, A-, etc.
An alternative to using a CHECK constraint would be to create a GRADE table which would be referenced in a foreign key
on the STUDENT_GRADES2 table. However, check constraints are great to use when you have 
a limited number of possible values that are very unlikely to change and no additional attributes 
need to be associated with the possible values.


*/

	
--Populating the STUDENT_GRADES2 table with attributes from the original un-normalized STUDENT_GRADES1 table:	
INSERT INTO STUDENT_GRADES2
SELECT 
	STUDENT_ID,
	SUBJECT_ID,
	GRADE_YEAR,
	GRADE
FROM STUDENT_GRADES1;
	
	
SELECT *
FROM STUDENT_GRADES2;


	


----creating a summary view----

CREATE VIEW STUDENTS_SUMMARY
AS
SELECT 
	ST.STUDENT_ID,
	ST.STUDENT_FIRST_NAME,
	ST.STUDENT_LAST_NAME,
	S.SUBJECT,
	SG2.GRADE_YEAR,
	SG2.GRADE
FROM STUDENTS ST 
JOIN STUDENT_GRADES2 SG2
ON ST.STUDENT_ID = SG2.STUDENT_ID
JOIN SUBJECTS S
ON S.SUBJECT_ID = SG2.SUBJECT_ID;


SELECT *
FROM STUDENTS_SUMMARY;

	
	

DROP TABLE STUDENT_GRADES1;
DROP TABLE STUDENT_GRADES2;
DROP TABLE STUDENTS;
DROP TABLE SUBJECTS;
DROP VIEW STUDENTS_SUMMARY;





