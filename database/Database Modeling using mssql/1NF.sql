USE test
GO


CREATE TABLE PARKS1 (
  PARK_ID INT,
  PARK_NAME VARCHAR(30),
  WEED_1 VARCHAR(30),
  WEED_2 VARCHAR(30),
  WEED_3 VARCHAR(30),
CONSTRAINT PARKS1_PK PRIMARY KEY (PARK_ID));

--Inserting data into the PARKS1 table:

INSERT INTO PARKS1 (PARK_ID, PARK_NAME, WEED_1, WEED_2, WEED_3) VALUES (101, 'Redwood', 'English Ivy', 'Hemlock', null);
INSERT INTO PARKS1 (PARK_ID, PARK_NAME, WEED_1, WEED_2, WEED_3) VALUES (102, 'Manchester', 'Japanese Climbing Fern', 'Chinese Wisteria', null);
INSERT INTO PARKS1 (PARK_ID, PARK_NAME, WEED_1, WEED_2, WEED_3) VALUES (103, 'Congaree', 'Chinese Wisteria', 'Japanese Stilt Grass', 'Japanese Climbing Fern');

SELECT *
FROM PARKS1;




/*
PARKS1 table is an example of a table design which matches how a report or spreadsheet might look.
For each park we can simply look across the row to see what weeds each park has.
Therefore we can easily answer the question: What weeds does a particular park have?
However, the reverse question is not easily answered i.e. What parks have a particular weed?
*/

--To answer the question 'What parks have Chinese Wisteria?' we could write the following query:

SELECT PARK_NAME
FROM PARKS1
WHERE WEED_1 = 'Chinese Wisteria' OR WEED_2 = 'Chinese Wisteria' OR WEED_3 = 'Chinese Wisteria';

SELECT *
FROM PARKS1;

/*
Currently, the table only lets someone enter no more than three weeds. If in the future more than 3 weeds 
need to entered then the table would need to be altered to add on new columns. Also the query above would need to be
re-written to include the new columns i.e. OR WEED_4 = 'Chinese Wisteria' OR WEED_5 = 'Chinese Wisteria'.
Therefore this table design is both difficult to query and maintain in the long run.

A better design is to think in terms of adding rows rather than columns for new weeds:
*/

---Creating a new parks table called PARKS2---
CREATE TABLE PARKS2 (
  PARK_ID INT,
  PARK_NAME VARCHAR(30),
CONSTRAINT PARKS2_PK PRIMARY KEY (PARK_ID));

---In the PARKS2 table the attributes for weeds have been removed.

SELECT *
FROM PARKS2;

--Let's now populate the PARKS2 table with data selected from the original PARKS1 table:

INSERT INTO PARKS2
SELECT 
  PARK_ID, 
  PARK_NAME
FROM PARKS1;

SELECT *
FROM PARKS2;

/*
We have removed the multi-valued information (the weeds data) from the parks table.
This will go into a child table called park_weeds which contains all the weeds for each park.

Note that there is a many-to-many relationship between parks and weeds 
i.e. one park can have multiple weed species and one weed species can be present in multiple parks.
Hence the need for a linking table which has unique combinations of the park_id and the weed id.
Before creating the park_weeds table we have to create the other parent table of unique weeds species:
*/

---Creating the other parent table which is the weeds table---

CREATE TABLE WEEDS (
  WEED_ID INT,
  WEED_NAME VARCHAR(30) NOT NULL,
CONSTRAINT WEEDS_PK PRIMARY KEY (WEED_ID),
CONSTRAINT WEEDS_UK UNIQUE (WEED_NAME));

INSERT INTO WEEDS (WEED_ID, WEED_NAME) VALUES (1, 'English Ivy');
INSERT INTO WEEDS (WEED_ID, WEED_NAME) VALUES (2, 'Hemlock');
INSERT INTO WEEDS (WEED_ID, WEED_NAME) VALUES (3, 'Japanese Climbing Fern');
INSERT INTO WEEDS (WEED_ID, WEED_NAME) VALUES (4, 'Chinese Wisteria');
INSERT INTO WEEDS (WEED_ID, WEED_NAME) VALUES (5, 'Japanese Stilt Grass');

SELECT *
FROM WEEDS;




---Creating the park weeds associative (linking) table---

