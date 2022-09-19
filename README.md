# Geospatial Databases
 Spatial SQL lab assignments for GTECH 78519: Geospatial Databases course.

## Lab 1
### Basic SQL SELECT query

All customers whose first name is Kelly or Tony
'''sql
SELECT * FROM customers WHERE first_name IN ('Kelly','Tony');
'''