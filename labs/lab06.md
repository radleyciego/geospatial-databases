# Lab 06: Spatial Queries in PostGIS
<br> Radley Ciego </br>
<br> October 31, 2022 </br>
<br> GTECH 78519: Geospatial Databases </br>
<br> Lab 6, Q1: </br>

``` sql
-- Use spatial queries to create a table that contains all restaurants in New York. The table sould contain county FIPS code and county name where the restaurant is located

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
```

<br> Results in pgAdmin: </br>
![L6, Q1 results](/img/l6q1.png)