CREATE TABLE PARK_WEEDS (
  PARK_ID INT,
  WEED_ID INT,
CONSTRAINT PARK_WEEDS_CPK PRIMARY KEY (PARK_ID, WEED_ID),
CONSTRAINT WEEDS_FK1 FOREIGN KEY (PARK_ID) REFERENCES PARKS2 (PARK_ID),
CONSTRAINT WEEDS_FK2 FOREIGN KEY (WEED_ID) REFERENCES WEEDS (WEED_ID));
  
SELECT *
FROM PARK_WEEDS;
  
/*  
This linking table has two foreign referencing back to each respective parent table.
In addition, we also have a composite primary key.

Now we need to populate the PARK_WEEDS table with the unique combinations of PARK_ID and WEED_ID.
*/

---workings---

/*
Unpivoting the PARKS1 table i.e. making the table goes from wide to deep.
We are using UNION ALL to put all the weeds from the 
different columns into a single column:
*/

SELECT
	PARK_ID,
	WEED_1 AS WEED_NAME
FROM PARKS1
UNION ALL
SELECT
	PARK_ID,
	WEED_2
FROM PARKS1
UNION ALL
SELECT
	PARK_ID,
	WEED_3
FROM PARKS1
ORDER BY PARK_ID;



---Modifying the query to join on the new WEED_ID from the WEEDS table:

SELECT
	UNP.PARK_ID,
	W.WEED_ID
FROM
	(
		SELECT
			PARK_ID,
			WEED_1 AS WEED_NAME
		FROM PARKS1
		UNION ALL
		SELECT
			PARK_ID,
			WEED_2
		FROM PARKS1
		UNION ALL
		SELECT
			PARK_ID,
			WEED_3
		FROM PARKS1
	) UNP 
JOIN WEEDS W
ON UNP.WEED_NAME = W.WEED_NAME;



---Insert statement to populate the PARK_WEEDS table:

INSERT INTO PARK_WEEDS
SELECT
	UNP.PARK_ID,
	W.WEED_ID
FROM
	(
		SELECT
			PARK_ID,
			WEED_1 AS WEED_NAME
		FROM PARKS1
		UNION ALL
		SELECT
			PARK_ID,
			WEED_2
		FROM PARKS1
		UNION ALL
		SELECT
			PARK_ID,
			WEED_3
		FROM PARKS1
	) UNP 
JOIN WEEDS W
ON UNP.WEED_NAME = W.WEED_NAME
ORDER BY UNP.PARK_ID, W.WEED_ID;

SELECT *
FROM PARK_WEEDS;





---create a combined information view:

CREATE VIEW PARK_DETAILS AS
SELECT 
  P2.PARK_ID,
  P2.PARK_NAME,
  W.WEED_ID,
  W.WEED_NAME
FROM PARKS2 P2
JOIN PARK_WEEDS PW
ON P2.PARK_ID = PW.PARK_ID
JOIN WEEDS W
ON PW.WEED_ID = W.WEED_ID;

--The view PARK_DETAILS combines information for parks and weeds:

SELECT *
FROM PARK_DETAILS;


--Now it is much easier to write a query to return all parks that have Chinese Wisteria:

SELECT *
FROM PARK_DETAILS
WHERE WEED_NAME = 'Chinese Wisteria';


--report style query:

SELECT 
	PARK_NAME,
	STUFF((
		   SELECT ', ' + WEED_NAME
		   FROM PARK_DETAILS P1
		   WHERE P1.PARK_NAME = P2.PARK_NAME
		   FOR XML PATH('')
		   ), 1, 2, '')
FROM PARK_DETAILS P2
GROUP BY PARK_NAME;




---Another way that the PARK_WEEDS table could have been populated is to use the UNPIVOT clause:

/*
SELECT 
  PARK_ID, 
  WEED
FROM PARKS1
UNPIVOT ( WEED FOR (WEED_NAME) IN (WEED_1, WEED_2, WEED_3));


SELECT 
UNP.PARK_ID,
--UNP.WEED,
W.WEED_ID
FROM (
      SELECT PARK_ID, WEED
      FROM PARKS1
      UNPIVOT ( WEED FOR (WEED_NAME) IN (WEED_1, WEED_2, WEED_3))) UNP
JOIN WEEDS W
ON UNP.WEED = W.WEED_NAME;

*/
------------------



DROP TABLE PARKS1;
DROP TABLE PARK_WEEDS;
DROP TABLE PARKS2;
DROP TABLE WEEDS;
DROP VIEW PARK_DETAILS;
















  
  
  








  
