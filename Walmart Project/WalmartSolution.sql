SELECT * FROM Walmart;

--Total Number Of Records
SELECT COUNT(*) Total_Records FROM Walmart;

-- Payment Methods And Number Of Transaction Done By Each Method 
SELECT payment_method,COUNT(*) Total_Payment
FROM Walmart
GROUP BY payment_method;

-- Distinct Branches
SELECT COUNT(DISTINCT(branch)) Total_Branches 
FROM Walmart;

-- Distinct City
SELECT COUNT(DISTINCT(CITY)) Total_city
FROM Walmart;

-- Distinct Categories
SELECT DISTINCT(category) FROM Walmart;

-- Minimum Quantity Sold
SELECT MIN(quantity) Min_Quantity_Sold 
FROM Walmart;

-- Maximum Quantity Sold
SELECT MAX(quantity) Max_Quantity_Sold
FROM Walmart;


-- Business Problems AND Solutions --

-- Q1: Find different payment methods, number of transactions, and quantity sold by payment method

SELECT payment_method,
COUNT(invoice_id) No_transaction,SUM(quantity) Quantity_Sold
FROM Walmart
GROUP BY payment_method;

-- Q2: Identify the highest-rated category in each branch
-- Display the branch, category, and avg rating

WITH High_Rated_Category AS(
SELECT Branch,category,AVG(Rating) Avg_Rating,
Row_NUMBER() OVER (PARTITION BY Branch ORDER BY AVG(Rating) DESC) 'RNK'
FROM Walmart
GROUP BY Branch,category) 
SELECT Branch,category,ROUND(Avg_Rating , 2) Avg_rating
FROM High_Rated_Category
WHERE RNK < = 1

-- Q3: Identify the busiest day for each branch based on the number of transactions.

WITH Busiest_Day AS (
SELECT Branch,DATEPART(DAY,date) 'Day',COUNT(invoice_id) Total_Transaction,
ROW_NUMBER() OVER (PARTITiON BY Branch ORDER BY COUNT(invoice_id) DESC) 'RNK'
FROM Walmart
GROUP BY Branch,DATEPART(DAY,date))
SELECT branch,Day,Total_Transaction
FROM Busiest_Day
WHERE RNK < 2


-- Q4: Calculate the total quantity of items sold per payment method

SELECT payment_method,SUM(quantity) Quantity_sold
FROM Walmart
GROUP BY payment_method;

-- Q5: Determine the average, minimum, and maximum rating of categories for each city

SELECT city,category,
ROUND(MIN(rating), 2) min_rating,
ROUND(Max(rating), 2) max_rating,
ROUND(AVG(rating), 2) avg_rsting 
FROM Walmart
GROUP BY city,category
ORDER BY 1 ;

-- Q6: Calculate the total profit for each category

SELECT category,SUM(unit_price*quantity*profit_margin) Total_Profit
FROM Walmart
GROUP BY category
ORDER BY 2 DESC;


SELECT category,SUM(revenue*profit_margin) Total_Profit
FROM Walmart
GROUP BY category
ORDER BY 2 DESC;

-- Q7: Determine the most common payment method for each branch

WITH Most_Common_Payment_Method AS (
SELECT Branch,payment_method,COUNT(invoice_id) Total_Transactions,
ROW_NUMBER() OVER (PARTITION BY Branch ORDER BY COUNT(invoice_id) DESC) 'RNK'
FROM Walmart
GROUP BY Branch,payment_method)
SELECT Branch,payment_method AS 'preferred_payment_method',Total_Transactions
FROM Most_Common_Payment_Method
WHERE RNK < 2;

-- Q8: Categorize sales into Morning, Afternoon, and Evening shifts


SELECT DATEPART(HOUR,time) 'Hour',
CASE 
WHEN DATEPART(HOUR,time) < 12 THEN 'Morning'
WHEN DATEPART(HOUR,time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
ELSE 'EVENING' 
END AS 'Shifts',
COUNT(invoice_id) No_Invoice,
ROUND(SUM(revenue), 2) Total_revenue
FROM Walmart
GROUP BY DATEPART(HOUR,time)
ORDER BY 1 

-- Q9: Identify the 5 branches with the highest revenue decrease ratio from last year to current year (e.g., 2022 to 2023)

WITH Revenue_2022 AS (
SELECT Branch,SUM(Revenue) Revenue_2022
FROM Walmart
WHERE DATEPART(YEAR,date) = 2022
GROUP BY Branch),
Revenue_2023 AS
(SELECT Branch,SUM(Revenue) Revenue_2023
FROM Walmart 
WHERE DATEPART(YEAR,date) = 2023
GROUP BY Branch )
SELECT TOP 5 R22.Branch,Revenue_2022,Revenue_2023,
ROUND(((Revenue_2023-Revenue_2022)/Revenue_2022)*100, 2) 'Revenue_Growth_Ratio'
FROM Revenue_2022 R22
JOIN Revenue_2023 R23
ON R22.Branch = R23.Branch
ORDER BY 4 DESC;
