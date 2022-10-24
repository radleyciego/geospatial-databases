# Lab 05: Spatial Functions in PostGIS
<br> Radley Ciego </br>
<br> October 24, 2022 </br>
<br> GTECH 78519: Geospatial Databases </br>
<br> Lab 5, Q1: </br>

```sql
-- Create a spatial table for NYS counties, set srid to UTM-18
CREATE TABLE nys_counties AS
SELECT * FROM counties
WHERE "state_name" = 'New York';

ALTER TABLE nys_counties
ADD COLUMN geom_3748 geometry(MULTIPOLYGON, 3748);
```
```sql
-- Import NYC MapPLUTO shapefile into PostgreSQL
```

```
shp2pgsql -s 3748 MapPLUTO.shp public.nycPLUTO | ./psql -h localhost -**** -d learnsql -U radleyciego
```

``` sql
-- Create a separate MapPLUTO table for NYC with the columns for id, zipcode, ownertype, yearbuilt, assesstot, and geometry in State Plane Long Island reference system
CREATE TABLE mapPLUTO_buildings AS
SELECT gid, zipcode, ownertype, yearbuilt, assesstot, geom FROM mapPLUTO;

SELECT UpdateGeometrySRID('public','mappluto_buldings','geom',2831);

SELECT ST_transform(geom,4326)
FROM mappluto_buldings
LIMIT 100;
```

``` sql
-- Make a separarate MapPLUTO table for one borough with the above columns
CREATE TABLE bronx_mapPLUTO AS
SELECT gid, zipcode, ownertype, yearbuilt, assesstot, geom FROM mapPLUTO
WHERE "borough" = 'BX';
```

``` sql
-- Check the spatial reference system for NYS_counties and mapPLUTO tables
SELECT Find_SRID('public','nys_counties','geom');

SELECT Find_SRID('public','mapPLUTO','geom');

-- Verify SRID
SELECT ST_Transform(geom,4326)
FROM nys_counties
LIMIT 100;

SELECT ST_Transform(geom,4326)
FROM mapPLUTO
LIMIT 100;
```
<br> Results in pgAdmin: </br>
![L5 Q2 results:](/img/l5q2.png)
![LB Q2 results:](/img/l5q2.1.png)