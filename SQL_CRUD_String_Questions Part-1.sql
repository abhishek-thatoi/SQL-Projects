USE ORG;

SHOW CREATE TABLE WORKER;-- DDL

SELECT * FROM org.worker;-- DML

-- ------------------------------------------- PRACTICE QUERIES ------------------------------------------------------


-- ------------------------------------------- Display

-- QUES 1: fetch first_name from worker using alias name as <WORKER_NAME>
SELECT FIRST_NAME AS WORKER_NAME FROM WORKER ;
			--  Alias name is given along with field, whether it is alias for table or alias for col
            
-- QUES 2: fetch  first_name from worker table in upper case
SELECT UPPER(FIRST_NAME) AS WORKER_NAME FROM WORKER;

-- QUES 3: fetch unique values of department from worker table
SELECT DISTINCT (DEPARTMENT) FROM WORKER; -- OR
SELECT DEPARTMENT FROM WORKER GROUP BY DEPARTMENT; -- without using aggregation function


-- ------------------------------------------- String Fun()

-- QUES 4: first 3 characters of first name from worker
SELECT substring(FIRST_NAME,1,3) FROM WORKER; -- -------------------------- USING SubString(col,start,end)

-- QUES 5: find out the position of 'B' in first_name 'AMITABH' ------------- TO FIND POSITON OF CHAR
SELECT INSTR ( FIRST_NAME, 'B') FROM WORKER WHERE FIRST_NAME='AMITABH';

-- QUES 6+7: To print first_name after removing whitespaces from 
SELECT RTRIM(FIRST_NAME) FROM WORKER ; -- from rightside
SELECT LTRIM(LAST_NAME) FROM WORKER ; -- from lefttside and use TRIM() to remove spaces from both sides 	

-- QUES 8: To print length of unique departments in worker table;
SELECT DISTINCT (DEPARTMENT), LENGTH(DEPARTMENT) FROM WORKER ;

-- QUES 9: To print first name with 'a' in place of 'A'
SELECT REPLACE(FIRST_NAME,'A','a') FROM WORKER;

-- QUES 10: print first and last name in one single column separated by space 
SELECT CONCAT(FIRST_NAME,' ',LAST_NAME) AS COMPLETE_NAME FROM WORKER; -- for generating new column we must use Alias name


-- --------------------------------------------------- Order By

-- QUES 11: print all worker details with first_name in ascending order
SELECT * FROM WORKER ORDER BY FIRST_NAME ASC;

-- QUES 12: print all worker details with first_name in ascending order
SELECT * FROM WORKER ORDER BY FIRST_NAME, DEPARTMENT DESC;

-- QUES 13: print worker details with first_name VIPUL and SATISH
SELECT * FROM WORKER WHERE FIRST_NAME IN ( 'VIPUL' ,'SATISH');

-- QUES 14: print worker details EXCLUDING first_name VIPUL and SATISH
SELECT * FROM WORKER WHERE FIRST_NAME NOT IN ( 'VIPUL' ,'SATISH');


-- ------------------------------------------------- LIKE ---------------------------------------------------------

-- QUES 15: print worker details with DEPARTMENT name as 'ADMIN*'
SELECT * FROM WORKER WHERE DEPARTMENT LIKE 'ADMIN%';  	

-- QUES 16: print worker details with first name having 'A';
SELECT * FROM WORKER WHERE FIRST_NAME LIKE '%A%';
-- QUES 17: print worker details with first name ENDS with 'A';
SELECT * FROM WORKER WHERE FIRST_NAME LIKE '%A';


-- QUES 18: print worker details with first name ends with 'h' and contains 6 Alphabets
SELECT * FROM WORKER WHERE FIRST_NAME LIKE '_____H';

-- ------------------------------------------- BETWEEN AND --------------------------------------------------------


-- QUES 19: print worker details whose salary lies between 1-5 lakhs;
SELECT * FROM WORKER WHERE SALARY BETWEEN 100000 AND 500000;


-- QUES 20: print worker details who joined in FEB 2014;
SELECT *FROM WORKER WHERE JOINING_DATE BETWEEN '2014-02-01' AND '2014-02-28';
-- 								--- OR ----
SELECT * FROM WORKER WHERE YEAR(JOINING_DATE)= 2014 AND MONTH(JOINING_DATE)= 02;


-- QUES 21: count employees working in Admin Department
SELECT DEPARTMENT, COUNT(WORKER_ID) FROM WORKER GROUP BY DEPARTMENT HAVING DEPARTMENT='ADMIN'; 

-- OR we can use COUNT(*)

-- QUES 22: fetch full name of workers with salaries >= 50000 and <= 100000
SELECT concat(FIRST_NAME,' ',LAST_NAME) AS FULL_NAME FROM WORKER WHERE SALARY BETWEEN 50000 AND 100000;


-- QUES 23: count no of workers in each department in descending order 
SELECT DEPARTMENT, COUNT(*) AS NO_OF_WORKERS FROM WORKER GROUP BY DEPARTMENT order by COUNT(*) DESC;


-- QUES 24: print worker details who are also manager
SELECT W.* FROM WORKER AS W  INNER JOIN TITLE T ON W.WORKER_ID = T.WORKER_REF_ID WHERE WORKER_TITLE = 'MANAGER';
-- W.* to get details of worker table only
	-- TO avoid miss conception ever check this->
	SELECT * FROM WORKER AS W  INNER JOIN TITLE T WHERE WORKER_TITLE = 'MANAGER'; -- // gives product


-- QUES 25: print no of different titles in ORG, that are greater than 2;
SELECT WORKER_TITLE, COUNT(WORKER_TITLE) as WORKERS FROM TITLE GROUP BY WORKER_TITLE HAVING COUNT(WORKER_TITLE)>1 order by COUNT(WORKER_TITLE);

-- QUES 26: print only ODD rows from a table
SELECT * FROM WORKER WHERE MOD(WORKER_ID,2)!=0;

-- QUES 27: print only EVEN rows from a table
SELECT * FROM WORKER WHERE MOD(WORKER_ID,2) =0;

-- QUES 28: clone a new table from old table -- -------------------------DDL COPY
CREATE TABLE WORKER_CLONE LIKE WORKER;
REPLACE INTO WORKER_CLONE (SELECT * FROM WORKER);
select * FROM WORKER_CLONE;

-- QUES 29: find intersecting records of two table
SELECT WORKER.* FROM WORKER INNER JOIN WORKER_CLONE USING(WORKER_ID);

-- QUES 30: show details of one table the clone table doesnt have
SELECT * FROM WORKER LEFT JOIN WORKER_CLONE USING (WORKER_ID) WHERE WORKER_CLONE.WORKER_ID IS NULL;

-- QUES 31: show current date
-- results from dual table
SELECT current_date();
SELECT now();

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
SELECT Salary
FROM (
    SELECT Salary, ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum
    FROM Worker
    ) AS SalaryRanked
WHERE RowNum = 3;


-- QUES 35: list employees with same salary
SELECT * FROM WORKER W1, WORKER W2 WHERE W1.SALARY=W2.SALARY AND W1.WORKER_ID <> W2.WORKER_ID;
SELECT W1.* FROM WORKER W1, WORKER W2 WHERE W1.SALARY=W2.SALARY AND W1.WORKER_ID <> W2.WORKER_ID; -- TO avoid repeated data


-- QUES 36: print 2nd highest salary
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

-- QUES 38: list worker id who doesnt get bonus

