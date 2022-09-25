# Lab 02 Assignment: SQL Statements in PostgreSQL
Radley Ciego

September 29, 2022

GTECH 78519: Geospatial Databases

<br> Lab 2, Q1 <br>

SQL code: <br>

```sql
-- Make a copy of the payment table using CREATE TABLE ... AS
CREATE TABLE payment_bk AS
SELECT * FROM payment 
```