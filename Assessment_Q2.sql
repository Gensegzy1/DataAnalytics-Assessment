SELECT * FROM adashi_staging;
-- Assessment_Q2.sql
-- ✅ Q2: Transaction Frequency Analysis
-- Goal: Categorize customers based on average monthly transaction frequency

WITH customer_monthly_activity AS (
    SELECT
        sa.owner_id,
        COUNT(*) AS total_transactions,
        -- Estimate tenure in months: use DATEDIFF / 30.44 (avg month length)
        ROUND(GREATEST(DATEDIFF(MAX(sa.transaction_date), MIN(sa.transaction_date)) / 30.44, 1), 1) AS active_months,
        ROUND(COUNT(*) / GREATEST(DATEDIFF(MAX(sa.transaction_date), MIN(sa.transaction_date)) / 30.44, 1), 2) AS avg_txn_per_month
    FROM savings_savingsaccount sa
    WHERE sa.transaction_date IS NOT NULL
    GROUP BY sa.owner_id
),

categorized AS (
    SELECT
        CASE
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        owner_id,
        avg_txn_per_month
    FROM customer_monthly_activity
)

-- Final aggregation: count of customers and average txn per category
SELECT
    frequency_category,
    COUNT(DISTINCT owner_id) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY
    CASE
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;