USE test
GO

--Example of defining a primary key constraint "in-line":

CREATE TABLE DEPARTMENTS1
(
  DEPT_ID SMALLINT PRIMARY KEY,
  DEPT_NAME VARCHAR(30) NOT NULL,
  PHONE VARCHAR(20) NOT NULL
);

/*
When defining a primary key "in-line" you do not get to name the constraint.
Instead SQL Server assigns a system generated name.
The system generated name can be found by querying the TABLE_CONSTRAINTS view
in the INFORMATION_SCHEMA: 
*/

SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'DEPARTMENTS1';


--Example of defining a primary key "out-of-line":

CREATE TABLE DEPARTMENTS2
(
  DEPT_ID SMALLINT,
  DEPT_NAME VARCHAR(30) NOT NULL UNIQUE,
  PHONE VARCHAR(20) NOT NULL,
CONSTRAINT DEPARTMENTS2_DEPT_ID_PK PRIMARY KEY (DEPT_ID)
);

/*
When defining a primary key constraint "out-of-line" we need to tell the database 
which column(s) are the primary key. The benefit of defining the primary key 
constraint out-of line is that we can give the primary key constraint a more meaningful name.
In this case the primary key constraint is named DEPARTMENTS2_DEPT_ID_PK and has been placed 
on the DEPT_ID column. DEPT_ID is an example of a surrogate key. 
*/

SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'DEPARTMENTS2';


INSERT INTO DEPARTMENTS2 (DEPT_ID, DEPT_NAME, PHONE) VALUES (1, 'Accounting', '843-124-09');
INSERT INTO DEPARTMENTS2 (DEPT_ID, DEPT_NAME, PHONE) VALUES (2, 'Marketing', '843-189-10');
INSERT INTO DEPARTMENTS2 (DEPT_ID, DEPT_NAME, PHONE) VALUES (3, 'Sales', '843-254-11');
INSERT INTO DEPARTMENTS2 (DEPT_ID, DEPT_NAME, PHONE) VALUES (4, 'IT', '843-128-04');

SELECT *
FROM DEPARTMENTS2;

INSERT INTO DEPARTMENTS2 (DEPT_ID, DEPT_NAME, PHONE) VALUES (4, 'Engineering', '843-109-04');

/*
SQL Error: Violation of PRIMARY KEY constraint 'DEPARTMENTS2_DEPT_ID_PK'. 
Cannot insert duplicate key in object 'dbo.DEPARTMENTS2'. The duplicate key value is (4).
The primary key constraint on DEPT_ID column ensures that this column
has values that are both unique and not null.
*/

--Delete all rows in the table:
DELETE FROM DEPARTMENTS2; 


SELECT *
FROM DEPARTMENTS2; 
--empty table at this point.



---Rather than manually entering values we can use a Sequence Object to generate a number sequence:
CREATE SEQUENCE DEPT_SEQUENCE
START WITH 1
INCREMENT BY 1 --increases by 1 each time the next value is generated.
MINVALUE 1
NO CYCLE
CACHE 50;

/*
The CACHE option when specified preallocates a cache of sequence values in memory for faster access.
In the sequence above the cache is set to 50 values.  

The disadvantage of using CACHE (compared to NO CACHE) is if a system failure occurs then all cached 
values are lost and there will be gaps in the sequence. 

However, in the majority of cases, having gaps in a sequence is not an issue for generating primary key 
values. All we are concerned about is that these numbers are unique. 
*/


INSERT INTO DEPARTMENTS2 (DEPT_ID, DEPT_NAME, PHONE) VALUES (NEXT VALUE FOR DEPT_SEQUENCE, 'Accounting', '843-124-09');
INSERT INTO DEPARTMENTS2 (DEPT_ID, DEPT_NAME, PHONE) VALUES (NEXT VALUE FOR DEPT_SEQUENCE, 'Marketing', '843-189-10');
INSERT INTO DEPARTMENTS2 (DEPT_ID, DEPT_NAME, PHONE) VALUES (NEXT VALUE FOR DEPT_SEQUENCE, 'Sales', '843-254-11');
INSERT INTO DEPARTMENTS2 (DEPT_ID, DEPT_NAME, PHONE) VALUES (NEXT VALUE FOR DEPT_SEQUENCE, 'IT', '843-128-04');

SELECT *
FROM DEPARTMENTS2;

/*
Even if we had specified NOCACHE for a sequence it is still possible to get gaps in the sequence. 
For example, if an INSERT statement fails, the unused sequence value will be lost. For example:
*/

--Run an insert statement that we know will fail:
INSERT INTO DEPARTMENTS2 (DEPT_ID, DEPT_NAME, PHONE) VALUES (NEXT VALUE FOR DEPT_SEQUENCE, 'IT', '843-128-04');

--Violation of UNIQUE KEY constraint 
--Cannot insert duplicate key in object 'dbo.DEPARTMENTS2'. The duplicate key value is (IT).

