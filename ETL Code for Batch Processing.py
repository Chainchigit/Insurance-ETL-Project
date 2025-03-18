import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
import pandas as pd
import pyodbc
from google.cloud import storage, bigquery

# SQL Server Configuration
SQL_SERVER = "your_sql_server"
DATABASE = "insurance_db"
USERNAME = "your_username"
PASSWORD = "your_password"
TABLE_NAME = "PolicyInfo"

# Google Cloud Storage & BigQuery Configuration
GCS_BUCKET = "your-bucket-name"
GCS_TEMP_PATH = f"gs://{GCS_BUCKET}/temp/"
GCS_PARQUET_PATH = f"gs://{GCS_BUCKET}/insurance_data.parquet"
BIGQUERY_DATASET = "insurance_dataset"
BIGQUERY_TABLE = "fact_policy"

# Step 1: Extract - ดึงข้อมูลจาก SQL Server
def extract_from_sql():
    conn_str = f"DRIVER={{SQL Server}};SERVER={SQL_SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD}"
    conn = pyodbc.connect(conn_str)
    query = f"SELECT * FROM {TABLE_NAME}"
    df = pd.read_sql(query, conn)
    conn.close()
    
    # Save as Parquet
    df.to_parquet("/tmp/insurance_data.parquet")
    
    # Upload to GCS
    storage_client = storage.Client()
    bucket = storage_client.bucket(GCS_BUCKET)
    blob = bucket.blob("insurance_data.parquet")
    blob.upload_from_filename("/tmp/insurance_data.parquet")

    print("Data Extracted & Uploaded to GCS")

# Step 2: Transform - ใช้ Apache Beam จัดการข้อมูล
class TransformData(beam.DoFn):
    def process(self, element):
        element["policy_no"] = str(element["policy_no"])
        element["premium"] = float(element["premium"])
        element["sale_date"] = element["sale_date"].split(" ")[0]  # Keep only YYYY-MM-DD
        return [element]

# Step 3: Load - โหลดข้อมูลไปยัง BigQuery
def load_to_bigquery():
    client = bigquery.Client()
    table_id = f"{BIGQUERY_DATASET}.{BIGQUERY_TABLE}"

    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.PARQUET,
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE
    )
    
    uri = GCS_PARQUET_PATH
    load_job = client.load_table_from_uri(uri, table_id, job_config=job_config)
    load_job.result()

    print("Data Loaded to BigQuery")

# Step 4: Run Apache Beam Pipeline
def run_etl_pipeline():
    options = PipelineOptions(
        runner='DataflowRunner',
        project='your-gcp-project',
        temp_location=GCS_TEMP_PATH,
        region='us-central1'
    )

    with beam.Pipeline(options=options) as pipeline:
        (
            pipeline
            | "Read Data from GCS" >> beam.io.ReadFromParquet(GCS_PARQUET_PATH)
            | "Transform Data" >> beam.ParDo(TransformData())
            | "Write to BigQuery" >> beam.io.WriteToBigQuery(
                f"{BIGQUERY_DATASET}.{BIGQUERY_TABLE}",
                schema="policy_no:STRING, premium:FLOAT, sale_date:DATE",
                write_disposition=beam.io.BigQueryDisposition.WRITE_TRUNCATE
            )
        )

# Run the ETL Pipeline
if __name__ == "__main__":
    extract_from_sql()
    run_etl_pipeline()
    load_to_bigquery()
