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

-- Select all the information from the employees table.
select * from employees;


-- For each customer select customer_id, company_name, contact_name, contact_title, and city.
select
  customer_id,
  company_name,
  contact_name,
  contact_title,
  city
from customers;


-- Show each product_name alongside its category_name
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


-- For each year, show the total revenue from all orders shipped to the USA. Show two columns: revenue_year and total_revenue_usa.
-- Order the rows by year.
SELECT
  EXTRACT(YEAR FROM order_date) AS revenue_year,
  SUM(amount) AS total_revenue_usa
FROM orders
WHERE ship_country = 'USA'
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date);


-- Show the total revenue from each quarter of 2017. Show two columns: quarter_in_2017 and total_revenue.
-- Order the rows by quarter.
SELECT
  EXTRACT(QUARTER FROM order_date) AS quarter_in_2017,
  SUM(amount) AS total_revenue
FROM orders
WHERE order_date >= '2017-01-01' AND order_date < '2018-01-01'
GROUP BY EXTRACT(QUARTER FROM order_date)
ORDER BY EXTRACT(QUARTER FROM order_date);


-- Show the total monthly revenue in each year, but only for orders processed by the employee with ID of 5.
-- Order the results by year and month. The columns names should be revenue_year, revenue_month, and total_revenue.
SELECT
  EXTRACT(YEAR FROM order_date) AS revenue_year,
  EXTRACT(MONTH FROM order_date) AS revenue_month,
  SUM(amount) AS total_revenue
FROM orders
WHERE employee_id = 5
GROUP BY EXTRACT(YEAR FROM order_date),
  EXTRACT(MONTH FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date),
  EXTRACT(MONTH FROM order_date);


-- Run the template query.
-- As you can see, we've got rows showing three aggregation levels: the grand total revenue, annual revenues, and the quarterly revenues for each year.
-- In other words, now you can see:
-- 1. the grand total revenue ??? the total sum for all years (revenue_year and revenue_quarter being NULL).
-- 2. the annual revenues ??? the sums for each year (revenue_quarter being NULL).
-- 3. the sums for each year and quarter (being the results of the query from the pevious exercise).
SELECT
  EXTRACT(year FROM order_date) AS revenue_year,
  EXTRACT(quarter FROM order_date) AS revenue_quarter,
  SUM(amount) AS total_revenue
FROM orders
GROUP BY ROLLUP(
  EXTRACT(year FROM order_date),
  EXTRACT(quarter FROM order_date)
)
ORDER BY
  EXTRACT(year FROM order_date),
  EXTRACT(quarter FROM order_date);


-- Show the total revenue generated by all orders on three aggregation levels:
--
-- The grand total of all revenue values ??? total_revenue
-- Annual revenue values ??? revenue_year
-- Monthly revenue values ??? revenue_month
-- Order all rows by year and month.
SELECT
  EXTRACT(YEAR FROM order_date) AS revenue_year,
  EXTRACT(MONTH FROM order_date) AS revenue_month,
  SUM(amount) AS total_revenue
FROM orders
GROUP BY ROLLUP (
  EXTRACT(YEAR FROM order_date),
  EXTRACT(MONTH FROM order_date)
)
ORDER BY EXTRACT(YEAR FROM order_date),
  EXTRACT(MONTH FROM order_date);


-- For each month of 2016, show the average order amount and the average order amount from the previous month. Show three columns: calculation_month, avg_order_amount, and previous_month_avg_order_amount.
--
-- In the first row, leave the previous month value as NULL. Order the rows by month.
SELECT
  EXTRACT(MONTH FROM order_date) AS calculation_month,
  AVG(amount) AS avg_order_amount,
  LAG(AVG(amount), 1) OVER(ORDER BY EXTRACT(MONTH FROM order_date)) AS previous_month_avg_order_amount
FROM orders
WHERE order_date >= '2016-01-01' AND order_date < '2017-01-01'
GROUP BY EXTRACT(MONTH FROM order_date)
ORDER BY EXTRACT(MONTH FROM order_date);


-- For each year, calculate the count of orders placed in the current year and the count of orders placed in the previous year. Show three columns: order_year, order_count, and previous_year_order_count.
--
-- In the first row, leave the previous year value as NULL. Order the rows by year.
SELECT
  EXTRACT(YEAR FROM order_date) AS order_year,
  COUNT(order_id) AS order_count,
  LAG(COUNT(order_id), 1) OVER (ORDER BY EXTRACT(YEAR FROM order_date)) AS previous_year_order_count
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date);


