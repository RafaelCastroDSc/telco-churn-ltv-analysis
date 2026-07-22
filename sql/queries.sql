-- =====================================================
-- TELCO CHURN & PROMOTION LTV ANALYSIS
-- Author: Rafael Castro
-- Objective: Calculate churn rates, revenue risk, and LTV by promotion type
-- =====================================================

-- Query 1: Churn Rate and Revenue Impact by Promotion Type
SELECT 
    promotion_applied,
    COUNT(customer_id) AS total_customers,
    SUM(CASE WHEN churn_status = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(CAST(SUM(CASE WHEN churn_status = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(customer_id) * 100, 2) AS churn_rate_pct,
    ROUND(AVG(monthly_charges), 2) AS avg_monthly_revenue,
    ROUND(SUM(CASE WHEN churn_status = 'Yes' THEN monthly_charges ELSE 0 END), 2) AS lost_monthly_revenue
FROM telco_churn
GROUP BY promotion_applied
ORDER BY churn_rate_pct DESC;

-- Query 2: Customer Lifetime Value (LTV) & Tenure by Contract
SELECT 
    contract_type,
    promotion_applied,
    ROUND(AVG(tenure_months * monthly_charges), 2) AS estimated_ltv,
    ROUND(AVG(tenure_months), 1) AS avg_tenure_months
FROM telco_churn
WHERE churn_status = 'No'
GROUP BY contract_type, promotion_applied
ORDER BY estimated_ltv DESC;
