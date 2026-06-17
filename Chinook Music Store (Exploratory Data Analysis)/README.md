# 🎵 Chinook Music Store Exploratory Data Analysis (SQL)

## Project Overview

This project explores the Chinook Music Store database using SQL to uncover customer purchasing behavior, sales trends, employee performance, and music preferences.

The analysis demonstrates the use of SQL for data exploration, aggregation, joins, Common Table Expressions (CTEs), window functions, and business insight generation.

---

## Database

The project uses the Chinook Database, a sample digital music store database containing information about:

* Customers
* Employees
* Invoices
* Invoice Lines
* Artists
* Albums
* Tracks
* Genres
* Media Types
* Playlists

---

## Objectives

The analysis was conducted to answer several business questions, including:

* Who are the highest-spending customers?
* Which artists have released the most albums?
* Which customers are assigned to each support representative?
* What does the employee reporting hierarchy look like?
* What music tracks do customers purchase?
* Which tracks are purchased most frequently?
* Which genres generate the highest sales?
* Which media types are most popular?
* Which albums contain the most tracks?
* Which playlists contain the most tracks?
* Which artists are preferred by individual customers?

---

## SQL Concepts Used

Throughout the project, the following SQL techniques were applied:

* SELECT statements
* Filtering with WHERE clauses
* Aggregate functions (COUNT, SUM)
* GROUP BY
* ORDER BY
* INNER JOINs
* LEFT JOINs
* Common Table Expressions (CTEs)
* Window Functions (ROW_NUMBER)
* Data Cleaning with DELETE and UPDATE statements
* Subqueries

---

## Key Analyses Performed

1. **Customer Spending Analysis** - Identified customers who generated the highest revenue for the music store by calculating total spending from invoice data.

2. **Artist Performance Analysis** - Determined which artists have the largest number of albums in the catalog.

3. **Customer Support Analysis** - Created customer lists grouped by support representatives to understand employee workload distribution.

4. **Employee Hierarchy Analysis** Mapped reporting relationships between employees and managers.

5. **Purchase Behavior Analysis** - Tracked the music tracks purchased by customers to understand buying patterns.

6. **Genre Analysis** - Analyzed which music genres are purchased most frequently.

7. **Media Type Analysis** - Investigated customer preferences for different media formats.

8. **Playlist Analysis** - Evaluated playlists based on the number of tracks they contain and performed data cleaning to remove duplicate playlists.

9. **Customer Music Preferences** - Used a Common Table Expression (CTE) to identify each customer's most-purchased artist.

---

## Files

* `Chinook music Exploratory Analysis.sql` [file link](https://github.com/MercyBundi/MySQL/blob/main/Chinook%20music/Chinook%20music%20Exploratory%20Analysis.sql) – SQL queries used for the analysis
* `datasets` - the files used in the project
* `README.md` – Project documentation

---

## Skills Demonstrated

* SQL Data Analysis
* Data Exploration
* Business Intelligence
* Relational Database Querying
* Data Cleaning
* Window Functions
* Common Table Expressions (CTEs)
* Query Optimization Fundamentals

---

## Business Value

The insights generated from this analysis can help a music retailer:

* Identify high-value customers
* Understand customer music preferences
* Optimize marketing campaigns
* Improve customer support allocation
* Evaluate catalog performance
* Support data-driven business decisions

---

## Tools Used

* MySQL
* SQL
* Chinook Sample Database

---

