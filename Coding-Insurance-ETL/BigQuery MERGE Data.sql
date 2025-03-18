MERGE INTO fact_premium_history AS target
USING (
    SELECT
        policy_no,
        customer_id,
        agent_code,
        due_date,
        outstanding_amount,
        is_paid,
        updated_at
    FROM staging_table
) AS source
ON target.policy_no = source.policy_no

WHEN MATCHED AND source.updated_at > target.updated_at THEN
    UPDATE SET
        target.outstanding_amount = source.outstanding_amount,
        target.is_paid = source.is_paid,
        target.updated_at = source.updated_at

WHEN NOT MATCHED THEN
    INSERT (policy_no, customer_id, agent_code, due_date, outstanding_amount, is_paid, updated_at)
    VALUES (source.policy_no, source.customer_id, source.agent_code, source.due_date, source.outstanding_amount, source.is_paid, source.updated_at);
