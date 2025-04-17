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
### 1. 📆 Monthly Sales Trend

### 📊 Summary Table

| Month | Units Sold | Revenue (SAR) | Units Δ | Units % Δ | Revenue Δ | Revenue % Δ |
|-------|------------|---------------|---------|------------|------------|---------------|
| 9     | 654        | 1,874,912     | –       | –          | –          | –             |
| 10    | 7,412      | 20,597,028    | 6,758   | 1,033.3%   | 18,722,116 | 998.6%        |
| 11    | 8,176      | 21,813,068    | 764     | 10.3%      | 1,216,040  | 5.9%          |
| 12    | 7,735      | 19,427,642    | -441    | -5.4%      | -2,385,426 | -10.9%        |


![image](https://github.com/user-attachments/assets/05c60e2c-f280-483a-839b-5746f28bf866)



### 🔍 Insight
- Massive growth in October (likely campaign-driven)
- November stabilized with moderate growth
- December saw a drop in both units and revenue

### ✅ Recommendation
- Analyze October campaigns and replicate what worked
- Investigate revenue dip in December — review product mix, stock, or demand drop
- Plan early Q4 strategies to maintain momentum into year-end

---
## 📉 December Sales Dip – What Went Missing? 

---

### 1. Model Sales Drop-Off

| Model        | Oct Units | Dec Units | Oct Revenue | Dec Revenue |
|--------------|-----------|-----------|-------------|-------------|
| 65T8B        | 942       | 132       | 2.82M       | 388K        |
| 65C745       | 438       | 11        | 1.18M       | 29K         |
| 98P745       | 124       | 19        | 923K        | 134K        |
| 115X955 Max  | 8         | 3         | 780K        | 249K        |

- **Top October models lost momentum** or were nearly absent in December (e.g. 65T8B, 65C745, 98P745).

✅ **Recommendation:**
- Ensure high-performing models from campaigns are **stocked and promoted through Q4**
- Investigate availability gaps or pricing strategy for premium units

---

### 2. Store Performance Shift

| Store                          | Oct Revenue | Dec Revenue |
|--------------------------------|-------------|-------------|
| Almanea Albustan Khobar        | 1.08M       | 132K        |
| Almanea Prince Sultan          | 855K        | 34K         |
| Extra Obhur                    | 573K        | 317K        |
| Extra RAKA                     | 998K        | 596K        |

**Several top-performing stores in October saw 60–90% revenue drops** in December.

✅ **Recommendation:**
- Audit key locations that dropped — check for stockout, floor display, or pricing issues
- Prioritize restocking and visual merchandising in high-opportunity outlets

---

### 3. Retailer Drop-Off

| Retailer   | Oct Revenue | Dec Revenue |
|------------|-------------|-------------|
| Manea      | 5.3M        | 2.2M        |
| Jarir      | 1.37M       | 951K        |
| Bin Homood | 1.09M       | 804K        |
| Black Box  | 338K        | 119K        |

**Manea and other partners saw sharp sales decline**, while Extra grew.

✅ **Recommendation:**
- Strengthen partner collaboration, especially with Manea and Jarir
- Share campaign strategies that worked with Extra to raise consistency across partners

---

### 4. Regional Shift

| Region   | Oct Revenue | Dec Revenue |
|----------|-------------|-------------|
| Central  | 6.7M        | 5.2M        |
| West     | 6.3M        | 4.4M        |
| East     | 6.0M        | 4.3M        |
| **South**| 1.5M        | 5.5M        |

- While most regions dipped, **South surged in December** (possibly new campaign/store).

✅ **Recommendation:**
- Investigate what worked in South (promotions, store launches, new partner?)
- Reinforce efforts in Central/West to return to peak levels

---
## 6. 💸 Price Inconsistency

| Model         | Min Price | Max Price | Price Diff |
|---------------|-----------|-----------|------------|
| 115X955 Max   | 3,599     | 99,999    | 96,400     |
| 98P745        | 1,599     | 25,998    | 24,399     |
| 55P69B        | 1,334     | 23,984    | 22,650     |
| 65T8B         | 1,999     | 21,989    | 19,990     |
| 58V6B         | 1,399     | 13,592    | 12,193     |
| 65C655        | 1,598     | 12,999    | 11,401     |

- Extreme price variation (SAR 10K–96K) across key models
- Likely caused by lack of price controls or data entry issues

### ✅ Recommendation
- Implement centralized pricing policy and validate in reports
- Audit stores with large gaps to identify pricing leaks or system errors
- Set thresholds to flag and resolve extreme price differences


---

## (II) Market Share and Status

### 1. 📊 TCL Market Share (Jan 2024)

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

## 3. 💸 Average Selling Price by Brand (Jan 24)

### 📊 Highlights

| Brand     | Avg. Price (SAR) |
|-----------|------------------|
| SAMSUNG   | 5,820            |
| SONY      | 5,389            |
| LG        | 4,861            |
| TCL       | 2,331            |

---

### 🔍 Insight
- **TCL’s average price** (SAR 2,331) is **significantly lower** than LG, Sony, and Samsung
- LG earns more revenue from fewer units → Higher pricing strategy

### ✅ Recommendation
- Push **higher-value models** to lift revenue per unit
- Learn from LG/Sony on pricing strategy and positioning
- Focus marketing on **premium features & sizes** to compete upmarket


---


## ✅ Conclusion Summary

- Poor follow-up after October: High-performing models lost visibility or stock by December.
- Top stores underperformed: Several key outlets dropped 60–90% in revenue with no recovery plan.
- Retailer inconsistency: Partners like Manea & Jarir declined sharply — unlike Extra.
- Inventory imbalance: Premium and top-selling models like 65T8B were missing in peak sales period.
- Regional focus shifted: No reinforcement in strong areas (Central/West); South grew without support.





