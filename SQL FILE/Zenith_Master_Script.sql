-- ================================================================
-- PROJECT    : Zenith Retail - Complete Master Script
-- DATABASE   : zenith_retail
-- DESCRIPTION: All queries consolidated in one script
-- ================================================================

-- ---------------------------------------------------------------
-- SECTION 1: DATABASE & TABLE SETUP
-- ---------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS zenith_retail;

-- ---------------------------------------------------------------
-- SECTION 2: VIEW 1 - Monthly Revenue
-- ---------------------------------------------------------------
CREATE OR REPLACE VIEW zenith_retail.vw_monthly_revenue AS
SELECT 
    DATE_FORMAT(`Order Date`, '%Y-%m')      AS Month,
    ROUND(SUM(Sales), 2)                    AS Total_Revenue,
    ROUND(SUM(Profit), 2)                   AS Total_Profit,
    COUNT(DISTINCT `Order ID`)              AS Total_Orders,
    ROUND((SUM(Profit)/SUM(Sales))*100, 2)  AS Profit_Margin_Pct
FROM zenith_retail.orders
GROUP BY DATE_FORMAT(`Order Date`, '%Y-%m')
ORDER BY Month ASC;

-- ---------------------------------------------------------------
-- SECTION 3: VIEW 2 - Category Rankings
-- ---------------------------------------------------------------
CREATE OR REPLACE VIEW zenith_retail.vw_category_rankings AS
WITH category_sales AS (
    SELECT 
        p.Category,
        ROUND(SUM(o.Sales), 2)        AS Total_Sales,
        SUM(o.Quantity)               AS Total_Quantity,
        ROUND(SUM(o.Profit), 2)       AS Total_Profit,
        COUNT(DISTINCT o.`Order ID`)  AS Total_Orders
    FROM zenith_retail.orders o
    JOIN zenith_retail.products p ON o.`Product ID` = p.`Product ID`
    GROUP BY p.Category
)
SELECT *,
    RANK()       OVER (ORDER BY Total_Sales DESC) AS Sales_Rank,
    DENSE_RANK() OVER (ORDER BY Total_Sales DESC) AS `Dense_Rank`
FROM category_sales;

-- ---------------------------------------------------------------
-- SECTION 4: VIEW 3 - VIP Customers
-- ---------------------------------------------------------------
CREATE OR REPLACE VIEW zenith_retail.vw_vip_customers AS
WITH customer_spend AS (
    SELECT 
        `Customer ID`,
        `Customer Name`,
        ROUND(SUM(Sales), 2)        AS Total_Spend,
        COUNT(DISTINCT `Order ID`)  AS Total_Orders,
        ROUND(SUM(Profit), 2)       AS Total_Profit,
        ROUND(AVG(Sales), 2)        AS Avg_Order_Value
    FROM zenith_retail.orders
    GROUP BY `Customer ID`, `Customer Name`
),
ntile_ranking AS (
    SELECT *,
        NTILE(10) OVER (ORDER BY Total_Spend DESC) AS Spend_Tile
    FROM customer_spend
)
SELECT *,
    CASE 
        WHEN Spend_Tile = 1 THEN 'VIP Customer'
        WHEN Spend_Tile = 2 THEN 'High Value'
        WHEN Spend_Tile = 3 THEN 'Mid Value'
        ELSE 'Regular'
    END AS Customer_Segment
FROM ntile_ranking;

-- ---------------------------------------------------------------
-- SECTION 5: VIEW 4 - Low Inventory Alert
-- ---------------------------------------------------------------
CREATE OR REPLACE VIEW zenith_retail.vw_low_inventory_alert AS
WITH product_velocity AS (
    SELECT 
        p.`Product ID`,
        p.`Product Name`,
        p.`Category`,
        p.`Sub-Category`,
        SUM(o.Quantity)                                  AS Total_Units_Sold,
        ROUND(SUM(o.Sales), 2)                           AS Total_Sales,
        ROUND(AVG(o.Quantity), 2)                        AS Avg_Units_Per_Order,
        ROUND(SUM(o.Quantity) / 12, 2)                   AS Avg_Monthly_Units,
        ROUND((SUM(o.Profit) / SUM(o.Sales)) * 100, 2)  AS Profit_Margin_Pct,
        NTILE(4) OVER (ORDER BY SUM(o.Quantity) DESC)    AS Volume_Quartile
    FROM zenith_retail.orders o
    JOIN zenith_retail.products p ON o.`Product ID` = p.`Product ID`
    GROUP BY p.`Product ID`, p.`Product Name`, p.`Category`, p.`Sub-Category`
)
SELECT *,
    CASE
        WHEN Volume_Quartile = 1 AND Profit_Margin_Pct > 10  THEN 'URGENT - Restock Immediately'
        WHEN Volume_Quartile = 1 AND Profit_Margin_Pct <= 10 THEN 'MEDIUM - Monitor Stock'
        WHEN Volume_Quartile = 2                              THEN 'LOW - Plan Restock'
        ELSE 'OK - Sufficient Stock'
    END AS Inventory_Alert,
    ROUND(Avg_Monthly_Units * 3, 0) AS Recommended_Restock_Qty
