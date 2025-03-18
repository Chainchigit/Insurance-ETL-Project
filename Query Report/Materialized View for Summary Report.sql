CREATE MATERIALIZED VIEW outstanding_premium_summary AS
SELECT 
    agent_code,
    SUM(outstanding_amount) AS total_outstanding_premium,
    COUNT(policy_no) AS total_unpaid_policies,
    LAST_DAY(due_date) AS month_end
FROM fact_outstanding_premium
WHERE is_paid = FALSE
GROUP BY agent_code, month_end;
