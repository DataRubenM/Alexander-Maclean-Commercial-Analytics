-- ============================================================
-- ALEXANDER MACLEAN COMMERCIAL ANALYTICS PROJECT
-- Author: Ruben Martin Lopez
-- Database: alexander_maclean
-- Description: Multi-dataset commercial analytics covering
--              Sales (2020-2022), HR (1983-2017), and
--              E-Learning Market Analysis (Udemy, edX, Coursera)
-- ============================================================


-- ============================================================
-- SECTION 1: DATABASE SETUP
-- ============================================================

CREATE DATABASE alexander_maclean;
GO

USE alexander_maclean;
GO


-- ============================================================
-- SECTION 2: CREATE TABLES
-- ============================================================

-- Sales data (2020-2022) — 11,000 rows
CREATE TABLE sales (
    order_date    DATE,
    order_id      VARCHAR(20),
    customer_name VARCHAR(100),
    segment       VARCHAR(50),
    country       VARCHAR(50),
    city          VARCHAR(50),
    location      VARCHAR(50),
    product_id    VARCHAR(20),
    category      VARCHAR(50),
    product_name  VARCHAR(200),
    sales         DECIMAL(10,2),
    quantity      INT,
    company_name  VARCHAR(100),
    expiry_date   DATE
);
GO

-- HR data (1983-2017) — 384 rows
CREATE TABLE hr (
    emp_id               INT,
    gender               VARCHAR(5),
    age_years            DECIMAL(5,2),
    date_of_joining      DATE,
    year_of_joining      INT,
    month_of_joining     INT,
    age_in_company_years DECIMAL(5,2),
    salary               DECIMAL(10,2),
    monthly_salary       DECIMAL(10,2),
    city                 VARCHAR(50),
    current_employee     VARCHAR(5),
    function             VARCHAR(50)
);
GO

-- Udemy market data (2011-2017) — 3,678 rows
CREATE TABLE udemy (
    course_id       INT,
    course_title    VARCHAR(300),
    is_paid         VARCHAR(10),
    price           DECIMAL(8,2),
    num_subscribers INT,
    num_reviews     INT,
    num_lectures    INT,
    level           VARCHAR(50),
    content_duration DECIMAL(6,2),
    published_year  INT,
    subject         VARCHAR(100)
);
GO

-- Coursera market data — 891 rows
CREATE TABLE coursera (
    course_title      VARCHAR(300),
    organization      VARCHAR(200),
    certificate_type  VARCHAR(100),
    rating            DECIMAL(3,1),
    difficulty        VARCHAR(50),
    students_enrolled INT
);
GO


-- ============================================================
-- SECTION 3: IMPORT DATA (BULK INSERT)
-- ============================================================

BULK INSERT sales
FROM 'C:\Users\Admin\OneDrive\Desktop\DATA SETS\Cleaned Data\files\sales_clean.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK);
GO

BULK INSERT hr
FROM 'C:\Users\Admin\OneDrive\Desktop\DATA SETS\Cleaned Data\files\hr_clean.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK);
GO

BULK INSERT udemy
FROM 'C:\Users\Admin\OneDrive\Desktop\DATA SETS\Cleaned Data\files\udemy_clean.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK);
GO

BULK INSERT coursera
FROM 'C:\Users\Admin\OneDrive\Desktop\DATA SETS\Cleaned Data\files\coursera_clean.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', TABLOCK);
GO


-- ============================================================
-- SECTION 4: VERIFY ROW COUNTS
-- ============================================================

-- Expected: sales=11000, hr=384, udemy=3678, coursera=891
SELECT 'sales'    AS table_name, COUNT(*) AS rows FROM sales
UNION ALL
SELECT 'hr',                     COUNT(*) FROM hr
UNION ALL
SELECT 'udemy',                  COUNT(*) FROM udemy
UNION ALL
SELECT 'coursera',               COUNT(*) FROM coursera;


-- ============================================================
-- SECTION 5: SALES ANALYSIS QUERIES
-- ============================================================

-- ------------------------------------------------------------
-- Query 1: Total revenue and quantity sold
-- ------------------------------------------------------------
SELECT
    SUM(sales)    AS total_revenue,
    SUM(quantity) AS total_quantity_sold,
    COUNT(*)      AS total_orders
FROM sales;


-- ------------------------------------------------------------
-- Query 2: Sales by year
-- ------------------------------------------------------------
SELECT
    YEAR(order_date)    AS year,
    SUM(sales)          AS total_revenue,
    SUM(quantity)       AS total_quantity,
    COUNT(*)            AS total_orders
