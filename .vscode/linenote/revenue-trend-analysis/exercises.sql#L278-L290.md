Show the total revenue for each quarter in each year alongside the delta (revenue change) as compared to the previous quarter. Show the following columns: revenue_year, revenue_quarter, total_revenue, and delta.

In the first row, leave the delta value as NULL. Order the rows by year and quarter.

[Calculating revenue deltas](https://learnsql.com/course/sql-revenue-trend-analysis/comparing-revenue/calculating-deltas/calculating-revenue-deltas)


SUM(amount) - LAG(SUM(amount), 1) OVER (ORDER BY EXTRACT(YEAR FROM order_date), EXTRACT(QUARTER FROM order_date))

This means:
1. Order by the year followed by the quarter of the year,
2. Take the revenues for each quarter of each year,
3. Take the previous quarter's revenue.
4. Finally, find the difference in revenue of the current quarter and the previous quarter.
