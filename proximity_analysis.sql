/*******************************************************************************
1. GEOSPATIAL DATA PREPARATION
We convert raw latitude/longitude columns into Geometric POINT types for 
efficient distance calculations.
*******************************************************************************/

-- Standardizing customer locations
CREATE TEMP TABLE customer_points AS (
  SELECT
    customer_id,
    point(longitude, latitude) AS lng_lat_point
  FROM customers
  WHERE longitude IS NOT NULL AND latitude IS NOT NULL
);

-- Standardizing dealership locations
CREATE TEMP TABLE dealership_points AS (
  SELECT
    dealership_id,
    point(longitude, latitude) AS lng_lat_point
  FROM dealerships
);

/*******************************************************************************
2. DISTANCE MATRIX & OPTIMIZATION
We calculate the distance between every customer and every dealership. 
The <@> operator returns the distance in statute miles.
*******************************************************************************/

CREATE TEMP TABLE customer_dealership_distance AS (
  SELECT
    customer_id,
    dealership_id,
    c.lng_lat_point <@> d.lng_lat_point AS distance
  FROM customer_points c
  CROSS JOIN dealership_points d
);

-- Using DISTINCT ON to isolate the SINGLE closest dealership for each customer.
-- Sorting by distance ensures the 'first' record per customer is the nearest one.
CREATE TEMP TABLE closest_dealerships AS (
  SELECT DISTINCT ON (customer_id)
    customer_id,
    dealership_id,
    distance
  FROM customer_dealership_distance
  ORDER BY customer_id, distance ASC
);

/*******************************************************************************
3. BUSINESS INSIGHTS & DESCRIPTIVE STATISTICS
We compare the Mean vs. Median to detect skewness and identify potential 
'Service Deserts' or data quality issues.
*******************************************************************************/

SELECT
  ROUND(AVG(distance)::numeric, 2) AS avg_dist_miles,
  PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY distance) AS median_dist_miles,
  COUNT(*) FILTER (WHERE distance > 200) AS high_distance_outliers
FROM closest_dealerships;
