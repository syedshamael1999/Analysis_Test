/*(I) Sellout Q4 Analysis*/

-- 1. Monthly Sales Trend
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

-- 2. Top-Selling Models
SELECT
  Model,
  SUM(Quantity) AS Units_Sold,
  SUM(Revenue) AS Total_Revenue
FROM Sellout_Q4
GROUP BY Model
ORDER BY Total_Revenue DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- 3. Underperforming Models (Sold < 10 Units)
SELECT
  Model,
  SUM(Quantity) AS Units_Sold,
  SUM(Revenue) AS Total_Revenue,
  AVG(Sales_Price) AS Avg_Sales_Price
FROM Sellout_Q4
GROUP BY Model
HAVING SUM(Quantity) < 10
ORDER BY Total_Revenue ASC;

-- 4. Store Performance
-- Top 10 Stores
SELECT TOP 10
  Store_Name,
  SUM(Quantity) AS Units_Sold,
  SUM(Revenue) AS Revenue
FROM Sellout_Q4
GROUP BY Store_Name
ORDER BY Revenue DESC;

-- Bottom 10 Stores
SELECT TOP 10
  Store_Name,
  SUM(Quantity) AS Units_Sold,
  SUM(Revenue) AS Revenue
FROM Sellout_Q4
GROUP BY Store_Name
ORDER BY Revenue ASC;

-- 5. Customer (Retailer) Performance
SELECT
  Customer,
  SUM(Quantity) AS Units_Sold,
  SUM(Revenue) AS Revenue
FROM Sellout_Q4
GROUP BY Customer
ORDER BY Revenue DESC;

-- 6. Price Consistency Check
SELECT
  Model,
  MIN(Sales_Price) AS Min_Price,
  MAX(Sales_Price) AS Max_Price,
  MAX(Sales_Price) - MIN(Sales_Price) AS Price_Diff
FROM Sellout_Q4
GROUP BY Model
ORDER BY Price_Diff DESC;

-- 7. Regional Performance
SELECT
  Department,
  SUM(Quantity) AS Units_Sold,
  SUM(Revenue) AS Revenue
FROM Sellout_Q4
GROUP BY Department
ORDER BY Revenue DESC;








