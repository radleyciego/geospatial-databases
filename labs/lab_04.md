# Lab 03: PostGIS and Spatial Data Types
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