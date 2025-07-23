CREATE 	DATABASE coffee_shop;
USE coffee_shop;

SELECT * FROM coffe_shop_sales;

Describe coffe_shop_sales;

SET SQL_SAFE_UPDATES = 0;

UPDATE coffe_shop_sales
SET transaction_date = STR_TO_DATE(transaction_date, '%c/%e/%Y');

ALTER TABLE coffe_shop_sales
MODIFY COLUMN transaction_date DATE;

UPDATE coffe_shop_sales
SET transaction_time = STR_TO_DATE(transaction_time, '%H:%i:%s');

ALTER TABLE coffe_shop_sales
MODIFY COLUMN transaction_time TIME;

ALTER TABLE coffe_shop_sales
CHANGE COLUMN ï»¿transaction_id transaction_id INT;

-- Total sales
SELECT ROUND(SUM(transaction_qty*unit_price)) AS Total_sales
FROM coffe_shop_sales
WHERE
MONTH (transaction_date) = 5; -- Number of month

-- Month-over-Month Sales Comparison
-- TOTAL SALES KPI - MOM DIFFERENCE AND MOM GROWTH
SELECT  
    -- Extract the month from the transaction_date (e.g., 4 for April, 5 for May)
    MONTH(transaction_date) AS month,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
    -- Calculate Month-over-Month (MoM) percentage increase:
    -- 1. Find the current month's sales: SUM(unit_price * transaction_qty)
    -- 2. Use LAG to get previous month's sales
    -- 3. Subtract to find the difference
    -- 4. Divide by previous month's sales
    -- 5. Multiply by 100 to get percentage
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
     OVER (ORDER BY MONTH(transaction_date)))
    / LAG(SUM(unit_price * transaction_qty), 1) 
     OVER (ORDER BY MONTH(transaction_date)) * 100 
    AS mom_increase_percentage
FROM 
    coffe_shop_sales
-- Filter to include only April (4) and May (5) sales
WHERE 
    MONTH(transaction_date) IN (4, 5)
-- Group by month to aggregate sales data month-wise
GROUP BY 
    MONTH(transaction_date)
-- Ensure results are shown in chronological order: April, then May
ORDER BY 
    MONTH(transaction_date);
    
-- TOTAL ORDERS
Describe coffe_shop_sales;
SELECT COUNT(transaction_id) AS Total_orders
FROM coffe_shop_sales
WHERE MONTH(transaction_date)= 5;

-- TOTAL ORDERS KPI - MOM DIFFERENCE AND MOM GROWTH
SELECT 
	MONTH(transaction_date) AS month,
    ROUND(COUNT(transaction_id)) AS total_orders,
    (COUNT(transaction_id)-LAG (COUNT(transaction_id),1)
    OVER (ORDER BY MONTH (transaction_date)))/
    LAG (COUNT(transaction_id),1)
    OVER (ORDER BY MONTH (transaction_date))*100
    AS MoM_increase_Percentage
FROM
    coffe_shop_sales
WHERE MONTH(transaction_date) IN (4,5)

GROUP BY MONTH(transaction_date)

ORDER BY MONTH (transaction_date);

-- Total Quantity sold 
SELECT SUM(transaction_qty) as Total_Quantity_Sold
FROM coffe_shop_sales 
WHERE MONTH(transaction_date) = 5;

-- TOTAL QUANTITY SOLD KPI - MOM DIFFERENCE AND MOM GROWTH
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty)) AS total_quantity_sold,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffe_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5)   -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);

-- CALENDAR TABLE – DAILY SALES, QUANTITY and TOTAL ORDERS
SELECT 
	CONCAT(ROUND(SUM(unit_price *transaction_qty)/1000,1), 'K') AS total_sales,
    CONCAT(ROUND(COUNT(transaction_id)/1000,1),'K') AS Total_orders,
    CONCAT(ROUND(SUM(transaction_qty)/1000,1),'K') AS total_quantity_sold
FROM Coffe_shop_sales
WHERE transaction_date = '2023-04-15';

-- SALES ANALYSIS BY WEEKDAYS AND WEEK ENDS
SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'weekend'
        ELSE 'weekday'
    END AS day_type,
    SUM(unit_price * transaction_qty) AS total_sales
FROM coffe_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'weekend'
        ELSE 'weekday'
    END;

-- Sales Trend Over period
SELECT AVG(total_sales) AS average_sales
FROM(
	SELECT SUM(unit_price * transaction_qty) AS total_sales
	
	FROM coffe_shop_sales
    WHERE MONTH(transaction_date) =5
GROUP BY transaction_date) AS internal_query;

-- DAILY SALES FOR SELECTED MONTH
SELECT 
	DAY (transaction_date) AS day_of_month,
    ROUND(SUM(unit_price * transaction_qty),1) AS total_sales
    FROM coffe_shop_sales
WHERE 
    MONTH(transaction_date) = 5  -- Filter for May
GROUP BY 
    DAY(transaction_date)
ORDER BY 
    DAY(transaction_date);

-- COMPARING DAILY SALES WITH AVERAGE SALES – IF GREATER THAN “ABOVE AVERAGE” and LESSER THAN “BELOW AVERAGE”
SELECT 
    day_of_month,
    CASE 
        WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS sales_status,
    total_sales
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM 
        coffe_shop_sales
    WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        DAY(transaction_date)
) AS sales_data
ORDER BY 
    day_of_month;

-- SALES BY STORE LOCATION
SELECT 
	store_location,
	SUM(unit_price * transaction_qty) as Total_Sales
FROM coffe_shop_sales
WHERE
	MONTH(transaction_date) =5 
GROUP BY store_location
ORDER BY 	SUM(unit_price * transaction_qty) DESC;

-- SALES BY PRODUCT CATEGORY
SELECT 
	product_category,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffe_shop_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_category
ORDER BY SUM(unit_price * transaction_qty) DESC;

-- SALES BY PRODUCTS (TOP 10)
SELECT 
	product_type,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffe_shop_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) DESC
LIMIT 10;

-- SALES BY DAY | HOUR
SELECT 
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales,
    SUM(transaction_qty) AS Total_Quantity,
    COUNT(*) AS Total_Orders
FROM 
    coffe_shop_sales
WHERE 
    DAYOFWEEK(transaction_date) = 3 -- Filter for Tuesday (1 is Sunday, 2 is Monday, ..., 7 is Saturday)
    AND HOUR(transaction_time) = 8 -- Filter for hour number 8
    AND MONTH(transaction_date) = 5; -- Filter for May (month number 5)

-- TO GET SALES FROM MONDAY TO SUNDAY FOR MONTH OF MAY
SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffe_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;


-- TO GET SALES FOR ALL HOURS FOR MONTH OF MAY
SELECT 
    HOUR(transaction_time) AS Hour_of_Day,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffe_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    HOUR(transaction_time)
ORDER BY 
    HOUR(transaction_time);





