# Geospatial Network Analysis: Customer Proximity Mapping

## Project Overview
This project performs a geospatial optimization analysis for a retail automotive network. The objective is to calculate the precise distance between the customer base and physical dealership locations. By identifying the nearest service point for every customer, the organization can improve marketing attribution and identify geographic "service deserts" where new dealerships may be required.
<img width="512" height="398" alt="image" src="https://github.com/user-attachments/assets/7ee68300-7483-4c59-b04b-85b5d1218132" />


## Business Objectives
* **Customer Engagement:** Provide localized marketing data to help customers find their nearest service center.
* **Network Optimization:** Use mean and median distance metrics to identify regions where physical coverage is insufficient.
* **Data Integrity:** Identify outliers in residential data that may indicate outdated customer records or coordinate errors.

---

## Repository Structure

| File | Description |
| :--- | :--- |
| `setup_and_seed.sql` | Schema definition and sample data population. |
| `proximity_analysis.sql` | The core geospatial logic and statistical summary. |

---

## Technical Challenges and Solutions

### 1. Geometric Calculation Efficiency
Calculating the distance between two points on a sphere can be computationally expensive. 
* **Solution:** Used the PostgreSQL `<@>` operator with `POINT` data types. This allows for rapid distance calculation in statute miles without requiring the overhead of a full PostGIS installation.

### 2. Identifying Nearest Neighbors
In a large dataset, a simple `JOIN` would result in a massive Cartesian product (every customer x every dealership).
* **Solution:** Employed a `CROSS JOIN` followed by a `DISTINCT ON (customer_id)` clause. By sorting the results by `distance ASC`, the script efficiently isolates the single closest record per customer, which is more performant than utilizing window functions.

### 3. Statistical Skewness
The analysis revealed a significant gap between the average distance (147 miles) and the median distance (91 miles).
* **Solution:** Analyzed the distribution for outliers. A higher mean indicates a "long tail" of customers living far from the hub network. This prompted a recommendation for a data audit to verify if these outliers represent real growth opportunities or "dirty" data from legacy addresses.

---

## Implementation Instructions

### Step 1: Initialize the Environment
Execute the `setup_and_seed.sql` script to create the necessary tables and populate them with mock data.

### Step 2: Run the Analysis
Execute the `proximity_analysis.sql` script. This will:
1. Generate temporary geometric tables.
2. Calculate the distance matrix.
3. Output the final Mean and Median distance metrics.

---

## Key Results and Recommendations
* **Identify Service Deserts:** Customers with a distance significantly above the median should be flagged for a specific "Remote Service" marketing campaign.
* **Network Expansion:** Use geographic clusters of high-distance customers to propose the next physical dealership locations.
* **Data Maintenance:** Records with a distance significantly above the 95th percentile should be flagged for address verification during the next customer touchpoint.
