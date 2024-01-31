/* ===================
   2.1 SQL Inner Join
   ===================
*/

USE da100;
SELECT * FROM employee_bonus AS b
INNER JOIN employees AS e
ON b.emp_no = e.emp_no;

SELECT * FROM employee_bonus AS b
INNER JOIN employees AS e
ON b.emp_no = e.emp_no;

SELECT b.year, b.emp_no, b.bonus, e.first_name, e.last_name
FROM employee_bonus AS b
INNER JOIN employees AS e
ON b.emp_no = e.emp_no;

SELECT b.year, b.emp_no, b.bonus, e.first_name, e.last_name
FROM employee_bonus AS b
INNER JOIN employees AS e
USING(emp_no);
/* ===================
   2.2 SQL Left Join
   ===================
*/

SELECT * FROM employee_bonus AS b
LEFT JOIN employees AS e
ON b.emp_no = e.emp_no;

SELECT * FROM employee_bonus AS b
LEFT JOIN employees AS e
ON b.emp_no =e.emp_no;

SELECT * FROM employee_bonus as bonus
LEFT JOIN employees as emp
ON bonus.emp_no = emp.emp_no;
/* ===================
   2.3 SQL Right Join
   ===================
*/

# Example 1 - Similar result to LEFT JOIN example above (only columns are reordered)
SELECT * FROM employees AS e
RIGHT JOIN employee_bonus AS b
ON b.emp_no = e.emp_no;

# Example 2
SELECT * FROM employee_bonus AS b
RIGHT JOIN employees AS e
ON b.emp_no = e.emp_no;

/* ==============================================
   3.1.1 In-Class Practice: Tech Stocks Analysis
   ==============================================
*/

# Q1. Retrieve all stock data with closing price above 270.
SELECT * FROM tech_stock
WHERE closing_price>270;

SELECT * FROM tech_stock
WHERE closing_price >270;

SELECT * FROM tech_company;
# Q2. Retrieve all available stock data for GOOGL and AMZN.
#     Your result should show the most recent prices at the top,
#     and also sort prices by symbol (alphabetical order).
SELECT * FROM tech_company AS tc
INNER JOIN tech_stock AS ts
ON tc.symbol =ts.symbol
#WHERE symbol ="GOOGL";
WHERE tc.symbol IN ("GOOGL","AMZN")
ORDER BY date DESC, tc.symbol;

SELECT * FROM tech_stock
WHERE symbol in ("GOOGL","AMZN")
ORDER BY date DESC, symbol;

SELECT * FROM tech_stock
#WHERE symbol ="GOOGL" OR symbol ="AMZN"
WHERE symbol IN ("GOOGL" ,"AMZN")
ORDER BY date DESC, symbol ASC;



# Q3. Provide the daily summary statistics of the stock prices
#      (min / max / mean), and sort your result in chronological order.
SELECT *, MIN(closing_price), AVG(closing_price), MAX(closing_price) FROM tech_stock
GROUP BY date
ORDER BY date;



SELECT *, MAX(closing_price), MIN(closing_price), AVG(closing_price) FROM tech_stock
GROUP BY symbol, date
ORDER BY symbol, date;

SELECT *, MAX(closing_price), MIN(closing_price), AVG(closing_price) FROM tech_stock
GROUP BY date
ORDER BY date;



/* ==============================================
   3.1.2 In-Class Practice: Tech Stocks Analysis
   ==============================================
*/

# Q1. Retrieve all stock data for companies starting with 'A'.
#     Sort your result by date (chronological order), and show the first 5 rows.
SELECT * FROM tech_company AS tc
LEFT JOIN tech_stock AS ts 
ON tc.symbol=ts.symbol
WHERE company_name LIKE "A%"
ORDER BY date, closing_price DESC
LIMIT 5;




SELECT * FROM tech_stock AS Ts
LEFT JOIN tech_company AS Tc
ON Ts.symbol=Tc.symbol
WHERE company_name LIKE "A%"
ORDER BY date, closing_price DESC
LIMIT 5;




# Q2. Retrieve all available stock data on or after 08 June 2023
#     for companies in the "Internet Content & Information" industry.
#     Sort your result by closing price (ascending order).
SELECT * FROM tech_stock AS ts
LEFT JOIN tech_company AS tc
ON ts.symbol=tc.symbol
WHERE date >= "2023-06-08" AND industry="Internet Content & Information"
ORDER BY closing_price;



SELECT * FROM tech_company AS TC
INNER JOIN tech_stock AS TS
ON TC.symbol=TS.symbol
WHERE date >= "2023-06-08" AND industry ="Internet Content & Information"
ORDER BY closing_price; 





/* ===================================================
   3.2.1 In-Class Practice: Bank Transaction Analysis
   ===================================================
*/

# Q1. List all transactions on 2022-07-14, and on each row,
#     specify the transaction_id, timestamp, customer name, 
#     transaction type and transaction amount.
#SELECT ts.transaction_id, ts.timestamp, c.name, 
#   ts.type, ts.amount FROM transaction AS ts
SELECT * FROM transaction AS ts
LEFT JOIN customer AS c
ON ts.customer_id = c.customer_id
WHERE timestamp >= "2022-07-14 00:00:00" AND timestamp <= "2022-07-14 23:59:59";





