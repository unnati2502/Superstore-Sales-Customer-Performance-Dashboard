# Superstore Sales & Customer Performance Dashboard

An end-to-end data analysis project exploring sales, profit, and customer behavior for a retail superstore — built to practice and showcase SQL, Python, and dashboarding skills on a realistic business dataset.

## Problem Statement
Retail businesses generate huge volumes of order-level data, but raw transactions rarely answer the questions leadership actually cares about: *Which categories are profitable? Which customers are worth retaining? Is the business growing?* This project takes a raw order-level dataset and turns it into a structured analysis and interactive dashboard that answers those questions.

## Tools Used
- **SQL (SQLite)** — data loading, aggregation, window functions, CTEs
- **Python (pandas)** — data cleaning, validation, RFM customer segmentation
- **Tableau** — interactive dashboard for sales trends, geographic breakdown, and customer segments

## Dataset
[Sample Superstore Dataset](https://www.kaggle.com/datasets) — ~10,200 order-level records including sales, profit, discount, customer, product, and geographic fields, covering 2023-2026.

## Approach

### 1. Data Loading & Cleaning (SQL)
- Loaded raw CSV into a SQLite database
- Standardized inconsistent date formats to ISO (`YYYY-MM-DD`) to enable reliable time-based queries
- Verified data quality: row counts, duplicate checks, null checks

### 2. Exploratory & Advanced SQL Analysis
- Aggregate queries: total sales/profit by region, category, and top customers
- **Window functions**: running cumulative sales total over time, year-over-year growth by category using `LAG()`
- **CTEs**: customer spend segmentation (High/Medium/Low value tiers)

Key finding: profit margins vary significantly by category — some sub-categories generate high sales volume but run at a **loss**, indicating a pricing or discounting problem worth investigating further.

### 3. Python: Data Validation & RFM Customer Segmentation
- Validated the dataset in pandas (zero nulls, zero duplicates across 10,194 rows)
- Built an **RFM (Recency, Frequency, Monetary)** model to segment all 800 customers into quartile-based scores, then mapped them to business-friendly labels:

| Segment | Customer Count |
|---|---|
| Regular | 308 |
| Loyal Customers | 209 |
| At Risk | 160 |
| Lost | 92 |
| Champions | 31 |

Key finding: roughly **20% of customers (At Risk + Lost)** haven't ordered recently despite historically being active buyers — a clear target segment for a re-engagement campaign.

### 4. Dashboard
Built an interactive dashboard summarizing:
- KPI overview (total sales and profit)
- Sales & profit trend over time
- Geographic sales breakdown by state
- Profit by category/sub-category (surfacing loss-making segments)
- Customer segment breakdown from the RFM analysis

> **Note:** The dashboard was built in Tableau but exported as a PowerPoint due to a Tableau Public publishing issue. A screenshot is included below for quick viewing.

![Dashboard Screenshot]('Superstore Dashboard Screenshot.png')


## Key Takeaways
- Certain product categories are eroding profit despite strong sales — worth a pricing/discount review
- A meaningful share of the customer base is at risk of churning and could be targeted for retention efforts
- Sales show consistent year-over-year growth across all categories, with Technology and Office Supplies growing fastest in the most recent year

## Future Improvements
- Automate the pipeline with a scheduler (e.g., Airflow) to simulate a production refresh cycle
- Add a basic churn prediction model on top of the RFM segments
- Republish the dashboard to Tableau Public once the publishing issue is resolved
