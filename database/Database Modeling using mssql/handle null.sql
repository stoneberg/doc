

---Handling Nulls in SQL Server:

CREATE TABLE CLIENTS1 
(	
	FIRST_NAME VARCHAR(50),
	MIDDLE_NAME VARCHAR(50),
	LAST_NAME VARCHAR(50)
);




---Inserting 2 rows. Both rows will have a null value for MIDDLE_NAME:

INSERT INTO CLIENTS1 (FIRST_NAME, MIDDLE_NAME, LAST_NAME) VALUES ('Kevin', NULL, 'Osten');
INSERT INTO CLIENTS1 (FIRST_NAME, LAST_NAME) VALUES ('Anna', 'Victor');


SELECT *
FROM CLIENTS1;

/*
The first row inserted is for a client named Kevin Osten. 
In this row we inserted a null value for the MIDDLE_NAME column. 
Note that when inserting a null value, we do not have any quotation marks around the word null. 
This is because quotation marks are used for character strings and not for nulls.

The second row inserted is for a client named Anna Victor. 
In this case we did not provide any value in the insert statement for the MIDDLE_NAME column. 
When this occurs, the database inserts a null value by default.


Therefore both Kevin Osten and Anna Victor have null values in the MIDDLE_NAME column. 
Does this mean that neither of them has a middle name? 

Not necessarily. As far as the database is concerned, it is unknown whether or not Kevin or Anna have middle names. 
*/

/*
---Nulls in Concatenation---

In SQL Server, one method for concatenating attribute values is to use the plus sign (+) operator. 
However, be careful when concatenating attributes that possibly contain null values:
*/

SELECT 
	FIRST_NAME + ' ' + MIDDLE_NAME + ' ' + LAST_NAME AS FULL_NAME
FROM CLIENTS1;



---Nulls in math operations


CREATE TABLE EMPLOYEES1
(
EMP_ID INT,
EMP_LAST_NAME VARCHAR(100),
SALARY DECIMAL(12,2),
BONUS DECIMAL(12,2)
);


INSERT INTO EMPLOYEES1 (EMP_ID, EMP_LAST_NAME, SALARY, BONUS) VALUES (1, 'Jones', 60000, 800);
INSERT INTO EMPLOYEES1 (EMP_ID, EMP_LAST_NAME, SALARY, BONUS) VALUES (2, 'Richardson', 65000, null);

SELECT *
FROM EMPLOYEES1;



SELECT EMP_ID, EMP_LAST_NAME, SALARY, BONUS
FROM EMPLOYEES1;



--Calculating Total remuneration by adding together salary and bonus:

SELECT 
	EMP_ID, 
	EMP_LAST_NAME, 
	SALARY, 
	BONUS,
	SALARY + BONUS AS TOTAL_REMUNERATION
FROM EMPLOYEES1;

--- 65,000 + NULL = NULL
--- Math operations errors with nulls can easily go undetected in queries.


---Workaround Solution: Replace nulls using the ISNULL function in the query:

SELECT 
	EMP_ID, 
	EMP_LAST_NAME, 
	SALARY, 
	BONUS,
	SALARY + ISNULL(BONUS,0) AS TOTAL_REMUNERATION
FROM EMPLOYEES1;

--SQL Server's ISNULL function replaces nullS with the value specified in the second argument of the function: 
--ISNULL(string1, replace_with)


--Drop the EMPLOYEES1 table i.e. removes it from the database:

DROP TABLE EMPLOYEES1;


---Next we will create the table from scratch again but this time with the appropriate constraints.

--Permanent Solution: Apply not null constraints to all columns that should be mandatory in table data definition.

CREATE TABLE EMPLOYEES1
(
EMP_ID INT,
EMP_LAST_NAME VARCHAR(50) NOT NULL,
SALARY DECIMAL(12,2) NOT NULL,
BONUS DECIMAL(12,2) NOT NULL,
CONSTRAINT EMPLOYEES1_PK PRIMARY KEY (EMP_ID)
);

