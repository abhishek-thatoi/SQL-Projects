USE ORG;

SHOW CREATE TABLE WORKER;-- DDL

SELECT * FROM org.worker;-- DML

-- ------------------------------------------- PRACTICE QUERIES ------------------------------------------------------


-- QUES 32: show top N=5 records of table by desc order of salary
SELECT * FROM WORKER ORDER BY SALARY DESC LIMIT 5; -- --------------------------------- DISPLAY LIMITED NO.OF TUPPLES


-- QUES 34: -------------------------------------- FIND 5th highest salary ----------------------------------------------

SELECT * FROM WORKER ;

# METHOD 1 using LIMIT keyword (-- QUES 33: show Nth=5 record of table by desc order of salary)

SELECT distinct * FROM WORKER ORDER BY SALARY DESC LIMIT 4,1; 
-- // here 4 is the exclusive index and 1 is the no of records from 4 onwards
-- The DISTINCT keyword is used to handle cases where multiple workers might have the same salary. 

# METHOD 2 without using LIMIT keyword	*IMPORTANT
SELECT * FROM WORKER AS W1 WHERE 5 = (SELECT COUNT(W2.SALARY) FROM WORKER AS W2 WHERE W2.SALARY>=W1.SALARY);

# Method 3 using ranking
-- SELECT Salary
-- FROM (
--     SELECT Salary, ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum
--     FROM Worker
--     ) AS SalaryRanked
-- WHERE RowNum = 3;


-- QUES 35: list employees with same salary
SELECT * FROM WORKER W1, WORKER W2 WHERE W1.SALARY=W2.SALARY AND W1.WORKER_ID <> W2.WORKER_ID;
SELECT W1.* FROM WORKER W1, WORKER W2 WHERE W1.SALARY=W2.SALARY AND W1.WORKER_ID <> W2.WORKER_ID; -- TO avoid repeated data


-- QUES 36: print 2nd highest salary // wihtout using correlated query
SELECT MAX(SALARY) FROM WORKER WHERE SALARY<(SELECT MAX(SALARY) FROM WORKER);

-- QUES 37: print a row twice in table
SELECT * FROM WORKER
UNION ALL 								-- UNION GOES FOR DISTINCT VALUE BUT UNION ALL DOESNT, repeats all here
SELECT * FROM WORKER order by WORKER_ID;



-- QUES 38: list worker id who doesnt get bonus

# METHOD 1: USING JOIN
SELECT * FROM WORKER AS W LEFT JOIN BONUS AS B ON WORKER_ID = WORKER_REF_ID; -- prepare a table first(divide and rule)

	SELECT WORKER_ID FROM( SELECT * FROM WORKER AS W LEFT JOIN BONUS AS B ON WORKER_ID = WORKER_REF_ID) AS TEMP 
	WHERE BONUS_AMOUNT IS NULL ;

# METHOD 2: using sub-query to compare ID without using JOIN
SELECT WORKER_ID FROM WORKER WHERE WORKER_ID NOT IN( SELECT WORKER_REF_ID FROM BONUS);

-- QUES 39: list first 50% record of table
SELECT * FROM WORKER WHERE WORKER_ID <= (SELECT COUNT(*) FROM WORKER )/2;

-- QUES 40: list department having less than 4 people ;
SELECT DEPARTMENT FROM WORKER GROUP BY DEPARTMENT  HAVING COUNT(DEPARTMENT)<4;

-- QUES 41: show all departments with no.of people in them ;
SELECT DEPARTMENT, count(DEPARTMENT) AS strength FROM WORKER GROUP BY DEPARTMENT ;

-- QUES 42: show last record of table ;
SELECT * FROM (SELECT * FROM WORKER ORDER BY WORKER_ID desc) AS TEMP LIMIT 1;

-- QUES 43: show first record of table ;
SELECT * FROM WORKER WHERE WORKER_ID=(SELECT MIN(WORKER_ID) FROM WORKER); -- 42 & 43 can be done either way

-- QUES 44: show last 5 records of table ;
SELECT * FROM(SELECT * FROM WORKER ORDER BY WORKER_ID desc LIMIT 0,5) AS TEMP ORDER BY WORKER_ID;
-- used order by twice

-- QUES 45: list employees with highest salary in each department
SELECT MAX(SALARY) FROM WORKER GROUP BY DEPARTMENT; -- // GOT MAX SALARY
-- NOTE : when sub query returns multiple tupples use IN ()
SELECT WORKER_ID, FIRST_NAME,DEPARTMENT, SALARY FROM WORKER 
WHERE SALARY IN (SELECT MAX(SALARY) FROM WORKER GROUP BY DEPARTMENT);

-- QUES 45: FETCH 3 max salaries from the table using co-related queries
SELECT DISTINCT SALARY FROM WORKER W1 WHERE 3>=(SELECT COUNT( DISTINCT SALARY) FROM WORKER W2 WHERE W1.SALARY <= W2.SALARY) ORDER BY W1.SALARY DESC;
-- ----------------------------------------- #IMPORTANT: -----------------------------------------------------------
				-- HERE each W1.SALARY compares with every W2.SALARY 
                -- now select counts: distinct salary++ FOR EVERY COMPARISION == TRUE
                -- SO we get count for each W1.SALARY
                -- FINALLY  when count for any W1.SALARY<=3 we print RESULT 