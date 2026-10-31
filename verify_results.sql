USE ROLE SYSADMIN;
USE WAREHOUSE REDGRAVE_WH;
SELECT TO_VARCHAR(sales_date) AS sales_date, write_mode, attempt, paid_orders, paid_revenue_gbp
FROM REDGRAVE.LAB.DAILY_SALES ORDER BY sales_date, write_mode, attempt;
SELECT sales_date, COUNT(*) AS rows_per_day, MIN(write_mode) AS write_mode, MAX(attempt) AS last_attempt
FROM REDGRAVE.LAB.DAILY_SALES
WHERE sales_date BETWEEN '2026-08-01' AND '2026-08-07'
GROUP BY sales_date ORDER BY sales_date;
SELECT runtime, status, COUNT(*) AS result_count FROM REDGRAVE.LAB.DBT_RESULTS
WHERE runtime = 'airflow' GROUP BY runtime, status;
SHOW WAREHOUSES LIKE 'REDGRAVE_TF%';
SHOW SCHEMAS LIKE 'MARTS' IN DATABASE REDGRAVE_TF;
SELECT question, answer FROM REDGRAVE.LAB.ANSWERS WHERE lab='RED-401' ORDER BY question;
