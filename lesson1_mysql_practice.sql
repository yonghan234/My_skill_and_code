/* =================================
   3. Retrieve with SELECT / FROM
   =================================
*/

# 3.2 SELECT ... FROM <database>.<table>
SELECT first_name FROM da100.employees;
SELECT name FROM da100.customer;
SELECT company_name FROM da100.tech_company;

# 3.2 SELECT ... FROM <table>
USE da100;  # sets default database for future queries
SELECT first_name FROM employees;
SELECT closing_price FROM tech_stock;

# 3.3 You can even SELECT multiple columns at a time!
SELECT emp_no, first_name, last_name FROM employees;
SELECT company_name, ceo, industry FROM tech_company;

# 3.3 What does SELECT * do? ANSWER:
SELECT * FROM employees;
SELECT * FROM tech_stock;
# 3.3.1 PRACTICE: Retrieve the columns emp_no, title and salary.
SELECT 
	emp_no, 
    title,
    salary 
FROM employees;

# 3.4 You may rename columns as well
#     Before...
			SELECT emp_no, birth_date
			FROM employees;
# 	   After...
			SELECT
				emp_no AS employee_number,
				birth_date AS date_of_birth  # "AS" keyword is optional
			FROM employees;

# 3.5.1 Examples of Aggregation function usage
SELECT COUNT(emp_no) FROM employees;  # COUNT(*) works as well, if you're feeling lazy!
SELECT 
	ROUND(AVG(salary),2) AS average_salary, 
	MIN(salary) AS min_salary,
	MAX(salary) AS max_salary 
FROM employees;

#SELECT ROUND(salary,-2) FROM employees;
SELECT salary FROM employees;
# 3.5.2 PRACTICE: What are the average, highest and lowest paid salary in the company?
#       Rename columns in your output to avg_salary, min_salary and max_salary respectively.


# 3.5.3 Examples of DISTINCT keyword usage
SELECT DISTINCT title FROM employees;
SELECT title FROM employees;
SELECT DISTINCT dept_name, title FROM employees;
SELECT COUNT(DISTINCT title) as number_distinct_title FROM employees;

# 3.5.4 PRACTICE: How many unique departments are there in the employees dataset?
#       Rename the column in your result to num_depts

SELECT COUNT(DISTINCT dept_name) AS num_depts FROM employees;
SELECT first_name FROM employees;

/* =====================
   4. Filter with WHERE
   =====================
*/
# 4.1 Examples of analytical queries with WHERE
# Q1 - Which employees have a salary more than $96,000?
SELECT * FROM employees
WHERE salary > 96000;
#    Alternatively: you can query monthly salaries
SELECT *, salary / 12 AS monthly_salary 
FROM employees
WHERE salary / 12 > 8000;


# Q2 - Which employees are in the Technology department?
SELECT * FROM employees
WHERE dept_name != "Technology";

SELECT * FROM employees
WHERE dept_name = "Technology";  
#  - How many employees are not in the Technology department?
SELECT COUNT(*) FROM employees
WHERE dept_name != 'Technology';   # Both <> and != can used interchangeably

# 4.1.1 PRACTICE: Are there more male or female employees in the dataset?
#     ANSWER: 
SELECT COUNT(*) AS num_males FROM employees
WHERE gender = "M";
SELECT COUNT(*) AS num_females FROM employees
WHERE gender = "F";


# 4.2 Multiple WHERE conditions using AND/OR
# Q1 - Which employees in the Banking Ops department have a salary higher than $80,000?
SELECT * FROM employees
WHERE dept_name ="Banking Ops" AND salary >80000;
SELECT * FROM employees
WHERE dept_name = "Banking Ops" AND salary > 80000;
# Q2 - How many employees have a salary between $55,000 and $60,000?
SELECT COUNT(*) AS employee_within_range_salary FROM employees
WHERE salary >55000 AND salary <60000;
SELECT COUNT(*) FROM employees
WHERE salary BETWEEN 55000 AND 60000; # equivalent to salary >= 55000 AND salary <= 60000
# Q3 - List all employees in the Finance and Marketing departments.
SELECT* FROM employees
WHERE dept_name ="Finance" OR dept_name="Marketing";

