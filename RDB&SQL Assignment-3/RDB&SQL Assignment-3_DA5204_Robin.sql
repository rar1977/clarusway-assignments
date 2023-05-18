--- Discount Effects

-- Using SampleRetail database generate a report, including product IDs and discount effects on whether the increase in the 
-- discount rate positively impacts the number of orders for the products. 
-- For this, statistical analysis methods can be used. However, this is not expected.
-- In this assignment, you are expected to generate a solution using SQL with a logical approach. 

--Sample Result:
--Product_id	Discount Effect
--1	Positive
--2	Negative
--3	Negative
--4	Neutral

SELECT
    p.product_id,
    CASE
        WHEN SUM(CASE WHEN oi.discount > 0 THEN 1 ELSE 0 END) > SUM(CASE WHEN oi.discount = 0 THEN 1 ELSE 0 END) THEN 'Positive'
        WHEN SUM(CASE WHEN oi.discount > 0 THEN 1 ELSE 0 END) < SUM(CASE WHEN oi.discount = 0 THEN 1 ELSE 0 END) THEN 'Negative'
        ELSE 'Neutral'
    END AS discount_effect
FROM
    product.product p
    LEFT JOIN sale.order_item oi ON p.product_id = oi.product_id
GROUP BY
    p.product_id
ORDER BY
    p.product_id