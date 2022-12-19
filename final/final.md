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
-- Create and import acs geoheader table
CREATE TABLE acs2011_5yr_geoheader
(fileid character varying(6), -- Always equal to ACS Summary File identification
 stusab character varying(2) NOT NULL, -- State Postal Abbreviation
 sumlevel integer, -- Summary Level
 component character varying(2), -- Geographic Component
 logrecno integer NOT NULL, -- Logical Record Number
 us character varying(1), -- US
 region character varying(1), -- Census Region
 division character varying(1), -- Census Division
 statece character varying(2), -- State (Census Code)
 state character varying(2), -- State (FIPS Code)
 county character varying(3), -- County of current residence
 cousub character varying(5), -- County Subdivision (FIPS)
  place character varying(5), -- Place (FIPS Code)
  tract character varying(6), -- Census Tract
  blkgrp character varying(1), -- Block Group
  concit character varying(5), -- Consolidated City
  aianhh character varying(4), -- American Indian Area/Alaska Native Area/ Hawaiian Home Land (Census)
  aianhhfp character varying(5), -- American Indian Area/Alaska Native Area/ Hawaiian Home Land (FIPS)
  aihhtli character varying(1), -- American Indian Trust Land/ Hawaiian Home Land Indicator
  aitsce character varying(3), -- American Indian Tribal Subdivision (Census)
  aits character varying(5), -- American Indian Tribal Subdivision (FIPS)
  anrc character varying(5), -- Alaska Native Regional Corporation (FIPS)
  cbsa character varying(5), -- Metropolitan and Micropolitan Statistical Area
  csa character varying(3), -- Combined Statistical Area
  metdiv character varying(5), -- Metropolitan Statistical Area-Metropolitan Division
  macc character varying(1), -- Metropolitan Area Central City
  memi character varying(1), -- Metropolitan/Micropolitan Indicator Flag
  necta character varying(5), -- New England City and Town Area
  cnecta character varying(3), -- New England City and Town Combined Statistical Area
  nectadiv character varying(5), -- New England City and Town Area Division
  ua character varying(5), -- Urban Area
  blank1 character varying(5), -- Reserved for future use
  cdcurr character varying(2), -- Current Congressional District ***
  sldu character varying(3), -- State Legislative District Upper
  sldl character varying(3), -- State Legislative District Lower
  blank2 character varying(6), -- Reserved for future use
  blank3 character varying(3), -- Reserved for future use
  zcta5 character varying(5), -- 5-digit ZIP Code Tabulation Area
  submcd character varying(5), -- Subminor Civil Division (FIPS)
  sdelm character varying(5), -- State-School District (Elementary)
  sdsec character varying(5), -- State-School District (Secondary)
  sduni character varying(5), -- State-School District (Unified)
  ur character varying(1), -- Urban/Rural
  pci character varying(1), -- Principal City Indicator
  blank5 character varying(6), -- Reserved for future use
  blank6 character varying(5), -- Reserved for future use
  puma5 character varying(5), -- Public Use Microdata Area - 5% File
  blank7 character varying(5), -- Reserved for future use
  geoid character varying(40), -- Geographic Identifier
  name character varying(1000), -- Area Name
  bttr character varying(6), -- Tribal Tract
  btbg character varying(1), -- Tribal Block Group
  blank8 character varying(44),
  CONSTRAINT geoheader_pkey PRIMARY KEY (stusab, logrecno)) -- Reserved for future use;