SELECT ts.transaction_id, ts.timestamp, c.name, 
ts.type, ts.amount FROM transaction AS ts
LEFT JOIN customer AS c
ON ts.customer_id=c.customer_id
WHERE timestamp >"2022-07-14 00:00:00" AND timestamp <"2022-07-14 23:59:59";





# Q2. For each customer, find the count and total value of 
#     transactions on 2022-07-14, that are Credit or Debit type.
SELECT ts.transaction_id, ts.timestamp, c.name, 
ts.type, ts.amount, count(amount), SUM(amount) FROM transaction AS ts
LEFT JOIN customer AS c
ON ts.customer_id=c.customer_id
WHERE timestamp >"2022-07-14 00:00:00" AND timestamp <"2022-07-14 23:59:59" AND type IN ("Credit","Debit")
GROUP BY name;


SELECT COUNT(ts.transaction_id), ts.timestamp, c.name, 
ts.type, SUM(ts.amount) FROM transaction AS ts
LEFT JOIN customer AS c
ON ts.customer_id=c.customer_id
WHERE timestamp >"2022-07-14 00:00:00" AND timestamp <"2022-07-14 23:59:59" AND type IN ("Credit", "Debit")
GROUP BY name;


# Q3. Compare the total and average spending by gender (type = 'Credit')
SELECT ts.transaction_id, ts.timestamp, c.name, 
ts.type, ts.amount, AVG(amount), SUM(amount) FROM transaction AS ts
LEFT JOIN customer AS c
ON ts.customer_id=c.customer_id
WHERE timestamp >"2022-07-14 00:00:00" AND timestamp <"2022-07-14 23:59:59" AND type IN ("Credit")
GROUP BY gender;




SELECT ts.transaction_id, ts.timestamp, c.name, 
ts.type, SUM(ts.amount), AVG(ts.amount), c.gender FROM transaction AS ts
LEFT JOIN customer AS c
ON ts.customer_id=c.customer_id
WHERE timestamp >"2022-07-14 00:00:00" AND timestamp <"2022-07-14 23:59:59" AND type = "Credit"
GROUP BY gender;





/* ==================================
   4.1 Window Functions - Aggregation
   ==================================
*/


# Simple aggregation across entire dataset
SELECT MAX(salary) AS max_salary FROM employees;
SELECT *, MAX(salary) AS max_salary FROM employees;

# Simple aggregation by department
SELECT
	dept_name,
	MAX(salary) AS max_salary 
FROM employees
GROUP BY dept_name;


# Aggregation in window functions (entire dataset)
SELECT 
	*,
	MAX(salary) OVER() AS max_salary
FROM employees;


# Aggregation in window functions (by department)
SELECT 
	*,
	MAX(salary) OVER(PARTITION BY dept_name) AS max_salary
FROM employees;


# 4.1.1 Investigate the total department salary corresponding to each 
#       employee, as well as the percentage of salary the employee earns.
SELECT *, SUM(salary) OVER (PARTITION BY dept_name) AS total_salary, salary/SUM(salary) OVER(PARTITION BY dept_name) AS pct_salary FROM employees
ORDER BY emp_no;




SELECT emp_no, first_name, last_name,dept_name, salary, SUM(salary) OVER (PARTITION BY dept_name) as sum_salary, 
salary*100/SUM(salary) OVER (PARTITION BY dept_name) as percentage_salary
FROM employees
ORDER BY emp_no;






/* ===================================
   4.2 Window Functions - ROW_NUMBER()
   ===================================
*/

# ROW_NUMBER() in window functions (entire dataset)
SELECT
	*,
	ROW_NUMBER() OVER() AS rn
FROM employees;


# ROW_NUMBER() in window functions (by department)
SELECT 
	*,
	ROW_NUMBER() OVER(PARTITION BY dept_name) AS rn
FROM employees;


# ROW_NUMBER() in window functions (by department with specific order)
SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY dept_name ORDER BY hire_date) AS rn
FROM employees;


# ROW_NUMBER() with window functions + Subqueries
# Example: Get first 2 employees hired in each dept

SELECT * FROM (
	SELECT
		*,
		ROW_NUMBER() OVER(PARTITION BY dept_name ORDER BY hire_date) AS ranknum
	FROM employees
) result
WHERE result.ranknum <= 2;


/* ===================================
   4.3 Window Functions - RANK()
   ===================================
*/

# Example: Rank employees in each dept by salaries
SELECT 
	*,
	RANK() OVER(PARTITION BY dept_name ORDER BY salary DESC) AS rank_num
FROM employees;


# Example with subqueries: Get top 3 employees in each dept by salary
SELECT * FROM (
	SELECT 
		*,
		RANK() OVER(PARTITION BY dept_name ORDER BY salary DESC) AS rank_num
	FROM employees
) result
where result.rank_num <= 3;

/* ==============================================
   5.3.1 Take-Home Practice: Pagination with SQL
   ==============================================
*/

# Using two queries, try implementing pagination on the MAANG 
# stock price data (tech_stock table), using a page size of 15 rows.
# Sort your results by recency (most recent first) and symbol.

# First query for Page 1 (15 records)

SELECT * FROM tech_stock 
ORDER BY date DESC, symbol
LIMIT 15 OFFSET 0;

# Second query for Page 2 (10 records)
SELECT * FROM tech_stock 
ORDER BY date DESC, symbol
LIMIT 15 OFFSET 15;