--Insert a row:
INSERT INTO DEPARTMENTS2 (DEPT_ID, DEPT_NAME, PHONE) VALUES (NEXT VALUE FOR DEPT_SEQUENCE, 'Engineering', '843-109-04');

--Results in a gap in the sequence:
SELECT *
FROM DEPARTMENTS2;



--A sequence is independent of any table and can be called in an insert statement for different tables:
CREATE TABLE PROD1 
(
	PRODUCT_ID INT,
	PRODUCT_NAME VARCHAR(50) NOT NULL,
	CONSTRAINT PROD1_PRODUCT_ID_PK PRIMARY KEY (PRODUCT_ID)
);

INSERT INTO PROD1 VALUES (NEXT VALUE FOR DEPT_SEQUENCE, 'Lawnmower 3000x');

SELECT *
FROM PROD1;

/*
In the INSERT statement above we inserted the next value from the DEPT_SEQUENCE sequence into the PROD1 table.
This shows that a sequence is not tied to a particular table.
*/


--We can see what value the sequence is up to (i.e. the current value) by running the following query:
SELECT current_value FROM sys.sequences WHERE name = 'DEPT_SEQUENCE';


/*
An alternative to using a sequence is to instead use the IDENTITY column property 
to generate a number sequence for our primary key column DEPT_ID:
*/

CREATE TABLE DEPARTMENTS3
(
  DEPT_ID SMALLINT IDENTITY(1,1), --(starts at 1, increments by 1)
  DEPT_NAME VARCHAR(30) NOT NULL,
  PHONE VARCHAR(20) NOT NULL,
CONSTRAINT DEPARTMENTS3_DEPT_ID_PK PRIMARY KEY (DEPT_ID)); 

---When inserting rows, we do not specify a value for the identity column because these values are auto-generated:

INSERT INTO DEPARTMENTS3 (DEPT_NAME, PHONE) VALUES ('Accounting', '843-124-09');
INSERT INTO DEPARTMENTS3 (DEPT_NAME, PHONE) VALUES ('Marketing', '843-189-10');
INSERT INTO DEPARTMENTS3 (DEPT_NAME, PHONE) VALUES ('Sales', '843-254-11');
INSERT INTO DEPARTMENTS3 (DEPT_NAME, PHONE) VALUES ('IT', '843-128-04');
INSERT INTO DEPARTMENTS3 (DEPT_NAME, PHONE) VALUES ('Engineering', '843-109-04');

SELECT *
FROM DEPARTMENTS3;


---To get the current value of a column with the identity property we can run the following query:
SELECT IDENT_CURRENT('DEPARTMENTS3');


/*
---IDENTITY Property vs. SEQUENCE object---

Both the IDENTITY property and the SEQUENCE object can result in gaps in
the number sequence.

The IDENTITY property has no cycling support. However when generating values for 
a primary key we don't require any cycling of values.

The IDENTITY property is tied to a particular column in a table.
In contrast, a SEQUENCE can be used by multiple tables. This can be useful
in situations where you do not want keys to conflict across different tables.

You cannot remove an existing IDENTITY property from a column and you 
cannot update an IDENTITY column. There is however a workaround for this.

The TRUNCATE statement resets the IDENTITY column back to start i.e. the seed value.

In summary, the SEQUENCE object provides more flexibily and addresses 
some of the shortcomings of the IDENTITY property. However, the IDENTITY property is 
easy to implement and is useful in many situations.
*/  


---------Global Unique Identifiers-------------------
/*
A Global Unique Identifier or GUID is a 16 byte binary SQL Server data type 
that is globally unique across tables, databases, and servers. SQL Server
call the data type that can hold GUID values UNIQUEIDENTIFIER.
Therefore the terms GUID and UNIQUEIDENTIFIER are often used interchangeably.
 
SQL Server has a function called NEWID() which can be used to generate 
GUID values.:
*/


CREATE TABLE PROD2 (
  PRODUCT_ID UNIQUEIDENTIFIER,
  PRODUCT_NAME VARCHAR(50) NOT NULL,
CONSTRAINT PROD2_PRODUCT_ID_PK PRIMARY KEY (PRODUCT_ID));

INSERT INTO PROD2 VALUES (NEWID(), 'Lawnmower 3000x');
INSERT INTO PROD2 VALUES (NEWID(), 'Lawnmower 4000x');
INSERT INTO PROD2 VALUES (NEWID(), 'Lawnmower 5000x');
INSERT INTO PROD2 VALUES (NEWID(), 'Lawnmower 6000x');

SELECT *
FROM PROD2;


/*
GUID's are typically used in situations 
where you need unique values across multiple database instances.
*/


---PRIMARY KEY CONSTRAINT VS. UNIQUE CONSTRAINT---
CREATE TABLE DEPARTMENTS4
(
  DEPT_ID SMALLINT,
  DEPT_NAME VARCHAR(30),
  PHONE VARCHAR(20) NOT NULL,
CONSTRAINT DEPARTMENTS4_DEPT_ID_PK PRIMARY KEY (DEPT_ID),
CONSTRAINT DEPARTMENTS4_DEPT_NAME_UK UNIQUE (DEPT_NAME)
);



