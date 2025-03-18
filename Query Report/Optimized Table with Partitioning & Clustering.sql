CREATE TABLE fact_outstanding_premium (
    policy_no STRING,
    agent_code STRING,
    customer_id STRING,
    due_date DATE,
    outstanding_amount DECIMAL,
    is_paid BOOLEAN
)
PARTITION BY DATE_TRUNC(due_date, MONTH)  -- Partition by Month
CLUSTER BY agent_code;  -- Cluster by Agent Code