-- Show the total revenue for each quarter in each year alongside the delta (revenue change) as compared to the previous quarter. Show the following columns: revenue_year, revenue_quarter, total_revenue, and delta.
--
-- In the first row, leave the delta value as NULL. Order the rows by year and quarter.
SELECT
  EXTRACT(YEAR FROM order_date) AS revenue_year,
  EXTRACT(QUARTER FROM order_date) AS revenue_quarter,
  SUM(amount) AS total_revenue,
  SUM(amount) - LAG(SUM(amount), 1) OVER (ORDER BY EXTRACT(YEAR FROM order_date), EXTRACT(QUARTER FROM order_date)) AS delta
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date),
  EXTRACT(QUARTER FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date),
  EXTRACT(QUARTER FROM order_date);


-- Calculate the total monthly revenue for each month of 2017, along with the revenue change as compared to the previous month. Show three columns: revenue_month, total_revenue, and delta.
--
-- In the first row, leave the delta value as NULL. Order the rows by month.
SELECT
  EXTRACT(MONTH FROM order_date) AS revenue_month,
  SUM(amount) AS total_revenue,
  SUM(amount) - LAG(SUM(amount), 1) OVER (ORDER BY EXTRACT(MONTH FROM order_date)) AS delta
FROM orders
WHERE order_date >= '2017-01-01' AND order_date < '2018-01-01'
GROUP BY EXTRACT(MONTH FROM order_date)
ORDER BY EXTRACT(MONTH FROM order_date);


-- The template query contains the code from the previous example. Modify it to show the revenue change as a percentage that's rounded to three decimal places.
--
-- Here's how you can count the revenue change as a percentage:
--
-- total amount from preceding quarters * 100 /
-- total amount???total amount from preceding quarters ???
--
-- Remember to round the result to three decimal places.
SELECT
  EXTRACT(year FROM order_date) AS revenue_year,
  EXTRACT(quarter FROM order_date) AS revenue_quarter,
  SUM(amount) AS total_revenue,
  ROUND(100 * (
    SUM(amount) - LAG(SUM(amount), 1) OVER (ORDER BY
      EXTRACT(year FROM order_date),
      EXTRACT(quarter FROM order_date)
      )
    )
    /
    CAST(
        LAG(SUM(amount), 1) OVER (ORDER BY
          EXTRACT(year FROM order_date),
          EXTRACT(quarter FROM order_date)
        )
      AS DECIMAL(10, 2)
    )
  , 3) AS delta
FROM orders
GROUP BY
  EXTRACT(year FROM order_date),
  EXTRACT(quarter FROM order_date)
ORDER BY
  EXTRACT(year FROM order_date),
  EXTRACT(quarter FROM order_date);


-- For each month of 2017, calculate the total monthly revenue from orders shipped to the USA and the percentage revenue change (delta) as compared to the previous month.
-- Show three columns: revenue_month, total_revenue, and delta_percentage.
--
-- In the first row, leave the delta value as NULL. Order the rows by month. Here's how you can count delta_percentage:
--
-- \frac{\textrm{total amount} - \textrm{total amount from preceding months}}{\textrm{total amount from preceding months}} \cdot 100
--
-- Remember to round the result to the second decimal point.
SELECT
  EXTRACT(MONTH FROM order_date) AS revenue_month,
  SUM(amount) AS total_revenue,
  ROUND(
    100 *
    (
      SUM(amount)
      - LAG(SUM(amount), 1) OVER (ORDER BY EXTRACT(MONTH FROM order_date))
    )
    /
    CAST(LAG(SUM(amount), 1) OVER (ORDER BY EXTRACT(MONTH FROM order_date)) AS DECIMAL(10, 2)),
    2
  ) AS delta_percentage
FROM orders
WHERE (order_date >= '2017-01-01' AND order_date < '2018-01-01')
  AND ship_country = 'USA'
GROUP BY EXTRACT(MONTH FROM order_date)
ORDER BY EXTRACT(MONTH FROM order_date);


-- For each order shipped to Germany, show three columns:
--
-- 1. order_id
-- 2. amount
-- 3. order_value ??? set this value to 'high' if the order's amount is greater than $1,000. Otherwise, set it to 'low'.
SELECT
  order_id,
  amount,
  CASE
    WHEN amount > 1000.00
      THEN 'high'
    ELSE 'low'
  END AS order_value
