**6. Which acquisition channels produce the highest-value customers?** 

WITH cte AS (
SELECT
	c.customer_id AS customer_id,
	c.acquisition_channel AS acquisition_channel,
	c.estimated_clv AS estimated_clv,
	SUM(o.net_revenue) AS total_spend_per_customer
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.acquisition_channel, c.estimated_clv
)
SELECT
	acquisition_channel,
	COUNT(customer_id) AS customer_count,
	ROUND(AVG(estimated_clv),2) AS avg_estimated_clv,
	ROUND(AVG(total_spend_per_customer),2) AS total_spend_per_customer
FROM cte
GROUP BY acquisition_channel
ORDER BY total_spend_per_customer DESC

**7. Do email opt-in customers spend more?**

WITH cte AS (
SELECT
	c.customer_id as customer_id,
	c.email_opt_in as email_opt_in_status,
	ROUND(SUM(o.net_revenue),2) AS total_customer_spend 
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.email_opt_in
)
SELECT
	COUNT(customer_id) AS total_customers,
	CASE
		WHEN email_opt_in_status = 1 THEN 'Yes'
		ELSE 'No'
		END AS opt_in_status,
	ROUND(AVG(total_customer_spend),2) AS avg_customer_spend
FROM cte
GROUP BY email_opt_in_status

**8. Which customer segments have the highest return/cancellation rates?**

SELECT
    COUNT(c.customer_id) as customer_count,
    c.customer_segment,
    o.order_status
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
WHERE o.order_status = 'Returned' OR o.order_status = 'Cancelled'
GROUP BY c.customer_segment, o.order_status
ORDER BY customer_count DESC

**9. Which customers haven't placed any orders?**

SELECT
	c.customer_id,
	c.signup_date,
	c.gender,
	c.country,
	c.acquisition_channel,
	c.customer_segment
FROM customers AS c
LEFT JOIN orders AS o
ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL

**10. What's the average time between signup and first order by acquisition channel?**

WITH cte1 AS (
SELECT
	c.customer_id AS customer_id,
	c.acquisition_channel AS acquisition_channel,
	c.signup_date AS signup_date,
	MIN(o.order_date) as first_order_date
	FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.signup_date, c.customer_id, c.acquisition_channel
),
cte2 AS (
SELECT
	customer_id,
	acquisition_channel,
	signup_date,
	first_order_date,
	DATEDIFF(day, signup_date, first_order_date) AS date_difference
FROM cte1
)
SELECT
	cte2.acquisition_channel,
	ABS(AVG(date_difference)) AS avg_days_to_first_order
FROM cte2
GROUP BY cte2.acquisition_channel
