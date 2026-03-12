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


-- ============================================
-- Q6. Which acquisition channels produce the highest-value customers?
-- ============================================
-- Goal: JOIN both tables, group by acquisition channel and compare average estimated CLV and average total spend per customer to identify which channels attract the highest value customers.

WITH cte AS (
    SELECT
        c.customer_id AS customer_id,
        c.acquisition_channel AS acquisition_channel,
        c.estimated_clv AS estimated_clv,
        SUM(o.net_revenue) AS total_spend
    FROM customers AS c
    JOIN orders AS o
    ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.acquisition_channel, c.estimated_clv
)
SELECT
    acquisition_channel,
    COUNT(customer_id) AS customer_count,
    ROUND(AVG(estimated_clv), 2) AS avg_estimated_clv,
    ROUND(AVG(total_spend), 2) AS total_spend_per_customer
FROM cte
GROUP BY acquisition_channel
ORDER BY total_spend_per_customer DESC

-- Social Media acquires the most customers (77) and delivers the highest average spend per customer ($4,525.56), making it the most valuable acquisition channel overall. 
-- Paid Search customers (76) show the highest average estimated CLV ($332.56) despite ranking fourth in total spend, suggesting strong long term potential.
-- Referral has the fewest customers (8) and the lowest average spend ($3,262.46), indicating it is an underdeveloped channel.
-- Display Ad customers show a high avg CLV ($378.14) relative to their spend, suggesting untapped potential if the channel were scaled up.


-- ============================================
-- Q7. Do email opt-in customers spend more?
-- ============================================
-- Goal: Compare average total spend between email opt-in and non-opt-in customers to evaluate the value of email marketing.

