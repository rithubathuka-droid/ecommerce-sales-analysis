USE [ecommerce sales];
GO

-- ==========================================
-- E-COMMERCE SALES ANALYSIS
-- Table: dbo.OnlineRetail
-- ==========================================


-- 1. TOTAL REVENUE
SELECT
    SUM(
        TRY_CONVERT(decimal(18,4), Quantity)
        * TRY_CONVERT(decimal(18,4), UnitPrice)
    ) AS Total_Revenue
FROM dbo.OnlineRetail;


-- 2. MONTHLY REVENUE
SELECT
    YEAR(TRY_CONVERT(datetime, InvoiceDate, 103)) AS Sales_Year,
    MONTH(TRY_CONVERT(datetime, InvoiceDate, 103)) AS Sales_Month,
    SUM(
        TRY_CONVERT(decimal(18,4), Quantity)
        * TRY_CONVERT(decimal(18,4), UnitPrice)
    ) AS Monthly_Revenue
FROM dbo.OnlineRetail
WHERE TRY_CONVERT(decimal(18,4), Quantity) > 0
  AND TRY_CONVERT(datetime, InvoiceDate, 103) IS NOT NULL
GROUP BY
    YEAR(TRY_CONVERT(datetime, InvoiceDate, 103)),
    MONTH(TRY_CONVERT(datetime, InvoiceDate, 103))
ORDER BY
    Sales_Year,
    Sales_Month;


-- 3. TOP 10 PRODUCTS BY REVENUE
SELECT TOP 10
    Description,
    SUM(
        TRY_CONVERT(decimal(18,4), Quantity)
        * TRY_CONVERT(decimal(18,4), UnitPrice)
    ) AS Total_Revenue
FROM dbo.OnlineRetail
WHERE TRY_CONVERT(decimal(18,4), Quantity) > 0
  AND Description IS NOT NULL
GROUP BY Description
ORDER BY Total_Revenue DESC;


-- 4. TOP 10 COUNTRIES BY REVENUE
SELECT TOP 10
    Country,
    SUM(
        TRY_CONVERT(decimal(18,4), Quantity)
        * TRY_CONVERT(decimal(18,4), UnitPrice)
    ) AS Total_Revenue
FROM dbo.OnlineRetail
WHERE TRY_CONVERT(decimal(18,4), Quantity) > 0
  AND Country IS NOT NULL
GROUP BY Country
ORDER BY Total_Revenue DESC;


-- 5. TOP 10 CUSTOMERS BY REVENUE
SELECT TOP 10
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS Total_Orders,
    SUM(
        TRY_CONVERT(decimal(18,4), Quantity)
        * TRY_CONVERT(decimal(18,4), UnitPrice)
    ) AS Total_Revenue
FROM dbo.OnlineRetail
WHERE TRY_CONVERT(decimal(18,4), Quantity) > 0
  AND CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY Total_Revenue DESC;


-- 6. CANCELLATION / RETURNS ANALYSIS
SELECT
    COUNT(*) AS Cancelled_Transactions,
    SUM(
        ABS(
            TRY_CONVERT(decimal(18,4), Quantity)
            * TRY_CONVERT(decimal(18,4), UnitPrice)
        )
    ) AS Cancelled_Value
FROM dbo.OnlineRetail
WHERE InvoiceNo LIKE 'C%';


-- 7. AVERAGE ORDER VALUE
SELECT
    COUNT(DISTINCT InvoiceNo) AS Total_Orders,
    SUM(
        TRY_CONVERT(decimal(18,4), Quantity)
        * TRY_CONVERT(decimal(18,4), UnitPrice)
    ) AS Total_Revenue,
    SUM(
        TRY_CONVERT(decimal(18,4), Quantity)
        * TRY_CONVERT(decimal(18,4), UnitPrice)
    )
    / NULLIF(COUNT(DISTINCT InvoiceNo), 0) AS Average_Order_Value
FROM dbo.OnlineRetail
WHERE TRY_CONVERT(decimal(18,4), Quantity) > 0
  AND InvoiceNo NOT LIKE 'C%';


-- 8. TOP 10 BEST-SELLING PRODUCTS BY QUANTITY
SELECT TOP 10
    Description,
    SUM(TRY_CONVERT(decimal(18,2), Quantity)) AS Total_Quantity_Sold
FROM dbo.OnlineRetail
WHERE TRY_CONVERT(decimal(18,2), Quantity) > 0
  AND Description IS NOT NULL
GROUP BY Description
ORDER BY Total_Quantity_Sold DESC;


-- 9. UNIQUE ORDERS
SELECT
    COUNT(DISTINCT InvoiceNo) AS Unique_Orders
FROM dbo.OnlineRetail
WHERE TRY_CONVERT(decimal(18,2), Quantity) > 0
  AND InvoiceNo NOT LIKE 'C%';


-- 10. SALES BY YEAR
SELECT
    YEAR(TRY_CONVERT(datetime, InvoiceDate, 103)) AS Sales_Year,
    SUM(
        TRY_CONVERT(decimal(18,4), Quantity)
        * TRY_CONVERT(decimal(18,4), UnitPrice)
    ) AS Total_Revenue
FROM dbo.OnlineRetail
WHERE TRY_CONVERT(decimal(18,2), Quantity) > 0
  AND InvoiceNo NOT LIKE 'C%'
  AND TRY_CONVERT(datetime, InvoiceDate, 103) IS NOT NULL
GROUP BY YEAR(TRY_CONVERT(datetime, InvoiceDate, 103))
ORDER BY Sales_Year;