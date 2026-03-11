-- ============================================
-- **Q1. Which product categories generate the most revenue?**
-- ============================================
-- Goal: Rank categories by total net revenue and compare average
-- order values to identify top performing categories.

SELECT
    product_category,
    ROUND(SUM(net_revenue), 2) AS total_revenue,
    ROUND(AVG(net_revenue), 2) AS avg_order_value
FROM orders
GROUP BY product_category
ORDER BY total_revenue DESC

-- Insight: Electronics leads all categories with $982,839 in total revenue,
-- nearly 4x the lowest performing category, driven by a high AOV of $1,118.
-- Apparel ranks second ($241,455) through volume despite a lower AOV of $228.
-- Toys and Books sit at the bottom of both revenue and AOV.
-- Electronics promotions could significantly move the needle given its high ticket size.


-- ============================================
-- Q2. What does our monthly revenue trend look like over time?
-- ============================================
-- Goal: Aggregate net revenue by month and year to identify
-- seasonality or growth patterns over time.

SELECT
    YEAR(order_date) AS year,
    DATENAME(MONTH, order_date) AS month_name,
    ROUND(SUM(net_revenue), 2) AS monthly_revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date), DATENAME(MONTH, order_date)
ORDER BY year, MONTH(order_date)

-- Insight: Revenue shows no strong consistent seasonality across 2021-2024.
-- 2021 peaked in September ($39,658) before dropping sharply in December ($22,002),
-- suggesting a post-summer slowdown. 2024 shows a strong November ($49,721)
-- indicating a possible holiday uplift. Monthly revenue generally fluctuates
-- between $22,000 and $59,000 across all years with no single dominant month
-- consistently outperforming others -- typical of a broad product catalog
-- without heavy seasonal dependency.