INSERT INTO DEPARTMENTS4 (DEPT_ID, DEPT_NAME, PHONE) VALUES (1, 'Accounting', '843-124-09');
INSERT INTO DEPARTMENTS4 (DEPT_ID, DEPT_NAME, PHONE) VALUES (2, 'Marketing', '843-189-10');
INSERT INTO DEPARTMENTS4 (DEPT_ID, DEPT_NAME, PHONE) VALUES (3, 'Sales', '843-254-11');
INSERT INTO DEPARTMENTS4 (DEPT_ID, DEPT_NAME, PHONE) VALUES (4, 'IT', '843-128-04');

--4 rows inserted.

SELECT *
FROM DEPARTMENTS4;


/*
In DEPARTMENTS4 we have a primary key constraint called DEPARTMENTS4_DEPT_ID_PK placed on the DEPT_ID column.
There is also a unique constraint called DEPARTMENTS4_DEPT_NAME_UK placed on the DEPT_NAME column. 
This also ensures that this column is unique. Previously, the DEPARTMENTS2 table also had a 
unique constraint, however, this was created in-line. Whereas in DEPARTMENTS4 the unique constraint 
has been created out-of-line so that it can be named.

In SQL Server, the main difference between a unique constraint and a primary key constraint 
is that a unique constraint allows one null value to be entered:
*/

INSERT INTO DEPARTMENTS4 (DEPT_ID, DEPT_NAME, PHONE) VALUES (5, NULL, '843-808-04');
--1 row inserted


INSERT INTO DEPARTMENTS4 (DEPT_ID, DEPT_NAME, PHONE) VALUES (6, NULL, '853-743-06');
--Violation of UNIQUE KEY constraint 

SELECT *
FROM DEPARTMENTS4;

/* 
At the time of table creation we could have added both a UNIQUE and NOT NULL constraint
onto the DEPT_NAME column. This would have the same effect as a primary key even though
we have set DEPT_ID as the primary key. A table can only have one primary key but can have
multiple unique constraints or unique indexes.
*/


---Unique Constraint vs. Unique Index---

/*
When you add a unique constraint to a table. A unique index is also automatically
added at the same time. However, you can create a unique index on it's own:
*/

CREATE TABLE MONITORING_SITES1 (
  SITE_ID SMALLINT,
  SITE_NAME VARCHAR(50) NOT NULL,
  OLD_SITE_NAME VARCHAR(50) NOT NULL,
CONSTRAINT MONITORING_SITES1_SITE_ID_PK PRIMARY KEY (SITE_ID));

CREATE UNIQUE INDEX MONITORING_SITES1_UX1 ON MONITORING_SITES1 (SITE_NAME);
CREATE UNIQUE INDEX MONITORING_SITES1_UX2 ON MONITORING_SITES1 (OLD_SITE_NAME);


INSERT INTO MONITORING_SITES1 (SITE_ID, SITE_NAME, OLD_SITE_NAME) VALUES (1, 'Antler''s river', 'Monitoring site A11'); 
INSERT INTO MONITORING_SITES1 (SITE_ID, SITE_NAME, OLD_SITE_NAME) VALUES (2, 'Mountain view stream', 'Monitoring site A12'); 
INSERT INTO MONITORING_SITES1 (SITE_ID, SITE_NAME, OLD_SITE_NAME) VALUES (3, '32 Benson Road', 'Monitoring site B1');

SELECT *
FROM MONITORING_SITES1;


INSERT INTO MONITORING_SITES1 (SITE_ID, SITE_NAME, OLD_SITE_NAME) VALUES (4, 'Mountain view stream', 'Monitoring site A13');
--Cannot insert duplicate key row in object 'dbo.MONITORING_SITES1' with unique index 'MONITORING_SITES1_UX1'.
--The duplicate key value is (Mountain view stream).

/*
Should you use a unique constraint with an auto-generated unique index
or explicitly create a unique index by itself?

There are pros and cons to both:
Unique constraints have the benefit of being self-documenting in
that when someone checks the constraints on the table they will see any unique constraints.

If the primary purpose is to index the unique column (to speed up sorting or filtering) 
then there is benefit in creating a unique index rather than a unique constraint in order to make this clear. 
For instance, if the requirement of uniqueness is no longer required in the future then it will
be more obvious to the person making the changes to know to make sure that a non-unique index 
is substituted for the unique index.
*/


DROP TABLE PROD1;
DROP TABLE DEPARTMENTS3;
DROP TABLE PROD2;
DROP TABLE DEPARTMENTS4;
DROP TABLE MONITORING_SITES1;
DROP TABLE DEPARTMENTS1;
DROP TABLE DEPARTMENTS2;
DROP SEQUENCE DEPT_SEQUENCE;






















