SELECT 
    f.policy_no,
    f.customer_id,
    c.customer_name,
    f.agent_code,
    a.agent_name,
    f.product_id,
    p.product_name,
    f.due_date,
    f.outstanding_amount,
    f.is_paid,
    DATE('2024-12-31') AS report_date
FROM fact_outstanding_premium f
JOIN dim_agents a ON f.agent_code = a.agent_code
JOIN dim_customers c ON f.customer_id = c.customer_id
JOIN dim_products p ON f.product_id = p.product_id
WHERE f.due_date <= '2024-12-31'  -- เฉพาะกรมธรรม์ที่ถึงกำหนดชำระแล้ว
AND f.is_paid = FALSE  -- เฉพาะกรมธรรม์ที่ยังไม่จ่าย
ORDER BY f.agent_code, f.due_date ASC;
