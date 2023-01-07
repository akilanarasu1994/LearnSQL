select
  customer_id,
  count(distinct o.order_id) as order_count,
  sum(quantity * unit_price * (1 - discount)) as total_revenue_after_discount
from orders o
join order_items oi
on oi.order_id = o.order_id
group by customer_id;

select
  o.customer_id,
  o.order_id,
  o.product_id,
  oi.quantity,
  oi.unit_price
from orders o
join order_items oi
on oi.order_id = o.order_id
group by o.customer_id;

select
  customer_id,
  company_name,
  contact_name,
  contact_title,
  city
from customers;

SELECT
  product_name,
  category_name
FROM products p
JOIN categories c
ON p.category_id = c.category_id;

-- For each order display order_id, order_date, the number of products ordered in this order (name this column product_count) and the total amount paid for that order (name this column total_amount).

-- To access the total_amount for each order, you should use the amount column from the orders table.

SELECT
  o.order_id,
  order_date,
  COUNT(product_id) AS product_count,
  o.amount AS total_amount
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_id, order_date, o.amount;

-- Find the total revenue to date for all beverages (i.e., products with category_id = 1). Use the amount column from order_items as total_revenue.

SELECT
  SUM(amount) AS total_revenue
FROM order_items
JOIN products
ON order_items.product_id = products.product_id
WHERE category_id = 1;

-- Show each category_id and category_name alongside the total_revenue generated by all order items from that category.

SELECT
  c.category_id,
  c.category_name,
  SUM(oi.amount) as total_revenue
FROM order_items oi
JOIN products p
ON p.product_id = oi.product_id
JOIN categories c
ON c.category_id = p.category_id
GROUP BY c.category_id,
  c.category_name;


-- Find the total_revenue (the sum of all amounts) from all orders placed in 2017.

SELECT
  SUM(amount) as total_revenue
FROM orders o
WHERE o.order_date >= '2017-01-01' AND o.order_date < '2018-01-01';


-- The fiscal year in Northwind starts on September 1.

-- For each customer, show the total revenue from orders placed in the fiscal year starting September 1, 2016. Show three columns: customer_id, company_name, and total_revenue.

-- Use the INTERVAL keyword.

SELECT
  c.customer_id,
  c.company_name,
  SUM(amount) AS total_revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
WHERE order_date >= '2016-09-01'
AND order_date < CAST('2016-09-01' AS DATE) + INTERVAL '1' YEAR
GROUP BY c.customer_id,
  c.company_name;


-- Show the total revenue generated in the first quarter of 2018. Group revenue by each shipping country. Show two columns: ship_country and total_revenue

SELECT
  o.ship_country,
  SUM(o.amount) AS total_revenue
FROM orders o
WHERE o.order_date >= '2018-01-01'
AND o.order_date < CAST('2018-01-01' AS DATE) + INTERVAL '3' MONTH
GROUP BY o.ship_country;

-- In a column named current_year_start, show the beginning of the current year.

SELECT
  CAST(
    EXTRACT(YEAR FROM CURRENT_TIMESTAMP)
    || '-'
    || EXTRACT(MONTH FROM CURRENT_TIMESTAMP)
    || '-01'
    AS DATE) AS current_year_start;


-- In a column named current_year_start, show the beginning of the current year using the function DATE_TRUNC().

SELECT DATE_TRUNC('year', CURRENT_TIMESTAMP) AS current_year_start;


-- Calculate the year-to-date revenue for each customer. Show two columns: customer_id and total_revenue

SELECT
  customer_id,
  SUM(amount) AS total_revenue
FROM orders
WHERE order_date >= DATE_TRUNC('year', CURRENT_TIMESTAMP)
GROUP BY customer_id;


-- For each employee, find their quarter-to-date revenue. Show three columns: employee_id, last_name, and total_revenue. Use a DATE_TRUNC() function

SELECT
  e.employee_id,
  e.last_name,
  SUM(amount) AS total_revenue
FROM orders o
JOIN employees e
ON o.employee_id = e.employee_id
WHERE o.order_date >= DATE_TRUNC('quarter', CURRENT_TIMESTAMP)
GROUP BY e.employee_id,
  e.last_name;


-- Show the total revenue for 2018 in a column named total_revenue.

SELECT
  SUM(amount) AS total_revenue
FROM orders
WHERE order_date >= '2018-01-01'
AND order_date < CAST('2018-01-01' AS DATE) + INTERVAL '1' YEAR;


-- For each shipping country, find the month-to-date revenue. Show two columns: ship_country and total_revenue.

SELECT
  ship_country,
  SUM(amount) AS total_revenue
FROM orders
WHERE order_date >= DATE_TRUNC('month', CURRENT_TIMESTAMP)
GROUP BY ship_country;


