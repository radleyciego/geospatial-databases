# Lab 02 Assignment: SQL Statements in PostgreSQL
<br> Radley Ciego <br>
<br> September 29, 2022 <br>
<br> GTECH 78519: Geospatial Databases <br>
<br> Lab 2, Q1: <br>

```sql
-- Make a copy of the payment table using CREATE TABLE ... AS
CREATE TABLE payment_bk AS
SELECT * FROM payment 
```

<br> Results in pgAdmin: <br>

![Lab 2, Q1 Result:](img/q1.png)

<br> Lab 2, Q2: <br>

```sql
/* For a holiday promotion, the store plans to give 5% refund to the rental payment that is greater than $5.00. 
Add a new refund column of money type to the payment table and update the column values according to this
new promotion policy.*/ 

 ALTER TABLE payment
 ADD COLUMN refund money;

 UPDATE payment
 SET refund = (0.05*amount)::money
 WHERE amount > 5.00
```

<br> Results in pgAdmin: <br>

![Lab 2, Q2 Result:](img/q2.png)

<br> Lab 2, Q3: <br>

```sql
/* Create a new view using the updated payment table but with a new Boolean column is_refunded 
indicating if a refund is available. */

CREATE VIEW payment_view AS 
SELECT *, (refund::numeric)>0 AS is_refunded
FROM payment
ORDER BY refund DESC;
```

<br> Results in pgAdmin: <br>

![Lab 2, Q3 Result:](img/q3.png)