WITH cte AS (
    SELECT
        c.customer_id AS customer_id,
        c.email_opt_in AS email_opt_in_status,
        ROUND(SUM(o.net_revenue), 2) AS total_customer_spend
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
    ROUND(AVG(total_customer_spend), 2) AS avg_customer_spend
FROM cte
GROUP BY email_opt_in_status

-- Email opt-in customers (296) spend significantly more on average ($4,424.13) compared to non-opt-in customers (129) who spend $3,968.56, a difference of $455.57 or approximately 11.5% more per customer.
-- This suggests email marketing is positively associated with higher customer value, either by attracting more engaged buyers or by driving repeat purchases through campaigns.
-- Growing the email opt-in base should be a priority for the marketing team.


-- ============================================
-- Q8. Which customer segments have the highest return and cancellation rates?
-- ============================================
-- Goal: Identify which customer segments generate the most returns and cancellations to help the business target retention and quality improvements.

SELECT
    COUNT(c.customer_id) AS customer_count,
    c.customer_segment,
    o.order_status
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
WHERE o.order_status IN ('Returned', 'Cancelled')
GROUP BY c.customer_segment, o.order_status
ORDER BY customer_count DESC

-- New customers account for the highest raw count of both returns (192) and cancellations (172), making them the most problematic segment by volume.
-- This may reflect unmet expectations from first-time buyers unfamiliar with the brand. Occasional customers rank second across both statuses (124 each), suggesting infrequent buyers are less committed to their purchases.
-- At-Risk and Loyalist segments show moderate return and cancellation counts, which is concerning for Loyalists, as these are otherwise high-value customers.
-- High-Value customers show the lowest combined counts (78 + 68), suggesting that higher engagement correlates with lower dissatisfaction.


-- ============================================
-- Q9. Which customers have never placed an order?
-- ============================================
-- Goal: Use a LEFT JOIN to identify customers in the customers table that have no matching records in the orders table.

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

-- 75 customers (15% of the total customer base) have never placed an order.
-- The output spans a mix of acquisition channels, segments, and countries, suggesting no single channel or segment is solely responsible for inactive customers.
-- Notable observations include High-Value and Loyalist segment customers appearing in the list, which warrants further investigation, as these segments are expected to be active buyers.
-- This group represents a potential re-engagement opportunity for the marketing team through targeted win-back campaigns.


-- ============================================
-- Q10. What is the average time between signup and first order by acquisition channel?
-- ============================================
-- Goal: Calculate the average number of days between a customer's signup date and their first order date, grouped by acquisition channel.
-- ABS() is applied as some customers placed a guest order before signing up, which is a valid real-world scenario.

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
	acquisition_channel,
	ABS(AVG(date_difference)) AS avg_days_to_first_order
FROM cte2
GROUP BY cte2.acquisition_channel

-- Affiliate channel has the longest average time to first order (864 days), suggesting customers acquired through affiliates take significantly longer to convert, possibly due to lower purchase intent at acquisition.
-- Direct channel customers convert faster (578 days) indicating higher intent from customers who seek out the brand directly.
-- Display Ad (525 days) surprisingly shows the fastest conversion despite being a passive channel, which may reflect impulse purchase behavior.
-- All channels show relatively long conversion windows (525-864 days) which may reflect the synthetic nature of the dataset spanning 4 years.


-- ============================================
-- Q11. Who are our top 10% of customers by revenue?
-- ============================================
-- Goal: Use NTILE(10) to bucket customers by total spend and profile the top 10% by segment, acquisition channel and country to identify shared characteristics of the highest value customers.

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
    GROUP BY c.customer_id, c.customer_segment, c.acquisition_channel,
             c.country, c.estimated_clv
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

-- The top 10% of customers by revenue show a diverse mix of segments and channels with no single dominant profile, suggesting high-value customers are acquired across multiple touchpoints.
-- USA customers appear most frequently, reflecting the dataset's geographic distribution.
-- Organic Search and Social Media are the most represented acquisition channels in the top tier.
-- Churned customers appearing in the top 10% is a significant finding; these are high-value customers the business has already lost and should be priority targets for win-back campaigns.


-- ============================================
-- Q12. What is the month-over-month revenue growth rate?
-- ============================================
-- Goal: Use LAG() to compare each month's revenue to the prior month and calculate the percentage change to identify growth trends.
-- NULL in row 1 is expected as there is no prior month to compare against.

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
    ROUND(LAG(monthly_revenue) OVER(ORDER BY year, month), 2) AS previous_month_revenue,
    ROUND(monthly_revenue - LAG(monthly_revenue) OVER(ORDER BY year, month), 2) AS sales_difference,
    ROUND((monthly_revenue - LAG(monthly_revenue) OVER(ORDER BY year, month))
        * 100.0 / LAG(monthly_revenue) OVER(ORDER BY year, month), 2) AS percent_difference
FROM cte

-- Revenue growth is highly volatile month-over-month with swings ranging from -42.7% (September 2024) to +90.8% (January 2022).
-- No consistent upward or downward trend is visible across the 4 year period, suggesting revenue is driven by unpredictable demand rather than seasonal or structural growth patterns.
-- The largest positive jump occurs in January 2022 (+90.8%) following December 2021's sharp decline (-36.96%), indicating a post-holiday recovery effect.
-- The high volatility across all years is consistent with the synthetic nature of the dataset where orders were distributed randomly across months.


-- ============================================
-- Q13. Build a simple RFM score for each customer
-- ============================================
-- Goal: Calculate Recency (days since last order), Frequency (order count), and Monetary (total spend) per customer, score each on a 1-5 scale using NTILE(5), and combine into a single RFM score.
-- Higher RFM score = more valuable customer.

WITH cte AS (
    SELECT
        customer_id,
        DATEDIFF(day, MAX(order_date), GETDATE()) AS recency,
        COUNT(order_id) AS frequency,
        ROUND(SUM(net_revenue), 2) AS monetary
    FROM orders
    GROUP BY customer_id
),
cte2 AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency ASC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency DESC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary DESC) AS monetary_score
    FROM cte
)
SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    (recency_score + frequency_score + monetary_score) AS RFM_score
FROM cte2
ORDER BY RFM_score DESC

-- The highest RFM score achievable is 15, with the top customers scoring a perfect 15 across all three dimensions: recent purchasers, high frequency buyers, and high spenders simultaneously.
-- Recency scores of 5 dominate the top of the list, confirming that recent purchase behavior is a strong indicator of overall customer value.
-- Customers scoring 12-15 are prime candidates for loyalty rewards, while those scoring below 6 may require win-back campaigns or can be deprioritized for high-cost marketing spend.


-- ============================================
-- Q14. Which marketing channels have the best ROI?
-- ============================================
-- Goal: Compare total ad spend vs total revenue for paid channels only and calculate a return ratio to identify the most efficient channels.
-- Organic channels are excluded as direct costs are not captured in this dataset and would result in a divide by zero error.

