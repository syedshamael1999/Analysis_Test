# Report - Insights & Recommendation

The task involved analyzing 3 months of TCL sell-out data, alongside a market status report containing brand-level sales and market share. The goal is to provide a clear, data-backed summary of where TCL stands in the market — and how it can improve in upcoming quarters.

### Objective:
- Identify problems in TCL's sales performance
- Highlight weak areas across products, stores, and regions
- Benchmark TCL against competitors using market data
- Provide clear, actionable recommendations for improvement

### Steps Taken:
- Merged the 3 Month data `Sellout_Q4.csv`
- Data Required some cleaning - Some cells dint follow Revenue = Quantity * Price.
- Analyzed with SQL (MS SQL) -> Found Insights -> Report
---

## (I) Sellout Q4 Analysis
---
### 1. ## 📆 Monthly Sales Trend

### 📊 Summary Table

| Month | Units Sold | Revenue (SAR) | Units Δ | Units % Δ | Revenue Δ | Revenue % Δ |
|-------|------------|---------------|---------|------------|------------|---------------|
| 9     | 654        | 1,874,912     | –       | –          | –          | –             |
| 10    | 7,412      | 20,597,028    | 6,758   | 1,033.3%   | 18,722,116 | 998.6%        |
| 11    | 8,176      | 21,813,068    | 764     | 10.3%      | 1,216,040  | 5.9%          |
| 12    | 7,735      | 19,427,642    | -441    | -5.4%      | -2,385,426 | -10.9%        |

---

### 🔍 Insight
- Massive growth in October (likely campaign-driven)
- November stabilized with moderate growth
- December saw a drop in both units and revenue

### ✅ Recommendation
- Analyze October campaigns and replicate what worked
- Investigate revenue dip in December — review product mix, stock, or demand drop
- Plan early Q4 strategies to maintain momentum into year-end



```SQL
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
```

---

### 2. 🔝 Top-Selling Models

### 📊 Summary Table

| Model   | Units Sold | Revenue (SAR) |
|---------|------------|----------------|
| 65C655  | 2,983      | 7,723,606      |
| 65V6B   | 3,189      | 6,093,770      |
| 65T8B   | 1,130      | 3,381,800      |
| 75C655  | 740        | 2,839,038      |
| 65P69B  | 1,242      | 2,490,435      |
| 85C655  | 454        | 2,307,492      |
| 98P745  | 257        | 1,929,731      |
| 65P71B  | 993        | 1,907,347      |
| 55C655  | 958        | 1,897,551      |
| 75P755  | 615        | 1,813,170      |

