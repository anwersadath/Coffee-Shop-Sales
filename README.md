# ☕ Coffee Shop Sales SQL Project

This is a MySQL-based data analysis project for a fictional coffee shop. It focuses on extracting business insights from transactional sales data using SQL.

> 🔄 This project currently includes SQL-based analysis. Power BI dashboards based on the same dataset will be added soon under the `PowerBI/` folder.

---

## 📦 Project Overview

The project includes:
- Cleaning date and time columns
- Total sales calculation
- Month-over-month KPI comparisons
- Daily and hourly sales trends
- Weekday vs weekend performance
- Store and product performance

---

## 📊 Dataset Description

| Column Name        | Description                              |
|--------------------|------------------------------------------|
| transaction_id     | Unique ID for each transaction           |
| transaction_date   | Date of transaction (converted to DATE)  |
| transaction_time   | Time of transaction (converted to TIME)  |
| transaction_qty    | Quantity of products purchased           |
| store_id           | Store ID number                          |
| store_location     | Physical store location                  |
| product_id         | Product ID number                        |
| unit_price         | Price per unit                           |
| product_category   | E.g., Coffee, Tea, Pastry                |
| product_type       | Specific product name (e.g., Latte)      |
| product_detail     | Additional product detail                |

---

## 🔧 Key SQL Features Used

- `STR_TO_DATE()` for date/time formatting
- `LAG()` for month-over-month comparison
- `GROUP BY`, `CASE`, `ROUND`, `CONCAT`, `AVG()`, etc.
- Date/time functions like `MONTH()`, `DAY()`, `HOUR()`, `DAYOFWEEK()`
---
## 📈 Insights Generated

The SQL queries in this project provide insights such as:

- 📌 **Total sales** for the month of May
- 🔁 **Month-over-Month growth** in:
  - Total sales
  - Orders placed
  - Quantity sold
- 📆 **Daily sales** with comparison to average (Above/Below Average)
- ⏰ **Hourly trends** to identify peak sales hours
- 🗓️ **Weekday vs Weekend performance**
- 🏪 **Store-wise sales** comparison
- ☕ **Product category performance** (e.g., Coffee vs Tea)
- 🔝 **Top 10 products** by sales value
---
## 🛠️ How to Run

1. Import the dataset into a MySQL database.
   - Table name: `coffe_shop_sales`
2. Open `coffee_shop.sql` using MySQL Workbench, DBeaver, or any SQL editor.
3. Make sure `USE coffee_shop;` is executed first to select the correct database.
4. Run each query block step by step to see:
   - Cleaned data (dates/times)
   - Sales KPIs
   - Daily/hourly breakdown
   - Store/product-level performance
