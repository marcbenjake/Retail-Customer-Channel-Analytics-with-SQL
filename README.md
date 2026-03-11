# From Clicks to Customers: A SQL Analysis of E-Commerce Marketing Performance

Exploratory analysis of a synthetic e-commerce dataset using SQL Server. Covers revenue trends, customer segmentation, marketing channel performance, and RFM scoring across 5,000 orders and 500 customers. Demonstrates core to advanced SQL skills including JOINs, CTEs, window functions, and business metric calculations.

---

## Table of Contents
1. [Project Overview](#project-overview)
2. [Dataset Schema](#dataset-schema)
3. [Business Questions](#business-questions)
   - [Beginner: Q1–Q5](#beginner-q1q5)
   - [Intermediate: Q6–Q10](#intermediate-q6q10)
   - [Advanced: Q11–Q15](#advanced-q11q15)

---

## Project Overview

**Industry:** E-Commerce / Retail  
**Tools:** SQL Server, Excel (for output screenshots)  
**Skills Demonstrated:** Aggregations, JOINs, CTEs, Window Functions, CASE WHEN, Date Functions, RFM Scoring, Business Metric Calculations

**Objective:** Answer 15 real business questions across three levels of SQL complexity — from basic revenue aggregations to advanced customer segmentation and marketing ROI analysis.

---

## Dataset Schema

### `orders` (5,000 rows — Fact Table)
| Column | Description |
|---|---|
| order_id | Unique order identifier (PK) |
| customer_id | Foreign key linking to customers table |
| order_date | Date the order was placed |
| product_category | Category of the product ordered |
| quantity | Number of units ordered |
| unit_price | Price per unit |
| gross_revenue | Total before discounts |
| discount_pct | Discount percentage applied |
| discount_amount | Discount value in dollars |
| net_revenue | Final revenue after discounts |
| shipping_cost | Shipping charged on the order |
| promo_code | Promotional code used (if any) |
| marketing_channel | Channel that drove the order |
| ad_spend | Ad spend associated with the order |
| device_type | Device used to place the order |
| payment_method | Payment method used |
| order_status | Current status of the order |
| is_first_order | Flag indicating if this is the customer's first order |
| session_duration_sec | Session duration in seconds |
| pages_viewed | Number of pages viewed in the session |

### `customers` (500 rows — Dimension Table)
| Column | Description |
|---|---|
| customer_id | Unique customer identifier (PK) |
| signup_date | Date the customer signed up |
| age | Customer age |
| gender | Customer gender |
| country | Customer country |
| acquisition_channel | Channel through which the customer was acquired |
| customer_segment | Segment the customer belongs to |
| email_domain | Customer email domain |
| estimated_clv | Estimated customer lifetime value |
| email_opt_in | Whether the customer opted into email marketing |
| push_opt_in | Whether the customer opted into push notifications |

> **Note:** 75 customers in the `customers` table have no matching rows in the `orders` table, simulating real-world incomplete data relationships.

---

## Business Questions

---

### 🟢 Beginner: Q1–Q5
*Demonstrates core SQL fluency — filtering, aggregation, grouping, and CASE WHEN logic*

---

#### Q1. Which product categories generate the most revenue?
**Goal:** Rank categories by total net revenue and compare average order values to identify top performing categories.

```sql
SELECT
    product_category,
    ROUND(SUM(net_revenue), 2) AS total_revenue,
    ROUND(AVG(net_revenue), 2) AS avg_order_value
FROM orders
GROUP BY product_category
ORDER BY total_revenue DESC
```

📸 *[Screenshot: q1_category_revenue.png]*

**Key Findings:**
- Electronics leads all categories with **$982,839 in total revenue**, nearly 4x the lowest performing category, driven by a high average order value of **$1,118**
- Apparel ranks second in revenue (**$241,455**) but has a significantly lower AOV of **$228**, suggesting high order volume compensates for lower ticket sizes
- Toys and Books sit at the bottom of both revenue and AOV, indicating either low demand or low price points in this customer base
- Home & Garden and Sports show mid-tier revenue with relatively healthy AOVs of **$347** and **$314** respectively, suggesting fewer but higher value purchases

**Business Interpretation:** Electronics is the clear revenue driver, but its high AOV means promotions targeting this category could significantly move the needle. Apparel's volume-driven performance suggests it may benefit more from loyalty or repeat purchase strategies.

---

*Q2–Q15 findings to be added progressively*