WITH cte AS (
    SELECT
        marketing_channel,
        ROUND(SUM(ad_spend), 2) AS total_ad_spend,
        ROUND(SUM(net_revenue), 2) AS total_revenue
    FROM orders
    WHERE ad_spend > 0
    GROUP BY marketing_channel
)
SELECT
    marketing_channel,
    total_ad_spend,
    total_revenue,
    ROUND((total_revenue - total_ad_spend) * 100.0 / total_ad_spend, 2) AS marketing_ROI
FROM cte
ORDER BY marketing_ROI DESC

-- All three paid channels deliver exceptionally high ROI, returning roughly 2,600-3,000x their ad spend in revenue.
-- Paid Search leads with the highest ROI (3,021x) on $11,605 in spend, generating $362,329 in revenue, making it the most efficient paid channel.
-- Social Media follows closely (2,803x) with the highest absolute ad spend ($12,843) and revenue ($372,881).
-- Display Ad has the lowest ROI (2,596x) and the smallest spend ($3,245), suggesting it is underinvested relative to its potential.
-- Note: The extremely high ROI values across all channels are consistent with the synthetic nature of the dataset, where ad spend values were kept small relative to revenue.


-- ============================================
-- Q15. Do paid channels drive higher purchase frequency than organic ones?
-- ============================================
-- Goal: Compare average order frequency between paid and organic acquisition channels to identify which channel type produces more frequent buyers.
-- Organic channels: Direct, Organic Search, Referral
-- Paid channels: Social Media, Email, Paid Search, Affiliate, Display Ad

WITH cte1 AS (
    SELECT
        c.customer_id AS customer_id,
        c.acquisition_channel AS acquisition_channel,
        COUNT(o.order_id) AS order_count
    FROM customers AS c
    JOIN orders AS o
    ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.acquisition_channel
),
cte2 AS (
    SELECT
        COUNT(customer_id) AS total_customers,
        CASE
            WHEN acquisition_channel IN ('Direct', 'Organic Search', 'Referral')
                THEN 'Organic'
            ELSE 'Paid Media'
        END AS acquisition_channel,
        ROUND(AVG(order_count), 2) AS average_order_count
    FROM cte1
    GROUP BY
        CASE
            WHEN acquisition_channel IN ('Direct', 'Organic Search', 'Referral')
                THEN 'Organic'
            ELSE 'Paid Media'
        END
)
SELECT
    acquisition_channel,
    total_customers,
    average_order_count
FROM cte2

-- Both paid (257 customers) and organic (168 customers) channels produce an identical average order frequency of 11 orders per customer.
-- This suggests that the acquisition channel does not influence purchase frequency in this dataset.
-- The finding is likely attributable to the synthetic nature of the dataset where orders were distributed randomly across customers regardless of their acquisition channel.


-- ============================================
-- Q16. Which customer segments have a disproportionately high return and cancellation rate, and where should the business focus its retention efforts?
-- ============================================
-- Goal: Calculate return and cancellation rates per customer segment by comparing cancelled/returned orders against total orders to give a fairer picture than raw counts alone.

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
    ROUND(COUNT(o1.order_status) * 100.0 / CAST(cte.order_count AS FLOAT), 2) AS cancel_return_percent
FROM customers AS c1
JOIN orders AS o1
ON c1.customer_id = o1.customer_id
JOIN cte
ON cte.customer_segment = c1.customer_segment
WHERE o1.order_status IN ('Returned', 'Cancelled')
GROUP BY cte.customer_segment, cte.order_count
ORDER BY cancel_return_percent DESC

-- Occasional customers have the highest return and cancellation rate (27.19%) despite not having the highest raw count, making them the most disproportionately dissatisfied segment.
-- New customers follow closely at 25.28%, confirming that first-time buyers have higher dissatisfaction levels, possibly due to unmet expectations.
-- At-Risk customers show the lowest rate (21.91%), suggesting their at-risk status may be driven by other factors such as inactivity rather than poor purchase experience.
-- Loyalist (25.95%) and High-Value (25.75%) segments showing rates above 25% is a concern; these are the business's most valuable customers and their dissatisfaction should be investigated and addressed as a priority.