SELECT * FROM employees
WHERE dept_name = "Finance" OR dept_name = "Marketing";
SELECT * FROM employees
WHERE dept_name IN ('Finance', 'Marketing');  # equivalent to above. You can provide a list with IN for brevity

# 4.3.1 PRACTICE: Which employees fulfill both of these criteria:
#                 (1) in either Customer Service or Legal and Compliance department
#                 (2) born before 1 Jan 1985
#                 You may retrieve all columns in your SQL result.

SELECT * FROM employees
WHERE dept_name IN ("Customer Service", "Legal and Compliance") AND birth_date < "1985-01-01";


SELECT * FROM employees
#WHERE dept_name IN ("Customer Service", "Legal and Compliance") AND YEAR(birth_date) <1985;
WHERE dept_name IN ("Customer Service", "Legal and Compliance") AND birth_date <"1985-01-01";

# 4.4 Examples with the LIKE operator. What do you think % means?
#   ANSWER: 
SELECT * FROM employees
WHERE first_name LIKE "A%";  # first name starts with A
SELECT * FROM employees
WHERE first_name LIKE "A%";

SELECT * FROM employees
WHERE title LIKE "%Staff%";  # job title contains the word "Staff"

# 4.4.1 PRACTICE: How many engineers are there in the employee dataset?
#                 (Check for titles that contain the word "Engineer".)
SELECT COUNT(*) FROM employees
WHERE title LIKE "%Engineer%";
SELECT COUNT(*) FROM employees
WHERE title LIKE "%Engineer%";

SELECT *, UPPER(title) AS new_title FROM employees
WHERE title LIKE "%Engineer%";

# 4.4.2 PRACTICE: Find employees whose first or last name starts with 'W'.
SELECT * FROM employees
WHERE first_name LIKE "W%" or last_name LIKE "W%";

SELECT * FROM employees
WHERE first_name LIKE "W%" OR last_name LIKE "W%";

/* =====================
   5. Sort with ORDER BY
   =====================
*/

# 5 ORDER BY: You can sort by various column types
SELECT * FROM employees ORDER BY salary;
SELECT * FROM employees ORDER BY first_name;
SELECT * FROM employees ORDER BY birth_date;

# 5 ORDER BY: You can sort multiple columns at a time
SELECT * FROM employees
ORDER BY dept_name, title;

# 5 ORDER BY: Use DESC to sort by descending order, otherwise ascending by default
SELECT * FROM employees
ORDER BY dept_name DESC, title ASC;  # ASC is optional

/* =======================
   6. Truncate with LIMIT
   =======================
*/

# 6 LIMIT: What do you think this code does?
# ANSWER: 
SELECT * FROM employees 
ORDER BY hire_date
LIMIT 3;

# 6.1 PRACTICE: Who are the 5 most highly paid employees?
# Hint: Sort employees table by salary
SELECT * FROM employees
	ORDER BY salary DESC
    LIMIT 5;
    


/* ==========================
   7. Aggregate with GROUP BY
   ==========================
*/

# 7.2 Example of GROUP BY: Sum total salary by department
# Aggregation without GROUP BY
SELECT
	SUM(salary)
FROM employees;
# Aggregation with GROUP BY
SELECT
	dept_name,
	SUM(salary)
FROM employees 
GROUP BY dept_name;

# 7.2.1 PRACTICE: 
#    Q1. Find the mean salary for each department. Name the average salary column avg_salary.
#    Q2. Which are the top 3 departments in terms of average salary?
#    Q3. BONUS: Use ROUND(AVG(salary)) to round your results to the nearest whole number.

