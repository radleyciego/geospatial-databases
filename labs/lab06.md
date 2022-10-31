# Lab 06: Spatial Queries in PostGIS
<br> Radley Ciego </br>
<br> October 31, 2022 </br>
<br> GTECH 78519: Geospatial Databases </br>
<br> Lab 6, Q1: </br>

``` sql
/* Use spatial queries to create a table that contains all restaurants in New York. 
The table sould contain county FIPS code and county name where the restaurant is located */

CREATE VIEW nys_cnty_v AS
SELECT *
FROM counties
WHERE statefp = '36';

SELECT Find_SRID('public','counties','geom');
SELECT Find_SRID('public','restaurant_geom_geog', 'geom');

SELECT geom, ST_AsEWKT(geom)
FROM restaurant_geom_geog;

WITH nys_cnty AS (
    SELECT *
    FROM counties
    WHERE statefp = '36'
)
SELECT r.*
FROM restaurant_geom_geog AS r, nys_cnty AS nys
WHERE ST_Within(r.geom, nys.geom);

SELECT r.*, nys.countyfp, nys.name
FROM restaurant_geom_geog AS r
JOIN nys_cnty_v AS nys
ON ST_Contains(nys.geom, r.geom);

/* Run spatial query to create a table showing NYS county names, FIP codes, 
the total number of restaurants in each county, the total number of McDonalds,
the total number of Pizza Huts, and the brand that has the most stores in each county */

SELECT nys.countyfp, nys.name, COUNT(*) AS numrst, COUNT(CASE r.name WHEN 'MCD' THEN 1 ELSE NULL END) AS nummcd, COUNT(CASE r.name WHEN 'PZH' THEN 1 ELSE NULL END) AS numpzh, MODE() WITHIN GROUP (ORDER BY r.name) AS most_freq
FROM nys_cnty_v AS nys
JOIN restaurant_geom_geog AS r
ON ST_Contains(nys.geom, r.geom)
GROUP BY nys.countyfp, nys.name
ORDER BY numrst DESC;
```

<br> Results in pgAdmin: </br>
![L6, Q1 results](/img/l6q1.png)
![L6, Q1 results](/img/l6q1.1.png)

<br> Lb 6, Q2: </br>

``` sql

-- Query the total number of restaueants within 200, 500, and 1000 mters from each McDonald's restaurant
CREATE TABLE nys_rst_200 AS
WITH nys_cnty AS (
	SELECT *
	FROM counties
	WHERE statefp='36'
), nys_rst AS (
	SELECT r.*
	FROM restaurant_geom_geog AS r, nys_cnty AS nys
	WHERE ST_Within(r.geom, nys.geom)
)
SELECT r1.name, r1.geom, r1.geog,
	COUNT(*) - 1 AS rst_num_200,
	COUNT(r2.name='MCD') AS mcd1,
	SUM((r2.name='MCD')::integer)-1 AS mcd2
FROM nys_rst AS r1
JOIN nys_rst AS r2
ON ST_DWithin(r1.geog, r2.geog, 200)
WHERE r1.name = 'MCD'
GROUP BY r1.geom, r1.geog, r1.name;

CREATE TABLE nys_rst_500 AS
WITH nys_cnty AS (
	SELECT *
	FROM counties
	WHERE statefp='36'
), nys_rst AS (
	SELECT r.*
	FROM restaurant_geom_geog AS r, nys_cnty AS nys
	WHERE ST_Within(r.geom, nys.geom)
)
SELECT r3.name, r3.geom, r3.geog,
	COUNT(*) - 1 AS rst_num_500,
	COUNT(r4.name='MCD') AS mcd1,
	SUM((r4.name='MCD')::integer)-1 AS mcd2
FROM nys_rst AS r3
JOIN nys_rst AS r4
ON ST_DWithin(r3.geog, r4.geog, 500)
WHERE r3.name = 'MCD'
GROUP BY r3.geom, r3.geog, r3.name;

CREATE TABLE nys_rst_1000 AS
WITH nys_cnty AS (
	SELECT *
	FROM counties
	WHERE statefp='36'
), nys_rst AS (
	SELECT r.*
	FROM restaurant_geom_geog AS r, nys_cnty AS nys
	WHERE ST_Within(r.geom, nys.geom)
)
SELECT r5.name, r5.geom, r5.geog,
	COUNT(*) - 1 AS rst_num_1000,
	COUNT(r6.name='MCD') AS mcd1,
	SUM((r6.name='MCD')::integer)-1 AS mcd2
FROM nys_rst AS r5
JOIN nys_rst AS r6
ON ST_DWithin(r5.geog, r6.geog, 1000)
WHERE r5.name = 'MCD'
GROUP BY r5.geom, r5.geog, r5.name;

ALTER TABLE nys_rst_200 
ADD COLUMN id serial PRIMARY KEY;

ALTER TABLE nys_rst_500 
ADD COLUMN id serial PRIMARY KEY;

ALTER TABLE nys_rst_1000 
ADD COLUMN id serial PRIMARY KEY;

CREATE TABLE join_200_500_1000 AS
SELECT r.id, r.name, r1.rst_num_200, r3.rst_num_500, r5.rst_num_1000
FROM restaurant_geom_geog AS r
LEFT JOIN nys_rst_200 r1
ON r.id=r1.id
LEFT JOIN nys_rst_500 r3
ON r3.id=r.id
LEFT JOIN nys_rst_1000 r5
ON r5.id=r.id;

<br> Results in pgAdmin: </br>
![Lab 6, Q2](/img/l6q2.png)
```