/*
Now the EMPLOYEES1 table has NOT NULL constraints on all columns.
We do not need to specify the not null constraint for the EMP_ID column 
as this is the primary key column and therefore has cannot have nulls.
The primary key constraint also ensures that EMP_ID column will have unique values. 
More on this latter in the course. 

In SQL Server you cannot create NOT NULL constraints "out-of-line'.
NOT NULL constraints are therefore always specified "in-line".
*/



INSERT INTO EMPLOYEES1 (EMP_ID, EMP_LAST_NAME, SALARY, BONUS) VALUES (1, 'Jones', 60000, 800);

SELECT *
FROM EMPLOYEES1;

INSERT INTO EMPLOYEES1 (EMP_ID, EMP_LAST_NAME, SALARY, BONUS) VALUES (2, 'Richardson', 65000, null);

/*
SQL Error: Cannot insert the value NULL into column 'BONUS', INSERT fails.

--The database throws an error because we tried to insert a NULL value into the BONUS column 
when null are not allowed due to the NOT NULL costraint now placed on the table.
*/

INSERT INTO EMPLOYEES1 (EMP_ID, EMP_LAST_NAME, SALARY, BONUS) VALUES (2, 'Richardson', 65000, 0);

--inserted the correct bonus of 0.

SELECT *
FROM EMPLOYEES1;


---now the query below returns the correct result without the data analyst having 
---to use a function to replace nulls with zeros:

SELECT 
	EMP_ID, 
	EMP_LAST_NAME, 
	SALARY, 
	BONUS,
	SALARY + BONUS AS TOTAL_REMUNERATION
FROM EMPLOYEES1;


---------------------------------------------
-----HANDLING NULLS WHEN FILTERING DATA------
---------------------------------------------

CREATE TABLE PRODUCTS99 (
    PROD_ID INT,
    PRODUCT_NAME VARCHAR(50),
    MANUFACTURER_COUNTRY VARCHAR(50),
CONSTRAINT PRODUCTS99_PROD_ID_PK PRIMARY KEY (PROD_ID));

INSERT INTO PRODUCTS99 (PROD_ID, PRODUCT_NAME, MANUFACTURER_COUNTRY) VALUES (1, 'E34 MP3 PLAYER', 'Japan');
INSERT INTO PRODUCTS99 (PROD_ID, PRODUCT_NAME, MANUFACTURER_COUNTRY) VALUES (2, '34S2 SMART PHONE', 'Japan');
INSERT INTO PRODUCTS99 (PROD_ID, PRODUCT_NAME, MANUFACTURER_COUNTRY) VALUES (3, 'R12 SMART PHONE', 'USA');
INSERT INTO PRODUCTS99 (PROD_ID, PRODUCT_NAME, MANUFACTURER_COUNTRY) VALUES (4, '808 FITNESS TRACKER', 'USA');
INSERT INTO PRODUCTS99 (PROD_ID, PRODUCT_NAME, MANUFACTURER_COUNTRY) VALUES (5, 'R4 TABLET', NULL);


SELECT *
FROM PRODUCTS99;




SELECT *
FROM PRODUCTS99
WHERE MANUFACTURER_COUNTRY = 'Japan';

--2 products returned returned

SELECT *
FROM PRODUCTS99
WHERE MANUFACTURER_COUNTRY <> 'Japan'; -- <> means not equals

/*
2 rows returned. However this does not return the product which had a null value for MANUFACTURER_COUNTRY.
To return the nulls as well we have to add an OR condition to the WHERE clause:
*/

SELECT *
FROM PRODUCTS99
WHERE MANUFACTURER_COUNTRY <> 'Japan' OR MANUFACTURER_COUNTRY IS NULL;

--Now we return all products that are not manufactured in Japan 
--or where the manufacturer country is unknown i.e. null.


---Aggregate functions such as COUNT, MAX, MIN ignore nulls with the exception of COUNT(*):

SELECT COUNT(MANUFACTURER_COUNTRY)
FROM PRODUCTS99;

--count of 4 rows i.e. ignored the null value.



SELECT COUNT(*)
FROM PRODUCTS99;

--count of 5 i.e. counts all rows in a table regardless of nulls.



---dropping tables used in this tutorial:
DROP TABLE EMPLOYEES1;
DROP TABLE CLIENTS1;
DROP TABLE PRODUCTS99;

------------------------------------------------------------------------------------------------------------------------------------------






















