# 🛒 End-to-End E-Commerce Sales Analysis & Customer Segmentation

![SQL](https://img.shields.io/badge/Language-SQL-orange) ![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-blue) ![Status](https://img.shields.io/badge/Status-Complete-green)

## 📖 Project Overview
This project simulates a real-world analytics scenario for a fictional E-Commerce retailer. Using **PostgreSQL**, I analyzed over 1,000 transaction records to solve critical business questions regarding sales trends, customer behavior, and product performance.

The goal was to move beyond basic aggregation and demonstrate advanced SQL capabilities like **Window Functions**, **CTEs**, **Time-Series Analysis**, and **Customer Segmentation**.

---

## 📂 The Dataset
The project operates on a Star Schema consisting of three joined tables:
1.  **`Transactions`**: Order-level data (Order ID, Date, Quantity, Total Value).
2.  **`Customers`**: Demographics (Customer ID, Name, Region, Sign-up Date).
3.  **`Products`**: Inventory details (Product ID, Category, Price).

---

## 🔍 Key Business Problems Solved

### 1. Changes Over Time Analysis (Time-Series)
* **Goal:** Track growth volatility and smooth out daily noise.
* **Techniques:** `LAG()`, `DATE_TRUNC()`, Rolling Averages.
* **Key Insight:** Calculated Month-over-Month (MoM) growth and identified a 29% sales dip in Q4 compared to Q3.

### 2. Cumulative Analysis (Growth Tracking)
* **Goal:** Visualize progress toward monthly and annual targets.
* **Techniques:** Window Sums `SUM() OVER(ORDER BY...)`, Partitioning.
* **Key Insight:** Built a "Running Total" report that resets monthly to track "Burn Rate" performance.

### 3. Performance Ranking (Pareto & Best Sellers)
* **Goal:** Identify the 20% of products driving 80% of revenue.
* **Techniques:** `DENSE_RANK()`, `NTILE()`, Pareto Logic.
* **Key Insight:** Identified the Top 3 "Best Sellers" within each specific category (Books, Electronics, etc.) to optimize inventory stocking.

### 4. Customer Segmentation (RFM Analysis)
* **Goal:** Classify users into actionable marketing buckets (VIP, Churn Risk).
* **Techniques:** `CASE WHEN`, Date Math (`CURRENT_DATE - Last_Order`).
* **Key Insight:** Segmented customers into **VIP**, **Loyal**, and **At-Risk** groups based on spending thresholds and inactivity days (>90 days).

---

## 💻 SQL Techniques Demonstrated
This project showcases the following advanced SQL skills:

* **Window Functions:** `RANK`, `DENSE_RANK`, `ROW_NUMBER`, `LAG`, `LEAD`, `NTILE`.
* **Advanced Aggregation:** Moving Averages (7-day), Running Totals.
* **Date Manipulation:** `DATE_TRUNC`, Interval math for Churn calculation.
* **Complex Logic:** `CASE WHEN` for dynamic segmentation.
* **Optimization:** Using Common Table Expressions (CTEs) for readability and modularity.

---

## 📊 Sample Analysis: Customer 360 Master Report
*Constructing a "Single View" of the customer for the CRM team.*

```sql
WITH Customer_Stats AS (
    SELECT 
        customerid,
        SUM(totalvalue) AS lifetime_value,
        COUNT(transactionid) AS total_orders,
        MAX(transactiondate) AS last_order_date
    FROM transactions
    GROUP BY 1
),
Customer_Fav AS (
    SELECT 
        customerid, category,
        ROW_NUMBER() OVER(PARTITION BY customerid ORDER BY SUM(totalvalue) DESC) AS rnk
    FROM transactions t
    JOIN products p ON t.productid = p.productid
    GROUP BY 1, 2
)
SELECT 
    c.customername,
    cs.lifetime_value,
    CASE 
        WHEN cs.lifetime_value > 5000 THEN 'Platinum'
        WHEN cs.lifetime_value > 2500 THEN 'Gold'
        ELSE 'Silver'
    END AS loyalty_tier,
    cf.category AS favorite_category
FROM Customer_Stats cs
JOIN customers c ON cs.customerid = c.customerid
JOIN Customer_Fav cf ON cs.customerid = cf.customerid
WHERE cf.rnk = 1
ORDER BY cs.lifetime_value DESC;
