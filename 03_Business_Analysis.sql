USE RetailSalesAnalysis;
GO

-- Query 1: Overall Business Performance

SELECT
    COUNT(*) AS Total_Transactions,
    SUM(Gross_Sales) AS Total_Gross_Sales,
    SUM(Return_Amount) AS Total_Return_Amount,
    SUM(Net_Sales) AS Total_Net_Sales,
    SUM(Cogs) AS Total_COGS,
    SUM(Profit) AS Total_Profit,
    AVG(Profit_Margin) AS Average_Profit_Margin
FROM dbo.retail_sales_clean;

-- Query 2: Monthly Sales Performance

SELECT
    Year,
    Month,
    Month_Name,
    SUM(Net_Sales) AS Total_Net_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Cogs) AS Total_COGS,
    AVG(Profit_Margin) AS Average_Profit_Margin
FROM dbo.retail_sales_clean
GROUP BY
    Year,
    Month,
    Month_Name
ORDER BY
    Year,
    Month;

-- Query 3: Sales Performance by Sales Type

SELECT
    Sales_Type,
    COUNT(*) AS Transaction_Count,
    SUM(Net_Sales) AS Total_Net_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Cogs) AS Total_COGS,
    AVG(Profit_Margin) AS Average_Profit_Margin
FROM dbo.retail_sales_clean
GROUP BY
    Sales_Type
ORDER BY
    Total_Net_Sales DESC;

-- Query 4: Top 10 Products by Net Sales

SELECT TOP 10
    Product_No,
    Product_Description,
    Product_Category,
    SUM(Qty_Sold) AS Total_Units_Sold,
    SUM(Net_Sales) AS Total_Net_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Profit_Margin) AS Average_Profit_Margin
FROM dbo.retail_sales_clean
GROUP BY
    Product_No,
    Product_Description,
    Product_Category
ORDER BY
    Total_Net_Sales DESC;

-- Query 5: Bottom 10 Products by Profit

SELECT TOP 10
    Product_No,
    Product_Description,
    Product_Category,
    SUM(Qty_Sold) AS Total_Units_Sold,
    SUM(Net_Sales) AS Total_Net_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Profit_Margin) AS Average_Profit_Margin
FROM dbo.retail_sales_clean
GROUP BY
    Product_No,
    Product_Description,
    Product_Category
ORDER BY
    Total_Profit ASC;

-- Query 6: Store Performance

SELECT
    Store,
    COUNT(*) AS Transaction_Count,
    SUM(Net_Sales) AS Total_Net_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Profit_Margin) AS Average_Profit_Margin
FROM dbo.retail_sales_clean
GROUP BY
    Store
ORDER BY
    Total_Net_Sales DESC;

-- Query 7: Product Category Performance

SELECT
    Product_Category,
    COUNT(*) AS Transaction_Count,
    SUM(Qty_Sold) AS Total_Units_Sold,
    SUM(Net_Sales) AS Total_Net_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Profit_Margin) AS Average_Profit_Margin
FROM dbo.retail_sales_clean
GROUP BY
    Product_Category
ORDER BY
    Total_Net_Sales DESC;

-- Query 8: Sales Channel Performance

SELECT
    Sales_Channel,
    COUNT(*) AS Transaction_Count,
    SUM(Qty_Sold) AS Total_Units_Sold,
    SUM(Net_Sales) AS Total_Net_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Profit_Margin) AS Average_Profit_Margin
FROM dbo.retail_sales_clean
GROUP BY
    Sales_Channel
ORDER BY
    Total_Net_Sales DESC;

-- Query 9: Return Performance

SELECT
    Is_Return,
    COUNT(*) AS Transaction_Count,
    SUM(Qty_Sold) AS Total_Units,
    SUM(Return_Amount) AS Total_Return_Amount,
    SUM(Net_Sales) AS Total_Net_Sales,
    SUM(Profit) AS Total_Profit
FROM dbo.retail_sales_clean
GROUP BY
    Is_Return
ORDER BY
    Is_Return;

-- Query 10: Inventory Stock Status

SELECT
    Stock_Available,
    COUNT(*) AS Product_Records,
    SUM(Qty_on_hand) AS Total_Qty_On_Hand,
    SUM(Inventory_Value) AS Total_Inventory_Value,
    SUM(Inventory_Cost) AS Total_Inventory_Cost
FROM dbo.retail_inventory_clean
GROUP BY
    Stock_Available
ORDER BY
    Product_Records DESC;

-- Query 11: Inventory Performance by Category

