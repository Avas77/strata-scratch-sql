-- http://platform.stratascratch.com/coding/10314-revenue-over-time?code_type=1

-- Solution:
-- Remove negative purchase_amt
-- Group by date

WITH month_revenue AS (SELECT
    TO_CHAR(created_at, 'YYYY-MM') AS date,
    SUM(purchase_amt) AS revenue
FROM amazon_purchases
WHERE purchase_amt > 0
GROUP BY date)

-- Calculate 3-month rolling average using avg aggregate function with 
-- windowing clause order by date and rows between 2 preceding and current row

SELECT
    date,
    AVG(revenue) OVER (
        ORDER BY date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS roll_avg
FROM month_revenue;