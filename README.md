# 🛒 E-Commerce Exploratory Data Analysis (EDA)

## 📌 Project Overview
This project focuses on analyzing the **operational and financial performance** of an E-commerce platform. By leveraging Python and SQL, the analysis identifies key trends in customer behavior, revenue growth, and product performance to provide data-driven recommendations for business efficiency and expansion.

## 📂 Dataset Structure
The project utilizes three primary datasets representing the core entities of the E-commerce ecosystem:

| Dataset | Description | Key Columns |
| :--- | :--- | :--- |
| **`customer.csv`** | Customer demographic and registration details. | `customerid`, `customername`, `region`, `signupdate` |
| **`products.csv`** | Product inventory and pricing information. | `productid`, `productname`, `category`, `price` |
| **`Transactions.csv`** | Transactional records linking customers to products. | `transactionid`, `customerid`, `productid`, `transactiondate`, `quantity`, `totalvalue` |

## 🛠️ Tech Stack
* **Language:** Python 3.x, SQL
* **Libraries:** Pandas, NumPy, Matplotlib, Seaborn, SQLAlchemy, DuckDB
* **Database:** PostgreSQL (linked via `Load into pg adminn.py`)
* **Tools:** Jupyter Notebook, PGAdmin

## 📊 Key Analyses & Methodologies

### 1. Python Analysis (`E-Commerce NoteBook.ipynb`)
* **Data Cleaning & Preprocessing:** Handling date formats and ensuring data consistency across CSVs.
* **Pareto Analysis (80/20 Rule):** Identifying the top % of customers responsible for 80% of the revenue to target high-value clients.
* **Visualizations:** Utilizing Seaborn and Matplotlib to plot revenue distributions and customer trends.

### 2. Advanced SQL Analysis (`SQL E-Commerce.sql`)
Complex SQL queries were engineered to derive deeper insights:
* **Time-Series Analysis:**
    * Monthly Sales Growth (MoM calculation using `LAG` and window functions).
    * 7-Day Moving Average of Daily Revenue to smooth out volatility.
* **Product Performance:**
    * Quarter-over-Quarter (QoQ) growth analysis broken down by product category.
* **Customer Segmentation:**
    * **RFM Metrics:** Calculation of Lifetime Value (LTV), Total Orders, and Average Order Value (AOV).
    * **Churn Analysis:** Categorizing customers as 'Active' or 'Dormant' based on the recency of their last purchase.

## 🚀 Installation & Usage

### Prerequisites
* Python 3.10+
* PostgreSQL Database instance

### Setup Steps
1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/yourusername/ecommerce-eda.git](https://github.com/yourusername/ecommerce-eda.git)
    ```
2.  **Install Dependencies:**
    ```bash
    pip install pandas numpy seaborn matplotlib sqlalchemy psycopg2 duckdb
    ```
3.  **Load Data into Database:**
    * Configure your PostgreSQL connection string in `Load into pg adminn.py`.
    * Run the script to populate your database tables:
        ```bash
        python "Load into pg adminn.py"
        ```
4.  **Run the Analysis:**
    * Open `E-Commerce NoteBook.ipynb` in Jupyter to view the Python-based EDA and visualizations.
    * Execute scripts in `SQL E-Commerce.sql` within your SQL client (e.g., PGAdmin) to generate reports.

## 📈 Key Insights Derived
* **Revenue Concentration:** A Pareto analysis revealed that a small segment of customers contributes to the majority of the revenue, highlighting the importance of loyalty programs.
* **Seasonality:** Time-series analysis identified specific months with peak growth percentages, aiding in inventory planning.
* **Customer Health:** Segmentation logic isolated dormant users, creating actionable lists for re-engagement campaigns.

## 🤝 Contributing
Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/yourusername/ecommerce-eda/issues).

---
*Author: Nitin KS*
