# Final Project: NYC Transportation Access and Household Income Spatial Analysis
<br> Radley Ciego <br>
<br> December 19, 2022 <br>
<br> GTECH 78519: Geospatial Databases <br>

```
# import shapefiles into database using psql
shp2pgsql -s 4326 tl_2018_36_tract.shp public.nytracts | psql -h localhost -p 1841 -d learnsql -U postgres
shp2pgsql -s 4326 geo_export_3f16bb8e-d03a-4349-9c66-df51376b8f05.shp public.subway | psql -h localhost -p 1841 -d learnsql -U postgres
shp2pgsql -s 4326 geo_export_efa04990-1f75-412c-996b-a2a5ac6c4534.shp public.mtastations | psql -h localhost -p 1841 -d learnsql -U postgres
```

![Subway stations](/img/f2.png)
![Subway lines](/img/f1.png)

```sql
-- query NY census tract data, create NYC table
CREATE TABLE nyctracts AS (
SELECT * FROM nytracts
WHERE (countyfp = '005' OR countyfp = '081' OR countyfp = '047' OR countyfp = '061' OR countyfp = '085')
AND (aland != '0'));
```

