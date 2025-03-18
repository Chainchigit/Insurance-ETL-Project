// Define Tables for Data Warehouse Schema

Table fact_premium_history {
  policy_no varchar [primary key]   // เลขที่กรมธรรม์
  premium decimal                   // เบี้ยประกันภัย
  effective_date date                // วันที่เริ่มมีผล
  end_date date                      // วันที่สิ้นสุดของเบี้ยประกัน (NULL ถ้าเป็นปัจจุบัน)
  is_active boolean                  // 1 = ปัจจุบัน, 0 = ถูกแทนที่แล้ว
  last_updated timestamp             // Timestamp ของการอัปเดตข้อมูลล่าสุด

  product_id varchar                 // FK to dim_products
  customer_id varchar                 // FK to dim_customers
  agent_code varchar                 // FK to dim_agents
}

Table dim_products {
  product_id varchar [primary key]   // รหัสผลิตภัณฑ์
  product_name varchar               // ชื่อผลิตภัณฑ์
  category varchar                   // ประเภทผลิตภัณฑ์
}

Table dim_customers {
  customer_id varchar [primary key]  // รหัสลูกค้า
  customer_name varchar              // ชื่อ-นามสกุล
}

Table dim_agents {
  agent_code varchar [primary key]   // รหัสตัวแทน
  agent_name varchar                 // ชื่อตัวแทน
}

Table stg_premium_updates {
  update_id integer [primary key, increment]  // ID ของการอัปเดต
  policy_no varchar                           // เลขที่กรมธรรม์ที่ต้องการแก้ไข
  new_premium decimal                         // ยอดเบี้ยประกันใหม่
  effective_date date                         // วันที่มีผลของเบี้ยประกันใหม่
  modified_by varchar                         // User ที่ทำการอัปเดต
  modified_at timestamp                       // เวลาที่อัปเดต
}

Table fact_premium_audit_log {
  log_id integer [primary key, increment]  // ID ของ Log
  policy_no varchar                        // เลขที่กรมธรรม์ที่ถูกอัปเดต
  old_premium decimal                      // ยอดเบี้ยประกันเก่า
  new_premium decimal                      // ยอดเบี้ยประกันใหม่
  change_date timestamp                     // เวลาที่แก้ไข
  modified_by varchar                       // User ที่แก้ไขข้อมูล
}

// Define Relationships

Ref: fact_premium_history.product_id > dim_products.product_id  // Many-to-One
Ref: fact_premium_history.customer_id > dim_customers.customer_id  // Many-to-One
Ref: fact_premium_history.agent_code > dim_agents.agent_code  // Many-to-One

Ref: stg_premium_updates.policy_no > fact_premium_history.policy_no  // Many-to-One (อัปเดตจาก Staging)
Ref: fact_premium_audit_log.policy_no > fact_premium_history.policy_no  // Many-to-One (เก็บประวัติการอัปเดต)

