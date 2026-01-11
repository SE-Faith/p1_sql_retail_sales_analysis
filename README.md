# p1_sql_retail_sales_analysis
This is a beginner SQL project analyzing retail sales data using filtering, aggregation and date-based queries.


 # SQL Retail Sales Analysis 

## Project Overview
This project analyzes a retail sales dataset using SQL. It includes:

- Creating and importing data into a database  
- Cleaning and validating transactional data  
- Performing exploratory data analysis (EDA)  
- Running detailed queries to uncover insights about customers, products and sales trends  

The goal is to understand customer behavior, product performance and revenue patterns to support business decisions.

---

## Dataset
The dataset contains transaction-level retail sales data with the following columns:  

- `transactions_id`  
- `sale_date` & `sale_time`  
- `customer_id`, `gender`, `age`  
- `category`, `quantity`, `price_per_unit`, `cogs`, `total_sale`  


---

## Database & Table Structure

### Create Database
```sql
CREATE DATABASE sql_project_one;
```

### Create the retail_sales table
```sql
USE sql_project_one;
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```
#### View first 10 records
```sql
SELECT *
FROM retail_sales
LIMIT 10;
```
### Data Cleaning
-- Count total transactions
```sql
SELECT COUNT(*)
FROM retail_sales;
```

-- Check for NULL values
```sql
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
```

-- Delete NULL values
```sql
DELETE FROM retail_sales
WHERE transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

SET sql_safe_updates = 0;
```

### Data Exploration
```sql
SELECT COUNT(*) AS total_number_of_sales
FROM retail_sales;

SELECT COUNT(DISTINCT customer_id) AS total_number_of_customers
FROM retail_sales;

SELECT COUNT(DISTINCT category) AS total_number_of_categories
FROM retail_sales;

SELECT DISTINCT category
FROM retail_sales;
```
### Data Analysis
-- Sales transactions on 5th November 2022
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

-- Clothing transactions with 4 or more items in November 2022
```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
    AND quantity >= 4
    AND YEAR(sale_date) = 2022
    AND MONTH(sale_date) = 11;
```
-- Total revenue and number of orders per category
```sql
SELECT category,
       SUM(total_sale) AS net_sale,
       COUNT(*) AS total_order
FROM retail_sales
GROUP BY category;
```
-- Average age of customers who bought Beauty products
```sql
SELECT ROUND(AVG(age), 2) AS average_age_beauty
FROM retail_sales
WHERE category = 'Beauty';
```
-- Transactions with high sales amounts (> 1000)
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```
-- Transactions distribution by gender and category
```sql
SELECT gender,
       COUNT(transactions_id) AS total_number_of_transactions,
       category
FROM retail_sales
GROUP BY gender, category
ORDER BY category;
```

-- Best-performing month in each year based on average sales
```sql
SELECT month, year, total_monthly_sale
FROM (
    SELECT MONTH(sale_date) AS month,
           YEAR(sale_date) AS year,
           ROUND(AVG(total_sale), 2) AS total_monthly_sale,
           RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS ranking
    FROM retail_sales
    GROUP BY MONTH(sale_date), YEAR(sale_date)
) AS table_one
WHERE ranking = 1;
```

-- Top 5 customers by total spending
```sql
SELECT customer_id,
       SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale DESC
LIMIT 5;
```

-- Unique customers per category
```sql
SELECT COUNT(DISTINCT customer_id) AS number_of_unique_customers,
       category
FROM retail_sales
GROUP BY category;
```

-- Sales by time of day (shifts)
```sql
WITH shift_table AS (
    SELECT *,
           CASE 
               WHEN HOUR(sale_time) < 12 THEN 'Morning'
               WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
           END AS shift
    FROM retail_sales
)
SELECT shift,
       COUNT(*) AS total_number_of_order
FROM shift_table
GROUP BY shift;
```

-- Rename column typo
```sql
ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;
```


## Key Findings and Insights

#### Total Sales and Customers
-- Total transactions: 1,987
-- Total unique customers: 155
-- Number of product categories: 3 (Clothing, Beauty, Electronics)

#### Sales by Category
-- Electronics generated the highest total sales revenue.
-- Clothing had the highest number of orders.

#### Customer Demographics
-- Average age of customers buying Beauty products: 40 years.
-- Women accounted for 54% of Beauty product transactions.
-- Men purchased 50.3% Clothing and 50.6% Electronic items.

#### High-Value Transactions
-- Transactions with total sales greater than 1000 were mainly in Electronics and Clothing categories.

#### Peak Sales Periods
-- Morning: 27.6% of transactions
-- Afternoon: 19% of transactions
-- Evening: 53.5% of transactions
-- Evening is the busiest period for sales.

#### Best Performing Months
-- July and February had the highest average sales, likely due to seasonal shopping and promotions.

#### Top Customers
Top 5 customers with customer_id 3,1,5,2,4, contributed a significant portion of total revenue, showing a small segment of loyal or high-spending customers.


### Technologies Used
SQL (MySQL) – database creation, querying, and analysis


### Project Status
Completed
