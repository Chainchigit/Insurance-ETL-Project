# **📌 Insurance ETL Project**  

## **🔹 Project Overview**  
The **Insurance ETL Project** is a system that automates the **Extract, Transform, Load (ETL) process** for **insurance premium and outstanding payment data**, enabling efficient **data ingestion, transformation, and reporting**.  

This project supports both **Batch Processing** (SQL Server → BigQuery) and **Real-time Streaming Processing** (Pub/Sub → Dataflow → BigQuery) using **Google Cloud Platform (GCP)**, ensuring scalability, automation, and high-performance data processing.  

---

## **🔹 Project Objectives**  
✅ **Extract & consolidate insurance policy data** from **On-Premises Databases (SQL Server)** and **real-time event streams**  
✅ **Standardize & transform data** before storing it in **BigQuery Data Warehouse**  
✅ **Optimize data queries** using **Partitioning & Clustering in BigQuery**  
✅ **Generate reports on outstanding insurance premiums** for each agent and customer  
✅ **Support historical data updates** to allow modifications to previously stored insurance premiums  

---

## **🔹 System Architecture**  
This project is designed with **five main layers** following industry best practices for Data Engineering.  

1️⃣ **Data Sources** → Data is sourced from **SQL Server (On-Premises Database)** and **real-time event streams** from enterprise applications.  
2️⃣ **Data Ingestion** → Uses **Apache Beam (Dataflow) & Pub/Sub** for data extraction.  
3️⃣ **Data Processing & Storage** → Data is transformed and stored in **Google Cloud Storage (GCS) & BigQuery**.  
4️⃣ **Data Orchestration & Monitoring** → **Cloud Composer (Apache Airflow) & StackDriver** manage workflows and system monitoring.  
5️⃣ **Data Visualization & Reporting** → Processed data is visualized using **Looker Studio & BI Dashboards** for business insights.  

---

## **🔹 Data Processing Workflows**
This project supports **two main data processing methods**:  

### **🔹 1. Batch Processing (SQL Server → BigQuery)**
- Uses **Apache Beam (Dataflow)** to extract data from **SQL Server**  
- Transforms data and stores raw files in **Google Cloud Storage (GCS)**  
- Loads processed data into **BigQuery** for analytics  
- Scheduled to run **daily** via **Cloud Composer (Apache Airflow)**  

### **🔹 2. Streaming Processing (Pub/Sub → BigQuery)**
- Real-time events are ingested via **Pub/Sub**  
- **Dataflow (Apache Beam)** processes and cleans data before sending it to **BigQuery**  
- Enables **real-time analytics** for immediate insights  

---

## **🔹 Data Warehouse Schema (Star Schema)**
The **Insurance ETL Project** follows the **Star Schema** design to optimize query performance.  

- **Fact Table: `fact_premium_history`** → Stores policy transactions, premiums, and outstanding payments  
- **Dimension Tables:**  
  - `dim_agents` → Stores agent information  
  - `dim_customers` → Stores customer details  
  - `dim_products` → Stores insurance product details  

The **Fact Table** is **partitioned by payment due date** and **clustered by agent code** to improve query efficiency.  

---

## **🔹 Reporting & Analytics**
This project enables reporting and analysis of outstanding insurance premiums and customer payment behavior.  

### **🔹 Key Reports**
✅ **Outstanding premium report per agent at the end of each month**  
✅ **Detailed report of unpaid policies, including customer and agent details**  
✅ **Historical trend analysis of premium payments**  

The processed data can be visualized via **Looker Studio or BI Dashboards**, allowing management teams to gain real-time business insights.  

---

## **🔹 Historical Data Updates & Modification Handling**
To support modifications to past premium records, this project implements **Slowly Changing Dimensions Type 2 (SCD Type 2)**. This ensures:  

✅ **Historical records remain accessible**  
✅ **Data updates are automated** via **BigQuery MERGE**  
✅ **Users can retrieve the most recent premium data efficiently**  

---

## **🔹 Performance Optimization**
To enhance query performance and scalability, the project uses several optimization techniques:  

✅ **BigQuery Partitioning** → Reduces query scan time for historical data  
✅ **Clustering by Agent Code** → Speeds up queries for specific agents  
✅ **Materialized Views** → Precomputed views for faster summary reports  
✅ **Apache Beam with Dataflow** → Enables parallel data processing for large-scale datasets  

---

## **🔹 Business Benefits**
🔹 **Enables real-time analysis of insurance policies and outstanding premiums**  
🔹 **Reduces report generation time** from **hours to seconds**  
🔹 **Simplifies data modification handling** using **SCD Type 2 & BigQuery MERGE**  
🔹 **Easily scalable architecture** using **Google Cloud Platform (GCP)**  

---

## **🔹 Future Enhancements**
✅ **Implement Machine Learning (ML) for customer payment risk prediction**  
✅ **Enhance Data Quality checks using Great Expectations**  
✅ **Introduce Predictive Analytics for proactive business decision-making**  

---

## **📌 Conclusion**
The **Insurance ETL Project** automates the ingestion, processing, and transformation of **insurance policy and outstanding premium data**. It enables real-time and batch data processing, uses **BigQuery as a Data Warehouse**, and provides fast and scalable reporting.  

📌 **This project is ideal for insurance companies looking to improve data analytics, automate premium tracking, and gain real-time business insights.** 🎯  

---