FROM sales
GROUP BY YEAR(order_date)
ORDER BY year;


-- ------------------------------------------------------------
-- Query 3: Sales by country
-- ------------------------------------------------------------
SELECT
    country,
    SUM(sales)    AS total_revenue,
    SUM(quantity) AS total_quantity,
    COUNT(*)      AS total_orders
FROM sales
GROUP BY country
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- Query 4: Sales by category
-- ------------------------------------------------------------
SELECT
    category,
    SUM(sales)          AS total_revenue,
    SUM(quantity)       AS total_quantity,
    ROUND(100.0 * SUM(sales) / SUM(SUM(sales)) OVER(), 1) AS pct_of_total
FROM sales
GROUP BY category
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- Query 5: Top 10 best selling courses
-- ------------------------------------------------------------
SELECT TOP 10
    product_name,
    SUM(quantity) AS total_sold,
    SUM(sales)    AS total_revenue
FROM sales
GROUP BY product_name
ORDER BY total_sold DESC;


-- ------------------------------------------------------------
-- Query 6: Bottom 10 worst selling courses
-- ------------------------------------------------------------
SELECT TOP 10
    product_name,
    SUM(quantity) AS total_sold,
    SUM(sales)    AS total_revenue
FROM sales
GROUP BY product_name
ORDER BY total_sold ASC;


-- ------------------------------------------------------------
-- Query 7: Sales by location (Site vs Hub)
-- ------------------------------------------------------------
SELECT
    location,
    SUM(sales)    AS total_revenue,
    SUM(quantity) AS total_quantity,
    ROUND(100.0 * SUM(sales) / SUM(SUM(sales)) OVER(), 1) AS pct_of_total
FROM sales
GROUP BY location
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- Query 8: Monthly sales trend
-- ------------------------------------------------------------
SELECT
    YEAR(order_date)  AS year,
    MONTH(order_date) AS month,
    DATENAME(MONTH, order_date) AS month_name,
    SUM(sales)        AS total_revenue
FROM sales
GROUP BY YEAR(order_date), MONTH(order_date), DATENAME(MONTH, order_date)
ORDER BY year, month;


-- ============================================================
-- SECTION 6: HR ANALYSIS QUERIES
-- ============================================================

-- ------------------------------------------------------------
-- Query 9: Workforce overview
-- ------------------------------------------------------------
SELECT
    COUNT(*)                                    AS total_employees,
    COUNT(CASE WHEN current_employee = 'Y' THEN 1 END) AS active_employees,
    ROUND(AVG(age_years), 1)                    AS avg_age,
    ROUND(AVG(salary), 0)                       AS avg_salary,
    ROUND(AVG(age_in_company_years), 1)         AS avg_tenure_years
FROM hr;


-- ------------------------------------------------------------
-- Query 10: Retention rate
-- ------------------------------------------------------------
SELECT
    COUNT(*)                                                    AS total_employees,
    COUNT(CASE WHEN current_employee = 'Y' THEN 1 END)         AS active_employees,
    ROUND(100.0 * COUNT(CASE WHEN current_employee = 'Y' THEN 1 END) / COUNT(*), 2) AS retention_pct
FROM hr;


-- ------------------------------------------------------------
-- Query 11: Average salary by department and gender
-- ------------------------------------------------------------
SELECT
    function        AS department,
    gender,
    COUNT(*)        AS headcount,
    ROUND(AVG(salary), 0)  AS avg_salary,
    MIN(salary)     AS min_salary,
    MAX(salary)     AS max_salary
FROM hr
GROUP BY function, gender
ORDER BY function, gender;


-- ------------------------------------------------------------
-- Query 12: Headcount by city
-- ------------------------------------------------------------
SELECT
    city,
    COUNT(*)        AS total_employees,
    ROUND(AVG(salary), 0) AS avg_salary,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 1) AS pct_of_workforce
FROM hr
GROUP BY city
ORDER BY total_employees DESC;


-- ------------------------------------------------------------
-- Query 13: Staff additions by year
-- ------------------------------------------------------------
SELECT
    year_of_joining AS year,
    COUNT(*)        AS new_starters
FROM hr
GROUP BY year_of_joining
ORDER BY year;