SELECT dept_name, ROUND(AVG(salary),2) AS Average_Salary FROM employees
GROUP BY dept_name
ORDER BY Average_Salary DESC
LIMIT 3;

SELECT dept_name, ROUND(AVG(salary)) as avg_salary FROM employees
GROUP BY dept_name
ORDER BY avg_salary DESC
LIMIT 3;


# 7.2.2 PRACTICE:
#    Q1. Using just one SQL query, count the number of male and female employees.
#    Q2. What about the number of male vs female employees who are in Senior roles?

SELECT gender, COUNT(first_name) FROM employees
WHERE title LIKE ("%Senior%")
GROUP BY gender;


SELECT gender, COUNT(emp_no) FROM employees 
GROUP BY gender; 

SELECT gender, COUNT(emp_no) FROM employees 
WHERE title LIKE "%Senior%"
GROUP BY gender; 


/* =============================
   8. Filter groups with HAVING
   =============================
*/


# 8.1 HAVING vs WHERE: On the surface they behave the same
SELECT first_name, last_name FROM employees WHERE first_name = 'Mary';
SELECT first_name, last_name FROM employees HAVING first_name = 'Mary';

# 8.1 HAVING vs WHERE: How are these outputs different?
SELECT last_name FROM employees WHERE first_name = 'Mary';   # WHERE uses columns from table
SELECT last_name FROM employees HAVING first_name = 'Mary';  # HAVING uses columns from result

# 8.2 HAVING example: Usually used with GROUP BY
# List the job titles with an average salary above $70,000
SELECT
	title,
	AVG(salary) AS avg_salary
FROM employees
GROUP BY title
HAVING avg_salary > 70000;


/* ================================
   9. Take-Home Practice Questions
   ================================
*/


# Q1a - Find the highest paid female employee in each department.
#       Order your output by salary in descending order.
#       Hint: Figure out your WHERE condition first, then perform GROUP BY
SELECT *, MAX(salary) AS HIGHEST_PAID_F FROM employees
WHERE gender = "F"
GROUP BY dept_name
ORDER BY HIGHEST_PAID_F DESC;
#LIMIT 1;

#SELECT dept_name, MAX(salary) FROM employees
#	WHERE gender ="F"
#   GROUP BY dept_name;
    
 SELECT
	dept_name,
	MAX(salary) AS max_salary
FROM employees
WHERE gender = 'F'
GROUP BY dept_name
ORDER BY max_salary DESC;   


# Q1b - Modify your answer to 1a) to only display rows where the salary exceeds $90,000.
#       Order your output by salary in descending order.
#       Hint: Figure out your WHERE condition first, then perform GROUP BY

SELECT *, MAX(salary) AS HIGHEST_PAID_F FROM employees
WHERE gender = "F" AND salary >90000
GROUP BY dept_name
ORDER BY HIGHEST_PAID_F DESC;

SELECT dept_name, MAX(salary) FROM employees
	WHERE gender ="F" AND salary > 90000
    GROUP BY dept_name
    ORDER BY salary DESC;

SELECT
	dept_name,
	MAX(salary) AS max_salary
FROM employees
WHERE gender = 'F'
GROUP BY dept_name
HAVING max_salary > 90000
ORDER BY max_salary DESC;



# Q1c - List the departments that have more than 5 male employee.
#       Sort your result by department name (alphabetical order).
#       Hint: Count the number of male employees in each department

SELECT dept_name, COUNT(gender) AS COUNT_GENDER FROM employees
WHERE gender="M"
GROUP BY dept_name
HAVING COUNT_GENDER>5
ORDER BY dept_name;

SELECT dept_name, COUNT(gender) as count_gender FROM employees
    WHERE gender ="M"
    GROUP BY dept_name
    HAVING count_gender >5
    ORDER BY dept_name;
    
SELECT
	dept_name,
    COUNT(*) AS num_staff
FROM employees
WHERE gender = 'M'
GROUP BY dept_name
HAVING num_staff > 5
ORDER BY dept_name;
