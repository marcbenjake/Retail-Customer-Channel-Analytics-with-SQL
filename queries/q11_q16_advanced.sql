**-- 11. Who are our top 10% of customers by revenue, and what do they have in common?**

WITH cte AS (
SELECT
	c.customer_id AS customer_id,
	c.customer_segment AS customer_segment,
	c.acquisition_channel AS acquisition_channel,
	c.country AS country,
	c.estimated_clv AS estimated_clv,
	SUM(o.net_revenue) AS total_spend,
	NTILE(10) OVER (ORDER BY SUM(o.net_revenue) DESC) AS spend_percentile
	FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_segment, c.acquisition_channel, c.country, c.estimated_clv
)
SELECT
	customer_id,
	customer_segment,
	acquisition_channel,
	country,
	estimated_clv,
	total_spend,
	spend_percentile
FROM cte
WHERE spend_percentile = 1
ORDER BY total_spend DESC

**-- 12. What's the month-over-month revenue growth rate?**

WITH cte AS (
SELECT
	YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    SUM(net_revenue) AS monthly_revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT
    year,
    month,
    ROUND(LAG(monthly_revenue) OVER(ORDER BY year, month),2) AS previous_month_revenue,
    ROUND(monthly_revenue - LAG(monthly_revenue) OVER(ORDER BY year, month),2) AS sales_difference,
    ROUND((monthly_revenue - LAG(monthly_revenue) OVER(ORDER BY year, month)) * 100.0 / LAG(monthly_revenue) OVER(ORDER BY year, month),2) AS percent_difference
FROM cte

**-- 13. Build a simple RFM score for each customer Calculate Recency (days since last order), Frequency (order count), and Monetary (total spend) per customer**

WITH cte AS (
SELECT
	customer_id,
	DATEDIFF(day, MAX(order_date), GETDATE()) AS recency,
	COUNT(order_id) AS frequency,
	ROUND(SUM(net_revenue),2) AS monetary
FROM orders
GROUP BY customer_id
),
cte2 AS (
SELECT
	customer_id,
	recency,
	frequency,
	monetary,
	NTILE(5) OVER(ORDER BY recency ASC) as recency_score,
	NTILE(5) OVER(ORDER BY frequency DESC) as frequency_score,
	NTILE(5) OVER(ORDER BY monetary DESC) as monetary_score
FROM cte
)
SELECT
	customer_id, recency, frequency, monetary,
	recency_score, frequency_score, monetary_score,
	(recency_score+frequency_score+monetary_score) AS RFM_score
FROM cte2
ORDER BY rfm_score DESC

**-- 14. Which marketing channels have the best ROI?**

WITH cte AS (
SELECT
	marketing_channel,
	ROUND(SUM(ad_spend),2) as total_ad_spend,
	ROUND(SUM(net_revenue),2) as total_revenue
	FROM orders
WHERE ad_spend > 0
GROUP BY marketing_channel
)
SELECT
	marketing_channel,
	total_ad_spend,
	total_revenue,
	(total_revenue - total_ad_spend) / total_ad_spend * 100.0 AS marketing_ROI
FROM cte
ORDER BY marketing_ROI DESC

**-- 15. Which acquisition channels produce the most frequent buyers, and do paid channels drive higher purchase frequency than organic ones?**

WITH cte1 AS (
SELECT
	c.customer_id as customers,
	c.acquisition_channel AS acquisition_channel,
	COUNT(o.order_id) AS order_count
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.acquisition_channel 
),
cte2 AS (
SELECT
	COUNT(customers) AS total_customers,
	CASE
		WHEN acquisition_channel IN ('Direct', 'Organic Search', 'Referral') THEN 'Organic'
		ELSE 'Paid Media'
		END AS acquisition_channel,
		AVG(order_count) AS average_order_count
FROM cte1
GROUP BY CASE
		WHEN acquisition_channel IN ('Direct', 'Organic Search', 'Referral') THEN 'Organic'
		ELSE 'Paid Media'
		END
)
SELECT
    acquisition_channel,
    total_customers,
    average_order_count
FROM cte2

**-- 16.	Which customer segments have a disproportionately high return and cancellation rate, and where should the business focus its retention efforts?**

WITH cte AS (
SELECT
	COUNT(o.order_id) AS order_count,
	c.customer_segment AS customer_segment
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_segment
)
SELECT
	cte.customer_segment,
	COUNT(o1.order_status) AS cancel_return_orders,
	cte.order_count,
	ROUND(COUNT(o1.order_status) * 100.0 / cte.order_count , 2) AS cancel_return_percent
FROM customers AS c1
JOIN orders AS o1
ON c1.customer_id = o1.customer_id
JOIN cte as cte
ON cte.customer_segment = c1.customer_segment
WHERE o1.order_status IN ('Returned', 'Cancelled')
GROUP BY cte.order_count, cte.customer_segment
