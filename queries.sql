-- ============================================
-- Q1. Which product categories generate the most revenue?
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
