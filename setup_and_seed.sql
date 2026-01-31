-- 1. SETUP: Create Tables
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name TEXT,
    longitude DOUBLE PRECISION,
    latitude DOUBLE PRECISION
);

CREATE TABLE dealerships (
    dealership_id SERIAL PRIMARY KEY,
    dealership_name TEXT,
    longitude DOUBLE PRECISION,
    latitude DOUBLE PRECISION
);

-- 2. SEEDING: Insert Mock Data (Focusing on the 147-mile mean vs 91-mile median story)
INSERT INTO customers (customer_name, longitude, latitude) VALUES
('Local Larry', -73.9352, 40.7306),    -- NYC
('Suburban Sue', -74.1724, 40.7357),   -- Newark (Close to NYC)
('Remote Rick', -76.6122, 39.2904),    -- Baltimore (Medium distance)
('Outlier Owen', -80.8431, 35.2271);   -- Charlotte (Very far - will skew the mean)

INSERT INTO dealerships (dealership_name, longitude, latitude) VALUES
('Main Street Motors', -73.9352, 40.7306), -- In NYC
('Jersey Hub', -74.0060, 40.7128);         -- Near NYC

-- Use this to reset the exercise environment
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS dealerships;
