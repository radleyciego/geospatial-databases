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

SELECT nys.countyfp, nys.name, COUNT(*) AS numrst, COUNT(CASE r.name WHEN 'MCD' THEN 1 ELSE NULL END) AS nummcd, COUNT(CASE r.name WHEN 'PZH' THEN 1 ELSE NULL END) AS numpzh, COUNT(name) AS value_occurance
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

/* Query the total number of parcels and their average assessed values in the MapPLUTO dataset within
1000, 2000, and 5000 feet from each restaurant */
```