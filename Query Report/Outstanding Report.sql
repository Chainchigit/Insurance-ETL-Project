
SELECT 
    f.policy_no,
    p.product_name AS product,
    c.customer_name AS insured_name,
    a.agent_code,
    a.agent_name,
    f.sale_date,
    f.due_date,
    f.outstanding_amount,
    CASE WHEN f.is_paid = FALSE THEN 'Outstanding' ELSE 'Paid' END AS payment_status
FROM fact_outstanding_premium f
JOIN dim_products p ON f.product_id = p.product_id
JOIN dim_customers c ON f.customer_id = c.customer_id
JOIN dim_agents a ON f.agent_code = a.agent_code
WHERE f.is_paid = FALSE
ORDER BY f.due_date ASC;