FROM orders
WHERE ship_country = 'Germany';


-- Show two columns:
--
-- sum_high_freight ??? The total amount generated by all orders with freight values above 100.0.
-- sum_low_freight ??? The total amount generated by all orders with freight values equal to or less than 100.0.
SELECT
  SUM(
    CASE
      WHEN freight > 100.0
        THEN amount
      ELSE 0.0
    END) AS sum_high_freight,
  SUM(
    CASE
      WHEN freight <= 100.0
        THEN amount
      ELSE 0.0
    END) AS sum_low_freight
FROM orders;


-- Show a revenue in quarters report similar to the one in the explanation. Instead of the revenue per quarter, show the average order amount per quarter.
--
-- Order the rows by year.
SELECT
  EXTRACT(YEAR FROM order_date) AS year,
  AVG(CASE WHEN EXTRACT(QUARTER FROM order_date) = 1 THEN amount END) AS Q1,
  AVG(CASE WHEN EXTRACT(QUARTER FROM order_date) = 2 THEN amount END) AS Q2,
  AVG(CASE WHEN EXTRACT(QUARTER FROM order_date) = 3 THEN amount END) AS Q3,
  AVG(CASE WHEN EXTRACT(QUARTER FROM order_date) = 4 THEN amount END) AS Q4
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date);


-- Create a "revenue in quarters" report showing the number of orders placed in each quarter of each year.
-- Order the rows by year.
SELECT
  EXTRACT(YEAR FROM order_date) AS year,
  COUNT(CASE WHEN EXTRACT(QUARTER FROM order_date) = 1 THEN order_id END) AS Q1,
  COUNT(CASE WHEN EXTRACT(QUARTER FROM order_date) = 2 THEN order_id END) AS Q2,
  COUNT(CASE WHEN EXTRACT(QUARTER FROM order_date) = 3 THEN order_id END) AS Q3,
  COUNT(CASE WHEN EXTRACT(QUARTER FROM order_date) = 4 THEN order_id END) AS Q4
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date);


-- Calculate the average order value for each month of 2017. Show two columns: revenue_month and avg_order_value.
-- Order the rows by month.
SELECT
  EXTRACT(MONTH FROM order_date) AS revenue_month,
  AVG(amount) AS avg_order_value
FROM orders
WHERE order_date >= '2017-01-01' AND order_date < '2018-01-01'
GROUP BY EXTRACT(MONTH FROM order_date)
ORDER BY EXTRACT(MONTH FROM order_date);


-- For each month of the first half of 2017, calculate the total revenue and the revenue change (delta) as compared to the previous month.
-- Show three columns: revenue_month, total_revenue, and delta.
-- In the first row, leave the delta value as NULL. Order the results by month.
SELECT
  EXTRACT(MONTH FROM order_date) AS revenue_month,
  SUM(amount) AS total_revenue,
  SUM(amount) - LAG(SUM(amount), 1) OVER (ORDER BY EXTRACT(MONTH FROM order_date)) AS delta
FROM orders
WHERE order_date >= '2017-01-01' AND order_date < '2017-07-01'
GROUP BY EXTRACT(MONTH FROM order_date)
ORDER BY EXTRACT(MONTH FROM order_date);


-- Show the count of orders shipped to the USA on three aggregation levels:
--
-- The grand total number of orders.
-- The annual number of orders.
-- The quarterly number of orders.
-- Order all rows by year and quarter. The column names should be: year, quarter, and order_count.
SELECT
  EXTRACT(YEAR FROM order_date) AS year,
  EXTRACT(QUARTER FROM order_date) AS quarter,
  COUNT(order_id) AS order_count
FROM orders
WHERE ship_country = 'USA'
GROUP BY ROLLUP(
  EXTRACT(YEAR FROM order_date),
  EXTRACT(QUARTER FROM order_date)
)
ORDER BY EXTRACT(YEAR FROM order_date),
  EXTRACT(QUARTER FROM order_date);


-- For all orders shipped to Germany, create a "revenue in quarters" report showing the total quarterly revenue in each year.
-- Order the results by year.
SELECT
  EXTRACT(YEAR FROM order_date) AS year,
  SUM(CASE WHEN EXTRACT(QUARTER FROM order_date) = 1 THEN amount ELSE 0 END) AS Q1,
  SUM(CASE WHEN EXTRACT(QUARTER FROM order_date) = 2 THEN amount ELSE 0 END) AS Q2,
  SUM(CASE WHEN EXTRACT(QUARTER FROM order_date) = 3 THEN amount ELSE 0 END) AS Q3,
  SUM(CASE WHEN EXTRACT(QUARTER FROM order_date) = 4 THEN amount ELSE 0 END) AS Q4
