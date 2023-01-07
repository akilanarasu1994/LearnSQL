For each month of 2016, show the average order amount and the average order amount from the previous month. Show three columns: calculation_month, avg_order_amount, and previous_month_avg_order_amount.

In the first row, leave the previous month value as NULL. Order the rows by month.

[Showing total revenue for a previous period](https://learnsql.com/course/sql-revenue-trend-analysis/comparing-revenue/calculating-deltas/showing-total-revenue-for-a-previous-period)


LAG(AVG(amount), 1) OVER(ORDER BY EXTRACT(MONTH FROM order_date))

This means: Order all values by the month, take average of order values for each month,
and take the value from the previous month.
