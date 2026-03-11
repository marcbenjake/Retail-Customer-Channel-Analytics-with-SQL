-- ============================================
-- Q1. Which product categories generate the most revenue?
-- ============================================
-- Goal: Rank categories by total net revenue and compare average order values to identify top-performing categories.

SELECT
    product_category,
    ROUND(SUM(net_revenue), 2) AS total_revenue,
    ROUND(AVG(net_revenue), 2) AS avg_order_value
FROM orders
GROUP BY product_category
ORDER BY total_revenue DESC

-- Electronics leads all categories with $982,839 in total revenue, nearly 4x the lowest performing category, driven by a high AOV of $1,118.
-- Apparel ranks second ($241,455) through volume despite a lower AOV of $228.
-- Toys and Books sit at the bottom of both revenue and AOV.
-- Electronics promotions could significantly move the needle given its high ticket size.


-- ============================================
-- Q2. What does our monthly revenue trend look like over time?
-- ============================================
-- Goal: Aggregate net revenue by month and year to identify seasonality or growth patterns over time.

SELECT
    YEAR(order_date) AS year,
    DATENAME(MONTH, order_date) AS month_name,
    ROUND(SUM(net_revenue), 2) AS monthly_revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date), DATENAME(MONTH, order_date)
ORDER BY year, MONTH(order_date)

-- Revenue shows no strong consistent seasonality across 2021-2024.
-- 2021 peaked in September ($39,658) before dropping sharply in December ($22,002), suggesting a post-summer slowdown.
-- 2024 shows a strong November ($49,721), indicating a possible holiday uplift.
-- Monthly revenue generally fluctuates between $22,000 and $59,000 across all years, with no single dominant month consistently outperforming others, typical of a broad product catalogue without heavy seasonal dependency.


-- ============================================
-- Q3. Which marketing channels bring in the most orders?
-- ============================================
-- Goal: Count orders and sum revenue by marketing channel to identify the most effective channels for driving both volume and revenue.

SELECT
    marketing_channel,
    COUNT(*) AS order_count,
    ROUND(SUM(net_revenue), 2) AS total_revenue
FROM orders
GROUP BY marketing_channel
ORDER BY order_count DESC

-- Organic Search dominates both order count (1,110) and total revenue ($398,592), making it the single most valuable channel by far.
-- Social Media ranks second in orders (1,028), but its revenue ($373,021) is closer to Organic Search, suggesting similar average order values.
-- Paid Search drives fewer orders (937) but generates strong revenue ($362,359), hinting at higher intent buyers.
-- Referral sits at the bottom with only 155 orders ($37,176), indicating an underdeveloped channel worth investigating.
-- Notably, the top 3 channels account for over 60% of all orders.


-- ============================================
-- Q4. How effective are promo codes?
-- ============================================
-- Goal: Compare average net revenue, discount amount, and order quantity between orders that used a promo code vs those that didn't.

SELECT
    CASE
        WHEN promo_code IS NULL OR promo_code = '' THEN 'No Promo'
        ELSE 'Promo Used'
    END AS promo_code_status,
    ROUND(AVG(net_revenue), 2) AS avg_net_revenue,
    ROUND(AVG(discount_amount), 2) AS avg_discount_amount,
    ROUND(AVG(quantity), 2) AS avg_order_quantity
FROM orders
GROUP BY
    CASE
        WHEN promo_code IS NULL OR promo_code = '' THEN 'No Promo'
        ELSE 'Promo Used'
    END

-- Orders with promo codes generate slightly higher average net revenue ($372.46) compared to non-promo orders ($356.33), suggesting promo codes attract higher value purchases rather than just discounting existing ones.
-- Average discount amounts are nearly identical ($28.80 vs $28.40), indicating promo codes don't significantly deepen discounting.
-- Order quantity is the same across both groups at 1, suggesting promos don't drive bulk purchasing behavior.
-- Overall, promo codes appear to attract higher spending customers rather than simply cannibalizing margin.


-- ============================================
-- Q5. What is the split between device types and does it affect order size?
-- ============================================
-- Goal: Group by device type and compare order count, average order size, average net revenue and pages viewed to identify behavioral differences.

SELECT
    device_type,
    COUNT(*) AS device_orders,
    ROUND(AVG(quantity), 2) AS avg_order_size,
    ROUND(AVG(net_revenue), 2) AS avg_net_revenue,
    ROUND(AVG(pages_viewed), 2) AS avg_page_views
FROM orders
GROUP BY device_type
ORDER BY device_orders DESC

-- Mobile dominates order volume with 2,680 orders (53% of all orders), confirming a mobile-first customer base.
-- However Mobile's average net revenue ($374.69) is the highest across all devices, challenging the assumption that mobile users spend less.
-- Desktop accounts for 1,942 orders with a slightly lower AOV of $358.12.
-- Tablet has the lowest order volume (378) and the lowest AOV ($322.32).
-- Pages viewed is consistent across all three devices at 11-12, suggesting browsing behavior is not significantly influenced by device type.
-- The high mobile order volume and AOV suggests the storefront is well optimized for mobile commerce.
