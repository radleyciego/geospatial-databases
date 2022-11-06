# Lab 07: Update and Proximity with PostGIS
<br> Radley Ciego </br>
<br> November 7, 2022 </br>
<br> GTECH 78519: Geospatial Databases </br>
<br> Lab 7, Q1: </br>

```sql
-- update missing and exceptional mapPLUTO assessed values with spatial average
WITH pluto AS (
	SELECT p.gid AS gid, AVG(p1.assesstot) AS avgval
	FROM public.mappluto AS p        
	JOIN public.mappluto AS p1
	ON ST_DWithin(p.geom, p1.geom, 800 * 0.3048) -- convert 800 feet to meters
	WHERE p.assesstot IS NULL OR p.assesstot < 1000 
	GROUP BY p.gid)
UPDATE public.mappluto AS p
![SET assesstot = pluto.avgval
FROM pluto
WHERE (p.assesstot IS NULL OR p.assesstot < 1000) AND p.gid = pluto.gid;

SELECT p.gid, p.borough, p.block, p.lot, p.address, p.assesstot::money AS assessedvalue, p.geom
FROM public.mappluto AS p
ORDER BY assesstot ASC;
```
<br> Results in pgAdmin: </br>
![Lab 7, Q1 results:](/img/L7Q1.png)

```sql
-- find the closest 5 restaurants to each subway station. Include restaurant name and distance to station
SELECT s.name, r1.name AS n_closest_restaurant
FROM
	mtastations AS s
	CROSS JOIN LATERAL
	(
		SELECT name, id, geom
		FROM restaurant_geom_geog AS r
		ORDER BY s.geom <-> r.geom
		LIMIT 5
) AS r1;
```

<br> Results in pgAdmin: </br>
![Lab 7, q2 results:](/img/l7q2.png)