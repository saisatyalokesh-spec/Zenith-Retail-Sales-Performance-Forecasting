# SQL Documentation
## Zenith Retail Sales Performance & Forecasting

---

# Project Overview

This document describes the SQL implementation used in the **Zenith Retail Sales Performance & Forecasting** project.

The SQL scripts are responsible for:

- Creating the retail database
- Creating normalized tables
- Defining Primary and Foreign Keys
- Importing cleaned retail data
- Performing business analytics
- Creating reusable SQL Views
- Optimizing queries for Power BI

---

# Database Management System

- **Database:** MySQL 8.0
- **Language:** SQL
- **Workbench:** MySQL Workbench

---

# Database Name

```
zenith_retail
```

---

# Database Schema

The database stores historical retail sales information.

Main entities include:

- Orders
- Customers
- Products
- Categories
- Regions
- Shipping Information

---

# Database Creation

The SQL script first creates the database.

```sql
CREATE DATABASE zenith_retail;

USE zenith_retail;
```

Purpose

- Creates a dedicated database.
- Sets it as the active working database.

---

# Table Creation

The project creates relational tables with appropriate constraints.

Example

```sql
CREATE TABLE orders (
    Order_ID VARCHAR(20) PRIMARY KEY,
    Order_Date DATE,
    Customer_ID VARCHAR(20),
    Product_ID VARCHAR(20),
    Sales DECIMAL(10,2),
    Quantity INT,
    Profit DECIMAL(10,2)
);
```

Purpose

- Stores retail order information.
- Ensures data integrity using Primary Keys.

---

# Primary Keys

Primary Keys uniquely identify each record.

Example

```sql
PRIMARY KEY (Order_ID)
```

Benefits

- Prevents duplicate records.
- Improves query performance.
- Supports table relationships.

---

# Foreign Keys

Foreign Keys establish relationships between tables.

Example

```sql
FOREIGN KEY (Product_ID)
REFERENCES Products(Product_ID);
```

Benefits

- Maintains referential integrity.
- Prevents invalid data.
- Enables relational queries.

---

# Data Import

The cleaned CSV dataset is imported into MySQL.

Imported data includes

- Sales
- Profit
- Quantity
- Customer
- Product
- Region
- Dates

---

# SQL Operations Performed

The project uses multiple SQL operations.

## SELECT

Retrieves required records.

Example

```sql
SELECT *
FROM Orders;
```

---

## WHERE

Filters data.

Example

```sql
SELECT *
FROM Orders
WHERE Sales > 500;
```

---

## ORDER BY

Sorts results.

Example

```sql
SELECT *
FROM Orders
ORDER BY Sales DESC;
```

---

## GROUP BY

Groups similar records.

Example

```sql
SELECT Region,
SUM(Sales)
FROM Orders
GROUP BY Region;
```

---

## HAVING

Filters grouped records.

Example

```sql
SELECT Region,
SUM(Sales)
FROM Orders
GROUP BY Region
HAVING SUM(Sales) > 100000;
```

---

# Aggregate Functions

The project uses

- SUM()
- AVG()
- MAX()
- MIN()
- COUNT()

Example

```sql
SELECT
SUM(Sales),
AVG(Profit),
COUNT(*)
FROM Orders;
```

---

# Joins Used

The project uses SQL joins for combining multiple tables.

### INNER JOIN

Returns matching records.

```sql
SELECT *
FROM Orders
INNER JOIN Products
ON Orders.Product_ID = Products.Product_ID;
```

---

### LEFT JOIN

Returns all records from the left table.

```sql
SELECT *
FROM Customers
LEFT JOIN Orders
ON Customers.Customer_ID = Orders.Customer_ID;
```

---

# Window Functions

Window Functions perform calculations without collapsing rows.

Functions used include

- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- SUM() OVER()
- AVG() OVER()

Example

```sql
SELECT
Customer_Name,
Sales,
RANK() OVER(
ORDER BY Sales DESC
) AS Sales_Rank
FROM Orders;
```

---

# Common Table Expressions (CTE)

Used to simplify complex SQL queries.

Example

```sql
WITH MonthlySales AS
(
SELECT
MONTH(Order_Date) AS Month,
SUM(Sales) AS TotalSales
FROM Orders
GROUP BY MONTH(Order_Date)
)

SELECT *
FROM MonthlySales;
```

---

# SQL Views

SQL Views were created to simplify Power BI reporting.

Example

```sql
CREATE VIEW vw_sales_summary AS

SELECT
Region,
SUM(Sales) AS TotalSales,
SUM(Profit) AS TotalProfit
FROM Orders
GROUP BY Region;
```

Benefits

- Faster reporting
- Cleaner SQL
- Easier Power BI integration

---

# Analytical Queries

Business insights generated include

## Total Sales

```sql
SELECT
SUM(Sales)
FROM Orders;
```

---

## Monthly Sales

```sql
SELECT
MONTH(Order_Date),
SUM(Sales)
FROM Orders
GROUP BY MONTH(Order_Date);
```

---

## Top Customers

```sql
SELECT
Customer_Name,
SUM(Sales)
FROM Orders
GROUP BY Customer_Name
ORDER BY SUM(Sales) DESC;
```

---

## Top Products

```sql
SELECT
Product_Name,
SUM(Sales)
FROM Orders
GROUP BY Product_Name
ORDER BY SUM(Sales) DESC;
```

---

## Regional Performance

```sql
SELECT
Region,
SUM(Sales),
SUM(Profit)
FROM Orders
GROUP BY Region;
```

---

## Category Performance

```sql
SELECT
Category,
SUM(Sales)
FROM Orders
GROUP BY Category;
```

---

# Power BI Integration

SQL Views are connected directly to Power BI.

Power BI consumes

- Sales Summary View
- Product Performance View
- Customer Performance View
- Regional Performance View
- Monthly Sales View

This reduces dashboard loading time and simplifies report creation.

---

# Query Optimization

Optimization techniques include

- Primary Keys
- Foreign Keys
- Indexes
- SQL Views
- Aggregate Queries
- Optimized Joins
- Reduced Redundant Calculations

---

# Data Validation

Validation checks include

- Duplicate records
- Missing values
- Null values
- Row counts
- Sales totals
- Profit totals
- Data consistency

---

# SQL Output

The SQL scripts generate

- Clean database
- Analytical tables
- Business reports
- SQL Views
- Power BI-ready datasets

---

# Skills Demonstrated

- SQL Programming
- Database Design
- Relational Database Management
- Data Import
- Data Validation
- SQL Views
- Window Functions
- Aggregate Functions
- CTEs
- Joins
- Query Optimization
- Power BI Integration
- Business Analytics

---

# Conclusion

The SQL component forms the backbone of the Zenith Retail Analytics project by creating a structured relational database, performing advanced business analysis, and supplying optimized datasets for Power BI dashboards and machine learning workflows. The implementation demonstrates practical SQL skills required in real-world data analytics projects, including database design, query optimization, analytical reporting, and business intelligence integration.