```

```sql
-- Create and import acs household income table
CREATE TABLE acs2011_5yr_seq0056
(
  fileid character varying(50),
  filetype character varying(50),
  stusab character varying(2) NOT NULL,
  chariter character varying(3),
  seq character varying(4),
  logrecno integer NOT NULL,
  b19001001 double precision,
  b19001002 double precision,
  b19001003 double precision,
  b19001004 double precision,
  b19001005 double precision,
  b19001006 double precision,
  b19001007 double precision,
  b19001008 double precision,
  b19001009 double precision,
  b19001010 double precision,
  b19001011 double precision,
  b19001012 double precision,
  b19001013 double precision,
  b19001014 double precision,
  b19001015 double precision,
  b19001016 double precision,
  b19001017 double precision,
  b19001a001 double precision,
  b19001a002 double precision,
  b19001a003 double precision,
  b19001a004 double precision,
  b19001a005 double precision,
  b19001a006 double precision,
  b19001a007 double precision,
  b19001a008 double precision,
  b19001a009 double precision,
  b19001a010 double precision,
  b19001a011 double precision,
  b19001a012 double precision,
  b19001a013 double precision,
  b19001a014 double precision,
  b19001a015 double precision,
  b19001a016 double precision,
  b19001a017 double precision,
  b19001b001 double precision,
  b19001b002 double precision,
  b19001b003 double precision,
  b19001b004 double precision,
  b19001b005 double precision,
  b19001b006 double precision,
  b19001b007 double precision,
  b19001b008 double precision,
  b19001b009 double precision,
  b19001b010 double precision,
  b19001b011 double precision,
  b19001b012 double precision,
  b19001b013 double precision,
  b19001b014 double precision,
  b19001b015 double precision,
  b19001b016 double precision,
  b19001b017 double precision,
  b19001c001 double precision,
  b19001c002 double precision,
  b19001c003 double precision,
  b19001c004 double precision,
  b19001c005 double precision,
  b19001c006 double precision,
  b19001c007 double precision,
  b19001c008 double precision,
  b19001c009 double precision,
  b19001c010 double precision,
  b19001c011 double precision,
  b19001c012 double precision,
  b19001c013 double precision,
  b19001c014 double precision,
  b19001c015 double precision,
  b19001c016 double precision,
  b19001c017 double precision,
  b19001d001 double precision,
  b19001d002 double precision,
  b19001d003 double precision,
  b19001d004 double precision,
  b19001d005 double precision,
  b19001d006 double precision,
  b19001d007 double precision,
  b19001d008 double precision,
  b19001d009 double precision,
  b19001d010 double precision,
  b19001d011 double precision,
  b19001d012 double precision,
  b19001d013 double precision,
  b19001d014 double precision,
  b19001d015 double precision,
  b19001d016 double precision,
  b19001d017 double precision,
  b19001e001 double precision,
  b19001e002 double precision,
  b19001e003 double precision,
  b19001e004 double precision,
  b19001e005 double precision,
  b19001e006 double precision,
  b19001e007 double precision,
  b19001e008 double precision,
  b19001e009 double precision,
  b19001e010 double precision,
  b19001e011 double precision,
  b19001e012 double precision,
  b19001e013 double precision,
  b19001e014 double precision,
  b19001e015 double precision,
  b19001e016 double precision,
  b19001e017 double precision,
  b19001f001 double precision,
  b19001f002 double precision,
  b19001f003 double precision,
  b19001f004 double precision,
  b19001f005 double precision,
  b19001f006 double precision,
  b19001f007 double precision,
  b19001f008 double precision,
  b19001f009 double precision,
  b19001f010 double precision,
  b19001f011 double precision,
  b19001f012 double precision,
  b19001f013 double precision,
  b19001f014 double precision,
  b19001f015 double precision,
  b19001f016 double precision,
  b19001f017 double precision,
  b19001g001 double precision,
  b19001g002 double precision,
  b19001g003 double precision,
  b19001g004 double precision,
  b19001g005 double precision,
  b19001g006 double precision,
  b19001g007 double precision,
  b19001g008 double precision,
  b19001g009 double precision,
  b19001g010 double precision,
  b19001g011 double precision,
  b19001g012 double precision,
  b19001g013 double precision,
  b19001g014 double precision,
  b19001g015 double precision,
  b19001g016 double precision,
  b19001g017 double precision,
  b19001h001 double precision,
  b19001h002 double precision,
  b19001h003 double precision,
  b19001h004 double precision,
  b19001h005 double precision,
  b19001h006 double precision,
  b19001h007 double precision,
  b19001h008 double precision,
  b19001h009 double precision,
  b19001h010 double precision,
  b19001h011 double precision,
  b19001h012 double precision,
  b19001h013 double precision,
  b19001h014 double precision,
  b19001h015 double precision,
  b19001h016 double precision,
  b19001h017 double precision,
  b19001i001 double precision,
  b19001i002 double precision,
  b19001i003 double precision,
  b19001i004 double precision,
  b19001i005 double precision,
  b19001i006 double precision,
  b19001i007 double precision,
  b19001i008 double precision,
  b19001i009 double precision,
  b19001i010 double precision,
  b19001i011 double precision,
  b19001i012 double precision,
  b19001i013 double precision,
  b19001i014 double precision,
  b19001i015 double precision,
  b19001i016 double precision,
  b19001i017 double precision,
  b19013001 double precision,
  b19013a001 double precision,
  b19013b001 double precision,
  b19013c001 double precision,
  b19013d001 double precision,
  b19013e001 double precision,
  b19013f001 double precision,
  b19013g001 double precision,
  b19013h001 double precision,
  b19013i001 double precision,
  b19019001 double precision,
  b19019002 double precision,
  b19019003 double precision,
  b19019004 double precision,
  b19019005 double precision,
  b19019006 double precision,
  b19019007 double precision,
  b19019008 double precision,
  b19025001 double precision,
  b19025a001 double precision,
  b19025b001 double precision,
  b19025c001 double precision,
  b19025d001 double precision,
  b19025e001 double precision,
  b19025f001 double precision,
  b19025g001 double precision,
  b19025h001 double precision,
  b19025i001 double precision,
  CONSTRAINT seq0056_pkey PRIMARY KEY (stusab, logrecno)
);
```

```sql
-- Join household income data to geoheader
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
FROM acs2011_5yr_seq0056 JOIN acs2011_5yr_geoheader USING (stusab, logrecno)
WHERE sumlevel = 140;
```

```sql
-- Determine how many census tracts have a median income of more than 75,000
SELECT *
FROM vw_tract_household_income
WHERE median_hh_income > 75000
```

![](/img/f9.png)

```sql
-- Determine the average household income within a quarter mile of each station
SELECT s.name, sum(aggregate_hh_income)/sum(hh_total) AS avg_hh_income
FROM geo_nyc_tract_income i JOIN vw_geo_nyc_station s
ON (ST_Dwithin(i.geom_3748, s.geom_3748, 402.336))
GROUP BY s.name
```

![](/img/f11.png)
![](/img/f12.png)