-- ------------------------------------------------------------
-- Query 14: Salary by tenure band
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN age_in_company_years BETWEEN 0  AND 5  THEN '0-5 years'
        WHEN age_in_company_years BETWEEN 6  AND 10 THEN '6-10 years'
        WHEN age_in_company_years BETWEEN 11 AND 15 THEN '11-15 years'
        WHEN age_in_company_years BETWEEN 16 AND 20 THEN '16-20 years'
        WHEN age_in_company_years BETWEEN 21 AND 25 THEN '21-25 years'
        WHEN age_in_company_years BETWEEN 26 AND 30 THEN '26-30 years'
        ELSE '31+ years'
    END AS tenure_band,
    COUNT(*)              AS headcount,
    ROUND(AVG(salary), 0) AS avg_salary
FROM hr
GROUP BY
    CASE
        WHEN age_in_company_years BETWEEN 0  AND 5  THEN '0-5 years'
        WHEN age_in_company_years BETWEEN 6  AND 10 THEN '6-10 years'
        WHEN age_in_company_years BETWEEN 11 AND 15 THEN '11-15 years'
        WHEN age_in_company_years BETWEEN 16 AND 20 THEN '16-20 years'
        WHEN age_in_company_years BETWEEN 21 AND 25 THEN '21-25 years'
        WHEN age_in_company_years BETWEEN 26 AND 30 THEN '26-30 years'
        ELSE '31+ years'
    END
ORDER BY avg_salary;


-- ------------------------------------------------------------
-- Query 15: Gender distribution
-- ------------------------------------------------------------
SELECT
    gender,
    COUNT(*)  AS headcount,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_of_workforce,
    ROUND(AVG(salary), 0) AS avg_salary
FROM hr
GROUP BY gender;


-- ============================================================
-- SECTION 7: E-LEARNING MARKET ANALYSIS QUERIES
-- ============================================================

-- ------------------------------------------------------------
-- Query 16: Udemy — total market overview
-- ------------------------------------------------------------
SELECT
    COUNT(*)              AS total_courses,
    SUM(num_subscribers)  AS total_subscribers,
    SUM(price * num_subscribers) AS estimated_revenue,
    ROUND(AVG(price), 2)  AS avg_price,
    ROUND(AVG(num_reviews), 0) AS avg_reviews
FROM udemy;


-- ------------------------------------------------------------
-- Query 17: Udemy — top 10 courses by subscribers
-- ------------------------------------------------------------
SELECT TOP 10
    course_title,
    subject,
    num_subscribers,
    num_reviews,
    price,
    level
FROM udemy
ORDER BY num_subscribers DESC;


-- ------------------------------------------------------------
-- Query 18: Udemy — revenue by subject
-- ------------------------------------------------------------
SELECT
    subject,
    COUNT(*)              AS num_courses,
    SUM(num_subscribers)  AS total_subscribers,
    ROUND(AVG(price), 2)  AS avg_price,
    SUM(price * num_subscribers) AS estimated_revenue
FROM udemy
GROUP BY subject
ORDER BY estimated_revenue DESC;


-- ------------------------------------------------------------
-- Query 19: Udemy — paid vs free courses
-- ------------------------------------------------------------
SELECT
    is_paid,
    COUNT(*)             AS num_courses,
    SUM(num_subscribers) AS total_subscribers,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 1) AS pct_of_courses
FROM udemy
GROUP BY is_paid;


-- ------------------------------------------------------------
-- Query 20: Coursera — top 10 courses by enrolment
-- ------------------------------------------------------------
SELECT TOP 10
    course_title,
    organization,
    students_enrolled,
    rating,
    difficulty,
    certificate_type
FROM coursera
ORDER BY students_enrolled DESC;


-- ------------------------------------------------------------
-- Query 21: Coursera — enrolment by difficulty level
-- ------------------------------------------------------------
SELECT
    difficulty,
    COUNT(*)              AS num_courses,
    SUM(students_enrolled) AS total_enrolled,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(AVG(students_enrolled), 0) AS avg_enrolled_per_course
FROM coursera
GROUP BY difficulty
ORDER BY total_enrolled DESC;


-- ------------------------------------------------------------
-- Query 22: Coursera — top organisations by enrolment
-- ------------------------------------------------------------
SELECT TOP 10
    organization,
    COUNT(*)               AS num_courses,
    SUM(students_enrolled) AS total_enrolled,
    ROUND(AVG(rating), 2)  AS avg_rating
FROM coursera
GROUP BY organization
ORDER BY total_enrolled DESC;
