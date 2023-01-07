For each year, calculate the count of orders placed in the current year and the count of orders placed in the previous year. Show three columns: order_year, order_count, and previous_year_order_count.

In the first row, leave the previous year value as NULL. Order the rows by year.

[Showing total revenue for previous period – exercise](https://learnsql.com/course/sql-revenue-trend-analysis/comparing-revenue/calculating-deltas/showing-total-revenue-for-previous-period-exercise)


LAG(COUNT(order_id), 1) OVER (ORDER BY EXTRACT(YEAR FROM order_date))

This means: order all values by the year, take the count of orders for each year,
and take the value from the previous year.