SELECT
    Product_Category,
    COUNT(*) AS Inventory_Records,
    SUM(Qty_on_hand) AS Total_Qty_On_Hand,
    SUM(Inventory_Value) AS Total_Inventory_Value,
    SUM(Inventory_Cost) AS Total_Inventory_Cost,
    AVG(Stock_Unit_Selling_Price) AS Avg_Selling_Price
FROM dbo.retail_inventory_clean
GROUP BY
    Product_Category
ORDER BY
    Total_Inventory_Value DESC;

-- Query 12: Negative Stock Analysis

SELECT
    Product_Category,
    COUNT(*) AS Negative_Stock_Records,
    SUM(Qty_on_hand) AS Total_Negative_Qty,
    SUM(Inventory_Value) AS Negative_Inventory_Value,
    SUM(Inventory_Cost) AS Negative_Inventory_Cost
FROM dbo.retail_inventory_clean
WHERE Qty_on_hand < 0
GROUP BY
    Product_Category
ORDER BY
    Total_Negative_Qty ASC;

-- Query 13: Out-of-Stock Analysis by Category

SELECT
    Product_Category,
    COUNT(*) AS Out_of_Stock_Records,
    SUM(Qty_on_hand) AS Total_Qty_On_Hand,
    SUM(Inventory_Value) AS Total_Inventory_Value
FROM dbo.retail_inventory_clean
WHERE Stock_Available = 'Out of Stock'
GROUP BY
    Product_Category
ORDER BY
    Out_of_Stock_Records DESC;

-- Query 14: Store Inventory Risk

SELECT
    Store,
    COUNT(*) AS Inventory_Records,
    SUM(CASE WHEN Stock_Available = 'Out of Stock' THEN 1 ELSE 0 END) AS Out_of_Stock_Records,
    SUM(Qty_on_hand) AS Total_Qty_On_Hand,
    SUM(Inventory_Value) AS Total_Inventory_Value
FROM dbo.retail_inventory_clean
GROUP BY
    Store
ORDER BY
    Out_of_Stock_Records DESC;

-- Query 15: Final Business KPI Summary

SELECT
    COUNT(*) AS Total_Transactions,
    SUM(CASE WHEN Is_Return = 0 THEN 1 ELSE 0 END) AS Non_Return_Transactions,
    SUM(CASE WHEN Is_Return = 1 THEN 1 ELSE 0 END) AS Return_Transactions,
    SUM(CASE WHEN Is_Return = 0 THEN Sales_Amount ELSE 0 END) AS Gross_Sales,
    SUM(CASE WHEN Is_Return = 1 THEN ABS(Sales_Amount) ELSE 0 END) AS Return_Amount,
    SUM(Sales_Amount) AS Net_Sales,
    SUM(CASE WHEN Is_Return = 0 THEN Cogs ELSE 0 END) AS Total_COGS,
    SUM(CASE WHEN Is_Return = 0 THEN Sales_Amount - Cogs ELSE 0 END) AS Total_Profit
FROM dbo.retail_sales_clean;

-- Advanced Queires
-- Query 16: Rank Stores by Sales and Profit

WITH Store_Performance AS
(
    SELECT
        Store,
        SUM(Net_Sales) AS Total_Net_Sales,
        SUM(Profit) AS Total_Profit
    FROM dbo.retail_sales_clean
    WHERE Is_Return = 0
    GROUP BY Store
)
SELECT
    Store,
    Total_Net_Sales,
    Total_Profit,
    RANK() OVER (ORDER BY Total_Net_Sales DESC) AS Sales_Rank,
    RANK() OVER (ORDER BY Total_Profit DESC) AS Profit_Rank
FROM Store_Performance
ORDER BY Sales_Rank;

-- Query 17: Top 3 Products Within Each Category

WITH Product_Performance AS
(
    SELECT
        Product_Category,
        Product_No,
        Product_Description,
        SUM(Net_Sales) AS Total_Net_Sales,
        SUM(Profit) AS Total_Profit
    FROM dbo.retail_sales_clean
    WHERE Is_Return = 0
    GROUP BY
        Product_Category,
        Product_No,
        Product_Description
),
Ranked_Products AS
(
    SELECT
        Product_Category,
        Product_No,
        Product_Description,
        Total_Net_Sales,
        Total_Profit,
        ROW_NUMBER() OVER (
            PARTITION BY Product_Category
            ORDER BY Total_Net_Sales DESC
        ) AS Product_Rank
    FROM Product_Performance
)
SELECT
    Product_Category,
    Product_No,
    Product_Description,
    Total_Net_Sales,
    Total_Profit,
    Product_Rank
