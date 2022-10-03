# Lab 01: Basic SQL Query PostgreSQL
<br> Radley Ciego <br>
<br> September 19, 2022 <br>
<br> GTECH 78519: Geospatial Databases <br>
<br> Lab 1, Q1: <br>

```sql
-- Select all customers where first name are equal to Kelly and Tony
SELECT *
FROM customer
WHERE first_name = 'Kelly' OR first_name = 'Tony'
```

<br> Results in pgAdmin: <br>

![Lab 1, Q1 Results:](/img/l1q1.png)

<br> Lab 1, Q2: <br>

```sql
-- Select all films where length is over 120 minutes
SELECT *
FROM film
WHERE length > 120 
```
<br> Results in pgAdmin: <br>

![Lab 1, Q2 Results:](/img/l1q2.png)

<br> Lab 1, Q3: <br>

```sql
-- We use the WHERE function to filter films that have descriptions like drama or documentary

SELECT * FROM public.film
WHERE description LIKE '%Drama%' OR description LIKE '%Documentary%';
```

<br> Results in pgAdmin: <br>

![Lab 1, Q3 Results:](/img/l1q3.png)

<br> Lab 1, Q4: <br> 

```sql
/* 
Category fields are established to reflect drama and documentary films using the SELECT... AS category 
functions and create num fields using COUNT(*) AS num. To determine the average length of
those films, we use the AVG function and round the result to two decimals using ,2 to create
an avglen field
*/

SELECT 'drama' AS category, count(*) AS num, round(AVG(length),2) as avglen
FROM film
WHERE description LIKE '%Drama%';

SELECT 'documentary' AS category, count(*) AS num, round(AVG(length),2) as avglen
FROM film
WHERE description LIKE '%Documentary%';
```

<br> Results in pgAdmin: <br>

![Lab 1, Q4](/img/l1q4.png)

<br> Lab 1, Q5: <br>

```sql
/*
Group all first and last names using the GROUP BY function and aggregate the total number 
of times each name appears using the COUNT(*) function which also establishes a field 'n'.
The number of name occurances is in organized descending order
*/
SELECT first_name, COUNT(*) N FROM public.actor
GROUP BY first_name
ORDER BY n DESC;

SELECT last_name, COUNT(*) N FROM public.actor
GROUP BY last_name
ORDER BY n DESC;
```

<br> Results in pgAdmin: <br>

![Lab 1, Q5](/img/l1q5.png)