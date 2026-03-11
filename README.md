# From Clicks to Customers: A SQL Analysis of E-Commerce Marketing Performance

Exploratory analysis of a synthetic e-commerce dataset using SQL Server. Covers revenue trends, customer segmentation, marketing channel performance, and RFM scoring across 5,000 orders and 500 customers. Demonstrates core to advanced SQL skills including JOINs, CTEs, window functions, and business metric calculations.

---

## Table of Contents
1. [Project Overview](#project-overview)
2. [Dataset Schema](#dataset-schema)
3. [Business Questions](#business-questions)

---

## Project Overview

**Industry:** E-Commerce / Retail  
**Tools:** SQL Server  
**Skills Demonstrated:** Aggregations, JOINs, CTEs, Window Functions, CASE WHEN, Date Functions, RFM Scoring, Business Metric Calculations

**Objective:** Answer 15 real business questions across three levels of SQL complexity — from basic revenue aggregations to advanced customer segmentation and marketing ROI analysis.

---

## Dataset Schema

### `orders` (5,000 rows — Fact Table)
| Column | Type | Description |
|---|---|---|
| order_id | INT | Unique order identifier (PK) |
| customer_id | INT | Foreign key linking to customers table |
| order_date | DATE | Date the order was placed |
| product_category | VARCHAR | Category of the product ordered |
| quantity | INT | Number of units ordered |
| unit_price | DECIMAL | Price per unit |
| gross_revenue | DECIMAL | Total revenue before discounts |
| discount_pct | INT | Discount percentage applied |
| discount_amount | DECIMAL | Discount value in dollars |
| net_revenue | DECIMAL | Final revenue after discounts |
| shipping_cost | DECIMAL | Shipping charged on the order |
| promo_code | VARCHAR | Promotional code used (if any) |
| marketing_channel | VARCHAR | Channel that drove the order |
| ad_spend | DECIMAL | Ad spend associated with the order |
| device_type | VARCHAR | Device used to place the order |
| payment_method | VARCHAR | Payment method used |
| order_status | VARCHAR | Current status of the order |
| is_first_order | INT | Flag indicating if this is the customer's first order (1 = Yes, 0 = No) |
| session_duration_sec | INT | Session duration in seconds |
| pages_viewed | INT | Number of pages viewed in the session |

### `customers` (500 rows — Dimension Table)
| Column | Type | Description |
|---|---|---|
| customer_id | INT | Unique customer identifier (PK) |
| signup_date | DATE | Date the customer signed up |
| age | INT | Customer age |
| gender | VARCHAR | Customer gender |
| country | VARCHAR | Customer country |
| acquisition_channel | VARCHAR | Channel through which the customer was acquired |
| customer_segment | VARCHAR | Segment the customer belongs to |
| email_domain | VARCHAR | Customer email domain |
| estimated_clv | DECIMAL | Estimated customer lifetime value |
| email_opt_in | INT | Whether the customer opted into email marketing (1 = Yes, 0 = No) |
| push_opt_in | INT | Whether the customer opted into push notifications (1 = Yes, 0 = No) |

> **Note:** 75 customers in the `customers` table have no matching rows in the `orders` table, simulating real-world incomplete data relationships.

---

## Business Questions

### 🟢 Beginner: Q1–Q5
*Demonstrates core SQL fluency — aggregations, grouping, filtering, and CASE WHEN logic*

| # | Question | SQL Concepts |
|---|---|---|
| 1 | Which product categories generate the most revenue? | SUM, AVG, GROUP BY, ORDER BY |
| 2 | What does our monthly revenue trend look like over time? | YEAR, MONTH, DATENAME, GROUP BY |
| 3 | Which marketing channels bring in the most orders? | COUNT, SUM, GROUP BY |
| 4 | How effective are promo codes? | CASE WHEN, AVG, GROUP BY |
| 5 | What is the split between device types, and does it affect order size? | COUNT, AVG, GROUP BY |

---

### 🟡 Intermediate: Q6–Q10
*Demonstrates ability to work across tables and think analytically — JOINs, subqueries, and segmentation*

| # | Question | SQL Concepts |
|---|---|---|
| 6 | Which acquisition channels produce the highest-value customers? | JOIN, CTE, AVG, GROUP BY |
| 7 | Do email opt-in customers spend more? | JOIN, CTE, CASE WHEN, AVG |
| 8 | Which customer segments have the highest return and cancellation rates? | JOIN, WHERE, COUNT, GROUP BY |
| 9 | Which customers have never placed an order? | LEFT JOIN, IS NULL |
| 10 | What is the average time between signup and first order by acquisition channel? | JOIN, CTE, DATEDIFF, MIN, ABS |

---

### 🔴 Advanced: Q11–Q16
*Demonstrates analytical thinking beyond querying — window functions, CTEs, and business metric calculations*

| # | Question | SQL Concepts |
|---|---|---|
| 11 | Who are our top 10% of customers by revenue, and what do they have in common? | CTE, NTILE, Window Functions |
| 12 | What is the month-over-month revenue growth rate? | CTE, LAG, Window Functions |
| 13 | Build a simple RFM score for each customer | CTE, NTILE, DATEDIFF, Window Functions |
| 14 | Which marketing channels have the best ROI? | CTE, SUM, WHERE, Arithmetic |
| 15 | Do paid channels drive higher purchase frequency than organic ones? | CTE, CASE WHEN, AVG, GROUP BY |
| 16 | Which customer segments have a disproportionately high return and cancellation rate? | JOIN, CTE, COUNT, ROUND, Rate Calculation |

---

> Full queries with insights for each question are available in [queries.sql](queries.sql)

