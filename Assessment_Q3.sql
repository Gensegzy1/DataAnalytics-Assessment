-- Assessment_Q3.sql
-- ✅ Q3: Inactive Accounts - No inflow in over 1 year

WITH last_txn AS (
    SELECT
        plan_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY plan_id
)

SELECT
    p.id AS plan_id,
    p.owner_id,

    -- 🏷️ Label the plan type for clarity
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,

    lt.last_transaction_date,
    DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days

FROM plans_plan p
LEFT JOIN last_txn lt ON p.id = lt.plan_id

WHERE
    -- 💡 Plan must be savings or investment
    (p.is_regular_savings = 1 OR p.is_a_fund = 1)

    -- 🛑 Must be inactive for over 365 days
    AND (
        lt.last_transaction_date IS NULL
        OR DATEDIFF(CURDATE(), lt.last_transaction_date) > 365
    )

ORDER BY inactivity_days DESC;