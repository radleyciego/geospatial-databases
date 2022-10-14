# Lab 04: PostGIS and Basic Spatial Data Manipulation
<br> Radley Ciego </br>
<br> October 17, 2022 </br>
<br> GTECH 78519: Geospatial Databases </br>
<br> Lab 4, Q1: </br>

| SRID in PostGIS | Spatial Reference System Name | Datum Used | Distance Unit | Projection | Applicable Regions/Areas |
| --------------- | ----------------------------- | ---------- | ------------- | ---------- | ------------------------ |
| 4326            | WGS 1984                      | WGS84      | Degree        | longlat    | World                    |
| 3395            | World Mercator                | WGS84      | Meter         | Mercator   | World - 80ºS & 84ºN      |
| 4269            | WGS 1984                      | NAD83      | Degree        | longlat    | North America            |
| ESRI:102003     | Albers for Contiguous US      | NAD83      | Meter         | AEA        | USA - CONUS - Onshore    |
| ESRI:102004     | Lambert for Contiguous US     | NAD84      | Meter         | Lambert    | USA - CONUS - Onshore    |
| 3725            | UTM 18N                       | NAD83      | Meter         | Mercator   | USA - 78ºW & 72ºW        |
| 3748            | UTM 18N                       | NAD83      | Meter         | Mercator   | USA - 78ºW & 72ºW        |
| 2263            | SPCS Long Island              | NAD83      | Feet          | Lambert    | New York                 |
| 2831            | SPCS Long Island              | NAD83 HARN | Meter         | Lambert    | New York/Long Island     |
| 3627            | NAD83(NSRS2007) / New York Long Island | NAD83 (2007) | Feet  | Lambert | New York/Long Island     |
| 3628            | NAD83(NSRS2007) / New York Long Island | NAD83 (2007) | Feet | Lambert  | New York/Long Island     |

```sql
-- Use SQL SELECT to show that all SRIDs are in the spatial_ref_systems
SELECT * FROM spatial_ref_sys
ORDER BY srid ASC
```
<br> Results in pg Admin: </br>

![L4 Q1 result:](/img/l4q1.png)

<br> Lab 4, Q2: </br>

```
cd /Users/radleyciego/GitHub/geospatial-databases/data/cb_2020_us_county_500k
shp2pgsql -s 4326 cb_2020_us_county_500k.shp public.counties | psql -h localhost -**** -d learnsql -U ****  
```

```sql
-- Check the SRID of the country geometry column. If necessary, update the columd's SRID to an appropriate one
SELECT ST_SRID(geom) FROM counties
```

