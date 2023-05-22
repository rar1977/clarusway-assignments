-- Write a query that returns the count of orders of each day between '2020-01-19' and '2020-01-25'. Report the result using Pivot Table.

--- Note: The column names should be day names (Sun, Mon, etc.).

SELECT
    *
FROM
    (
        SELECT
            order_date,
            COUNT(*) AS order_count
        FROM
            sale.orders
        WHERE
            order_date >= '2020-01-19' AND order_date <= '2020-01-25'
        GROUP BY
            order_day
    ) AS order_counts
PIVOT
    (
        SUM(order_count)
        FOR order_day IN ('2020-01-19', '2020-01-20', '2020-01-21', '2020-01-22', '2020-01-23', '2020-01-24', '2020-01-25')
    ) AS pivot_table;



SELECT
    *
FROM
    (
        SELECT
            CASE WHEN DATEPART(dw, order_date) = 1 THEN 'Sunday'
                 WHEN DATEPART(dw, order_date) = 2 THEN 'Monday'
                 WHEN DATEPART(dw, order_date) = 3 THEN 'Tuesday'
                 WHEN DATEPART(dw, order_date) = 4 THEN 'Wednesday'
                 WHEN DATEPART(dw, order_date) = 5 THEN 'Thursday'
                 WHEN DATEPART(dw, order_date) = 6 THEN 'Friday'
                 WHEN DATEPART(dw, order_date) = 7 THEN 'Saturday'
            END AS day_of_week,
            COUNT(*) AS order_count
        FROM
            sale.orders
        WHERE
            order_date >= '2020-01-19' AND order_date <= '2020-01-25'
        GROUP BY
            DATEPART(dw, order_date)
    ) AS order_counts
PIVOT
    (
        SUM(order_count)
        FOR day_of_week IN ([sunday], [Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [saturday])
    ) AS pivot_table;


SELECT
    order_id
FROM
    sale.order_item
GROUP BY
    order_id
HAVING
    AVG(list_price * quantity * (1 - discount)) > 2000
ORDER BY
    order_id ASC;



