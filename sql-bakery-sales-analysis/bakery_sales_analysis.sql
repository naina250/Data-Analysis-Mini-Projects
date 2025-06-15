-- create database 
CREATE DATABASE IF NOT EXISTS sales;

-- use database
USE sales;

-- fetch all the rows from data
SELECT * 
FROM home_bakery_sales_data;

-- row count
SELECT COUNT(*)
FROM home_bakery_sales_data;

-- total orders
SELECT COUNT(DISTINCT Order_ID) AS total_distinct_order
FROM home_bakery_sales_data;

-- total revenue
SELECT round(sum(Quantity * Unit_Price * (1- `Discount(%)`/100)),2) AS total_revenue
FROM home_bakery_sales_data;

-- avg order value
SELECT round(avg(Quantity * Unit_Price * (1- `Discount(%)`/100)),2) AS avg_order_value
FROM home_bakery_sales_data;

-- add total price column
ALTER TABLE home_bakery_sales_data 
ADD total_price INT;

-- modify datatype of total_price to decimal
ALTER TABLE home_bakery_sales_data MODIFY COLUMN total_price DECIMAL(10, 2);

SELECT * 
FROM home_bakery_sales_data;

-- turn safe updates off
SET SQL_SAFE_UPDATES = 0;
 
-- update total_price column value
UPDATE home_bakery_sales_data
SET total_price = Quantity * Unit_Price * (1 - `Discount(%)` / 100);

-- turn safe updates back on
SET SQL_SAFE_UPDATES = 1;

SELECT *
FROM home_bakery_sales_data;

-- top 5 products by revenue
SELECT Product, SUM(total_price) AS Total_Price
FROM home_bakery_sales_data
GROUP BY Product 
ORDER BY Total_Price DESC
LIMIT 5;

-- top products by quantity sold
SELECT Product, COUNT(Quantity) AS Quantity_Ordered
FROM home_bakery_sales_data
GROUP BY Product
ORDER BY Quantity_Ordered DESC;

-- monthly revenue trend
SELECT date_format(Order_Date, '%Y-%m') AS Month, sum(total_price) AS Total_Price
FROM home_bakery_sales_data
GROUP BY Month
ORDER BY Month;

SELECT *
FROM home_bakery_sales_data;

-- orders by city
SELECT Customer_City, count(Order_ID) AS Total_Orders
FROM home_bakery_sales_data
GROUP BY Customer_City
ORDER BY Total_Orders DESC;

-- revenue by city
SELECT Customer_City, sum(total_price) AS Total_Revenue
FROM home_bakery_sales_data
GROUP BY Customer_City
ORDER BY Total_Revenue DESC;

-- avg order value by Discount
SELECT `Discount(%)`, round(avg(total_price),2) AS Avg_Order_Value
FROM home_bakery_sales_data
GROUP BY `Discount(%)`
ORDER BY `Discount(%)`;

SELECT *
FROM home_bakery_sales_data;

-- delivery status count
SELECT Delivery_Status, count(Order_ID) AS Order_Count
FROM home_bakery_sales_data
GROUP BY Delivery_Status
ORDER BY Order_Count;

-- payment mode popularity
SELECT Payment_Mode, count(Order_ID) AS Order_Count
FROM home_bakery_sales_data
GROUP BY Payment_Mode
ORDER BY Order_Count DESC;

-- most popular product by each city
WITH popular_product AS (
	SELECT Customer_City, Product, count(Order_ID) AS Order_Count,
    row_number() over(PARTITION BY Customer_City ORDER BY count(Order_ID) DESC) AS rn
    FROM home_bakery_sales_data
    GROUP BY Customer_City, Product
)
SELECT Customer_City, Product, Order_Count
FROM popular_product
WHERE rn = 1;
