/* Market Status and Share
This is market data, not just TCL — includes competitors.

Data: JAN 23 and JAN 24 */


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
