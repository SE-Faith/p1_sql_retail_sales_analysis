-- SQL Retail Sales  Analysis Project 1
-- Data Import

-- Create a new database to store retail sales data. This database will be used for analyzing sales transactions
create database sql_project_one;


-- Create the retail_sales table. This table stores transaction-level data.

use sql_project_one;
create table retail_sales (
	transactions_id int primary key,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(15),
	age int,
	category varchar(15),
	quantiy int,
	price_per_unit float,
	cogs float,
	total_sale float

)

select * from retail_sales
limit 10;

-- Data Cleaning

-- Count the total number of transactions in the dataset. This provides an overview of the dataset size

select count(*)
from retail_sales;

-- Check for NULL values in columns to ensure data quality before analysis

select * from retail_sales
where 
	transactions_id is null
    or
    sale_date is null
    or
    sale_time is null
    or
    customer_id is null
    or
    gender is null
    or
    age is null
    or
    category is null
    or
    quantiy is null
    or
    price_per_unit is null
    or
    cogs is null
    or
    total_sale is null;

-- Delete null values
delete from retail_sales
where 
	transactions_id is null
    or
    sale_date is null
    or
    sale_time is null
    or
    customer_id is null
    or
    gender is null
    or
    age is null
    or
    category is null
    or
    quantiy is null
    or
    price_per_unit is null
    or
    cogs is null
    or
    total_sale is null;

set sql_safe_updates = 0;


-- Data Exploration

-- Count the total number of sales transactions in the dataset
select count(*) as total_number_of_sales
from retail_sales;

-- Count the total number of unique customers
select count(distinct customer_id) as total_number_of_customers
from retail_sales;

-- Count the total number of product categories
select count(distinct category) as total_number_of_categories
from retail_sales;

-- List all distinct product categories available in the dataset
select distinct category
from retail_sales;



-- Data Analysis
-- 1. Retrieve all sales transactions that occurred on 5-11-2022 to analyze sales activity on that day
select *
from retail_sales
where sale_date = '2022-11-05';

-- 2. Identify clothing transactions where at least 4 items were sold during November 2022 to detect bulk clothing purchases in that month
select * from retail_sales
where
	category = 'Clothing'
    and
		quantity >= 4
	and 
		year(sale_date) = 2022
	and
		month(sale_date) = 11;
-- 3. Total revenue and number of orders for each product category to help determine which categories perform best in terms of sales
select category,
	sum(total_sale) as net_sale,
    count(*) as total_order
from retail_sales
group by category;

-- 4. Calculate the average age of customers who bought Beauty products
select round(avg(age), 2) as average_age_beauty
from retail_sales
where category = 'Beauty';

-- 5.Look for transactions with very high sales amounts i.e greater than 1000
select * from retail_sales
where total_sale > 1000;

-- 6. See how transactions are distributed by gender and category
select gender,
	count(transactions_id) as total_number_of_transactions,
    category
from retail_sales
group by gender,  category
order by category;

-- 7.  Find the best-performing month in each year based on average sales
select month, year, total_monthly_sale from 
(select month(sale_date) as month,
	year(sale_date) as year,
	round(avg(total_sale), 2) AS total_monthly_sale,
    rank() over(partition by year(sale_date) order by avg(total_sale) desc) as ranking
from retail_sales
group by month(sale_date), year(sale_date)
) as table_one
where ranking = 1;

-- 8. Identify the top 5 customers based on how much they spent in total
select 
	customer_id,
	sum(total_sale) as total_sale
from retail_sales
group by customer_id
order by total_sale desc
limit 5;

-- 9. Check how many unique customers bought items in each category
select 
	count(distinct customer_id) as number_of_unique_customers,
    category
from retail_sales
group by category;

-- 10. Group sales by time of day (shifts) to see when most orders happen
with shift_table as (
select 
	*,
    case 
		when hour(sale_time) < 12 then 'Morning'
        when hour(sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
        end as shift
from retail_sales
)
select shift,
count(*) as total_number_of_order
from shift_table
group by shift;

ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;

-- Project End