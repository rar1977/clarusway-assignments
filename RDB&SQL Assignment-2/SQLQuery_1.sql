select *
from sale.staff
where store_id =
	(	select store_id
		from sale.staff
		where first_name='Davis'
		and last_name='Thomas')


select *
from sale.staff
where manager_id=(
					select staff_id
					from sale.staff
					where first_name='Charles' and last_name='Cussona'
				  )




--- Write a query that returns the list of products that are more expensive than the product named "Pro-Series 49-Class Full HD Outdoor LED TV (Silver)".

SELECT p.product_name, p.list_price
FROM product.product AS p
WHERE p.list_price > (
    SELECT list_price
    FROM product.product
    WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'
);


-- Write a query that returns the customer names, last names, and order dates. The customers whose order are before the order date of Hassan Pope.

SELECT c.first_name, c.last_name, o.order_date
FROM sale.customer AS c
JOIN sale.orders AS o ON c.customer_id = o.customer_id
WHERE o.order_date < (
    SELECT order_date
    FROM sale.orders
    JOIN sale.customer ON sale.customer.customer_id = sale.orders.customer_id
    WHERE sale.customer.first_name = 'Hassan' AND sale.customer.last_name = 'Pope'
)


-- Question: Write a query that returns customer first names, last names and order dates. The customers who are order on the same dates as Laurel Goldammer.


SELECT c.first_name, c.last_name, o.order_date
FROM sale.customer AS c
JOIN sale.orders AS o ON c.customer_id = o.customer_id
WHERE o.order_date IN (
    SELECT order_date
    FROM sale.orders
    JOIN sale.customer ON sale.customer.customer_id = sale.orders.customer_id
    WHERE sale.customer.first_name = 'Laurel' AND sale.customer.last_name = 'Goldammer'
)

-- List the products that ordered in the last 10 orders in Buffalo city?
SELECT distinct p.product_name
FROM product.product AS p
JOIN sale.order_item AS oi ON p.product_id = oi.product_id
JOIN (
    SELECT TOP 10 o.order_id
    FROM sale.orders AS o
    JOIN sale.customer AS c ON o.customer_id = c.customer_id
    WHERE c.city = 'Buffalo'
    ORDER BY o.order_date DESC
) AS last_10_orders ON oi.order_id = last_10_orders.order_id;



-- To retrieve the product names that were ordered in 2021, excluding the categories that match "Game," "gps," or "Home Theater," you can use a combination of joins, subqueries, and filters. Here is the SQL query:

SELECT p.product_name
FROM product.product AS p
JOIN sale.order_item AS oi ON p.product_id = oi.product_id
JOIN sale.orders AS o ON oi.order_id = o.order_id
JOIN product.category AS c ON p.category_id = c.category_id
WHERE YEAR(o.order_date) = 2021
  AND c.category_name NOT IN ('Game', 'gps', 'Home Theater');


