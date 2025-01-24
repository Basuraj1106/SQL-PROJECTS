CREATE DATABASE ZA_RETAIL_DB;

USE ZA_RETAIL_DB;

CREATE TABLE Retail_Sales(
		transactions_id INT PRIMARY KEY,	
		sale_date	DATE,
		sale_time	TIME,
		customer_id	INT,
		gender	VARCHAR(15),
		age	INT,
		category VARCHAR(15),
		quantiy	INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT);

SELECT * FROM Retail_Sales;

-- Null Value Check**: Check for any null values in the dataset and delete records with missing data.
SELECT * FROM Retail_Sales
WHERE transactions_id IS NULL 
OR 
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR 
total_sale IS NULL;

DELETE FROM Retail_Sales
WHERE transactions_id IS NULL 
OR 
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR 
total_sale IS NULL;

-- Record Count: Determine the total number of records in the dataset.

SELECT COUNT(*) No_Of_records 
FROM Retail_Sales;

-- Customer Count: Find out how many unique customers are in the dataset.

SELECT COUNT(DISTINCT(customer_id)) Customer_Count 
FROM Retail_Sales;

-- Category Count: Identify all unique product categories in the dataset.

SELECT DISTINCT(category) 'Product' 
FROM Retail_Sales;

--3. Data Analysis & Findings

--1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM Retail_Sales
WHERE sale_date = '2022-11-05';

--2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than  in the month of Nov-2022:

SELECT * FROM Retail_Sales
WHERE category = 'clothing' AND quantiy >= 4
AND FORMAT(sale_date,'MM-yyyy') = '11-2022';
--AND DATEPART(MONTH,sale_date) = '11' AND DATEPART(YEAR,sale_date)='2022';

--3. Write a SQL query to calculate the total sales (total_sale) for each category:

SELECT category,SUM(total_sale) total_sale,COUNT(transactions_id) Total_Orders
FROM Retail_Sales
GROUP BY category
ORDER BY 2 DESC;

--4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category:

SELECT category,AVG(age) avg_age 
FROM Retail_Sales
WHERE category = 'beauty'
GROUP BY category;

--5. Write a SQL query to find all transactions where the total_sale is greater than 1000:

SELECT * FROM Retail_Sales
WHERE total_sale >1000;

--6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category:

SELECT gender,category,COUNT(transactions_id) Total_Transaction 
FROM Retail_Sales
GROUP BY gender,category;

--7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT year,Month,Avg_sale FROM(
		SELECT MONTH(sale_date) 'Month',YEAR(sale_date) 'Year',AVG(total_sale) 'Avg_sale',
		RANK()OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) 'RANK'
		FROM Retail_Sales
		GROUP BY MONTH(sale_date),YEAR(sale_date)) 
AS Temp
WHERE RANK = 1




--8. Write a SQL query to find the top 5 customers based on the highest total sales:

SELECT TOP 5 customer_id,SUM(total_sale) Total_sale
FROM Retail_Sales
GROUP BY customer_id
ORDER BY 2 DESC;


--9. Write a SQL query to find the number of unique customers who purchased items from each category:

SELECT category,COUNT(DISTINCT(customer_id)) Unique_Customer
FROM Retail_Sales
GROUP BY category;

--10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH Hourly_Sales AS(
SELECT *,
CASE
	WHEN DATEPART(HOUR,sale_time) < 12 THEN 'Morning'
	WHEN DATEPART(HOUR,sale_time) BETWEEN 12 AND 17 THEN 'Afternoon' 
	ELSE 'Evening'
	END AS Shift
	FROM Retail_Sales)
SELECT Shift,COUNT(*) Total_Orders
FROM Hourly_Sales
GROUP BY Shift;