FROM product_velocity
WHERE Volume_Quartile IN (1, 2);

-- ---------------------------------------------------------------
-- SECTION 6: VIEW 5 - Declining Margins
-- ---------------------------------------------------------------
CREATE OR REPLACE VIEW zenith_retail.vw_declining_margins AS
WITH product_stats AS (
    SELECT 
        p.`Product ID`,
        p.`Product Name`,
        p.`Category`,
        p.`Sub-Category`,
        COUNT(o.`Order ID`)                               AS Sales_Frequency,
        ROUND(SUM(o.Sales), 2)                            AS Total_Sales,
        ROUND(SUM(o.Profit), 2)                           AS Total_Profit,
        ROUND(AVG(o.Discount) * 100, 2)                   AS Avg_Discount_Pct,
        ROUND((SUM(o.Profit) / SUM(o.Sales)) * 100, 2)   AS Profit_Margin_Pct,
        NTILE(4) OVER (ORDER BY COUNT(o.`Order ID`) DESC) AS Frequency_Quartile
    FROM zenith_retail.orders o
    JOIN zenith_retail.products p ON o.`Product ID` = p.`Product ID`
    GROUP BY p.`Product ID`, p.`Product Name`, p.`Category`, p.`Sub-Category`
)
SELECT *,
    'High Sales Low Margin' AS Alert_Status
FROM product_stats
WHERE Frequency_Quartile = 1
  AND Profit_Margin_Pct < 10;

-- ---------------------------------------------------------------
-- SECTION 7: STORED PROCEDURE - Full Report
-- ---------------------------------------------------------------
DROP PROCEDURE IF EXISTS zenith_retail.sp_zenith_full_report;

DELIMITER $$
CREATE PROCEDURE zenith_retail.sp_zenith_full_report()
BEGIN
    SELECT 'REPORT 1: Monthly Revenue Trends' AS Report_Section;
    SELECT * FROM zenith_retail.vw_monthly_revenue;

    SELECT 'REPORT 2: Category Rankings' AS Report_Section;
    SELECT * FROM zenith_retail.vw_category_rankings ORDER BY Sales_Rank;

    SELECT 'REPORT 3: Top 3 Categories' AS Report_Section;
    SELECT * FROM zenith_retail.vw_category_rankings ORDER BY Sales_Rank LIMIT 3;

    SELECT 'REPORT 4: VIP Customers' AS Report_Section;
    SELECT * FROM zenith_retail.vw_vip_customers WHERE Spend_Tile = 1 ORDER BY Total_Spend DESC;

    SELECT 'REPORT 5: Declining Margins' AS Report_Section;
    SELECT * FROM zenith_retail.vw_declining_margins ORDER BY Profit_Margin_Pct ASC;

    SELECT 'REPORT 6: Low Inventory Alert' AS Report_Section;
    SELECT * FROM zenith_retail.vw_low_inventory_alert ORDER BY Total_Units_Sold DESC;
END$$
DELIMITER ;

-- ---------------------------------------------------------------
-- SECTION 8: VERIFY EVERYTHING
-- ---------------------------------------------------------------
-- Check all views
SELECT TABLE_NAME AS View_Name
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'zenith_retail';

-- Check stored procedure exists
SELECT ROUTINE_NAME 
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'zenith_retail'
  AND ROUTINE_TYPE = 'PROCEDURE';

-- ---------------------------------------------------------------
-- SECTION 9: RUN FULL REPORT
-- ---------------------------------------------------------------
CALL zenith_retail.sp_zenith_full_report();