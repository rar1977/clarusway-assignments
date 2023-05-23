--- Create a Database
CREATE DATABASE ecommerce;

--- Use the Database
USE ecommerce;

--- Create the table
CREATE TABLE e_commerce_data (
    Ord_ID INT,
    Cust_ID INT,
    Prod_ID INT,
    Ship_ID INT,
    Order_Date DATE,
    Ship_Date DATE,
    Customer_Name VARCHAR(255),
    Province VARCHAR(255),
    Region VARCHAR(255),
    Customer_Segment VARCHAR(255),
    Sales DECIMAL(10,2),
    Order_Quantity INT,
    Order_Priority VARCHAR(255),
    DaysTakenForShipping INT
);

--- Import the csv File
LOAD DATA INFILE 'e_commerce_data.csv' INTO TABLE e_commerce_data 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
--> Done with Extension


-- Verify accuracy of the analysis
SELECT TOP (1000) [Ord_ID]
      ,[Cust_ID]
      ,[Prod_ID]
      ,[Ship_ID]
      ,[Order_Date]
      ,[Ship_Date]
      ,[Customer_Name]
      ,[Province]
      ,[Region]
      ,[Customer_Segment]
      ,[Sales]
      ,[Order_Quantity]
      ,[Order_Priority]
      ,[DaysTakenForShipping]
  FROM [ecommerce].[dbo].[e_commerce_data]


--### Analyze the data
--1. Find the top 3 customers who have the maximum count of orders.
SELECT Top 3 Customer_Name, COUNT(*) as Order_Count
FROM e_commerce_data
GROUP BY Customer_Name
ORDER BY Order_Count DESC

--2. Find the customer whose order took the maximum time to get shipping.
SELECT Customer_Name, DaysTakenForShipping
FROM e_commerce_data
WHERE DaysTakenForShipping = (
    SELECT MAX(DaysTakenForShipping)
    FROM e_commerce_data
);

--3. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011

SELECT COUNT(*) as Customers_Every_Month
FROM (
    SELECT Cust_ID
    FROM e_commerce_data
    WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 1
) AS January_Customers
JOIN (
    SELECT Cust_ID
    FROM e_commerce_data
    WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 2
) AS February_Customers ON January_Customers.Cust_ID = February_Customers.Cust_ID
JOIN (
    SELECT Cust_ID
    FROM e_commerce_data
    WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 3
) AS March_Customers ON February_Customers.Cust_ID = March_Customers.Cust_ID
JOIN (
    SELECT Cust_ID
    FROM e_commerce_data
    WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 4
) AS April_Customers ON March_Customers.Cust_ID = April_Customers.Cust_ID
JOIN (
    SELECT Cust_ID
    FROM e_commerce_data
    WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 5
) AS May_Customers ON April_Customers.Cust_ID = May_Customers.Cust_ID
JOIN (
    SELECT Cust_ID
    FROM e_commerce_data
    WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 6
) AS June_Customers ON May_Customers.Cust_ID = June_Customers.Cust_ID
JOIN (
    SELECT Cust_ID
    FROM e_commerce_data
    WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 7
) AS July_Customers ON June_Customers.Cust_ID = July_Customers.Cust_ID
JOIN (
    SELECT Cust_ID
    FROM e_commerce_data
    WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 8
) AS August_Customers ON July_Customers.Cust_ID = August_Customers.Cust_ID
JOIN (
    SELECT Cust_ID
    FROM e_commerce_data
    WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 9
) AS September_Customers ON August_Customers.Cust_ID = September_Customers.Cust_ID
JOIN (
    SELECT Cust_ID
    FROM e_commerce_data
    WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 10
) AS October_Customers ON September_Customers.Cust_ID = October_Customers.Cust_ID
JOIN (
    SELECT Cust_ID
    FROM e_commerce_data
    WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 11
) AS November_Customers ON October_Customers.Cust_ID = November_Customers.Cust_ID
JOIN (
    SELECT Cust_ID
    FROM e_commerce_data
    WHERE YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = 12
) AS December_Customers ON November_Customers.Cust_ID = December_Customers.Cust_ID;



--4. Write a query to return for each user the time elapsed between the first purchasing and the third purchasing, in ascending order by Customer ID.
SELECT Cust_ID, 
       DATEDIFF(DAY, MIN(CASE WHEN purchase_rank = 1 THEN Order_Date END), 
                     MAX(CASE WHEN purchase_rank = 3 THEN Order_Date END)) as Days_Between
FROM (
    SELECT Cust_ID, 
           Order_Date, 
           ROW_NUMBER() OVER(PARTITION BY Cust_ID ORDER BY Order_Date) as purchase_rank
    FROM e_commerce_data
) as subquery
WHERE purchase_rank IN (1, 3)
GROUP BY Cust_ID
HAVING COUNT(*) = 2
ORDER BY Cust_ID;



--5. Write a query that returns customers who purchased both product 11 and product 14, as well as the ratio of these products to the total number of products purchased by the customer.
SELECT 
    Cust_ID, 
    (Prod_11_Orders + Prod_14_Orders) AS Total_Prod_11_and_14_Orders,
    Total_Orders,
    CAST((Prod_11_Orders + Prod_14_Orders) AS FLOAT) / Total_Orders AS Ratio
