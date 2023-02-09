
-- Taking a look at the dataset

select * from raw_sales;

-- Checking for inappropriate values in the propertytype column

select distinct propertytype
from raw_sales;

-- Checking for inappropriate values in the bedrooms column

select distinct bedrooms
from raw_sales;

-- HOUSE PROPERTY SALES ANALYSIS QUESTIONS

-- Which date corresponds to the highest number of sales?

select datesold as date, count(price) as highest_sales
from raw_sales
group by datesold 
order by highest_sales desc 
limit 1;

-- Find out the postcode with the highest average price per sale? (Using Aggregate Functions)

select postcode, avg(price) as avg_price
from raw_sales 
group by postcode
order by avg_price desc 
limit 1;

-- Which year witnessed the lowest number of sales?

select year(datesold) as year, count(*) as lowest_sales
from raw_sales 
group by year(datesold)
order by lowest_sales asc 
limit 1;

-- Use the window function to deduce the top six postcodes by year's price

WITH sales_cte AS (
  SELECT 
    year(datesold) as year, 
    postcode, 
    price,
    dense_rank() OVER (PARTITION BY year(datesold), postcode ORDER BY price DESC) rnk
  FROM raw_sales
)
SELECT 
  year,
  postcode,
  price
FROM (
  SELECT 
    *,
    row_number() OVER (PARTITION BY year ORDER BY price DESC) as row_num
  FROM sales_cte
  WHERE rnk < 2
) subquery
WHERE row_num BETWEEN 1 AND 6;
