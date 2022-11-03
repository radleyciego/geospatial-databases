# Lab 07: Update and Proximity with PostGIS
<br> Radley Ciego </br>
<br> November 7, 2022 </br>
<br> GTECH 78519: Geospatial Databases </br>
<br> Lab 7, Q1: </br>

```sql
-- update missing and exceptional mapPLUTO assessed values with spatial average

```

```sql
-- find the closest 5 restaurants to each subway station. Include restaurant name and distance to station
SELECT r.name, ROUND(ST_Distance(r.geom, s.geom))
FROM restaurant_geom_geog AS r, mtastations AS s;
```
