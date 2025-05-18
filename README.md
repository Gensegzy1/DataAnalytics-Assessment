# DataAnalytics-Assessment
Welcome to my solution for the SQL Proficiency Assessment for the Data Analyst role

## ✅ Question 1: High-Value Customers with Multiple Products
### 🧠 Objective:
- Identify customers who have:

- At least one funded savings plan (is_regular_savings = 1)

- At least one funded investment plan (is_a_fund = 1)

- Calculate the total confirmed deposits (inflows only) for each customer.

### 💡 Approach:
- Joined users_customuser, plans_plan, and savings_savingsaccount.

- Filtered for confirmed_amount > 0 to ensure the plan is funded.

- Aggregated to count number of savings and investment plans per user.

- Constructed full name using first_name + ' ' + last_name due to null values in the name column.

- Total deposits were converted from kobo to naira using /100.

### ✅ Output:
![assessment no 1](https://github.com/user-attachments/assets/e78cca99-f7eb-47ac-88ff-4176c7fe75cd)

### ⛔ Challenges:
- Some users had null values in the name column; resolved by using CONCAT(first_name, last_name) for a reliable full name.

- Ensured accuracy by filtering only confirmed inflow transactions.

## ✅ Question 2: Transaction Frequency Analysis
### 🧠 Objective:
Classify users based on average number of savings transactions per month into:

- High Frequency (≥ 10)

- Medium Frequency (3–9)

- Low Frequency (≤ 2)

### 💡 Approach:
- Counted total transactions per user from savings_savingsaccount.

- Calculated tenure using DATEDIFF(MAX, MIN) / 30.44 to estimate active months.

- Averaged transactions per month and categorized using CASE.

- Aggregated final results by frequency group.

### ✅ Output:
![assessment no 2](https://github.com/user-attachments/assets/b0eea0fd-427e-4501-a59b-66dd36c22073)


### ⛔ Challenges:
- No built-in function to calculate months in MySQL, so I approximated using average month length (30.44 days).

- Protected against divide-by-zero using GREATEST(..., 1).


## ✅ Question 3: Account Inactivity Alert
### 🧠 Objective:
Find all active plans (savings or investment) that have had no confirmed inflow transactions in the last 365 days.

### 💡 Approach:
- Used savings_savingsaccount to find MAX(transaction_date) for confirmed inflows per plan.

- Joined with plans_plan and filtered for savings (is_regular_savings = 1) and investment (is_a_fund = 1) plans.

- Filtered to return plans where:

  - Last transaction was more than 365 days ago

  - OR no transaction was recorded at all

- Calculated inactivity_days using DATEDIFF(CURDATE(), last_transaction_date).

### ✅ Output:
![assessment no 3](https://github.com/user-attachments/assets/0aba509b-cd32-4773-85f7-b1f272986d6a)

### ⛔ Challenges:
- Had to account for plans that have no inflows at all using a LEFT JOIN.

- Ensured only active savings or investment plans were included using logical OR conditions.


## ✅ Question 4: Customer Lifetime Value (CLV) Estimation
### 🧠 Objective:
Estimate each customer's CLV using the formula:

CLV = (total_transactions / tenure_months) * 12 * 0.001
Where:

- tenure_months = time since date_joined

- 0.001 represents 0.1% profit per transaction

### 💡 Approach:
- Joined users_customuser with savings_savingsaccount to get all transaction counts.

- Calculated tenure using DATEDIFF(CURDATE(), date_joined) / 30.44.

- Built full name from first_name + last_name.

- CLV rounded to two decimal places and ordered descending by value.

### ✅ Output:
![assessment no 4](https://github.com/user-attachments/assets/7c623897-6d44-41fa-a6d8-5f5ea5b86e82)


### ⛔ Challenges:
- To avoid division by zero for very new users, wrapped tenure calc with GREATEST(..., 1).

- name field was unreliable, so full name was generated dynamically.


