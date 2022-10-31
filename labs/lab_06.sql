CREATE VIEW nys_cnty_v AS
SELECT *
FROM counties
WHERE statefp = '36';

CREATE TABLE restaurant_geom_geog (
name TEXT,
lat NUMERIC,
lon NUMERIC
);

ALTER TABLE restaurant_geom_geog
ADD id serial PRIMARY KEY;

ALTER TABLE restaurant_geom_geog
ADD geom geometry(POINT, 4326),
ADD geog geography(POINT, 4326);

SELECT * FROM restaurant_geom_geog;

UPDATE restaurant_geom_geog
SET geom = ST_SetSRID(ST_Point(lon,lat),4269);

UPDATE restaurant_geom_geog
SET geog = ST_SetSRID(ST_Point(lon,lat),4326)::geography;

SELECT Find_SRID('public', 'counties', 'geom');
SELECT Find_SRID('public', 'restaurant_geom_geog', 'geom');
SELECT UpdateGeometrySRID('public','restaurant_geom_geog','geom',4326);

SELECT geom, ST_AsEWKT(geom)
FROM restaurant_geom_geog;

CREATE EXTENSION postgis;

ALTER TABLE restaurant_geom_geog
ALTER COLUMN geom TYPE geometry(POINT, 4326);

WITH nys_cnty AS (
SELECT *
FROM counties
WHERE statefp = '36'
)
SELECT r.*
FROM restaurant_geom_geog AS r, nys_cnty AS nys
WHERE ST_Within(r.geom, nys.geom);

SELECT r.*, nys.countyfp, nys.name
FROM restaurant_geom_geog AS r
JOIN nys_cnty_v AS nys
ON ST_Contains(nys.geom, r.geom);

SELECT nys.countyfp, nys.name, COUNT(*) AS numrst, COUNT(CASE r.name WHEN 'MCD' THEN 1 ELSE NULL END) AS nummcd, COUNT(CASE r.name WHEN 'PZH' THEN 1 ELSE NULL END) AS numpzh
FROM nys_cnty_v AS nys
JOIN restaurant_geom_geog AS r
ON ST_Contains(nys.geom, r.geom)
GROUP BY nys.countyfp, nys.name
ORDER BY numrst DESC;