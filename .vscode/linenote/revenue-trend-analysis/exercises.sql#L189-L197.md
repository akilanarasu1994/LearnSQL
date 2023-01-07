We can also use EXTRACT() to get quarterly info, which is frequently used in financial analyses. The statement below ...

EXTRACT(quarter FROM date) = 1
... signifies the period from January through March. The following statement:

EXTRACT(quarter FROM date) = 2
... signifies the period from April through June. And so on for the other two quarters.

Show the total revenue from each quarter of 2017. Show two columns: quarter_in_2017 and total_revenue.

Order the rows by quarter.

[Showing total revenue for each month and quarter](https://learnsql.com/course/sql-revenue-trend-analysis/comparing-revenue/multiple-periods/showing-total-revenue-for-each-month-and-quarter)
