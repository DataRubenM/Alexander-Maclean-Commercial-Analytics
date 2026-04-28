# Alexander Maclean — Commercial Data Analytics Project

![SQL Server](https://img.shields.io/badge/SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Tableau](https://img.shields.io/badge/Tableau-E97627?style=for-the-badge&logo=tableau&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Excel](https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white)

## 📊 Project Overview

A comprehensive multi-dataset commercial analytics project delivered for **Alexander Maclean**, an education and training organisation operating across the UK and internationally. The project analysed four datasets covering sales performance, HR workforce metrics, and e-learning market trends across three major online course platforms.

The analysis was delivered in **December 2024** and covers data spanning from **1983 to 2022**, providing actionable insights to support strategic decision-making, operational efficiency and future growth planning.

---

## 🎯 Key Insights

### Sales (2020–2022)
- 💰 **£184.84M total revenue** generated across 11,000 orders
- 🌍 **Pakistan was the top performing country** — contributing £103.51M (56% of total revenue)
- 📚 **Courses category led sales** at £78.70M, followed by Diplomas (£69.64M) and Awards (£36.50M)
- 📉 **Sales declined -10.36% in 2022** — flagging a need for strategic intervention
- 🎨 **Graphic Design was the top selling course** with 34K units sold

### HR (1983–2017)
- 👥 **384 employees** across Liverpool and Warrington
- 💼 **85.42% retention rate** — above industry average
- 💷 **Average salary £66.15K** with IT department leading at £99K average
- 📊 **Gender split 55% Male / 45% Female** — relatively balanced workforce
- 📈 **Employees with 26–30 years tenure earn the highest average salary** at £78K

### E-Learning Market (Udemy & Coursera)
- 🎓 **Udemy generated £884.92M estimated revenue** from 11.76M subscribers
- 💻 **Web Development dominates** Udemy with 7.98M subscribers
- 🏛️ **Top Coursera institution** by enrolment was a leading global university
- 📖 **91.38% of Udemy courses are paid** — strong monetisation model
- ⭐ **Beginner level courses attract the most subscribers** (4.05M on Udemy)

---

## 🖥️ Dashboard Screenshots

### Sales Dashboard
Analysis of £184.84M revenue across countries, product categories and time periods.

![Sales Dashboard](screenshots/Sales_Dashboard.png)

---

### HR Analytics Dashboard
Workforce analysis covering 384 employees across salary, retention, gender and tenure.

![HR Dashboard](screenshots/HR_dashboard.png)

---

### Udemy Market Analysis Dashboard
Market analysis of 3,678 Udemy courses covering revenue, subscribers and subject popularity.

![Udemy Dashboard](screenshots/Dashboard_Udemy_Market_Analysis.png)

---

### edX Market Analysis Dashboard
Market analysis of 972 edX courses covering institutions, enrolment and course levels.

![edX Dashboard](screenshots/Dashboard_Edx_Market_Analysis.png)

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| **Python (pandas)** | Data cleaning and CSV preparation |
| **SQL Server (SSMS)** | Database design, data import and analysis queries |
| **Power BI & DAX** | Sales and HR interactive dashboards |
| **Tableau** | Udemy and edX market analysis dashboards |
| **Excel** | Initial data cleaning and exploration |
| **T-SQL** | Analytical queries across all 4 datasets |

---

## 📁 Project Structure

```
Alexander-Maclean-Commercial-Analytics/
│
├── README.md
│
├── sql/
│   └── alexander_maclean_queries.sql   # Full SQL script — 22 analysis queries
│
├── data/
│   ├── hr_clean.csv                    # HR data — 384 employees (1983–2017)
│   ├── sales_clean.csv                 # Sales data — 11,000 orders (2020–2022)
│   ├── udemy_clean.csv                 # Udemy courses — 3,678 rows
│   └── coursera_clean.csv              # Coursera courses — 891 rows
│
├── docs/
│   └── Task_12_Final_Report_RML.docx   # Full project report
│
├── dashboard/
│   └── Alexander_Maclean_Analytics.pbix
│
└── screenshots/
    ├── Sales_Dashboard.png
    ├── HR_dashboard.png
    ├── Dashboard_Udemy_Market_Analysis.png
    └── Dashboard_Edx_Market_Analysis.png
```

---

## 🗄️ Database Structure

Four tables were created in SQL Server (`alexander_maclean` database):

| Table | Rows | Description |
|-------|------|-------------|
| `sales` | 11,000 | Order-level sales data 2020–2022 |
| `hr` | 384 | Employee HR records 1983–2017 |
| `udemy` | 3,678 | Udemy course catalogue and metrics |
| `coursera` | 891 | Coursera course catalogue and enrolment |

### Key SQL Techniques Used
- `BULK INSERT` with `FORMAT = CSV` for data loading
- `CASE WHEN` for tenure band categorisation
- `SUM() OVER()` window functions for percentage calculations
- `GROUP BY` with multiple aggregations
- `TOP N` for best and worst performer analysis
- `DATENAME()` and `YEAR()` for date-based analysis
- `DECIMAL` precision for financial data

---

## 📐 Key SQL Queries

```sql
-- Sales by category with % of total
SELECT
    category,
    SUM(sales) AS total_revenue,
    ROUND(100.0 * SUM(sales) / SUM(SUM(sales)) OVER(), 1) AS pct_of_total
FROM sales
GROUP BY category
ORDER BY total_revenue DESC;

-- Retention rate
SELECT
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN current_employee = 'Y' THEN 1 END) AS active_employees,
    ROUND(100.0 * COUNT(CASE WHEN current_employee = 'Y' THEN 1 END) / COUNT(*), 2) AS retention_pct
FROM hr;

-- Udemy revenue by subject
SELECT
    subject,
    COUNT(*) AS num_courses,
    SUM(num_subscribers) AS total_subscribers,
    SUM(price * num_subscribers) AS estimated_revenue
FROM udemy
GROUP BY subject
ORDER BY estimated_revenue DESC;
```

---

## 📂 Data Sources

| Dataset | Source | Period | Rows |
|---------|--------|--------|------|
| Sales | Alexander Maclean (internal) | 2020–2022 | 11,000 |
| HR | Alexander Maclean (internal) | 1983–2017 | 384 |
| Udemy | Project leads | 2011–2017 | 3,678 |
| Coursera | Project leads | N/A | 891 |
| edX | Project leads | N/A | 975 |

> **Note:** Sales and HR data was provided directly by Alexander Maclean and has been anonymised where appropriate. E-learning data was sourced from public datasets provided by the project leads.

---

## 📋 Project Report

A full written report covering requirements analysis, data cleaning methodology, market findings, critical analysis and strategic recommendations is available in the `docs/` folder.

The report covers:
- Business and stakeholder requirements analysis
- Data cleaning methodology across Excel, Power BI and Tableau
- Market analysis and key findings for all 4 datasets
- Critical analysis and strategic recommendations
- Conclusions and future growth opportunities

---

## 👤 About

**Ruben Martin Lopez**
Business Analyst / Data Analyst — London, UK

7+ years experience across healthcare (NHS histology, HSL), commercial BI (Alexander Maclean), and business analysis (Reynolds & Parker Solutions).

**Key Skills:** SQL · Power BI · Tableau · Python · Excel · Agile

**Certifications:**
- BCS Foundation Certificate in Business Analysis v4.1 (March 2026)
- Data Analyst Associate
- MSc Molecular & Cellular Biology

🔗 [LinkedIn](https://www.linkedin.com/in/ruben-martin-lopez-599533240) | 💼 [Upwork](https://www.upwork.com/freelancers/~01bcd439bd20e08328?mp_source=share) | 🏥 [NHS A&E Analytics Project](https://github.com/DataRubenM/NHS-AE-Performance-Analytics)

---

*This project was delivered as a commercial analytics engagement for Alexander Maclean in December 2024.*