FROM orders
WHERE ship_country = 'Germany'
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date);


-- Comparing revenue over time across different categories

-- Learn how you can extend the report types you already know by comparing different product categories.


-- For all order items from the order with the ID of 10498, show the following columns:
--
-- product_id
-- category_name
-- product_name
-- amount
SELECT
  oi.product_id,
  c.category_name,
  p.product_name,
  oi.amount
FROM order_items oi
JOIN products p
ON p.product_id = oi.product_id
JOIN categories c
ON p.category_id = c.category_id
WHERE oi.order_id = 10498;


-- Generate a history-to-date category revenue report based on orders shipped to the United States.
-- The names of the columns should be category_name and total_revenue.
SELECT
  c.category_name,
  SUM(oi.amount) AS total_revenue
FROM order_items oi
JOIN orders o
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
JOIN categories c
ON p.category_id = c.category_id
WHERE ship_country = 'USA'
GROUP BY c.category_name;


-- For all orders placed in the first six months of 2017, calculate the total revenue for all categories.
-- Show two columns: category_name and total_revenue.
SELECT
  c.category_name,
  SUM(oi.amount) AS total_revenue
FROM order_items oi
JOIN orders o
ON o.order_id = oi.order_id
JOIN products p
ON p.product_id = oi.product_id
JOIN categories c
ON c.category_id = p.category_id
WHERE o.order_date >= '2017-01-01' AND o.order_date < '2017-07-01'
GROUP BY c.category_name;


-- Create a report that shows the category revenue values for all orders placed in 2017.
-- Show three columns: category_name, category_revenue, and total_sum.
-- The last column should show the total revenue from 2017 for all rows.
WITH all_categories AS (
  SELECT SUM(amount) AS total_sum
  FROM orders
  WHERE order_date >= '2017-01-01' AND order_date < '2018-01-01'
)

SELECT
  c.category_name,
  SUM(oi.amount) AS category_revenue,
  ac.total_sum
FROM all_categories ac, order_items oi
JOIN orders o
ON o.order_id = oi.order_id
JOIN products p
ON p.product_id = oi.product_id
JOIN categories c
ON c.category_id = p.category_id
WHERE o.order_date >= '2017-01-01' AND o.order_date < '2018-01-01'
GROUP BY c.category_name, ac.total_sum;


-- Create a report of the category revenue for all orders placed in 2017 or later.
-- Show three columns: category_name, category_revenue, and total_revenue_percentage.
-- The last column should show the rounded to two decimal places percentage of the total revenue generated by that category.
WITH all_categories_total_revenue_2017_or_later AS (
  SELECT
    SUM(amount) AS total_sum
  FROM orders
  WHERE order_date >= '2017-01-01'
)

SELECT
  c.category_name,
  SUM(oi.amount) AS category_revenue,
  ROUND(100 * SUM(oi.amount) / CAST(ac.total_sum AS DECIMAL(10, 2)), 2) AS total_revenue_percentage
FROM all_categories_total_revenue_2017_or_later ac, order_items oi
JOIN orders o
ON o.order_id = oi.order_id
JOIN products p
ON p.product_id = oi.product_id
JOIN categories c
ON c.category_id = p.category_id
WHERE o.order_date >= '2017-01-01'
GROUP BY c.category_name, ac.total_sum;


-- Create a report of the category revenue for orders shipped to Germany.
-- Show three columns: category_name, category_revenue, and total_revenue_ratio.
-- The last column should show the ratio of category revenue to total revenue generated by orders shipped to Germany.
WITH all_categories_germany_total_revenue AS (
  SELECT
    SUM(amount) AS total_sum
  FROM orders
  WHERE ship_country = 'Germany'
)

SELECT
  c.category_name,
  SUM(oi.amount) AS category_revenue,
  SUM(oi.amount) / CAST(ac.total_sum AS DECIMAL(10, 2)) AS total_revenue_ratio
FROM all_categories_germany_total_revenue ac, order_items oi
JOIN orders o
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
JOIN categories c
ON p.category_id = c.category_id
WHERE o.ship_country = 'Germany'
GROUP BY c.category_name, ac.total_sum;


