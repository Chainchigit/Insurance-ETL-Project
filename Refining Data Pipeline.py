import apache_beam as beam
from google.cloud import bigquery

class UpdatePremium(beam.DoFn):
    def process(self, element):
        client = bigquery.Client()
        
        # ดึงข้อมูลกรมธรรม์เดิมจาก Data Warehouse
        query = f"""
        SELECT policy_no, premium, effective_date, is_active
        FROM fact_premium_history
        WHERE policy_no = '{element['policy_no']}' AND is_active = TRUE
        """
        results = list(client.query(query))

        # อัปเดตข้อมูลเก่าให้เป็น is_active = FALSE
        if results:
            update_query = f"""
            UPDATE fact_premium_history
            SET is_active = FALSE, end_date = CURRENT_DATE()
            WHERE policy_no = '{element['policy_no']}' AND is_active = TRUE
            """
            client.query(update_query)

        # เพิ่มข้อมูลเวอร์ชันใหม่
        insert_query = f"""
        INSERT INTO fact_premium_history (policy_no, premium, effective_date, end_date, is_active, last_updated)
        VALUES ('{element['policy_no']}', {element['new_premium']}, '{element['effective_date']}', NULL, TRUE, CURRENT_TIMESTAMP())
        """
        client.query(insert_query)

        yield element  # ส่งข้อมูลไปยังขั้นตอนถัดไป

# เรียกใช้ Pipeline
with beam.Pipeline() as pipeline:
    (pipeline
     | "Read Updates" >> beam.io.ReadFromBigQuery(query="SELECT * FROM stg_premium_updates")
     | "Refine Data" >> beam.ParDo(UpdatePremium())
     | "Write to BigQuery" >> beam.io.WriteToBigQuery("fact_premium_history"))
