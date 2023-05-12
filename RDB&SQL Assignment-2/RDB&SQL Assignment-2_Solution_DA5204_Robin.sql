--- 1. Product Sales
-- You need to create a report on whether customers who purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the product below or not.
-- 1. 'Polk Audio - 50 W Woofer - Black' -- (other_product)
-- To generate this report, you are required to use the appropriate SQL Server Built-in functions or expressions as well as basic SQL knowledge.


--Structure
select *
from [sale].[order_item]

select *
from [product].[product]

select *
from [sale].[orders]

select *
from [sale].[order_item]

-- Solution 1
SELECT DISTINCT c.customer_id, c.first_name, c.last_name,
CASE
    WHEN EXISTS (
        SELECT 1
        FROM [sale].[orders] o2
        JOIN [sale].[order_item] oi2 ON o2.order_id = oi2.order_id
        JOIN [product].[product] p2 ON oi2.product_id = p2.product_id
        WHERE o2.customer_id = c.customer_id
        AND p2.product_name = 'Polk Audio - 50 W Woofer - Black'
    ) THEN 'Yes'
    ELSE 'No'
END AS Other_Product
FROM [sale].[customer] c
JOIN [sale].[orders] o1 ON c.customer_id = o1.customer_id
JOIN [sale].[order_item] oi1 ON o1.order_id = oi1.order_id
JOIN [product].[product] p1 ON oi1.product_id = p1.product_id
WHERE p1.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'


--- 2. Conversion Rate
-- Below you see a table of the actions of customers visiting the website by clicking on two different types of advertisements given by an E-Commerce company. Write a query to return the conversion rate for each Advertisement type.

-- Solution
-- a.    Create above table (Actions) and insert values,
CREATE TABLE Actions (
    Visitor_ID INT,
    Adv_Type CHAR(1),
    Action VARCHAR(10)
);

INSERT INTO Actions (Visitor_ID, Adv_Type, Action) VALUES
(1, 'A', 'Left'),
(2, 'A', 'Order'),
(3, 'B', 'Left'),
(4, 'A', 'Order'),
(5, 'A', 'Review'),
(6, 'A', 'Left'),
(7, 'B', 'Left'),
(8, 'B', 'Order'),
(9, 'B', 'Review'),
(10, 'A', 'Review');


-- b.    Retrieve count of total Actions and Orders for each Advertisement Type,
SELECT 
    Adv_Type, 
    COUNT(*) AS Total_Actions,
    SUM(CASE WHEN Action = 'Order' THEN 1 ELSE 0 END) AS Total_Orders
FROM 
    Actions 
GROUP BY 
    Adv_Type;




-- c.    Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0.
--Solution 2
SELECT 
    Adv_Type, 
    ROUND((SUM(CASE WHEN Action = 'Order' THEN 1 ELSE 0 END) * 1.0 / COUNT(*)), 2) AS Conversion_Rate
FROM 
    Actions 
GROUP BY 
    Adv_Type;







