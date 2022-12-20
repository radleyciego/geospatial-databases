# Final Project: NYC Transportation Access and Household Income Spatial Analysis
<br> Radley Ciego <br>
<br> December 19, 2022 <br>
<br> GTECH 78519: Geospatial Databases <br>

<br> Research Questions: What is the average income of New York City residents who live within a quarter mile of a subway station? What are the ten stations with the highest and lowest average income within a quarter mile? Which borough has the lowest percentage of households with an average income < $40,000? How many census tracts have a median income > $75,000? </br>

```
# import shapefiles into database using psql
shp2pgsql -s 4326 tl_2018_36_tract.shp public.nytracts | psql -h localhost -p 1841 -d learnsql -U postgres
shp2pgsql -s 4326 geo_export_3f16bb8e-d03a-4349-9c66-df51376b8f05.shp public.subway | psql -h localhost -p 1841 -d learnsql -U postgres
shp2pgsql -s 4326 geo_export_efa04990-1f75-412c-996b-a2a5ac6c4534.shp public.mtastations | psql -h localhost -p 1841 -d learnsql -U postgres
```

![Subway stations](/img/f2.png)
![Subway lines](/img/f4.png)
![Census tracts](/img/f3.png)

```sql
-- query NY census tract data, create NYC table
CREATE TABLE nyctracts AS (
SELECT * FROM nytracts
WHERE (countyfp = '005' OR countyfp = '081' OR countyfp = '047' OR countyfp = '061' OR countyfp = '085')
AND (aland != '0'));
```
![NYC Census Tracts](/img/f1.png)

```sql
-- Check the spatial reference systems for tables
ALTER TABLE nyctracts
ADD COLUMN geom_3748 geometry(MULTIPOLYGON, 3748);

UPDATE nyctracts
SET geom_3748=ST_Transform(geom, 3748);

ALTER TABLE subway
ADD COLUMN geom_3748 geometry(MULTILINESTRING, 3748);

UPDATE subway
SET geom_3748=ST_Transform(geom, 3748);

ALTER TABLE mtastations
ADD COLUMN geom_3748 geometry(POINT, 3748);

UPDATE mtastations
SET geom_3748=ST_Transform(geom, 3748);
```

![](/img/f6.png)
![](/img/f7.png)
![](/img/f8.png)

```sql
-- Create and import acs census data 
CREATE TABLE acs_5yr_geoheader
(fileid character varying(6), 
 stusab character varying(2) NOT NULL, 
 sumlevel integer,
 component character varying(2),
 logrecno integer NOT NULL,
 us character varying(1),
 region character varying(1),
 division character varying(1),
 statece character varying(2),
 state character varying(2),
 county character varying(3),
 cousub character varying(5),
  place character varying(5),
  tract character varying(6),
  blkgrp character varying(1),
  concit character varying(5),
  aianhh character varying(4),
  aianhhfp character varying(5),
  aihhtli character varying(1),
  aitsce character varying(3),
  aits character varying(5),
  anrc character varying(5),
  cbsa character varying(5),
  csa character varying(3),
  metdiv character varying(5),
  macc character varying(1),
  memi character varying(1),
  necta character varying(5),
  cnecta character varying(3),
  nectadiv character varying(5),
  ua character varying(5),
  blank1 character varying(5),
  cdcurr character varying(2),
  sldu character varying(3),
  sldl character varying(3),
  blank2 character varying(6),
  blank3 character varying(3),
  zcta5 character varying(5),
  submcd character varying(5),
  sdelm character varying(5),
  sdsec character varying(5),
  sduni character varying(5),
  ur character varying(1),
  pci character varying(1),
  blank5 character varying(6),
  blank6 character varying(5),
  puma5 character varying(5),
  blank7 character varying(5),
  geoid character varying(40),
  name character varying(1000),
  bttr character varying(6),
  btbg character varying(1),
  blank8 character varying(44),
  CONSTRAINT geoheader_pkey PRIMARY KEY (stusab, logrecno));
```

```sql
-- Create view of household income data joined to census shapefile
CREATE VIEW vw_tract_household_income AS
SELECT
substr(geoid, 8) AS geoid, b19001001 AS hh_total,
b19001002 AS hh_under_10k, b19001003 AS hh_10k_to_15k,
b19001004 AS hh_15k_to_20k, b19001005 AS hh_20k_to_25k,
b19001006 AS hh_25k_to_30k, b19001007 AS hh_30k_to_35k,
b19001008 AS hh_35k_to_40k, b19001009 AS hh_40k_to_45k,
b19001010 AS hh_45k_to_50k, b19001011 AS hh_50k_to_60k,
b19001012 AS hh_60k_to_75k, b19001013 AS hh_75k_to_100k,
b19001014 AS hh_100k_to_125k, b19001015 AS hh_125k_to_150k,
b19001016 AS hh_150k_to_200k, b19001017 AS hh_over_200k,
b19013001 AS median_hh_income, b19025001 AS aggregate_hh_income
FROM acs_5yr_seq0056 JOIN acs_5yr_geoheader USING (stusab, logrecno)
WHERE sumlevel = 140;
```
```sql
--  Identify the percentage of households with an income less than $40,000
SELECT
substr(geoid, 1, 5) AS county_fips, sum(hh_total) AS hh_total,
sum(hh_under_10k + hh_10k_to_15k + hh_15k_to_20k + hh_20k_to_25k
	+ hh_25k_to_30k + hh_30k_to_35k + hh_35k_to_40k) AS hh_under_40k,
100.0 * sum(hh_under_10k + hh_10k_to_15k + hh_15k_to_20k + hh_20k_to_25k
+ hh_25k_to_30k + hh_30k_to_35k + hh_35k_to_40k) /sum(hh_total) AS pct_hh_under_40k
FROM vw_tract_household_income
WHERE substr(geoid, 1, 5) IN ('36005', '36047', '36061','36081','36085')
GROUP BY county_fips;
```

![](/img/f10.png)

```sql
-- Determine how many census tracts have a median income of more than 75,000
SELECT *
FROM vw_tract_household_income
WHERE median_hh_income > 75000
```

![](/img/f9.png)

```sql
-- Create 1/4 buffer around each station for analysis, visualize in QGIS
CREATE TABLE mta_income_buffer AS
SELECT gid, line, name, ST_Buffer(geom_3748, 402.336) AS geom
FROM vw_geo_nyc_station
```

![](/img/f12.png)

```sql
-- Determine the average household income within a quarter mile of each station, order by average income ascending
SELECT s.name, ROUND(sum(aggregate_hh_income)/sum(hh_total)) AS avg_hh_income
FROM geo_nyc_tract_income i JOIN vw_geo_nyc_station s
ON (ST_Dwithin(i.geom_3748, s.geom_3748, 402.336))
GROUP BY s.name
ORDER BY avg_hh_income ASC

-- Order by average income descending
SELECT s.name, ROUND(sum(aggregate_hh_income)/sum(hh_total)) AS avg_hh_income
FROM geo_nyc_tract_income i JOIN vw_geo_nyc_station s
ON (ST_Dwithin(i.geom_3748, s.geom_3748, 402.336))
GROUP BY s.name
ORDER BY avg_hh_income DESC
```

![](/img/f11.png)
![](/img/f13.png)
