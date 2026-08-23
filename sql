
SELECT TOP 10 * FROM customers;

SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'customers';

ALTER TABLE customers
ALTER COLUMN watch_hours DECIMAL(5,2);

ALTER TABLE customers
ALTER COLUMN monthly_fee DECIMAL(5,2);

SELECT TOP 10 watch_hours, monthly_fee FROM customers;

----------------------------------------------------------------
-- Query 1 — Overall churn rate
SELECT 
    COUNT(*) AS total_customers,
    SUM(CAST(churned AS INT)) AS churned_customers,
    CAST(SUM(CAST(churned AS INT)) AS FLOAT) / COUNT(*) * 100 AS churn_rate_pct
FROM customers;
-- Query 2 — Churn rate by subscription plan (let's confirm the Basic vs Premium finding in SQL too)
SELECT 
    subscription_type,
    COUNT(*) AS total_customers,
    SUM(CAST(churned AS INT)) AS churned_customers,
    CAST(SUM(CAST(churned AS INT)) AS FLOAT) / COUNT(*) * 100 AS churn_rate_pct
FROM customers
GROUP BY subscription_type
ORDER BY churn_rate_pct DESC;
-- Query 3 — Revenue at risk (how much monthly revenue is being lost to churned customers)
SELECT 
    subscription_type,
    COUNT(*) AS churned_customers,
    SUM(monthly_fee) AS monthly_revenue_at_risk
FROM customers
WHERE churned = 1
GROUP BY subscription_type
ORDER BY monthly_revenue_at_risk DESC;
-- Query 4 — Combine our two strongest predictors from Stage 2 <watch_hours,last_login_days> (engagement-based risk segments)
SELECT 
    CASE 
        WHEN watch_hours < 5 AND last_login_days > 30 THEN 'High Risk'
        WHEN watch_hours < 5 OR last_login_days > 30 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_segment,
    COUNT(*) AS total_customers,
    SUM(CAST(churned AS INT)) AS churned_customers,
    CAST(SUM(CAST(churned AS INT)) AS FLOAT) / COUNT(*) * 100 AS churn_rate_pct
FROM customers
GROUP BY 
    CASE 
        WHEN watch_hours < 5 AND last_login_days > 30 THEN 'High Risk'
        WHEN watch_hours < 5 OR last_login_days > 30 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END
ORDER BY churn_rate_pct DESC;
-- Query 5 — Churn rate by payment method
SELECT 
    payment,
    COUNT(*) AS total_customers,
    SUM(CAST(churned AS INT)) AS churned_customers,
    CAST(SUM(CAST(churned AS INT)) AS FLOAT) / COUNT(*) * 100 AS churn_rate_pct
FROM customers
GROUP BY payment
ORDER BY churn_rate_pct DESC;
-- Query 6 — Churn by region and device
SELECT region, COUNT(*) AS total_customers, 
    CAST(SUM(CAST(churned AS INT)) AS FLOAT) / COUNT(*) * 100 AS churn_rate_pct
FROM customers
GROUP BY region
ORDER BY churn_rate_pct DESC;

SELECT device, COUNT(*) AS total_customers, 
    CAST(SUM(CAST(churned AS INT)) AS FLOAT) / COUNT(*) * 100 AS churn_rate_pct
FROM customers
GROUP BY device
ORDER BY churn_rate_pct DESC;
-- Query 7 — Most popular plan / device / genre
SELECT subscription_type, COUNT(*) AS total_customers
FROM customers
GROUP BY subscription_type
ORDER BY total_customers DESC;

SELECT device, COUNT(*) AS total_customers
FROM customers
GROUP BY device
ORDER BY total_customers DESC;

SELECT favorite_genre, COUNT(*) AS total_customers
FROM customers
GROUP BY favorite_genre
ORDER BY total_customers DESC;








