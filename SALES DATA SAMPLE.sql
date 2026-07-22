CREATE TABLE sales_data_sample (
    ordernumber INT,
    quantityordered INT,
    priceeach NUMERIC(10,2),
    orderlinenumber INT,
    sales NUMERIC(12,2),
    orderdate TIMESTAMP,
    status text,
    qtr_id INT,
    month_id INT,
    year_id INT,
    productline VARCHAR(50),
    msrp INT,
    productcode VARCHAR(30),
    customername VARCHAR(100),
    addressline1 VARCHAR(100),
    city text,
    country text,
    dealsize text
);
SELECT *
FROM sales_data_sample
LIMIT 5;

SELECT COUNT(*)
FROM sales_data_sample;

--checking for blank values
--blank values
SELECT *
FROM sales_data_sample
WHERE customername = ''
   OR city = ''
   OR country = '';
   
--Replacing blank values
UPDATE sales_data_sample
SET city = 'Unknown'
WHERE TRIM(city) = '';

DELETE FROM sales_data_sample
WHERE customername IS NULL;

-- duplicate rows
SELECT ordernumber, COUNT(*)
FROM sales_data_sample
GROUP BY ordernumber
HAVING COUNT(*) > 1;

--task 2: CORE QUERIES
--WHERE

SELECT *
FROM sales_data_sample
WHERE sales > 500;

SELECT *
FROM sales_data_sample
WHERE country='USA';

--ORDER BY

SELECT customername,
sales
FROM sales_data_sample
ORDER BY sales DESC;

--GROUP BY

SELECT country,
SUM(sales) AS total_sales
FROM sales_data_sample
GROUP BY country
ORDER BY total_sales DESC;

--HAVING
--Countries with total sales above 100000

SELECT country,
SUM(sales) AS total_sales
FROM sales_data_sample
GROUP BY country
HAVING SUM(sales)>100000;

--Aggregate Functions
--Average sales
SELECT AVG(sales)
FROM sales_data_sample;

--Highest sale
SELECT MAX(sales)
FROM sales_data_sample;

--Lowest sale
SELECT MIN(sales)
FROM sales_data_sample;

--Total orders
SELECT COUNT(*)
FROM sales_data_sample;

--Task 3: Advanced SQL
--Subquery
---Customers spending above average
SELECT customername,
sales
FROM sales_data_sample
WHERE sales >(
SELECT AVG(sales)
FROM sales_data_sample
);

--ROW_NUMBER()
SELECT
customername,
sales,
ROW_NUMBER() OVER
(ORDER BY sales DESC)
FROM sales_data_sample;

--RANK()
SELECT
customername,
sales,
RANK() OVER
(ORDER BY sales DESC)
FROM sales_data_sample;

--PARTITION BY
Top sales within each country

SELECT
country,
customername,
sales,
RANK() OVER
(PARTITION BY country
ORDER BY sales DESC)
FROM sales_data_sample;

--Task 4: Business Questions
1. Top 10 Customers
SELECT
customername,
SUM(sales) AS total_sales
FROM sales_data_sample
GROUP BY customername
ORDER BY total_sales DESC
LIMIT 10;

2. Top Products
SELECT
productline,
SUM(sales) AS total_sales
FROM sales_data_sample
GROUP BY productline
ORDER BY total_sales DESC
LIMIT 10;

3. Revenue Trend
SELECT
year_id,
SUM(sales) AS revenue
FROM sales_data_sample
GROUP BY year_id
ORDER BY year_id;

4. Customer Purchasing Behaviour
SELECT
customername,
COUNT(ordernumber) AS orders,
SUM(sales) AS total_spent
FROM sales_data_sample
GROUP BY customername
ORDER BY total_spent DESC;

--Task 5: Query Optimization
indexes on frequently searched columns.

CREATE INDEX idx_customer
ON sales_data_sample(customername);

CREATE INDEX idx_country
ON sales_data_sample(country);

CREATE INDEX idx_orderdate
ON sales_data_sample(orderdate);