FROM (
    SELECT 
        Cust_ID,
        SUM(CASE WHEN Prod_ID = 'Prod_11' THEN 1 ELSE 0 END) AS Prod_11_Orders,
        SUM(CASE WHEN Prod_ID = 'Prod_14' THEN 1 ELSE 0 END) AS Prod_14_Orders,
        COUNT(*) AS Total_Orders
    FROM e_commerce_data
    GROUP BY Cust_ID
) AS Customer_Products
WHERE Prod_11_Orders > 0 AND Prod_14_Orders > 0;


--- Customer Segmentation
--1. Create a “view” that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
CREATE VIEW Customer_Visit_Logs AS
SELECT 
    Cust_ID, 
    YEAR(Order_Date) AS Year, 
    MONTH(Order_Date) AS Month
FROM e_commerce_data
GROUP BY Cust_ID, YEAR(Order_Date), MONTH(Order_Date);

SELECT * FROM Customer_Visit_Logs

--2. Create a “view” that keeps the number of monthly visits by users. (Show separately all months from the beginning business)
CREATE VIEW Monthly_Visits AS
SELECT 
    Cust_ID, 
    YEAR(Order_Date) AS Year, 
    MONTH(Order_Date) AS Month,
    COUNT(*) AS Visit_Count
FROM e_commerce_data
GROUP BY Cust_ID, YEAR(Order_Date), MONTH(Order_Date);

SELECT * FROM Monthly_Visits

--3. For each visit of customers, create the next month of the visit as a separate column.
CREATE VIEW Customer_Visits_Next_Month AS
SELECT 
    Cust_ID, 
    YEAR(Order_Date) AS Visit_Year, 
    MONTH(Order_Date) AS Visit_Month,
    YEAR(DATEADD(MONTH, 1, EOMONTH(Order_Date))) AS Next_Visit_Year,
    MONTH(DATEADD(MONTH, 1, EOMONTH(Order_Date))) AS Next_Visit_Month
FROM e_commerce_data;

SELECT * FROM Customer_Visits_Next_Month

--4. Calculate the monthly time gap between two consecutive visits by each customer.
CREATE VIEW Customer_Visit_Gaps AS
SELECT 
    Cust_ID, 
    YEAR(Order_Date) AS Visit_Year, 
    MONTH(Order_Date) AS Visit_Month,
    DATEDIFF(MONTH, LAG(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date), Order_Date) AS Month_Gap
FROM e_commerce_data;

SELECT * FROM Customer_Visit_Gaps



--5. Categorise customers using average time gaps. Choose the most fitted labeling model for you.
    --For example:
    --o Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
    --o Labeled as regular if the customer has made a purchase every month. Etc.

CREATE VIEW Customer_Categories AS
SELECT 
    Cust_ID, 
    CASE
        WHEN MAX(Order_Date) = MIN(Order_Date) THEN 'OneTime'
        WHEN DATEDIFF(MONTH, MIN(Order_Date), MAX(Order_Date)) = COUNT(DISTINCT YEAR(Order_Date)*100 + MONTH(Order_Date)) - 1 THEN 'Recurring'
        ELSE 'Churn'
    END AS Category
FROM e_commerce_data
GROUP BY Cust_ID;

SELECT * FROM Customer_Categories


--- Month-Wise Retention Rate
-- Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total Number of Customers in the Current Month
--1. Find the number of customers retained month-wise. (You can use time gaps) 
SELECT 
    YEAR(Order_Date) AS Year, 
    MONTH(Order_Date) AS Month,
    COUNT(DISTINCT Cust_ID) AS Retained_Customers
FROM (
    SELECT 
        Cust_ID, 
        Order_Date,
        LAG(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date) AS Previous_Order_Date
    FROM e_commerce_data
) AS Customer_Visits
WHERE DATEDIFF(MONTH, Previous_Order_Date, Order_Date) <= 1
GROUP BY YEAR(Order_Date), MONTH(Order_Date);




--2. Calculatethemonth-wiseretentionrate.
CREATE VIEW Total_Customers AS
SELECT 
    YEAR(Order_Date) AS Year, 
    MONTH(Order_Date) AS Month,
    COUNT(DISTINCT Cust_ID) AS Total_Customers
FROM e_commerce_data
GROUP BY YEAR(Order_Date), MONTH(Order_Date);

SELECT 
    Retained_Customers.Year, 
    Retained_Customers.Month,
    ISNULL(1.0 * Retained_Customers.Retained_Customers / Total_Customers.Total_Customers, 0) AS Retention_Rate
FROM (
    SELECT 
        YEAR(Order_Date) AS Year, 
        MONTH(Order_Date) AS Month,
        COUNT(DISTINCT Cust_ID) AS Retained_Customers
    FROM (
        SELECT 
            Cust_ID, 
            Order_Date,
            LAG(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date) AS Previous_Order_Date
        FROM e_commerce_data
    ) AS Customer_Visits
    WHERE DATEDIFF(MONTH, Previous_Order_Date, Order_Date) <= 1
    GROUP BY YEAR(Order_Date), MONTH(Order_Date)
) AS Retained_Customers
LEFT JOIN Total_Customers ON Retained_Customers.Year = Total_Customers.Year AND Retained_Customers.Month = Total_Customers.Month;

