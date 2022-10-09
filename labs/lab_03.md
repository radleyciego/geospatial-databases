# Lab 03: PostGIS and Spatial Data Types
<br> Radley Ciego <br>
<br> October 16, 2022 <br>
<br> GTECH 78519: Geospatial Databases <br>
<br> Lab 3, Q1: <br>

```sql
-- Create a table and import data from restaurant CSV, include primary key
CREATE TABLE restaurant (
    name TEXT,
    lat NUMERIC,
    lon NUMERIC
);

ALTER TABLE restaurant 
ADD id serial PRIMARY KEY;

-- Create the PostGIS extension with a geometry and geography column with subtype for points
CREATE EXTENSION postgis;

ALTER TABLE restaurant
ADD geom geometry(POINT, 4326)
ADD geog geography(POINT, 4326);
```

<br> Results in pgAdmin: <br>

![](img/)

<br> Lab 3, Q2: <br>

``` sql
-- Create spatial (geometry and geography) data from coordinates
UPDATE restaurant
SET geom = ST_SetSRID(ST_Point(lon,lat),4326);

UPDATE restaurant
SET geog = ST_SetSRID(ST_Point(lon,lat),4326)::geography;
```
<br> Results in pgAdmin: <br>

![](img/)

<br> Lab 3, Q3: <br>

```sql
-- Write SQL statements to find out the 10 restaurants closest to Hunter College main campus at 69th Street
SELECT name, ST_Transform(geom,4326),geom <-> 'SRID=4326;POINT(-73.963833 40.768444)'::geometry AS dist
FROM restaurant
ORDER BY dist ASC limit 10;
```