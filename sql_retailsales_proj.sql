CREATE DATABASE sql_project_p2;

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
	transactions_id INT PRIMARY KEY,
	sales_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,	  
	price_per_unit FLOAT, 
	cogs FLOAT,
	total_sale FLOAT
	);


SELECT * FROM retail_sales 
LIMIT 10


SELECT COUNT(*) 
FROM retail_sales

-- find out if we have any null values
SELECT 	* FROM retail_sales
WHERE 
	sale_time IS NULL 
	OR sales_date IS NULL 
	OR sale_time IS NULL
	OR gender IS NULL 
	OR category IS NULL 
	OR quantity IS NULL
	OR cogs IS NULL 
	OR total_sale IS NULL
	OR transactions_id IS NULL

-- deleting rows with null values 
DELETE FROM retail_sales
WHERE quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR  total_sale IS NULL

-- data exploration 
-- How many sales do we have?
SELECT (COUNT (*)) as total_sale FROM retail_sales

-- how many customers we have
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

-- how many unique categories
SELECT DISTINCT category FROM retail_sales

-- write a sql query to retrieve all columns for sales made on 2022-11-05
SELECT * 
FROM retail_sales
WHERE sales_date = '2022-11-05'


-- where category is clothing and the quantity sold is more than 4 in the month of nov 2022 
SELECT 
*
FROM retail_sales
WHERE category = 'Clothing'
	AND TO_CHAR(sales_date,'YYYY-MM') = '2022-11'
	AND quantity>=4

-- calcualte the total sales for each category 
SELECT category, SUM(total_sale) AS net_sale, COUNT (*) AS total_orders 
FROM retail_sales 
GROUP BY 1 

-- avg age of customers who purchased items from the beauty cat
SELECT ROUND(AVG(age),2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- find all transactions where the total_sale is greater than 1000
SELECT * FROM retail_sales 
WHERE total_sale > 1000

-- find total number of transactions made by each gender in each category 
SELECT COUNT(*), gender, category
FROM retail_sales
GROUP BY gender, category 

SELECT 
	category, 
	gender, 
	COUNT(*) AS total_trans
FROM retail_sales 
GROUP BY 1,2 
ORDER BY 1 

-- Write a SQL query to calculate the avg sale for each month. Find out the best performing month each year. 
SELECT year, month, avg_total_sale FROM
(
	SELECT 
		EXTRACT(YEAR FROM sales_date) AS year,
		EXTRACT(MONTH from sales_date) AS month,
		AVG(total_sale) AS avg_total_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sales_date) ORDER BY AVG(total_sale) DESC) as rank 
	FROM retail_sales 
	GROUP BY 1,2
) as t1 
WHERE rank = 1

--ORDER BY 1,3 DESC 

-- Find the top 5 customers based on the highest total sales. 
SELECT * FROM retail_sales

SELECT 
	DISTINCT(customer_id), 
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 5

-- find the number of unique customers who purchased items from each category. 
SELECT 
	category,
	COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales 
GROUP BY 1 

-- create each shift and number of orders (morning <=12, afternoon betwen 12 and 17, evening >17)

WITH hourly_sale 
AS 
(
	SELECT * ,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning' 
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon' 
			ELSE 'Evening'
		END as shift 
	FROM retail_sales 
) 
SELECT 
	shift,
	COUNT(*) as total_orders 
FROM hourly_sale
GROUP BY shift 

-- unrelated: show local hour 
-- SELECT EXTRACT(HOUR FROM CURRENT_TIME)