FROM Ranked_Products
WHERE Product_Rank <= 3
ORDER BY
    Product_Category,
    Product_Rank;

-- Query 18: Monthly Net Sales Growth

USE RetailSalesAnalysis;

WITH Monthly_Sales AS
(
    SELECT
        YEAR(Transaction_Date) AS Sales_Year,
        MONTH(Transaction_Date) AS Sales_Month,
        DATENAME(MONTH, Transaction_Date) AS Month_Name,
        SUM(Net_Sales) AS Total_Net_Sales
    FROM dbo.retail_sales_clean
    WHERE Is_Return = 0
    GROUP BY
        YEAR(Transaction_Date),
        MONTH(Transaction_Date),
        DATENAME(MONTH, Transaction_Date)
),
Sales_With_Previous_Month AS
(
    SELECT
        Sales_Year,
        Sales_Month,
        Month_Name,
        Total_Net_Sales,
        LAG(Total_Net_Sales) OVER (
            ORDER BY Sales_Year, Sales_Month
        ) AS Previous_Month_Sales
    FROM Monthly_Sales
)
SELECT
    Sales_Year,
    Sales_Month,
    Month_Name,
    Total_Net_Sales,
    Previous_Month_Sales,
    Total_Net_Sales - Previous_Month_Sales AS Sales_Change,
    CASE
        WHEN Previous_Month_Sales IS NULL OR Previous_Month_Sales = 0
            THEN NULL
        ELSE
            ((Total_Net_Sales - Previous_Month_Sales)
             / Previous_Month_Sales) * 100
    END AS MoM_Growth_Percentage
FROM Sales_With_Previous_Month
ORDER BY
    Sales_Year,
    Sales_Month;

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;

SELECT 
    name AS Database_Name
FROM sys.databases
ORDER BY name;

USE RetailSalesAnalysis;

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

USE RetailSalesAnalysis;

WITH Monthly_Sales AS
(
    SELECT
        YEAR(Transaction_Date) AS Sales_Year,
        MONTH(Transaction_Date) AS Sales_Month,
        DATENAME(MONTH, Transaction_Date) AS Month_Name,
        SUM(Net_Sales) AS Total_Net_Sales
    FROM dbo.retail_sales_clean
    GROUP BY
        YEAR(Transaction_Date),
        MONTH(Transaction_Date),
        DATENAME(MONTH, Transaction_Date)
)
SELECT
    Sales_Year,
    Sales_Month,
    Month_Name,
    Total_Net_Sales,
    LAG(Total_Net_Sales) OVER (
        ORDER BY Sales_Year, Sales_Month
    ) AS Previous_Month_Sales,
    Total_Net_Sales -
        LAG(Total_Net_Sales) OVER (
            ORDER BY Sales_Year, Sales_Month
        ) AS Sales_Change,
    CASE
        WHEN LAG(Total_Net_Sales) OVER (
            ORDER BY Sales_Year, Sales_Month
        ) IS NULL
        OR LAG(Total_Net_Sales) OVER (
            ORDER BY Sales_Year, Sales_Month
        ) = 0
        THEN NULL
        ELSE
            (
                (Total_Net_Sales -
                    LAG(Total_Net_Sales) OVER (
                        ORDER BY Sales_Year, Sales_Month
                    ))
                /
                LAG(Total_Net_Sales) OVER (
                    ORDER BY Sales_Year, Sales_Month
                )
            ) * 100
    END AS MoM_Growth_Percentage
FROM Monthly_Sales
ORDER BY Sales_Year, Sales_Month;

SELECT
    YEAR(Transaction_Date) AS Sales_Year,
    COUNT(*) AS Transaction_Count,
    SUM(Qty_Sold) AS Total_Units_Sold,
    SUM(Net_Sales) AS Total_Net_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(
        CASE
            WHEN Net_Sales <> 0
            THEN Profit / Net_Sales
        END
    ) AS Average_Profit_Margin
FROM dbo.retail_sales_clean
GROUP BY YEAR(Transaction_Date)
ORDER BY Sales_Year;

-- Qurey 19 - Return Rate by Sales Type

USE RetailSalesAnalysis;

