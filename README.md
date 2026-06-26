# Sales Analysis Data Pipeline

This project implements an end-to-end data pipeline designed to extract, clean, store, and analyze e-commerce sales data. The project demonstrates proficiency in data engineering practices, relational database management, and advanced SQL analytical techniques.

## Data Pipeline Architecture

1. Extraction and Cleaning (Python/Pandas): The pipeline ingests raw CSV files, performs data cleaning (handling null values via median/mode imputation), enforces data types (specifically for timestamps), and calculates business metrics such as TotalRevenue.
2. Storage (PostgreSQL): Processed data is persisted into a relational PostgreSQL database using SQLAlchemy for secure and robust connection management.
3. Business Analysis (SQL): The project includes a comprehensive suite of SQL queries designed to derive actionable business insights regarding profitability, customer behavior, and logistics efficiency.

## Technologies Used

- Language: Python 3.x
- Data Manipulation: Pandas
- Database: PostgreSQL
- Connectivity: SQLAlchemy, Psycopg2
- Configuration: Environment variables (.env) for credential security

## Key Business Insights

The analytical queries developed provide solutions to the following business problems:

- Category Profitability: Identifying top-performing categories to optimize marketing allocation.
- Customer Lifetime Value: Segmenting high-value customers based on purchase frequency and average spending.
- Logistics Risk Assessment: Calculating return rates by category to identify potential quality or transportation issues.
- Operational Efficiency: Analyzing shipping cost trends across different shipment providers and order priorities.

## How to Run the Project

1. Clone the repository:

```bash
git clone https://github.com/MipForShort/ecommerce-sales-analytics-pipeline.git
```

2. Create and activate a virtual environment:

```bash
python -m venv .venv
source .venv/bin/activate  # On Linux/macOS
```

3. Install dependencies:

```bash
pip install -r requirements.txt
```

4. Configure environment variables:
Create a .env file in the root directory with the following structure:

```
DB_USER=your_username
DB_PASS=your_password
DB_HOST=localhost
DB_PORT=5432
DB_NAME=sales_db
```

5. Execute the pipeline:

```bash
python src/online_sales.py
```

# SQL Analysis

The analytical logic was developed to extract actionable business intelligence from the sales dataset. The queries are stored in the sql/query.sql file and cover the following key areas:

- Profitability & Customer Insights: Analyzing revenue generation by category and calculating Average Order Value (AOV) per customer.
- Operational Efficiency: Evaluating shipping costs associated with different providers and order priorities to identify cost-saving opportunities.
- Time-Series Analysis: Tracking monthly revenue trends using date truncation techniques to identify growth patterns.
- Advanced Customer Segmentation: Implementing filtering logic (HAVING clause) to identify high-value, repeat-purchase customers.
- Logistics & Churn Analysis: Calculating return rates by category and comparing shipping costs against return status to mitigate financial leakage.
- Geographic and Operational Insights: Tracking order volume by region and evaluating the performance of various payment and shipping methods to support strategic logistical and financial planning.

You can find the detailed analysis report with visual results here:
[View Detailed Performance Report](./docs/e-commerce-sales-performance-report.md)

---

*Developed as a portfolio project to demonstrate capabilities in Data Engineering and Data Analysis.*