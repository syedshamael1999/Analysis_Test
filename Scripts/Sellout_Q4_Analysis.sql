/* Sellout_Q4 */

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


-- Top-Selling Models
SELECT
	  Model,
	  SUM(Quantity) AS Units_Sold,
	  SUM(Revenue) AS Total_Revenue
FROM Sellout_Q4
GROUP BY Model
ORDER BY Total_Revenue DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

-- Model Performance – Identify Underperformers
SELECT
  Model,
  SUM(Quantity) AS Units_Sold,
  SUM(Revenue) AS Revenue
FROM Sellout_Q4
GROUP BY Model
HAVING SUM(Quantity) < 10  -- You can adjust this threshold
ORDER BY Revenue ASC;
-- Found 0 revenue meaning Qty * Price formula doesnt apply 

-- Clean the Data 
SELECT Sales_Price, Quantity, Revenue
FROM Sellout_Q4
WHERE Revenue = 0 AND Quantity > 0 AND Sales_Price > 0;
-- Findings: Found all revenue that dont apply Qty * Price formula

-- Updating Table with formula
UPDATE Sellout_Q4
SET Revenue = Quantity * Sales_Price
WHERE Revenue = 0 AND Quantity > 0 AND Sales_Price > 0;

-- Redo: -- Model Performance – Identify Underperformers
SELECT
  Model,
  SUM(Quantity) AS Units_Sold,
  SUM(Revenue) AS Revenue
FROM Sellout_Q4
GROUP BY Model
HAVING SUM(Quantity) < 10  -- You can adjust this threshold
ORDER BY Revenue ASC;

-- Store Performance – Good performers
SELECT TOP 10
  Store_Name,
  SUM(Quantity) AS Units_Sold,
  SUM(Revenue) AS Revenue
FROM Sellout_Q4
GROUP BY Store_Name
ORDER BY Revenue DESC;

-- Store Performance – Bad performers
SELECT TOP 10
  Store_Name,
  SUM(Quantity) AS Units_Sold,
  SUM(Revenue) AS Revenue
FROM Sellout_Q4
GROUP BY Store_Name
ORDER BY Revenue ASC;

-- Customer (Retailer) Performance
SELECT
  Customer,
  SUM(Quantity) AS Units_Sold,
  SUM(Revenue) AS Revenue
FROM Sellout_Q4
GROUP BY Customer
ORDER BY Revenue DESC;

-- Price Consistency Check
SELECT
  Model,
  MIN(Sales_Price) AS Min_Price,
  MAX(Sales_Price) AS Max_Price,
  MAX(Sales_Price) - MIN(Sales_Price) AS Price_Diff
FROM Sellout_Q4
GROUP BY Model
HAVING MAX(Sales_Price) - MIN(Sales_Price) > 300  -- Adjust threshold as needed
ORDER BY Price_Diff DESC;
-- found models with price differences from SAR 349 to SAR 99999 — may indicate lack of pricing control across locations.
-- Possible 1. Lack of pricing governance 2. data entry error
-- Recommendation: Enforce pricing rules across locations and validate outliers during reporting.

-- Regional/Department Breakdown
SELECT
  Department,
  SUM(Quantity) AS Units_Sold,
  SUM(Revenue) AS Revenue
FROM Sellout_Q4
GROUP BY Department
ORDER BY Revenue DESC;
