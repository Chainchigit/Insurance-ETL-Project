import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
from google.cloud import bigquery

PROJECT_ID = "your-gcp-project"
PUBSUB_TOPIC = "projects/your-gcp-project/topics/insurance-stream"
BIGQUERY_TABLE = "your_dataset.streaming_policy"

class TransformStreamingData(beam.DoFn):
    def process(self, element):
        import json
        record = json.loads(element)
        return [{
            "policy_no": record["policy_no"],
            "premium": float(record["premium"]),
            "sale_date": record["sale_date"].split(" ")[0]
        }]

def run_streaming_etl():
    options = PipelineOptions(
        streaming=True,
        runner="DataflowRunner",
        project=PROJECT_ID,
        region="us-central1"
    )

    with beam.Pipeline(options=options) as pipeline:
        (
            pipeline
            | "Read from Pub/Sub" >> beam.io.ReadFromPubSub(topic=PUBSUB_TOPIC)
            | "Transform Data" >> beam.ParDo(TransformStreamingData())
            | "Write to BigQuery" >> beam.io.WriteToBigQuery(
                BIGQUERY_TABLE,
                schema="policy_no:STRING, premium:FLOAT, sale_date:DATE",
                write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND
            )
        )

if __name__ == "__main__":
    run_streaming_etl()
