**1. Which product categories generate the most revenue?**

SELECT
	product_category,
	ROUND(SUM(net_revenue),2) AS total_revenue,
	ROUND(AVG(net_revenue),2) AS avg_order_value
FROM orders
GROUP BY product_category
ORDER BY total_revenue DESC

**2. What does our monthly revenue trend look like over time?**

SELECT
    YEAR(order_date) AS year,
    DATENAME(MONTH, order_date) AS month_name,
    ROUND(SUM(net_revenue), 2) AS monthly_revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date), DATENAME(MONTH, order_date)
ORDER BY year, MONTH(order_date)

**3. Which marketing channels bring in the most orders?**

SELECT
	marketing_channel,
	COUNT(*) AS order_count,
	ROUND(SUM(net_revenue),2) AS total_revenue
FROM orders
GROUP BY marketing_channel
ORDER BY order_count DESC, total_revenue

**4. How effective are promo codes?**

SELECT
	CASE
		WHEN promo_code IS NULL OR promo_code = '' THEN 'No Promo'
		ELSE 'Promo Used'
	END AS promo_code_status,
	ROUND(AVG(net_revenue),2) AS avg_net_revenue,
    ROUND(AVG(discount_amount),2) AS avg_discount_amount,
    ROUND(AVG(quantity),2) AS avg_order_quantity
FROM orders
GROUP BY 
	CASE
		WHEN promo_code IS NULL OR promo_code = '' THEN 'No Promo'
		ELSE 'Promo Used'
	END

**5. What's the split between device types, and does it affect order size?**

SELECT
	device_type,
	COUNT(device_type) AS device_users,
	ROUND(AVG(quantity),2) AS avg_order_size,
	ROUND(AVG(net_revenue),2) AS avg_net_revenue,
	ROUND(AVG(pages_viewed),2) AS avg_page_views
FROM orders
GROUP BY device_type
