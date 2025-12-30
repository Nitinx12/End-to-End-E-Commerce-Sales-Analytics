--- Changes Over Time Analysis

WITH base_txn AS (
	SELECT
		transactiondate,
		totalvalue
	FROM transactions
),
Months AS (
	SELECT
		TO_CHAR(transactiondate, 'YYYY-MM') AS order_month,
		SUM(totalvalue) AS current_sales
	FROM base_txn
	GROUP BY 1
)
	SELECT
		order_month,
		current_sales,
		COALESCE(previous_month_sales, 0) AS previous_month_sales,
		CASE
			WHEN previous_month_sales IS NULL THEN 0
			ELSE ROUND((current_sales - previous_month_sales) / previous_month_sales * 100,2)
		END AS growth_percentage
	FROM(SELECT
			order_month,
			current_sales,
			LAG(current_sales) OVER(ORDER BY order_month) AS previous_month_sales
		FROM Months) AS X
-- -------------------------------------------------------------------------------------------------------

WITH RECURSIVE calander AS (
	SELECT
		MIN(transactiondate) AS start_date
	FROM transactions

	UNION ALL

	SELECT
		(start_date + INTERVAL '1 DAY') :: DATE
	FROM calander
	WHERE start_date < (SELECT MAX(transactiondate) FROM transactions)
),
Daily_revenue AS (
	SELECT
		X.start_date AS transactiondate,
		COALESCE(SUM(T.totalvalue),0) AS Daily_sales
	FROM calander AS X
	LEFT JOIN transactions AS T ON
	X.start_date = T.transactiondate
	GROUP BY 1
)
	SELECT
		transactiondate,
		Daily_sales,
		ROUND(AVG(Daily_sales)
			OVER(ORDER BY transactiondate ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) AS moving_7_day_avg
	FROM Daily_revenue

-- -------------------------------------------------------------------------------------------------------

WITH Quarterly_sales AS (
	SELECT
		P.category,
		EXTRACT(YEAR FROM transactiondate) AS sales_year,
		EXTRACT(QUARTER FROM transactiondate) AS sales_quarter,
		SUM(T.totalvalue) AS total_sales
	FROM transactions AS T
	INNER JOIN products AS P USING(productid)
	WHERE EXTRACT(YEAR FROM T.transactiondate) = 2024
	GROUP BY 1, 2, 3
)
	SELECT
		category,
		sales_year,
		sales_quarter,
		total_sales,
		COALESCE(prev_quarter_sales, 0) AS prev_quarter_sales,
	CASE
		WHEN prev_quarter_sales IS NULL THEN 0
		ELSE ROUND((total_sales - prev_quarter_sales) / prev_quarter_sales * 100,2)
	END AS qoq_growth_percentage
	FROM(SELECT
			category,
			sales_year,
			sales_quarter,
			total_sales,
			LAG(total_sales) 
				OVER(PARTITION BY category ORDER BY sales_year, sales_quarter) AS prev_quarter_sales
		FROM Quarterly_sales) AS X

-- -------------------------------------------------------------------------------------------------------

-- Cumulative Analysis

WITH customer_spend AS (
    SELECT
        C.customername,
        SUM(T.totalvalue) AS total_spend
    FROM customers AS C
    INNER JOIN transactions AS T USING (customerid)
    GROUP BY C.customername
),
ranked_spend AS (
    SELECT
        customername,
        total_spend,
        SUM(total_spend) OVER (ORDER BY total_spend DESC) AS cumulative_spend,
        SUM(total_spend) OVER () AS grand_total_spend
    FROM customer_spend
)
SELECT
    customername,
    total_spend,
    cumulative_spend,
    ROUND(cumulative_spend * 100.0 / grand_total_spend, 2) AS cumulative_spend_percent,
	'Top_spender' AS Tier
FROM ranked_spend
WHERE ROUND(cumulative_spend * 100.0 / grand_total_spend, 2) <= 80.00
ORDER BY total_spend DESC

-- -------------------------------------------------------------------------------------------------------

SELECT
	C.region,
	DATE(T.transactiondate) AS transactiondate,
	SUM(T.totalvalue) AS daily_region_sales,
	SUM(SUM(T.totalvalue))
		OVER(PARTITION BY C.region ORDER BY DATE(T.transactiondate)) AS region_running_total
FROM customers AS C
INNER JOIN transactions AS T USING(customerid)
GROUP BY 1, 2

-- -------------------------------------------------------------------------------------------------------

WITH Product_sales AS (
	SELECT
		P.productname,
		P.category,
		SUM(T.totalvalue) AS total_revenue
	FROM transactions AS T
	INNER JOIN products AS P USING(productid)
	GROUP BY 1, 2
)
	SELECT
		productname,
		category,
		total_revenue,
		running_total_revenue,
		ROUND(running_total_revenue / category_total_revenue * 100,2) AS  cumulative_revenue_percent
	FROM(SELECT
			productname,
			category,
			total_revenue,
			SUM(total_revenue)
				OVER(PARTITION BY category ORDER BY total_revenue DESC) AS running_total_revenue,
			SUM(total_revenue)
				OVER(PARTITION BY category) AS category_total_revenue
		FROM Product_sales) AS X
		
-- ------------------------------------------------------------------------------------------------------

-- Performance Analysis

SELECT
	category,
	productname,
	total_revenue,
	rnk
FROM(SELECT
		P.category,
		P.productname,
		SUM(T.totalvalue) AS total_revenue,
		DENSE_RANK() OVER(PARTITION BY P.category ORDER BY SUM(T.totalvalue) DESC) AS rnk
	FROM products AS P
	INNER JOIN transactions AS T USING(productid)
	GROUP BY 1, 2) AS X
WHERE X.rnk <= 3

-- ------------------------------------------------------------------------------------------------------

WITH Customer_Spend AS (
    SELECT 
        c.customername,
        SUM(t.totalvalue) AS total_spend
    FROM Transactions t
    JOIN Customers c ON t.customerid = c.customerid
    GROUP BY c.customername
)
SELECT 
    customername,
    total_spend,
    NTILE(5) OVER (ORDER BY total_spend DESC) AS spend_quintile
FROM Customer_Spend
ORDER BY spend_quintile, total_spend DESC;

-- ------------------------------------------------------------------------------------------------------

WITH product_stats AS (
	SELECT
		P.category,
		P.productname,
		SUM(T.totalvalue) AS product_revenue
	FROM transactions AS T
	INNER JOIN products AS P USING(productid)
	GROUP BY 1, 2
)
	SELECT
		category,
		productname,
		product_revenue,
		ROUND(AVG(product_revenue)
			OVER(PARTITION BY category),2) AS avg_category_revenue,
		product_revenue - ROUND(AVG(product_revenue)
			OVER(PARTITION BY category),2) AS diff_from_avg,
		CASE
			WHEN product_revenue > ROUND(AVG(product_revenue) OVER(PARTITION BY category),2)
			THEN 'Above Average'
			ELSE 'Below Average'
		END AS performance_status
	FROM product_stats

-- ------------------------------------------------------------------------------------------------------
-- Data Segmentation

WITH customer_totals AS (
	SELECT
		customerid,
		SUM(totalvalue) AS total_spend
	FROM transactions
	GROUP BY 1
)
	SELECT
		CASE
			WHEN total_spend > 5000 THEN 'Vip'
			WHEN total_spend BETWEEN 3000 AND 5000 THEN 'High Spender'
			ELSE 'Regular'
		END AS customer_segment,
		COUNT(customerid) AS customer_count,
		ROUND(AVG(total_spend),2) AS avg_segment_spend
	FROM customer_totals
	GROUP BY 1
	ORDER BY 1 ASC

-- ------------------------------------------------------------------------------------------------------

SELECT 
    CASE 
        WHEN p.price > 300 THEN 'Premium'
        WHEN p.price BETWEEN 100 AND 300 THEN 'Mid-Range'
        ELSE 'Budget'
    END AS price_tier,
    SUM(t.totalvalue) AS total_revenue,
    ROUND(AVG(t.quantity), 2) AS avg_quantity_per_order
FROM Transactions t
JOIN Products p ON t.productid = p.productid
GROUP BY 1
ORDER BY total_revenue DESC;

-- ------------------------------------------------------------------------------------------------------

WITH Last_date AS (
	SELECT
		MAX(transactiondate) AS last_date
	FROM transactions
),
Customer_Last_Order AS (
	SELECT
		C.customername,
		MAX(T.transactiondate) AS last_order_date,
		SUM(T.totalvalue) AS total_spend
	FROM transactions AS T 
	INNER JOIN customers AS C USING(customerid)
	GROUP BY 1
)
	SELECT
		CL.customername,
		CL.last_order_date,
		CL.total_spend,
		LD.last_date - Cl.last_order_date AS days_inactive,
	CASE
		WHEN LD.last_date - Cl.last_order_date > 180 THEN 'Churned'
		WHEN LD.last_date - Cl.last_order_date > 90 THEN 'At Risk'
		ELSE 'Active'
	END AS status
	FROM Customer_Last_Order AS CL
	CROSS JOIN Last_date AS LD
	WHERE total_spend > 2500
	ORDER BY 1, 2 

-- ------------------------------------------------------------------------------------------------------

-- Report Bulider

WITH Customer_totals AS (
	SELECT
		C.customerid,
		C.customername,
		SUM(T.totalvalue) AS total_spend,
		MAX(DATE(T.transactiondate)) AS last_order_date
	FROM customers AS C
	INNER JOIN transactions AS T USING(customerid)
	GROUP BY 1, 2
),
Cate_rnk AS (
	SELECT
		C.customerid,
		P.category,
		SUM(T.totalvalue) AS category_spend,
		ROW_NUMBER() OVER(PARTITION BY C.customerid ORDER BY SUM(T.totalvalue) DESC) AS cat_rank
	FROM customers AS C
	INNER JOIN transactions AS T USING(customerid)
	INNER JOIN products AS P USING(productid)
	GROUP BY 1, 2
)
	SELECT
		CT.customerid,
		CT.customername,
		CT.total_spend,
		CT.last_order_date,
		CR.category AS favorite_category,
		CASE
			WHEN CT.total_spend > 5000 THEN 'VIP'
			WHEN CT.total_spend BETWEEN 3000 AND 5000 THEN 'High Spender'
			ELSE 'Regular'
		END AS customer_segment
	FROM Customer_totals AS CT
	INNER JOIN Cate_rnk AS CR USING(customerid)
	WHERE CR.cat_rank = 1
	ORDER BY 1, 2 ASC, 3 DESC

-- ------------------------------------------------------------------------------------------------------

WITH Customer_stats AS (
	SELECT
		customerid,
		SUM(totalvalue) AS lifetime_value,
		COUNT(transactionid) AS total_orders,
		SUM(totalvalue) / NULLIF(COUNT(transactionid),0) AS avg_order_value,
		MIN(transactiondate) AS first_order_date,
		MAX(transactiondate) AS last_order_date
	FROM transactions
	GROUP BY 1
),
Customer_Fav AS (
	SELECT
		T.customerid,
		P.category,
		ROW_NUMBER()
			OVER(PARTITION BY T.customerid ORDER BY SUM(T.totalvalue) DESC) AS rnk
	FROM transactions AS T
	INNER JOIN products AS P USING(productid)
	GROUP BY 1, 2
)
	SELECT
		C.customername,
		C.region,
		CS.lifetime_value,
		CS.total_orders,
		ROUND(CS.avg_order_value,2) AS avg_order_value,
		CASE
			WHEN CURRENT_DATE - CS.last_order_date <= 90 THEN 'Active'
			WHEN CURRENT_DATE - CS.last_order_date <= 180 THEN 'Dormant'
			ELSE 'Churned'
		END AS status,
		CASE
			WHEN CS.lifetime_value > 5000 THEN 'Platinum'
			WHEN CS.lifetime_value > 2500 THEN 'Gold'
			ELSE 'Silver'
		END AS loyalty_tier,
		F.category AS top_category,
		CURRENT_DATE - CS.last_order_date AS days_inactive
	FROM customers AS C
	LEFT JOIN Customer_stats AS CS USING(customerid)
	LEFT JOIN Customer_Fav AS F USING(customerid)
	WHERE F.rnk = 1
	ORDER BY 1, 2 ASC, 3 DESC





