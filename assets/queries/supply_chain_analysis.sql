-- =========================================
-- 1. DATABASE CREATION
-- =========================================

CREATE DATABASE pharma_supply_chain;
USE pharma_supply_chain;

-- =========================================
-- 2. DATA PREPARATION
-- =========================================

SELECT * FROM datacosupplychaindataset;
CREATE TABLE supply_chain_data AS
SELECT `Order Id` AS order_id,
       `Days for shipping (real)` AS actual_shipping_days,
	   `Days for shipment (scheduled)` AS scheduled_shipping_days,
       `Delivery Status` AS delivery_status,
       `Late_delivery_risk` AS is_late_risk,
       `Category Name` AS category_name,
       `Order Region` AS order_region,
       `Shipping Mode` AS shipping_mode,
	   `Order Item Profit Ratio` AS profit_ratio,
       `order date (DateOrders)` AS raw_order_date
FROM datacosupplychaindataset;

-- =========================================
-- 3. DATA CLEANING & DATA QUALITY CHECK
-- =========================================

-- Check missing Order IDs
SELECT COUNT(*) AS missing_order_ids
FROM supply_chain_data
WHERE order_id IS NULL;

-- Check missing Order Dates
SELECT COUNT(*) AS missing_order_dates
FROM supply_chain_data
WHERE order_date IS NULL;

-- Check total records
SELECT COUNT(*) AS total_records
FROM supply_chain_data;

-- change datetime from string to real datetime
ALTER TABLE supply_chain_data
ADD COLUMN order_date DATETIME;
-- SET SAFE mode to zero
SET SQL_SAFE_UPDATES=0;
-- changing order date from string to datetime
UPDATE supply_chain_data
SET order_date= STR_TO_DATE(raw_order_date,'%c/%e/%Y %H:%i') ;
-- on safe mode
SET SQL_SAFE_UPDATES=1;
-- check data 
SELECT * FROM supply_chain_data
LIMIT 10;

-- =========================================
-- 4. BASIC DATA ANALYSIS
-- =========================================

-- Q1. What is the total no. of orders?
SELECT COUNT(DISTINCT(order_id)) AS total_orders 
FROM supply_chain_data;
-- Q2. How many orders are there in each region?
SELECT order_region,COUNT(DISTINCT(order_id)) AS number_order
FROM supply_chain_data
GROUP BY order_region
ORDER BY number_order DESC;
-- Q3. How many orders were placed using each shipping mode?
SELECT shipping_mode,COUNT(DISTINCT(order_id)) AS number_order
FROM supply_chain_data
GROUP BY shipping_mode
ORDER BY number_order DESC;
-- Q4. How many orders are there in each product category?
SELECT category_name AS product_category,COUNT(DISTINCT(order_id)) AS number_order
FROM supply_chain_data
GROUP BY category_name
ORDER BY number_order DESC;

-- =========================================
-- 5. DELIVERY PERFORMANCE
-- =========================================

-- Q5. What is the distribution of delivery statuses?
SELECT
    delivery_status,
    COUNT(*) AS total_orders
FROM supply_chain_data
GROUP BY delivery_status
ORDER BY total_orders DESC;
-- Q6. What is the average actual shipping time?
SELECT ROUND(AVG(actual_shipping_days),2) AS avg_actual_shipping_time
FROM supply_chain_data;
-- Q7. What is the average scheduled shipping time?
SELECT ROUND(AVG(scheduled_shipping_days),2) AS avg_scheduled_shipping_days
FROM supply_chain_data;
-- Q8. Which orders took longer to ship than their scheduled shipping time?
SELECT order_id,category_name,actual_shipping_days,scheduled_shipping_days FROM supply_chain_data
WHERE (actual_shipping_days-scheduled_shipping_days)>0;
-- Q9. Which shipping mode has the highest average actual shipping time?
SELECT shipping_mode,ROUND(AVG(actual_shipping_days),2) AS avg_actual_shipping_days
FROM supply_chain_data
GROUP BY shipping_mode
ORDER BY avg_actual_shipping_days DESC ;
-- Q10. Which regions have the highest number of late-risk orders?
SELECT order_region,sum(is_late_risk=1) AS late_risk_orders
FROM supply_chain_data
GROUP BY order_region
ORDER BY late_risk_orders DESC ;

-- =========================================
-- 6. PROFITABILITY ANALYSIS
-- =========================================

-- Q11. What is the average profit ratio for each product category?
SELECT category_name,ROUND(AVG(profit_ratio),2) AS avg_profit_ratio
FROM supply_chain_data
GROUP BY category_name
ORDER BY avg_profit_ratio DESC;
-- Q12. What is the average profit ratio for each region?
SELECT order_region,ROUND(AVG(profit_ratio),2) AS avg_profit_ratio
FROM supply_chain_data
GROUP BY order_region
ORDER BY avg_profit_ratio DESC;
-- Q13. Which orders have a profit ratio higher than the overall average profit ratio?
SELECT order_id,category_name,profit_ratio 
FROM supply_chain_data
WHERE profit_ratio > ( SELECT AVG(profit_ratio) 
FROM supply_chain_data)
ORDER BY profit_ratio DESC;

-- =========================================
-- 7. DATE ANALYSIS
-- =========================================

-- Q14. How many orders were placed in each year?
SELECT YEAR(order_date) AS year, COUNT(*) AS number_of_order
FROM supply_chain_data
GROUP BY YEAR(order_date)
ORDER BY number_of_order DESC;

-- Q15. How many orders were placed in each month?
SELECT MONTHNAME(order_date) AS month_name, COUNT(*) AS number_of_order
FROM supply_chain_data
GROUP BY MONTH(order_date) ,MONTHNAME(order_date)
ORDER BY MONTH(order_date) ;

-- =========================================
-- 8. ADVANCED SQL
-- =========================================

-- A1. Subquery: Find orders whose profit ratio is above the overall average

SELECT
    order_id,
    category_name,
    profit_ratio
FROM supply_chain_data
WHERE profit_ratio > (
    SELECT AVG(profit_ratio)
    FROM supply_chain_data
)
ORDER BY profit_ratio DESC;


-- A2. Create a Delivery Performance View

CREATE VIEW delivery_performance AS
SELECT
    order_region,
    shipping_mode,
    COUNT(*) AS total_orders,
    ROUND(AVG(actual_shipping_days), 2) AS avg_shipping_days,
    SUM(is_late_risk = 1) AS late_risk_orders
FROM supply_chain_data
GROUP BY
    order_region,
    shipping_mode;

-- Check the view
SELECT *
FROM delivery_performance;
