# E-Commerce Analytics Pipeline

## Description
This project implements an end-to-end data analysis pipeline for an e-commerce platform. It focuses on ingesting raw transactional data, performing advanced SQL-based analytics, and generating visual insights regarding customer behavior and revenue trends.

The system is designed to transform raw CSV logs into actionable business intelligence, specifically solving problems related to Customer Lifetime Value (CLV) calculation, customer segmentation (Active vs. Dormant), and sales growth tracking.

**Key capabilities include:**
* **ETL Process:** Automated loading of flat-file data into a relational database.
* **Customer Intelligence:** Analysis of purchasing habits, category preferences, and recency.
* **Revenue Analysis:** Month-over-Month (MoM) growth calculations and Pareto analysis (80/20 rule).

## Features
* **Automated Data Ingestion:** Python-based script to bulk load Customers, Products, and Transactions data into PostgreSQL.
* **Advanced SQL Analytics:**
    * Recursive CTEs for daily revenue tracking.
    * Window functions for calculating Month-over-Month growth percentage.
    * Customer segmentation logic based on purchase recency (Active, Dormant, Churned).
* **Exploratory Data Analysis (EDA):** Jupyter Notebook integration for visual statistical analysis, including revenue distribution and category performance.
* **Category Ranking:** Logic to identify the "favorite" product category for every unique customer.

## Tech Stack
* **Languages:** Python 3.x, SQL
* **Database:** PostgreSQL
* **Data Manipulation:** Pandas, NumPy
* **Visualization:** Matplotlib, Seaborn
* **ORM/Database Connectivity:** SQLAlchemy, DuckDB

## Project Structure
```text
├── data/
│   ├── customer.csv          # Raw customer demographic data
│   ├── products.csv          # Product catalog and pricing
│   └── Transactions.csv      # Historical transaction logs
├── notebooks/
│   └── E-Commerce NoteBook.ipynb  # EDA and visual analysis
├── scripts/
│   └── Load into pg adminn.py     # ETL script for database population
├── sql/
│   └── SQL E-Commerce.sql    # Analytical queries and business logic
└── README.md
