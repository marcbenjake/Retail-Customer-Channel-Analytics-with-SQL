-- ============================================
-- Q1. Which product categories generate the most revenue?
-- ============================================

SELECT
    product_category,
    ROUND(SUM(net_revenue), 2) AS total_revenue,
    ROUND(AVG(net_revenue), 2) AS avg_order_value
FROM orders
GROUP BY product_category
ORDER BY total_revenue DESC

-- Insight: Electronics leads with $982,839 in revenue driven by
-- a high AOV of $1,118. Apparel ranks second through volume.
