# 🛒 E-Commerce Data Analysis Project

![Project Status](https://img.shields.io/badge/Status-Completed-success)
![Python](https://img.shields.io/badge/Python-3.8%2B-blue)
![SQL](https://img.shields.io/badge/SQL-PostgreSQL-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## 📋 Table of Contents
* [Project Overview](#-project-overview)
* [Business Objective](#-business-objective)
* [Dataset](#-dataset)
* [Tech Stack](#-tech-stack)
* [Methodology](#-methodology)
* [Results and Key Findings](#-results-and-key-findings)
* [Visualizations](#-visualizations)
* [Conclusion & Recommendations](#-conclusion--recommendations)
* [Installation & Usage](#-installation--usage)
* [Repository Structure](#-repository-structure)
* [Contact Information](#-contact-information)

---

## 📖 Project Overview
This project performs a comprehensive **Exploratory Data Analysis (EDA)** on an E-Commerce dataset. By leveraging Python for data processing and visualization, alongside advanced SQL queries for metric calculation, the analysis uncovers deep insights into customer behavior, sales trends, and product performance. The project simulates a real-world data pipeline, calculating operational metrics like monthly growth, daily revenue moving averages, and customer lifetime value.

## 🎯 Business Objective
The primary objective of this project is to analyze the operational and financial performance of an E-commerce platform. The goal is to identify key trends and provide data-driven recommendations that foster growth and improve operational efficiency. Key focus areas include:
* **Revenue Optimization**: Identifying high-value customers (Pareto Analysis).
* **Trend Analysis**: Monitoring sales performance over time (Monthly/Quarterly).
* **Customer Segmentation**: Distinguishing between active and dormant users.

## 💾 Dataset
The analysis is based on three core datasets containing transactional and demographic data:

| Dataset | Filename | Description | Key Columns |
| :--- | :--- | :--- | :--- |
| **Customers** | `customer.csv` | Demographic info | `customerid`, `customername`, `region`, `signupdate` |
| **Products** | `products.csv` | Product catalog | `productid`, `productname`, `category`, `price` |
| **Transactions**| `Transactions.csv` | Sales records | `transactionid`, `customerid`, `productid`, `transactiondate`, `totalvalue`, `quantity` |

## 🛠 Tech Stack
The project utilizes a robust stack of data analysis and engineering tools:

* **Programming Language**: Python
* **Libraries**:
    * **Data Manipulation**: `pandas`, `numpy`
    * **Visualization**: `matplotlib`, `seaborn`
    * **Database Interaction**: `sqlalchemy`, `duckdb`
* **Database**: PostgreSQL (managed via pgAdmin)
* **Scripting**: SQL for analytical queries.

## ⚙️ Methodology
1.  **Data Ingestion**: Loading raw CSV files into a structured format using Pandas and importing them into a PostgreSQL database.
2.  **Data Cleaning & Preprocessing**: Handling missing values, converting date columns (e.g., `signupdate`, `transactiondate`) to datetime objects, and ensuring data consistency.
3.  **Exploratory Data Analysis (EDA)**:
    * Statistical summaries of sales and customer activities.
    * **Pareto Analysis** to understand revenue distribution.
4.  **Advanced SQL Analysis**:
    * **Time-Series Analysis**: Calculating Month-over-Month (MoM) and Quarter-over-Quarter (QoQ) growth.
    * **Moving Averages**: Computing 7-day moving averages to smooth daily revenue volatility.
    * **Customer Analytics**: analyzing lifetime value and retention.

## 📊 Results and Key Findings
The analysis yielded the following insights:
* **Pareto Principle Validation**: A small percentage of "top" customers are responsible for a significant portion (~80%) of the total revenue, highlighting the importance of VIP retention strategies.
* **Sales Volatility**: Daily revenue tracks show fluctuations that are better interpreted using a **7-day moving average**, which provides a clearer trend line for performance monitoring.
* **Growth Metrics**: Monthly and quarterly reports reveal specific periods of high growth versus stagnation, allowing for targeted marketing interventions.

## 📈 Visualizations
Key visualizations generated in the notebook include:
* **Pareto Analysis Chart**: Highlights the cumulative revenue contribution of customers.
* **Sales Trend Lines**: Visualizes daily, monthly, and quarterly sales performance.
* **Category Performance**: Bar charts comparing revenue across different product categories (e.g., Electronics, Books, Clothing).

## 💡 Conclusion & Recommendations
* **Focus on Retention**: Since a minority of customers drive the majority of sales, implement loyalty programs specifically designed for these high-value users.
* **Inventory Management**: Use the quarterly category sales trends to optimize stock levels for seasonal peaks.
* **Marketing Timing**: Leverage the daily revenue moving average to identify the most effective days for running promotional campaigns.

## 💻 Installation & Usage

### Prerequisites
* Python 3.x
* PostgreSQL (optional, for SQL script execution)

### Steps
1.  **Clone the repository**:
    ```bash
    git clone [https://github.com/yourusername/ecommerce-analysis.git](https://github.com/yourusername/ecommerce-analysis.git)
    ```
2.  **Install dependencies**:
    ```bash
    pip install pandas numpy seaborn matplotlib sqlalchemy duckdb
    ```
3.  **Load Data**:
    * Run `Load into pg adminn.py` to load CSV files into your PostgreSQL instance (update connection string `postgresql://postgres:admin@localhost/Online` as needed).
4.  **Run Analysis**:
    * Open `E-Commerce NoteBook.ipynb` in Jupyter Notebook to interact with the Python EDA.
    * Execute scripts in `SQL E-Commerce.sql` in your SQL client for database-side analysis.

## 📂 Repository Structure
