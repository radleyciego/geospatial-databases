# Lab 08: Geometry Operations and Spatial Analysis
<br> Radley Ciego </br>
<br> November 14, 2022 </br>
<br> GTECH 78519: Geospatial Databases </br>
<br> Lab 8, Q1: </br>

```sql
-- import, clean and process brooklyn acs educational attainment data

```

<br> Lab 8, Q2: </br>

```sql
-- find the total population with a bachelor's degree or higher
CREATE TABLE bk_acs_5y_edu AS (
	SELECT hd01_vd01 AS totalpop, hd01_vd22 AS bachelor, hd01_vd23 AS masters, hd01_vd24 AS professional, hd01_vd25 AS doctorate
	FROM bk_acs_5y);
```