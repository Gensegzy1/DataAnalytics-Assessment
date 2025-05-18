-- Assessment_Q4.sql
-- ✅ Q4: Customer Lifetime Value (CLV) Estimation

SELECT
    u.id AS customer_id,

    -- 🔠 Construct full name from first and last (name may be null)
    CONCAT(u.first_name, ' ', u.last_name) AS name,

    -- 📆 Tenure in months (rounded from days / avg month length)
    ROUND(DATEDIFF(CURDATE(), u.date_joined) / 30.44) AS tenure_months,

    -- 🔢 Total transaction count from savings_savingsaccount
    COUNT(sa.id) AS total_transactions,

    -- 💰 Estimated CLV formula: (txn/tenure) * 12 * 0.001
    ROUND(
        (COUNT(sa.id) / GREATEST(DATEDIFF(CURDATE(), u.date_joined) / 30.44, 1)) * 12 * 0.001,
        2
    ) AS estimated_clv

FROM users_customuser u
LEFT JOIN savings_savingsaccount sa ON u.id = sa.owner_id

GROUP BY u.id, name, u.date_joined
ORDER BY estimated_clv DESC;
