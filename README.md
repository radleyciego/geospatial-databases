# Geospatial Databases
 Spatial SQL lab assignments for GTECH 78519: Geospatial Databases course.

## Lab 1
### Basic SQL SELECT query

All customers whose first name is Kelly or Tony
''' SQL
SELECT *
FROM customers
WHERE first_name ('Kelly','Tony')
'''
