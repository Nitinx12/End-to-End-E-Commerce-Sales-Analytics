# E-Commerce Data Engineering and Analysis Project

## Project Overview
This project implements an end-to-end data pipeline and analytical suite for an e-commerce platform. It demonstrates the extraction, transformation, and loading (ETL) of transactional data into a PostgreSQL database, followed by advanced SQL analytics and Python-based exploratory data analysis (EDA). The goal is to derive actionable business insights regarding revenue trends, customer lifecycle, and product performance.

## Repository Structure
* **Load into pg adminn.py**: Python ETL script that ingests raw CSV data (`Customers`, `Products`, `Transactions`), performs necessary transformations using Pandas, and loads the data into a PostgreSQL database using SQLAlchemy.
* **SQL E-Commerce.sql**: Comprehensive SQL script containing advanced queries for time-series analysis, customer segmentation (RFM-style), and revenue growth metrics.
* **E-Commerce NoteBook.ipynb**: Jupyter Notebook focused on visual exploratory data analysis, including Pareto analysis (80/20 rule) and statistical distributions of sales data.
* **Data Files**:
    * `customer.csv`: Contains customer demographics and signup dates.
    * `products.csv`: Product catalog including categories and pricing.
    * `Transactions.csv`: Transactional sales records.

## Technologies Used
* **Database**: PostgreSQL
* **Programming Languages**: Python, SQL
* **Python Libraries**: Pandas, SQLAlchemy, Matplotlib, Seaborn, NumPy, DuckDB
* **Tools**: PGAdmin, Jupyter Notebook

## Database Schema
The project uses a relational schema with the following specifications:
1.  **Customers Table**: Stores `customerid`, `customername`, `region`, and `signupdate`.
2.  **Products Table**: Stores `productid`, `productname`, `category`, and `price`.
3.  **Transactions Table**: Stores `transactionid`, foreign keys to customers and products, `transactiondate`, `quantity`, `totalvalue`, and `price`.

## Key Analytical Features

### 1. SQL Analytics (`SQL E-Commerce.sql`)
* **Time-Series Analysis**: Implementation of recursive CTEs to generate continuous calendar dates for daily revenue tracking, ensuring no gaps in reporting.
* **Growth Metrics**: Calculation of Month-over-Month (MoM) growth percentages using window functions (`LAG`, `OVER`).
* **Customer Segmentation**: Logic to classify customers as 'Active' or 'Dormant' based on recency of their last purchase (e.g., < 90 days vs. > 180 days).
* **Lifetime Value (LTV)**: Aggregation of total spend per customer to identify high-value clients.

### 2. Exploratory Data Analysis (`E-Commerce NoteBook.ipynb`)
* **Pareto Principle Application**: Analysis identifying the top percentile of customers responsible for 80% of revenue.
* **Category Performance**: Visualization of sales distribution across different product categories.
* **Regional Insights**: Breakdown of customer base and purchasing power by region.

## Setup and Usage Instructions

### Prerequisites
* Python 3.x installed.
* PostgreSQL installed and running locally.

### Installation
1.  Clone this repository.
2.  Install required Python packages:
    ```bash
    pip install pandas sqlalchemy psycopg2 matplotlib seaborn numpy
    ```

### Database Initialization
1.  Create a database named `Online` (or update the connection string in the Python script).
2.  Open `Load into pg adminn.py` and configure your database credentials:
    ```python
    conn_string = 'postgresql://username:password@localhost/Online'
    ```
3.  Run the script to load data:
    ```bash
    python "Load into pg adminn.py"
    ```

### Running Analysis
* **SQL**: Execute the queries in `SQL E-Commerce.sql` using a tool like PGAdmin or DBeaver to view tabular insights.
* **Python**: Launch Jupyter Notebook to run `E-Commerce NoteBook.ipynb` for visual reports.
