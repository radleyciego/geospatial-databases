# Lab 05: Spatial Functions in PostGIS
<br> Radley Ciego </br>
<br> October 24, 2022 </br>
<br> GTECH 78519: Geospatial Databases </br>
<br> Lab 5, Q1: </br>

```sql
-- Create a spatial table for NYS counties, set srid to UTM-18
CREATE TABLE nys_counties AS
SELECT * FROM counties
WHERE "state_name" = 'New York'

ALTER TABLE nys_counties
ADD COLUMN geom_3748 geometry(MULTIPOLYGON, 3748)
```
```sql
-- Import NYC MapPLUTO shapefile into PostgreSQL
```

```
shp2pgsql -s 3748 MapPLUTO.shp public.nycPLUTO | ./psql -h localhost -**** -d learnsql -U radleyciego
```

``` sql
-- Create a separate MapPLUTO table for NYC with the columns for id, zipcode, ownertype, yearbuilt, assesstot, and geometry in State Plane Long Island reference system

CREATE TABLE mapPLUTO_buldings AS
SELECT gid, zipcode, ownertype, yearbuilt, assesstot, geom FROM mapPLUTO
```