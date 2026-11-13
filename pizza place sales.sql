SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN ('order_id', 'pizza_id', 'pizza_type_id')
ORDER BY COLUMN_NAME, TABLE_NAME;

ALTER TABLE orders DROP CONSTRAINT PK_orders;

ALTER TABLE orders ALTER COLUMN order_id INT NOT NULL;

ALTER TABLE orders ADD CONSTRAINT PK_orders PRIMARY KEY (order_id);

ALTER TABLE order_details ADD CONSTRAINT FK_od_orders
  FOREIGN KEY (order_id) REFERENCES orders(order_id);

  SELECT fk.name AS fk_name,
       OBJECT_NAME(fk.parent_object_id) AS child_table,
       OBJECT_NAME(fk.referenced_object_id) AS parent_table
FROM sys.foreign_keys fk;

SELECT COUNT(*) AS orders FROM orders;
SELECT COUNT(*) AS order_lines FROM order_details;
SELECT TOP 10 * FROM orders;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'orders';

SELECT SUM(od.quantity * p.price) AS total_revenue,
       COUNT(DISTINCT od.order_id) AS total_orders
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;

SELECT pt.name, SUM(od.quantity * p.price) AS revenue
FROM order_details od
JOIN pizzas p       ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC;

--Average order value

SELECT AVG(order_total) AS aov
FROM (
    SELECT od.order_id, SUM(od.quantity * p.price) AS order_total
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY od.order_id
) t;

--busiest hour of the day

SELECT DATEPART(HOUR, o.time) AS hour_of_day,
       COUNT(DISTINCT o.order_id) AS orders
FROM orders o
GROUP BY DATEPART(HOUR, o.time)
ORDER BY orders DESC;

--busiest day of the week

SELECT DATENAME(WEEKDAY, o.date) AS day_name,
       COUNT(DISTINCT o.order_id) AS orders
FROM orders o
GROUP BY DATENAME(WEEKDAY, o.date), DATEPART(WEEKDAY, o.date)
ORDER BY DATEPART(WEEKDAY, o.date);

--revenue by category

SELECT pt.category, SUM(od.quantity * p.price) AS revenue
FROM order_details od
JOIN pizzas p       ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY revenue DESC;

--revenue by size

SELECT p.size, SUM(od.quantity) AS pizzas_sold,
       SUM(od.quantity * p.price) AS revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY revenue DESC;


--month over month growth(windows function)

WITH monthly AS (
    SELECT FORMAT(o.date, 'yyyy-MM') AS month,
           SUM(od.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY FORMAT(o.date, 'yyyy-MM')
)
SELECT month, revenue,
       LAG(revenue) OVER (ORDER BY month) AS prev_month,
       (revenue - LAG(revenue) OVER (ORDER BY month))
         / LAG(revenue) OVER (ORDER BY month) * 100 AS growth_pct
FROM monthly;

ALTER TABLE pizzas ALTER COLUMN price DECIMAL(10,2) NOT NULL;

--why is xxl so low
SELECT pt.name, p.size, SUM(od.quantity) AS sold
FROM order_details od
JOIN pizzas p       ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
WHERE p.size = 'XXL'
GROUP BY pt.name, p.size;


CREATE VIEW vw_pizza_sales AS
SELECT o.order_id, o.date, o.time,
       od.order_details_id, od.quantity,
       p.size, p.price,
       pt.name AS pizza_name, pt.category,
       od.quantity * p.price AS line_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p         ON od.pizza_id = p.pizza_id
JOIN pizza_types pt   ON p.pizza_type_id = pt.pizza_type_id;


SELECT COUNT(*) FROM vw_pizza_sales;       
SELECT SUM(line_revenue) FROM vw_pizza_sales;  

