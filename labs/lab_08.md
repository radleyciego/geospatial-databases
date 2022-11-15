# Lab 08: Geometry Operations and Spatial Analysis
<br> Radley Ciego </br>
<br> November 14, 2022 </br>
<br> GTECH 78519: Geospatial Databases </br>
<br> Lab 8, Q1: </br>

```sql
-- import, clean and process brooklyn acs educational attainment and block group data
```

```
import pandas as pd
from sqlalchemy import create_engine

# read educational attainment csv
bk_acs = pd.read_csv('/Users/radleyciego/GitHub/geospatial-databases/data/Kings_Education_Attainment_ACS_17_5YR_B15003/ACS_17_5YR_B15003.csv')

# change columns to lowercase
bk_acs = bk_acs.rename(columns=str.lower)

# export dataframe to postgres
engine = create_engine('postgresql://radleyciego:Spot28@localhost:1841/learnsql')
bk_acs.to_sql('bk_acs_5y', engine)
```

```sql
CREATE TABLE bk_bg AS (
	SELECT * FROM blockgroips
	WHERE "statefp"=047);

ALTER TABLE bk_bg
ADD COLUMN geom3748 geometry(MULTIPOLYGON, 3748);

SELECT Find_SRID('public','bk_bg','geom');

UPDATE bk_bg
SET geom3748 ST_Transform(geom, 3748)

SELECT ST_Transform(geom, 4326) as geom_2
FROM bk_bg;

CREATE INDEX idx_geom
ON public.bk_bg USING gist
(geom3748)
TABLESPACE pg_default;

ALTER TABLE bk_bg ADD geoid2 bigint;

UPDATE bk_bg SET geoid2 = CAST(geoid AS bigint)

ALTER TABLE bk_bg
DROP COLUMN geoid;

-- join Brooklyn acs and block group data by geoid
CREATE TABLE bk_acs_bg_join AS 
	(SELECT *
	FROM bk_acs_5y_edu 
	JOIN bk_bg
	ON bk_acs_5y_edu."geo.id2" = bk_bg.geoid2;);
```

<br> Results in pgAdmin: </br>
![Lab8,q1 Results:](/img/l8q1.png)
![Lab8,q1 Results:](/img/l8q1.1.png)

<br> Lab 8, Q2: </br>

```sql
-- find the total population with a bachelor's degree or higher
CREATE TABLE bk_acs_5y_edu AS (
	SELECT hd01_vd01 AS totalpop, hd01_vd22 AS bachelor, hd01_vd23 AS masters, hd01_vd24 AS professional, hd01_vd25 AS doctorate
	FROM bk_acs_5y);

WITH bg AS
(
		SELECT *, ST_Transform(geom, 2263) AS geomft
		FROM bk_acs_bg_join
), sub_buf AS(
		SELECT *, ST_Buffer(ST_Transform(geom, 2263),200) as geombuf
		FROM mtastations)
SELECT b.*, ROUND(bg.bachelor/bg.totalpop::double precision*100) AS perc_bachelor, ROUND(bg.masters/bg.totalpop::double precision*100) AS perc_masters, ROUND(bg.professional/bg.totalpop::double precision*100) AS perc_professional, ROUND(bg.doctorate/bg.totalpop::double precision*100) AS perc_doctorate 
FROM sub_buf AS b
JOIN mht
ON ST_Intersects(b.geombuf,bg.geomft);

CREATE TABLE bg_acs_200 AS 
(WITH bg AS
(
		SELECT *, ST_Transform(geom, 2263) AS geomft
		FROM bk_acs_bg_join
), sub_buf AS(
		SELECT *, ST_Buffer(ST_Transform(geom, 2263),200) as geombuf
		FROM mtastations)
SELECT b.*, ROUND(bg.bachelor/bg.totalpop::double precision*100) AS perc_bachelor, ROUND(bg.masters/bg.totalpop::double precision*100) AS perc_masters, ROUND(bg.professional/bg.totalpop::double precision*100) AS perc_professional, ROUND(bg.doctorate/bg.totalpop::double precision*100) AS perc_doctorate 
FROM sub_buf AS b
JOIN bg
ON ST_Intersects(b.geombuf,bg.geomft));

CREATE TABLE bg_acs_500 AS 
(WITH bg AS
(
		SELECT *, ST_Transform(geom, 2263) AS geomft
		FROM bk_acs_bg_join
), sub_buf AS(
		SELECT *, ST_Buffer(ST_Transform(geom, 2263),500) as geombuf
		FROM mtastations)
SELECT b.*, ROUND(bg.bachelor/bg.totalpop::double precision*100) AS perc_bachelor, ROUND(bg.masters/bg.totalpop::double precision*100) AS perc_masters, ROUND(bg.professional/bg.totalpop::double precision*100) AS perc_professional, ROUND(bg.doctorate/bg.totalpop::double precision*100) AS perc_doctorate 
FROM sub_buf AS b
JOIN bg
ON ST_Intersects(b.geombuf,bg.geomft));

-- add id column to join tables
ALTER TABLE bg_acs_200 
ADD COLUMN id serial PRIMARY KEY;

ALTER TABLE bg_acs_500 
ADD COLUMN id serial PRIMARY KEY;

CREATE TABLE join_200_500 AS
SELECT m.line, m.name, b2.perc_bachelor_200, b5.perc_bachelor_500, b2.perc_masters_200, b5.perc_masters_500, b2.perc_professional_200, b5.perc_professional_500, b2.perc_doctorate_200, b5.perc_doctorate_500
FROM mtastations AS m
LEFT JOIN bg_acs_200 b2
ON m.gid=b2.id
LEFT JOIN bg_acs_500 b5
ON b5.id=m.gid
```

<br> Results in pgAdmin: </br>
![Lab8, Q2 results:](/img/l8q2.png)
![Lab 8 Q2 resutls:](/img/l8q2.1.png)