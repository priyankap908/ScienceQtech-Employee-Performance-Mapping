/* 3.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, 
and make a list of employees and details of their department */

SELECT EMP_ID, concat(FIRST_NAME, " ", LAST_NAME) AS EMP_NAME, GENDER, DEPT
FROM emp_record_table.emp_record_table;

/* 4.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
●	less than two
●	greater than four 
●	between two and four */

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table.emp_record_table
WHERE EMP_RATING <2;

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table.emp_record_table
WHERE EMP_RATING >4;

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table.emp_record_table
WHERE EMP_RATING >2 AND EMP_RATING <4;

-- 5.	Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department 

SELECT concat(FIRST_NAME, " ", LAST_NAME) AS EMP_NAME
FROM emp_record_table.emp_record_table
WHERE DEPT = 'FINANCE';

-- 6.	Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President).

SELECT concat(E.FIRST_NAME, " ", E.LAST_NAME) AS EMP_NAME, COUNT(M.EMP_ID) AS NUMBER_OF_REPORTEES
FROM emp_record_table.emp_record_table E JOIN emp_record_table.emp_record_table M ON E.EMP_ID = M.MANAGER_ID
GROUP BY EMP_NAME
HAVING COUNT(M.EMP_ID)>0;

-- 7.	Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.

SELECT concat(FIRST_NAME, " ", LAST_NAME) AS EMP_NAME, DEPT
FROM emp_record_table.emp_record_table
WHERE DEPT = 'FINANCE'

UNION

SELECT concat(FIRST_NAME, " ", LAST_NAME) AS EMP_NAME, DEPT
FROM emp_record_table.emp_record_table
WHERE DEPT = 'HEALTHCARE';

/* 8.	Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, 
and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the department. */

SELECT E.EMP_ID, E.FIRST_NAME, E.LAST_NAME, E.ROLE, E.DEPT, E.EMP_RATING, D.MAX_EMP_RATING
FROM emp_record_table.emp_record_table E
JOIN (
    SELECT DEPT, MAX(EMP_RATING) AS MAX_EMP_RATING
    FROM emp_record_table.emp_record_table
    GROUP BY DEPT
) D ON E.DEPT = D.DEPT;

-- 9.	Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.

SELECT concat(E.FIRST_NAME, " ", E.LAST_NAME) AS EMP_NAME, E.EMP_ID, E.ROLE, R.MAX_SALARY, R.MIN_SALARY
FROM emp_record_table.emp_record_table E
JOIN (
		SELECT ROLE, MAX(SALARY) AS MAX_SALARY, MIN(SALARY) AS MIN_SALARY
        FROM emp_record_table.emp_record_table
        GROUP BY ROLE
        ) R ON E.ROLE = R.ROLE;
        
-- OR
        
SELECT ROLE, MAX(SALARY) AS MAX_SALARY, MIN(SALARY) AS MIN_SALARY
FROM emp_record_table.emp_record_table
GROUP BY ROLE;

-- 10.	Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.

SELECT concat(FIRST_NAME, " ", LAST_NAME) AS EMP_NAME, EXP, RANK() OVER (ORDER BY EXP DESC) AS EXP_RANK
FROM emp_record_table.emp_record_table;

/* 11.	Write a query to create a view that displays employees in various countries whose salary is more than six thousand. 
Take data from the employee record table. */

CREATE VIEW HIGH_SAL_EMP AS 
SELECT concat(FIRST_NAME, " ", LAST_NAME) AS EMP_NAME, COUNTRY
FROM emp_record_table.emp_record_table
WHERE SALARY >6000
ORDER BY SALARY DESC;

SELECT * FROM HIGH_SAL_EMP;

-- 12.	Write a nested query to find employees with experience of more than ten years. Take data from the employee record table

SELECT concat(FIRST_NAME, " ", LAST_NAME) AS EMP_NAME, EXP
FROM emp_record_table.emp_record_table
WHERE EXP > (SELECT 10);

-- EXTRA QUESTION-- SAME QUESTION AS ABOVE, INSTEAD OF 10 WE NEED TO FECTCH DETAILS OF EMP HAVING EXP MORE THAN AVG EXP

SELECT concat(FIRST_NAME, " ", LAST_NAME) AS EMP_NAME, EXP
FROM emp_record_table.emp_record_table
WHERE EXP > (SELECT AVG(EXP) AS AVG_EXP
				FROM emp_record_table.emp_record_table);

/* 13.	Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. 
Take data from the employee record table. */

DELIMITER $$
CREATE PROCEDURE employeerecordwithexperience()
BEGIN 
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table.emp_record_table
WHERE EXP>3;
END $$

DELIMITER ;

CALL employeerecordwithexperience();

/* 14.	Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the 
data science team matches the organization’s set standard.

The standard being:
For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
For an employee with the experience of 12 to 16 years assign 'MANAGER'.
*/
DELIMITER $$

CREATE FUNCTION GetJobTitle1(EXP INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE job_title VARCHAR(50);
    
    IF EXP<= 2 THEN
        SET job_title = 'JUNIOR DATA SCIENTIST';
    ELSEIF EXP > 2 AND EXP <= 5 THEN
        SET job_title = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF EXP > 5 AND EXP <= 10 THEN
        SET job_title = 'SENIOR DATA SCIENTIST';
    ELSEIF EXP > 10 AND EXP <= 12 THEN
        SET job_title = 'LEAD DATA SCIENTIST';
    ELSEIF EXP > 12 AND EXP <= 16 THEN
        SET job_title = 'MANAGER';
    ELSE
        SET job_title = 'UNKNOWN';
    END IF;
    
    RETURN job_title;
END $$

DELIMITER ;

SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    EXP,
    ROLE,
    GetJobTitle1(EXP) AS EXPECTED_JOB_PROFILE,
    CASE 
        WHEN ROLE = GetJobTitle1(EXP) THEN 'MATCHES'
        ELSE 'DOES NOT MATCH'
    END AS PROFILE_MATCH
FROM 
    emp_record_table.emp_record_table
WHERE 
    DEPT = 'Data Science';

/* 15.	Create an index to improve the cost and performance of the query to find the 
employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan. */

EXPLAIN SELECT * FROM emp_record_table.emp_record_table WHERE FIRST_NAME = 'Eric';

CREATE INDEX indx_first_name ON emp_record_table.emp_record_table(FIRST_NAME);

EXPLAIN SELECT * FROM emp_record_table.emp_record_table WHERE FIRST_NAME = 'Eric';


/* 16.	Write a query to calculate the bonus for all the employees, based on their ratings 
and salaries (Use the formula: 5% of salary * employee rating).*/

SELECT EMP_ID, concat(FIRST_NAME, " ", LAST_NAME) AS EMP_NAME, DEPT, SALARY, EMP_RATING, 0.05 * SALARY * EMP_RATING AS BONUS
FROM emp_record_table.emp_record_table;


/* 17.	Write a query to calculate the average salary distribution 
based on the continent and country. Take data from the employee record table. */

SELECT CONTINENT, COUNTRY, AVG(SALARY) AS AVG_SALARY
FROM emp_record_table.emp_record_table
GROUP BY CONTINENT, COUNTRY
ORDER BY CONTINENT, COUNTRY;