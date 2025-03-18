WITH outstanding_summary AS (
    -- Summary: สรุปยอดเบี้ยค้างชำระรายตัวแทน
    SELECT 
        f.agent_code,
        a.agent_name,
        SUM(f.outstanding_amount) AS total_outstanding_premium,
        COUNT(f.policy_no) AS total_unpaid_policies,
        DATE('2024-12-31') AS report_date
    FROM fact_outstanding_premium f
    JOIN dim_agents a ON f.agent_code = a.agent_code
    WHERE f.due_date <= '2024-12-31'  -- เฉพาะกรมธรรม์ที่ถึงกำหนดชำระแล้ว
    AND f.is_paid = FALSE  -- เฉพาะกรมธรรม์ที่ยังไม่จ่าย
    GROUP BY f.agent_code, a.agent_name
), outstanding_details AS (
    -- Detail: ดึงข้อมูลกรมธรรม์ที่ค้างชำระของแต่ละตัวแทน
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
    WHERE f.due_date <= '2024-12-31'
    AND f.is_paid = FALSE
)
-- Combine Summary + Detail
SELECT 'Summary' AS report_type, * FROM outstanding_summary
UNION ALL
SELECT 'Detail' AS report_type, * FROM outstanding_details
ORDER BY report_type, agent_code, due_date;