SELECT
    Sales_Type,
    COUNT(*) AS Total_Transactions,
    SUM(CASE WHEN Is_Return = 1 THEN 1 ELSE 0 END) AS Returned_Transactions,
    CAST(
        SUM(CASE WHEN Is_Return = 1 THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS Return_Rate_Percentage,
    SUM(CASE WHEN Is_Return = 1 THEN Qty_Sold ELSE 0 END) AS Returned_Units,
    SUM(CASE WHEN Is_Return = 1 THEN Return_Amount ELSE 0 END) AS Total_Return_Amount
FROM dbo.retail_sales_clean
GROUP BY Sales_Type
ORDER BY Return_Rate_Percentage DESC;

-- Query 20: Profitability by Sales Type

USE RetailSalesAnalysis;

SELECT
    Sales_Type,
    COUNT(*) AS Transaction_Count,
    SUM(Net_Sales) AS Total_Net_Sales,
    SUM(Cogs) AS Total_COGS,
    SUM(Profit) AS Total_Profit,
    CAST(
        SUM(Profit) * 100.0
        / NULLIF(SUM(Net_Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percentage
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
GROUP BY Sales_Type
ORDER BY Total_Profit DESC;

-- Query 21: Return Performance by Product Category

USE RetailSalesAnalysis;

SELECT
    Product_Category,
    COUNT(*) AS Total_Transactions,
    SUM(CASE WHEN Is_Return = 1 THEN 1 ELSE 0 END) AS Returned_Transactions,
    CAST(
        SUM(CASE WHEN Is_Return = 1 THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS Return_Rate_Percentage,
    SUM(CASE WHEN Is_Return = 1 THEN Qty_Sold ELSE 0 END) AS Returned_Units,
    SUM(CASE WHEN Is_Return = 1 THEN Return_Amount ELSE 0 END) AS Total_Return_Amount
FROM dbo.retail_sales_clean
GROUP BY Product_Category
ORDER BY Return_Rate_Percentage DESC;


-- Query 22: Store Return Rate Analysis

SELECT
    Store,
    SUM(Number_of_Transactions) AS Total_Transactions,
    SUM(CASE WHEN Is_Return = 1 THEN Number_of_Transactions ELSE 0 END) AS Returned_Transactions,
    CAST(
        SUM(CASE WHEN Is_Return = 1 THEN Number_of_Transactions ELSE 0 END) * 100.0
        / NULLIF(SUM(Number_of_Transactions), 0)
        AS DECIMAL(10,2)
    ) AS Return_Rate_Percentage,
    SUM(CASE WHEN Is_Return = 1 THEN Qty_Sold ELSE 0 END) AS Returned_Units,
    SUM(CASE WHEN Is_Return = 1 THEN Return_Amount ELSE 0 END) AS Total_Return_Amount
FROM dbo.retail_sales_clean
GROUP BY Store
ORDER BY Return_Rate_Percentage DESC;

-- Query 23: Sales Channel Performance

SELECT
    Sales_Channel,
    SUM(Number_of_Transactions) AS Total_Transactions,
    SUM(Qty_Sold) AS Total_Units_Sold,
    SUM(Net_Sales) AS Total_Net_Sales,
    SUM(Profit) AS Total_Profit,
    CAST(
        SUM(Profit) * 100.0
        / NULLIF(SUM(Net_Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percentage
FROM dbo.retail_sales_clean
GROUP BY Sales_Channel
ORDER BY Total_Net_Sales DESC;

-- Query 24: Supplier Performance

SELECT
    Supplier,
    SUM(Number_of_Transactions) AS Total_Transactions,
    SUM(Qty_Sold) AS Total_Units_Sold,
    SUM(Net_Sales) AS Total_Net_Sales,
    SUM(Profit) AS Total_Profit,
    CAST(
        SUM(Profit) * 100.0
        / NULLIF(SUM(Net_Sales), 0)
        AS DECIMAL(10,2)
    ) AS Profit_Margin_Percentage
FROM dbo.retail_sales_clean
GROUP BY Supplier
ORDER BY Total_Net_Sales DESC;

-- Query 25: Overall Business Performance Summary

SELECT
    SUM(Number_of_Transactions) AS Total_Transactions,
    SUM(Qty_Sold) AS Total_Units_Sold,
    SUM(Net_Sales) AS Total_Net_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Return_Amount) AS Total_Return_Amount,
    CAST(
        SUM(Profit) * 100.0
        / NULLIF(SUM(Net_Sales), 0)
        AS DECIMAL(10,2)
    ) AS Overall_Profit_Margin,
    COUNT(DISTINCT Store) AS Total_Stores,
    COUNT(DISTINCT Product_Category) AS Total_Product_Categories,
    COUNT(DISTINCT Supplier) AS Total_Suppliers
FROM dbo.retail_sales_clean;

