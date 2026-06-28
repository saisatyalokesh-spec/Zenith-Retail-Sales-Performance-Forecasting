# 🛒 Zenith Retail — Sales Performance & Forecasting

> An end-to-end retail analytics project covering data cleaning, SQL analytics, exploratory data analysis, time series decomposition, and RFM-based customer segmentation — built on the Superstore dataset.

---

## 📌 Project Overview

Zenith Retail is a full-stack data analytics project that transforms raw retail transaction data into actionable business intelligence. The pipeline spans Python-based data preparation, a MySQL analytical layer with views and stored procedures, in-depth EDA with visualizations, and machine learning-driven customer segmentation.

---

## 📁 Repository Structure

```
zenith-retail/
│
├── Zenith_Retail_Sales_Performance_Forecasting.ipynb   # Data cleaning & SQL pipeline
├── EDA_Zenith_Forecasting.ipynb                        # EDA, time series & RFM segmentation
├── Zenith_Master_Script.sql                            # MySQL views, procedures & full report
├── Superstore_Formatted.csv                            # Cleaned & formatted source data
├── Full_report.csv                                     # Output of the SQL full report
└── README.txt
```

---

## 🔧 Tech Stack

| Layer | Tools |
|---|---|
| Language | Python 3.x |
| Data Manipulation | pandas, numpy |
| Visualization | matplotlib, seaborn |
| Machine Learning | scikit-learn (KMeans, StandardScaler) |
| Time Series | statsmodels (seasonal_decompose) |
| Database | MySQL 8.x |
| ORM / Connector | SQLAlchemy, PyMySQL |
| Storage Formats | CSV, Parquet (PyArrow) |

---

## 🗂️ Pipeline Stages

### 1. Data Cleaning (`Zenith_Retail_Sales_Performance_Forecasting.ipynb`)

- Removed duplicate `(Order ID, Product ID)` pairs
- Standardized city and region names (title case, abbreviation mapping: `"Nyc"` → `"New York City"`, etc.)
- Filled missing city values with `"Unknown"`
- Converted `Sales` and `Profit` to numeric; coerced errors
- Parsed and standardized `Order Date` and `Ship Date` to `YYYY-MM-DD`
- Exported cleaned data to both CSV and Parquet for downstream use
- Loaded data into MySQL (`zenith_retail` database) via SQLAlchemy

---

### 2. MySQL Analytics Layer (`Zenith_Master_Script.sql`)

Five analytical views and one stored procedure are created:

| View | Description |
|---|---|
| `vw_monthly_revenue` | Monthly revenue, profit, order count & margin % |
| `vw_category_rankings` | Product category sales ranked with RANK() & DENSE_RANK() |
| `vw_vip_customers` | Customers segmented into VIP / High / Mid / Regular via NTILE(10) |
| `vw_low_inventory_alert` | High-velocity products flagged for restocking with recommended qty |
| `vw_declining_margins` | High-frequency products with profit margin < 10% |

**Stored Procedure:** `sp_zenith_full_report()` — runs all six report sections in a single call.

```sql
CALL zenith_retail.sp_zenith_full_report();
```

---

### 3. Exploratory Data Analysis (`EDA_Zenith_Forecasting.ipynb`)

#### Data Overview
- Dataset shape inspection, dtype audit, missing value check
- Simulated a `Returns` column (30% Yes / 55% No / 15% NaN), imputed via mode, and binarized

#### Feature Engineering
- Extracted `Order Year`, `Order Month`, `Order Quarter`, `Order Day` from `Order Date`
- Computed `Shipping Days` = Ship Date − Order Date

#### Visualizations Generated
| File | Chart |
|---|---|
| `01_Distribution.png` | Sales & Profit distribution histograms with mean lines |
| `02_Correlation.png` | Heatmap of Sales, Quantity, Profit, Discount correlations |
| `03_Regional_Outliers.png` | Box plots of Sales by region with outlier counts |
| `peak_months.png` | Monthly sales bar chart with peak months highlighted in red |
| `monthly_pattern.png` | Seasonal monthly sales pattern across all years |

#### Time Series Analysis
- Aggregated daily sales; applied **additive seasonal decomposition** (period = 365)
- Extracted trend direction, peak month, and low month
- Identified top 10 peak months globally and top 3 per region

---

### 4. RFM Customer Segmentation (`EDA_Zenith_Forecasting.ipynb`)

**RFM (Recency, Frequency, Monetary)** analysis was performed to classify customers:

| Segment | Criteria |
|---|---|
| **Loyalists** | Above-median frequency & monetary value |
| **At Risk** | Recency above 75th percentile (haven't purchased recently) |
| **Bargain Hunters** | Monetary value below 25th percentile |

- Features scaled with `StandardScaler`
- Clusters found using **KMeans (k=3, random_state=42)**
- Visualized in 2D scatter and 3D multi-angle plots

#### Output Files
```
customer_segments.csv          # Customer ID + RFM scores + segment label
superstore_with_segments.csv   # Full dataset merged with segment labels
segmentation_report.txt        # Auto-generated segment summary report
rfm_3d_plot.png                # 3D RFM scatter plot
rfm_3d_multiple_views.png      # Three-angle 3D view
```

---

## 🚀 Getting Started

### Prerequisites

```bash
pip install pandas numpy matplotlib seaborn scikit-learn statsmodels sqlalchemy pymysql pyarrow openpyxl
```

### MySQL Setup

1. Run `Zenith_Master_Script.sql` in your MySQL client to create the database, views, and stored procedure.
2. Update the connection string in the notebook with your credentials:

```python
engine = create_engine('mysql+pymysql://<user>:<password>@<host>/zenith_retail')
```

### Running the Notebooks

```bash
# Step 1 — Data cleaning and MySQL ingestion
jupyter notebook Zenith_Retail_Sales_Performance_Forecasting.ipynb

# Step 2 — EDA, time series, and segmentation
jupyter notebook EDA_Zenith_Forecasting.ipynb
```

---

## 📊 Key Business Insights

- **Revenue trends** tracked month-over-month with profit margin percentages
- **Category rankings** identify top-performing and underperforming product lines
- **VIP customer identification** via decile-based spend segmentation
- **Inventory alerts** flag high-velocity products needing immediate restocking
- **Declining margin alerts** surface profitable-looking products silently losing money
- **RFM segmentation** enables targeted retention, win-back, and discount strategies

---

## 📄 Data Source

Based on the publicly available **Sample Superstore** dataset — a widely used retail benchmark dataset containing orders, products, customers, and regional sales data across the United States.

---

## 👤 Author

**Zenith Retail Analytics Project**
Built as a portfolio demonstration of end-to-end data analytics skills across SQL, Python, EDA, and ML.
**Sai Satya Lokesh**

Aspiring Data Analyst | Python | SQL | Machine Learning | Power BI

**LinkedIn:** *https://www.linkedin.com/in/sai-satya-lokesh-676906283/*

**GitHub:** *https://github.com/saisatyalokesh-spec*
