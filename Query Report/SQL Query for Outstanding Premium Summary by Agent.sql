SELECT 
    agent_code,
    SUM(outstanding_amount) AS total_outstanding_premium,
    COUNT(policy_no) AS total_unpaid_policies,
    DATE('2024-12-31') AS report_date
FROM fact_outstanding_premium
WHERE due_date <= '2024-12-31'  -- เฉพาะกรมธรรม์ที่ถึงกำหนดชำระแล้ว
AND is_paid = FALSE  -- เฉพาะกรมธรรม์ที่ยังไม่จ่าย
GROUP BY agent_code
ORDER BY total_outstanding_premium DESC;