### 🔍 Insight
- 65-inch models dominate top sellers (6 out of 10)
- Premium models (75", 85", 98") also perform well
- 65C655 and 65V6B are consistent leaders in both units and revenue

### ✅ Recommendation
- Focus promotions and inventory on 65" models
- Expand premium segment (75"+) to drive high-value growth


```SQL
SELECT
  Model,
  SUM(Quantity) AS Units_Sold,
  SUM(Revenue) AS Total_Revenue
FROM Sellout_Q4
GROUP BY Model
ORDER BY Total_Revenue DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
```

---

### 3. ⚠️ Underperforming Models (Sold < 10 Units)

### 📊 Summary Table

| Model   | Units Sold | Revenue (SAR) | Avg. Price (SAR) |
|---------|------------|----------------|------------------|
| 32D310  | 2          | 638            | 319              |
| 50C635  | 2          | 1,400          | 700              |
| 55C735  | 2          | 1,998          | 999              |
| 55C725  | 1          | 2,149          | 2,149            |
| 55P617  | 2          | 3,198          | 1,599            |
| 65C635  | 2          | 4,198          | 2,099            |
| 55C635  | 4          | 4,694          | 1,173            |
| 50P637  | 4          | 4,894          | 1,223            |
| 50P71B  | 4          | 5,396          | 1,349            |
| 75P637  | 2          | 5,398          | 2,699            |
| 55C835  | 4          | 5,996          | 1,499            |
| 55C825  | 2          | 6,598          | 3,299            |
| 75C955  | 2          | 7,198          | 3,599            |
| 75C735  | 4          | 7,998          | 1,999            |
| 65T635  | 7          | 11,943         | 1,706            |
| 55P61B  | 9          | 13,041         | 1,522            |
| 58T635  | 9          | 13,527         | 1,503            |
| 58P635  | 9          | 13,903         | 1,544            |
| 75C845  | 7          | 28,482         | 4,068            |
| 65C735  | 4          | 28,998         | 2,499            |
| 75C645  | 9          | 29,605         | 3,289            |
| 98X955  | 2          | 149,998        | 74,999           |

### 🔍 Insight
- 20+ models sold fewer than 10 units in total
- Mix of **low-end** models and **high-value flagships** (e.g., 98X955)
- Some premium models show very low volume despite high price points

### ✅ Recommendation
- Phase out or consolidate low-volume models
- For high-end underperformers, review pricing, availability, and marketing
- Focus inventory and promotions on consistently selling models


```SQL
SELECT
  Model,
  SUM(Quantity) AS Units_Sold,
  SUM(Revenue) AS Total_Revenue,
  AVG(Sales_Price) AS Avg_Sales_Price
FROM Sellout_Q4
GROUP BY Model
HAVING SUM(Quantity) < 10
ORDER BY Total_Revenue ASC;
```
---
### 4. 🏪 Store Performance

### 🥇 Top 10 Stores by Revenue

| Store Name                                | Units Sold | Revenue (SAR) |
|-------------------------------------------|------------|----------------|
| Extra Jizan                               | 2,170      | 4,778,399      |
| eXtra Sultan                              | 1,024      | 3,467,877      |
| eXtra RAKA                                | 837        | 2,562,654      |
| manea Alrimal                             | 480        | 2,270,242      |
| Almanea Albustan King fahad Rd Khobar     | 760        | 2,156,760      |
| eXtra Medina Aaliah mall                  | 702        | 1,867,900      |
| Extra aziziyah DMM                        | 574        | 1,598,442      |
| eXtra Tahlia                              | 578        | 1,548,232      |
| eXtra Dammam (Alfaysalya)                 | 558        | 1,528,278      |
| Extra Alraed                              | 275        | 1,479,718      |

---

### ❌ Bottom 10 Stores by Revenue

| Store Name                                 | Units Sold | Revenue (SAR) |
|--------------------------------------------|------------|----------------|
| Saco Jabal Thor Makkah                     | 4          | 8,536          |
| Al Faislaiah District DMM (Jarir)          | 6          | 13,194         |
| Saco Khurais Riyadh                        | 6          | 16,194         |
| BH Alaskri RD                              | 17         | 27,502         |
| Marwa (Mandreen) Jed (BH)                  | 30         | 52,940         |
| Saco world King Abdullah St Riyadh         | 20         | 55,236         |
| blackbox King Faisal                       | 28         | 68,278         |
| Saco Tahlia Jeddah                         | 34         | 78,286         |
| Lulu Hypermarket Marwah Jeddah             | 47         | 80,993         |
| LuLu Hypermarket Al Yasmin Riyadh          | 49         | 86,991         |

---

### 🔍 Insight
- Top stores (led by Extra and Almanea branches) drive significant revenue and volume
- Bottom 10 stores contribute minimal revenue despite national presence

### ✅ Recommendation
- Double down on high-performing stores with stock, promoter support, and campaigns
- Audit underperforming outlets — assess visibility, footfall, and stock issues


```SQL
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
```
---

### 5. 🛒 Customer (Retailer) Performance

### 📊 Summary Table

| Customer       | Units Sold | Revenue (SAR) |
|----------------|------------|----------------|
| Extra          | 13,238     | 36,481,742     |
| Manea          | 3,549      | 11,139,333     |
| LuLu           | 2,788      | 5,657,764      |
| Jarir          | 1,664      | 3,917,896      |
| Bin Homood     | 1,372      | 2,811,153      |
| Saco           | 408        | 1,408,292      |
| Black Box      | 465        | 1,042,743      |
| Tamkeen        | 234        | 694,316        |
| Shita & Saif   | 259        | 559,411        |

---

### 🔍 Insight
- Extra and Manea dominate in both volume and revenue
- Smaller players (e.g. Saco, Black Box, Shita & Saif) contribute relatively little

### ✅ Recommendation
- Strengthen partnerships with Extra and Manea (exclusive models, promotions)
- Review performance with smaller retailers — assess visibility, traffic, and stock flow


```SQL
SELECT
  Customer,
  SUM(Quantity) AS Units_Sold,
  SUM(Revenue) AS Revenue
FROM Sellout_Q4
GROUP BY Customer
ORDER BY Revenue DESC;
```
---
### 6. 💰 Price Consistency Check

### 📊 Models with Highest Price Differences

| Model         | Min Price (SAR) | Max Price (SAR) | Price Diff (SAR) |
|---------------|------------------|------------------|------------------|
| 115X955 Max   | 3,599            | 99,999           | 96,400           |
| 98P745        | 1,599            | 25,998           | 24,399           |
| 55P69B        | 1,334            | 23,984           | 22,650           |
| 65T8B         | 1,999            | 21,989           | 19,990           |
| 58V6B         | 1,399            | 13,592           | 12,193           |
| 65C655        | 1,598            | 12,999           | 11,401           |
| 75P69B        | 1,399            | 10,792           | 9,393            |
| 55P79B        | 1,399            | 10,194           | 8,795            |
| 98C655        | 7,599            | 15,998           | 8,399            |
| 85C655        | 2,299            | 9,998            | 7,699            |

---

### 🔍 Insight
- Major price inconsistencies: some models show differences over SAR 20K+
- Top price gap is 115X955 Max with a SAR 96K difference
- High variance may indicate lack of pricing control or data entry issues

### ✅ Recommendation
- Enforce pricing rules and consistency across retail partners
- Investigate outliers to fix possible data entry errors
- Standardize price reporting and validate before analysis


```SQL
SELECT
  Model,
  MIN(Sales_Price) AS Min_Price,
  MAX(Sales_Price) AS Max_Price,
  MAX(Sales_Price) - MIN(Sales_Price) AS Price_Diff
FROM Sellout_Q4
GROUP BY Model
ORDER BY Price_Diff DESC;
```

---

### 7. 🗺️ Regional Performance

### 📊 Summary Table

| Department | Units Sold | Revenue (SAR) |
|------------|------------|----------------|
| Central    | 6,531      | 19,381,292     |
| West       | 7,077      | 18,859,826     |
| East       | 6,595      | 16,776,310     |
| South      | 3,774      | 8,695,222      |

---

### 🔍 Insight
- Central and West regions lead in revenue and unit sales
- South lags significantly in both — half the sales of other regions

### ✅ Recommendation
- Focus inventory and campaigns in Central & West to maximize returns
- Investigate Southern region’s low performance — boost visibility, assess store presence or demand gaps


```SQL
SELECT
  Department,
  SUM(Quantity) AS Units_Sold,
  SUM(Revenue) AS Revenue
FROM Sellout_Q4
GROUP BY Department
ORDER BY Revenue DESC;
```

---

## (II) Market Share and Status

### 1. TCL Market Share (Jan 2024)

| PERIOD | TCL Units        | TCL Revenue | TCL Market Share (%)   |
|--------|------------------|-------------|------------------------|
| JAN 23 | 11,146.97        | 21,027,996  | 11.55                  |
| JAN 24 | 11,063.72        | 23,915,678  | 13.85                  |

### 🔍 Insight
- TCL Group grew its revenue share by +2.3% YoY, indicating strong brand momentum and competitive performance improvement.

### ✅ Recommendation
- Continue strategies that fueled this growth

```SQL
-- 1. TCL Group’s Market Share (Jan 24)
SELECT
  PERIOD,
  SUM(SALES_UNITS) AS TCL_Units,
  SUM(SALES_VALUE_SAR) AS TCL_Revenue,
  ROUND(SUM(SALES_VALUE_SAR) * 100.0 / 
        (SELECT SUM(SALES_VALUE_SAR) FROM KSATVTEST WHERE PERIOD = KS.PERIOD), 2) AS TCL_Market_Share_Percent
FROM KSATVTEST KS
WHERE BRAND IN ('TCL', 'TCL PRO') AND PERIOD IN ('JAN 23', 'JAN 24')
GROUP BY PERIOD
ORDER BY PERIOD;
```
---

### 2. Competitor Comparison – January 2024

| Rank | Brand         | Units Sold | Revenue (SAR) |
|------|---------------|------------|---------------|
|  1   | Samsung       | 13483      | 37,414,202    |
|  2   | LG            | 7686       | 26,818,798    |
|  3   | **TCL Group** | 11064      | 23,915,678    |
|  4   | Skyworth      | 6498       | 10,537,065    |
|  5   | Sony          | 2451       | 10,171,154    |


### 🔍 Insight:
- **TCL Group is 3rd in revenue** but **2nd in units sold**
- LG earns more revenue from fewer units — indicating TCL's **lower average selling price**
- Samsung dominates both value and volume

### ✅ Recommendation:
- Push **higher-value models** to improve revenue per unit
- Learn from LG’s positioning and pricing strategy
- Focus marketing on premium upgrades to challenge top 2

```SQL
-- 2. Competitor Comparison (Jan 24)
SELECT
  TOP 5
  CASE 
    WHEN BRAND IN ('TCL', 'TCL PRO') THEN 'TCL Group' 
    ELSE BRAND 
  END AS Brand_Group,
  SUM(SALES_UNITS) AS Units_Sold,
  SUM(SALES_VALUE_SAR) AS Revenue
FROM KSATVTEST
WHERE PERIOD = 'JAN 24'
GROUP BY
  CASE 
    WHEN BRAND IN ('TCL', 'TCL PRO') THEN 'TCL Group' 
    ELSE BRAND 
  END
ORDER BY Revenue DESC;
```
---


## ✅ Conclusion Summary

- **65-inch models** are best-sellers — push stock and promotions here.
- **Premium models (75”+)** show strong revenue potential — scale visibility and availability.
- **20+ models underperformed** — phase out low-sellers and optimize SKU lineup.
- **Top stores and retailers (Extra, Manea)** are key drivers — double down on partnerships.
- **Significant price gaps** exist — standardize pricing and fix data issues.
- **Central & West regions** perform best — focus campaigns here.
- **TCL’s market share is growing** — continue momentum with value and premium mix.
- **Competitors like LG earn more per unit** — increase average selling price to compete better.





