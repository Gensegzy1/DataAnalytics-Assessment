
-- Assessment_Q1.sql
-- ✅ Q1: High-Value Customers with Multiple Products
-- Objective: Find customers who have both funded savings and investment plans, ordered by total deposits.

SELECT
    u.id AS owner_id,

    -- 💬 Replaced `u.name` with full name using CONCAT because many users had null values in the `name` field,
    -- but `first_name` and `last_name` were consistently populated.
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,

    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT i.id) AS investment_count,

    -- 💰 Total deposits (confirmed inflow only), converted from Kobo to Naira
    ROUND(SUM(COALESCE(sa.confirmed_amount, 0)) / 100, 2) AS total_deposits

FROM users_customuser u

-- 🎯 Join customers who have at least one funded savings plan
JOIN plans_plan s
    ON s.owner_id = u.id AND s.is_regular_savings = 1
JOIN savings_savingsaccount sa
    ON sa.plan_id = s.id AND sa.confirmed_amount > 0

-- 📊 Ensure customer also has at least one funded investment plan
JOIN (
    SELECT DISTINCT owner_id, id
    FROM plans_plan
    WHERE is_a_fund = 1
) i ON i.owner_id = u.id

GROUP BY u.id, full_name
HAVING savings_count >= 1 AND investment_count >= 1
ORDER BY total_deposits DESC;