/* ============================================================
   Superstore Sales Analysis - SQL Queries
   Database: SQLite (superstore.db)
   ============================================================ */


-- Confirm row count
SELECT COUNT(*) FROM orders;

-- Confirm column names and types
PRAGMA table_info(orders);

-- Confirm date formatting is consistent (should return a single length, e.g. 10)
SELECT "Order Date", LENGTH("Order Date") AS len
FROM orders
GROUP BY len;

-- Confirm chronological range of the dataset
SELECT "Order Date" FROM orders ORDER BY "Order Date" ASC LIMIT 3;
SELECT "Order Date" FROM orders ORDER BY "Order Date" DESC LIMIT 3;


/* ------------------------------------------------------------
   2. EXPLORATORY ANALYSIS
------------------------------------------------------------ */

-- Total sales and profit by region
SELECT Region,
       ROUND(SUM(Sales), 2) AS total_sales,
       ROUND(SUM(Profit), 2) AS total_profit
FROM orders
GROUP BY Region
ORDER BY total_sales DESC;

-- Top 10 customers by revenue
SELECT "Customer Name",
       ROUND(SUM(Sales), 2) AS total_sales
FROM orders
GROUP BY "Customer Name"
ORDER BY total_sales DESC
LIMIT 10;

-- Profit margin by category
-- (Surfaces categories that generate high sales volume but run at a loss)
SELECT Category,
       ROUND(SUM(Sales), 2) AS total_sales,
       ROUND(SUM(Profit), 2) AS total_profit,
       ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin_pct
FROM orders
GROUP BY Category
ORDER BY profit_margin_pct ASC;


/* ------------------------------------------------------------
   3. ADVANCED ANALYSIS - WINDOW FUNCTIONS & CTEs
------------------------------------------------------------ */

-- 3a. Running total of sales over time (window function)
SELECT
    "Order Date",
    SUM(Sales) AS daily_sales,
    SUM(SUM(Sales)) OVER (ORDER BY "Order Date") AS running_total_sales
FROM orders
GROUP BY "Order Date"
ORDER BY "Order Date";


-- 3b. Customer segmentation by total spend (CTE)
WITH customer_totals AS (
    SELECT
        "Customer Name",
        SUM(Sales) AS total_spend
    FROM orders
    GROUP BY "Customer Name"
)
SELECT
    "Customer Name",
    total_spend,
    CASE
        WHEN total_spend >= 5000 THEN 'High Value'
        WHEN total_spend >= 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_totals
ORDER BY total_spend DESC;

-- Helper query used to decide the thresholds above
SELECT MIN(total_spend), MAX(total_spend), AVG(total_spend)
FROM (
    SELECT "Customer Name", SUM(Sales) AS total_spend
    FROM orders
    GROUP BY "Customer Name"
);


-- 3c. Year-over-year growth by category (CTE + LAG window function)
WITH yearly_sales AS (
    SELECT
        Category,
        substr("Order Date", 1, 4) AS order_year,
        SUM(Sales) AS total_sales
    FROM orders
    GROUP BY Category, order_year
)
SELECT
    Category,
    order_year,
    total_sales,
    LAG(total_sales) OVER (PARTITION BY Category ORDER BY order_year) AS prev_year_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (PARTITION BY Category ORDER BY order_year))
        / LAG(total_sales) OVER (PARTITION BY Category ORDER BY order_year) * 100, 2
    ) AS yoy_growth_pct
FROM yearly_sales
ORDER BY Category, order_year;

/* Key finding: All three categories (Furniture, Office Supplies, Technology)
   show consistent year-over-year growth from 2023-2026, with Office Supplies
   and Technology growing fastest in the most recent year (36.2% and 20.23%
   respectively). */
