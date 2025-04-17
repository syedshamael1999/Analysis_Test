/*(I) Sellout Q4 Analysis*/

-- Monthly Sales Trend
SELECT
  Month,
  SUM(Quantity) AS Total_Units_Sold,
  SUM(Revenue) AS Total_Revenue,

  -- Difference from previous month
  SUM(Quantity) - LAG(SUM(Quantity)) OVER (ORDER BY Month) AS Units_Diff,

  ROUND((SUM(Quantity) - LAG(SUM(Quantity)) OVER (ORDER BY Month)) * 100.0 /
        NULLIF(LAG(SUM(Quantity)) OVER (ORDER BY Month), 0), 1) AS Units_Percent_Change,

  SUM(Revenue) - LAG(SUM(Revenue)) OVER (ORDER BY Month) AS Revenue_Diff,

  ROUND((SUM(Revenue) - LAG(SUM(Revenue)) OVER (ORDER BY Month)) * 100.0 /
        NULLIF(LAG(SUM(Revenue)) OVER (ORDER BY Month), 0), 1) AS Revenue_Percent_Change

FROM Sellout_Q4
GROUP BY Month
ORDER BY Month;

/* Side-by-side comparison - Oct Vs Dec */

-- 1. Model Performance: Oct vs Dec
SELECT
  Model,
  SUM(CASE WHEN Month = 10 THEN Quantity ELSE 0 END) AS Oct_Units,
  SUM(CASE WHEN Month = 12 THEN Quantity ELSE 0 END) AS Dec_Units,
  SUM(CASE WHEN Month = 10 THEN Revenue ELSE 0 END) AS Oct_Revenue,
  SUM(CASE WHEN Month = 12 THEN Revenue ELSE 0 END) AS Dec_Revenue
FROM Sellout_Q4
WHERE Month IN (10, 12)
GROUP BY Model
ORDER BY Oct_Revenue DESC;

-- 2. Store Performance: Oct vs Dec
SELECT
  Store_Name,
  SUM(CASE WHEN Month = 10 THEN Quantity ELSE 0 END) AS Oct_Units,
  SUM(CASE WHEN Month = 12 THEN Quantity ELSE 0 END) AS Dec_Units,
  SUM(CASE WHEN Month = 10 THEN Revenue ELSE 0 END) AS Oct_Revenue,
  SUM(CASE WHEN Month = 12 THEN Revenue ELSE 0 END) AS Dec_Revenue
FROM Sellout_Q4
WHERE Month IN (10, 12)
GROUP BY Store_Name
ORDER BY Oct_Revenue DESC;

-- 3. Retailer (Customer) Performance: Oct vs Dec
SELECT
  Customer,
  SUM(CASE WHEN Month = 10 THEN Quantity ELSE 0 END) AS Oct_Units,
  SUM(CASE WHEN Month = 12 THEN Quantity ELSE 0 END) AS Dec_Units,
  SUM(CASE WHEN Month = 10 THEN Revenue ELSE 0 END) AS Oct_Revenue,
  SUM(CASE WHEN Month = 12 THEN Revenue ELSE 0 END) AS Dec_Revenue
FROM Sellout_Q4
WHERE Month IN (10, 12)
GROUP BY Customer
ORDER BY Oct_Revenue DESC;


-- 4. Region Performance: Oct vs Dec
SELECT
  Department,
  SUM(CASE WHEN Month = 10 THEN Quantity ELSE 0 END) AS Oct_Units,
  SUM(CASE WHEN Month = 12 THEN Quantity ELSE 0 END) AS Dec_Units,
  SUM(CASE WHEN Month = 10 THEN Revenue ELSE 0 END) AS Oct_Revenue,
  SUM(CASE WHEN Month = 12 THEN Revenue ELSE 0 END) AS Dec_Revenue
FROM Sellout_Q4
WHERE Month IN (10, 12)
GROUP BY Department
ORDER BY Oct_Revenue DESC;








