USE RetailSalesAnalysis;

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Transaction_Date IS NULL THEN 1 ELSE 0 END) AS Null_Transaction_Date,
    SUM(CASE WHEN Sales_Type IS NULL THEN 1 ELSE 0 END) AS Null_Sales_Type,
    SUM(CASE WHEN Supplier IS NULL THEN 1 ELSE 0 END) AS Null_Supplier,
    SUM(CASE WHEN Product_No IS NULL THEN 1 ELSE 0 END) AS Null_Product_No,
    SUM(CASE WHEN Qty_Sold IS NULL THEN 1 ELSE 0 END) AS Null_Qty_Sold,
    SUM(CASE WHEN Sales_Amount IS NULL THEN 1 ELSE 0 END) AS Null_Sales_Amount
FROM dbo.retail_sales_clean;


SELECT
    Transaction_Date,
    Sales_Type,
    Is_Return,
    Supplier,
    Product_No,
    Store,
    Qty_Sold,
    Sales_Amount,
    COUNT(*) AS Duplicate_Count
FROM dbo.retail_sales_clean
GROUP BY
    Transaction_Date,
    Sales_Type,
    Is_Return,
    Supplier,
    Product_No,
    Store,
    Qty_Sold,
    Sales_Amount
HAVING COUNT(*) > 1;

-- Inventory table null check

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Start_Date IS NULL THEN 1 ELSE 0 END) AS Null_Start_Date,
    SUM(CASE WHEN End_Date IS NULL THEN 1 ELSE 0 END) AS Null_End_Date,
    SUM(CASE WHEN Stock_Status IS NULL THEN 1 ELSE 0 END) AS Null_Stock_Status,
    SUM(CASE WHEN Supplier IS NULL THEN 1 ELSE 0 END) AS Null_Supplier,
    SUM(CASE WHEN Product_No IS NULL THEN 1 ELSE 0 END) AS Null_Product_No,
    SUM(CASE WHEN Store IS NULL THEN 1 ELSE 0 END) AS Null_Store,
    SUM(CASE WHEN Qty_on_hand IS NULL THEN 1 ELSE 0 END) AS Null_Qty_on_hand,
    SUM(CASE WHEN Stocks_Selling_Amount IS NULL THEN 1 ELSE 0 END) AS Null_Stocks_Selling_Amount,
    SUM(CASE WHEN Cost_of_Stocks IS NULL THEN 1 ELSE 0 END) AS Null_Cost_of_Stocks,
    SUM(CASE WHEN Stock_Unit_Selling_Price IS NULL THEN 1 ELSE 0 END) AS Null_Stock_Unit_Selling_Price,
    SUM(CASE WHEN Stock_Unit_Cost_Price IS NULL THEN 1 ELSE 0 END) AS Null_Stock_Unit_Cost_Price,
    SUM(CASE WHEN Inventory_Value IS NULL THEN 1 ELSE 0 END) AS Null_Inventory_Value,
    SUM(CASE WHEN Inventory_Cost IS NULL THEN 1 ELSE 0 END) AS Null_Inventory_Cost,
    SUM(CASE WHEN Stock_Available IS NULL THEN 1 ELSE 0 END) AS Null_Stock_Available
FROM dbo.retail_inventory_clean;

-- Inventory duplicate check

SELECT
    Start_Date,
    End_Date,
    Stock_Status,
    Supplier,
    Product_No,
    Store,
    Qty_on_hand,
    COUNT(*) AS Duplicate_Count
FROM dbo.retail_inventory_clean
GROUP BY
    Start_Date,
    End_Date,
    Stock_Status,
    Supplier,
    Product_No,
    Store,
    Qty_on_hand
HAVING COUNT(*) > 1;

-- Inventory negative value check

SELECT
    COUNT(*) AS Negative_Qty_On_Hand
FROM dbo.retail_inventory_clean
WHERE Qty_on_hand < 0;

SELECT
    Negative_Stock_Flag,
    COUNT(*) AS Record_Count
FROM dbo.retail_inventory_clean
WHERE Qty_on_hand < 0
GROUP BY Negative_Stock_Flag;

SELECT
    Negative_Stock_Flag,
    COUNT(*) AS Record_Count
FROM dbo.retail_inventory_clean
GROUP BY Negative_Stock_Flag;

SELECT
    Negative_Stock_Flag,
    MIN(Qty_on_hand) AS Min_Qty,
    MAX(Qty_on_hand) AS Max_Qty
FROM dbo.retail_inventory_clean
GROUP BY Negative_Stock_Flag;

-- Sales negative quantity check

SELECT
    COUNT(*) AS Negative_Qty_Sold
FROM dbo.retail_sales_clean
WHERE Qty_Sold < 0;

SELECT
    Is_Return,
    COUNT(*) AS Record_Count
FROM dbo.retail_sales_clean
WHERE Qty_Sold < 0
GROUP BY Is_Return;

SELECT
    Is_Return,
    COUNT(*) AS Record_Count
FROM dbo.retail_sales_clean
WHERE Qty_Sold >= 0
GROUP BY Is_Return;

SELECT
    COUNT(*) AS Negative_Sales_Amount
FROM dbo.retail_sales_clean
WHERE Sales_Amount < 0;

SELECT
    Is_Return,
    COUNT(*) AS Record_Count
FROM dbo.retail_sales_clean
WHERE Sales_Amount < 0
GROUP BY Is_Return;

SELECT
    COUNT(*) AS Negative_COGS
FROM dbo.retail_sales_clean
WHERE COGS < 0;

SELECT
    Is_Return,
    COUNT(*) AS Record_Count
FROM dbo.retail_sales_clean
WHERE COGS < 0
GROUP BY Is_Return;

-- Check zero sales amount on non-return transactions

SELECT
    Is_Return,
    COUNT(*) AS Record_Count
FROM dbo.retail_sales_clean
WHERE Sales_Amount <= 0
GROUP BY Is_Return;

SELECT
    Transaction_Date,
    Is_Return,
    Qty_Sold,
    Sales_Amount,
    COGS,
    Product_No,
    Store,
    Sales_Type
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND Sales_Amount <= 0;

SELECT
    Sales_Type,
    COUNT(*) AS Record_Count,
    SUM(Qty_Sold) AS Total_Qty,
    SUM(COGS) AS Total_COGS
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND Sales_Amount <= 0
GROUP BY Sales_Type;

SELECT
    Transaction_Date,
    Qty_Sold,
    Sales_Amount,
    COGS,
    Product_No,
    Store,
    COUNT(*) AS Record_Count
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND Sales_Amount = 0
GROUP BY
    Transaction_Date,
    Qty_Sold,
    Sales_Amount,
    COGS,
    Product_No,
    Store
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS Mismatched_Records
FROM dbo.retail_sales_clean
WHERE Qty_Sold > 0
  AND Sales_Amount < 0;

SELECT TOP 20
    Qty_Sold,
    Sales_Amount,
    Cogs,
    Qty_Sold * Cogs AS Calculated_COGS
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND Sales_Amount > 0;


SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'retail_sales_clean'
ORDER BY ORDINAL_POSITION;

SELECT
    MIN(Qty_Sold) AS Min_Qty_Sold,
    MAX(Qty_Sold) AS Max_Qty_Sold,
    MIN(Sales_Amount) AS Min_Sales_Amount,
    MAX(Sales_Amount) AS Max_Sales_Amount,
    MIN(Cogs) AS Min_Cogs,
    MAX(Cogs) AS Max_Cogs
FROM dbo.retail_sales_clean;

SELECT
    Is_Return,
    COUNT(*) AS Record_Count,
    MIN(Qty_Sold) AS Min_Qty_Sold,
    MIN(Sales_Amount) AS Min_Sales_Amount,
    MIN(Cogs) AS Min_Cogs
FROM dbo.retail_sales_clean
GROUP BY Is_Return
ORDER BY Is_Return;

SELECT
    COUNT(*) AS Invalid_Non_Return_Records
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND (
      Qty_Sold < 0
      OR Sales_Amount < 0
      OR Cogs < 0
  );

SELECT
    MIN(Transaction_Date) AS Earliest_Date,
    MAX(Transaction_Date) AS Latest_Date,
    COUNT(*) AS Total_Records
FROM dbo.retail_sales_clean;

SELECT
    Transaction_Date,
    Sales_Type,
    Is_Return,
    Supplier,
    Product_No,
    Store,
    Qty_Sold,
    Sales_Amount,
    COUNT(*) AS Duplicate_Count
FROM dbo.retail_sales_clean
GROUP BY
    Transaction_Date,
    Sales_Type,
    Is_Return,
    Supplier,
    Product_No,
    Store,
    Qty_Sold,
    Sales_Amount
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;

SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE
        WHEN Is_Return = 0
         AND Qty_Sold > 0
         AND Sales_Amount = 0
        THEN 1 ELSE 0
    END) AS Zero_Sales_With_Quantity
FROM dbo.retail_sales_clean;

SELECT
    Transaction_Date,
    Is_Return,
    Qty_Sold,
    Sales_Amount,
    Cogs,
    Product_No,
    Store,
    Sales_Type
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND Qty_Sold > 0
  AND Sales_Amount = 0;

SELECT
    COUNT(*) AS Zero_Sales_Anomalies,
    SUM(Cogs) AS Total_COGS_Of_Anomalies
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND Qty_Sold > 0
  AND Sales_Amount = 0;

SELECT
    COUNT(*) AS Invalid_COGS_Records
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND Qty_Sold > 0
  AND Cogs <= 0;

SELECT
    COUNT(*) AS Zero_Qty_With_Sales
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND Qty_Sold = 0
  AND Sales_Amount > 0;

SELECT
    COUNT(*) AS Profit_Mismatch_Records
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND ABS(Profit - (Net_Sales - Cogs)) > 0.01;

SELECT
    COUNT(*) AS Profit_Margin_Mismatch
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND Net_Sales <> 0
  AND ABS(Profit_Margin - (Profit / Net_Sales * 100)) > 0.01;

SELECT TOP 20
    Net_Sales,
    Cogs,
    Profit,
    Profit_Margin,
    Profit / NULLIF(Net_Sales, 0) AS Calculated_Margin
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND Net_Sales <> 0;

SELECT
    COUNT(*) AS Profit_Margin_Mismatch
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND Net_Sales <> 0
  AND ABS(Profit_Margin - (Profit / Net_Sales)) > 0.01;

SELECT
    Is_Return,
    COUNT(*) AS Record_Count,
    SUM(CASE
        WHEN Is_Return = 1 AND Return_Amount IS NULL THEN 1
        ELSE 0
    END) AS Returns_With_Null_Amount,
    SUM(CASE
        WHEN Is_Return = 0 AND Return_Amount <> 0 THEN 1
        ELSE 0
    END) AS Non_Returns_With_Return_Amount
FROM dbo.retail_sales_clean
GROUP BY Is_Return;

SELECT
    Sales_Channel,
    COUNT(*) AS Record_Count
FROM dbo.retail_sales_clean
GROUP BY Sales_Channel
ORDER BY Record_Count DESC;

SELECT
    Sales_Type,
    COUNT(*) AS Record_Count
FROM dbo.retail_sales_clean
GROUP BY Sales_Type
ORDER BY Record_Count DESC;

-- Check for invalid Sales_Type values
SELECT DISTINCT Sales_Type
FROM dbo.retail_sales_clean
WHERE Sales_Type NOT IN (
    'Full Price',
    'Promo',
    'Markdown Tier 1',
    'Markdown Tier 2',
    'Clearance'
);

-- Check Is_Return values
SELECT
    Is_Return,
    COUNT(*) AS Record_Count
FROM dbo.retail_sales_clean
GROUP BY Is_Return
ORDER BY Is_Return;

-- Check Return Amount consistency
SELECT
    Is_Return,
    COUNT(*) AS Record_Count,
    SUM(CASE
            WHEN Is_Return = 1 AND Return_Amount IS NULL THEN 1
            ELSE 0
        END) AS Returns_With_Null_Amount,
    SUM(CASE
            WHEN Is_Return = 0 AND Return_Amount IS NOT NULL THEN 1
            ELSE 0
        END) AS Non_Returns_With_Return_Amount
FROM dbo.retail_sales_clean
GROUP BY Is_Return
ORDER BY Is_Return;

-- Check for incorrect Return Amounts
SELECT
    COUNT(*) AS Invalid_Non_Return_Amounts
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND Return_Amount <> 0;

-- Check Sales Amount consistency
SELECT
    COUNT(*) AS Invalid_Sales_Amount
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND Qty_Sold > 0
  AND Sales_Amount <= 0;

-- Inspect invalid Sales Amount records
SELECT
    Transaction_Date,
    Is_Return,
    Qty_Sold,
    Sales_Amount,
    Cogs,
    Product_No,
    Store,
    Sales_Type
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND Qty_Sold > 0
  AND Sales_Amount <= 0;

-- Investigate zero Sales Amount records
SELECT
    Transaction_Date,
    Qty_Sold,
    Sales_Amount,
    Gross_Sales,
    Return_Amount,
    Net_Sales,
    Cogs,
    Profit,
    Sales_Type
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND Qty_Sold > 0
  AND Sales_Amount <= 0;

-- Check Profit calculation
SELECT TOP 20
    Net_Sales,
    Cogs,
    Profit,
    Net_Sales - Cogs AS Calculated_Profit
FROM dbo.retail_sales_clean
WHERE ABS(Profit - (Net_Sales - Cogs)) > 0.01;

-- Check Profit Margin calculation
SELECT TOP 20
    Net_Sales,
    Profit,
    Profit_Margin,
    Profit / NULLIF(Net_Sales, 0) AS Calculated_Margin
FROM dbo.retail_sales_clean
WHERE Net_Sales > 0
  AND ABS(Profit_Margin - (Profit / NULLIF(Net_Sales, 0))) > 0.01;

-- Check for duplicate sales records
SELECT
    Transaction_Date,
    Sales_Type,
    Is_Return,
    Supplier,
    Product_No,
    Store,
    Qty_Sold,
    Sales_Amount,
    COUNT(*) AS Duplicate_Count
FROM dbo.retail_sales_clean
GROUP BY
    Transaction_Date,
    Sales_Type,
    Is_Return,
    Supplier,
    Product_No,
    Store,
    Qty_Sold,
    Sales_Amount
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;

-- Check for invalid Qty_Sold values
SELECT
    COUNT(*) AS Invalid_Qty_Sold
FROM dbo.retail_sales_clean
WHERE Qty_Sold < 0;

-- Check for negative Qty_Sold in non-return transactions
SELECT
    COUNT(*) AS Invalid_Non_Return_Qty
FROM dbo.retail_sales_clean
WHERE Is_Return = 0
  AND Qty_Sold < 0;

-- Check Product and Store completeness

SELECT
    SUM(CASE WHEN Product_No IS NULL OR LTRIM(RTRIM(Product_No)) = '' THEN 1 ELSE 0 END) AS Invalid_Product_No,
    SUM(CASE WHEN Store IS NULL OR LTRIM(RTRIM(Store)) = '' THEN 1 ELSE 0 END) AS Invalid_Store
FROM dbo.retail_sales_clean;

-- Check Gross Sales, Return Amount and Net Sales consistency

SELECT
    COUNT(*) AS Financial_Mismatch_Records
FROM dbo.retail_sales_clean
WHERE ABS(Net_Sales - (Gross_Sales - Return_Amount)) > 0.01;

-- Check for future transaction dates

SELECT
    COUNT(*) AS Future_Dated_Transactions
FROM dbo.retail_sales_clean
WHERE Transaction_Date > '2026-04-24';

-- Check Inventory Value consistency

SELECT
    COUNT(*) AS Inventory_Value_Mismatches
FROM dbo.retail_inventory_clean
WHERE ABS(
    Inventory_Value - (Qty_on_hand * Stock_Unit_Cost_Price)
) > 0.01;

SELECT TOP 20
    Qty_on_hand,
    Stock_Unit_Selling_Price,
    Stock_Unit_Cost_Price,
    Inventory_Value,
    Inventory_Cost,
    Stocks_Selling_Amount,
    Cost_of_Stocks
FROM dbo.retail_inventory_clean;

-- Check Inventory Value against Qty × Selling Price

SELECT
    COUNT(*) AS Inventory_Value_Mismatches
FROM dbo.retail_inventory_clean
WHERE ABS(
    Inventory_Value - (Qty_on_hand * Stock_Unit_Selling_Price)
) > 0.01;

-- Check Inventory Cost against Qty × Cost Price

SELECT
    COUNT(*) AS Inventory_Cost_Mismatches
FROM dbo.retail_inventory_clean
WHERE ABS(
    Inventory_Cost - (Qty_on_hand * Stock_Unit_Cost_Price)
) > 0.01;

-- Investigate Inventory Cost mismatches
SELECT TOP 20
    Qty_on_hand,
    Stock_Unit_Cost_Price,
    Inventory_Cost,
    Qty_on_hand * Stock_Unit_Cost_Price AS Calculated_Inventory_Cost,
    Inventory_Value,
    Stock_Available,
    Negative_Stock_Flag
FROM dbo.retail_inventory_clean
WHERE ABS(
    Inventory_Cost - (Qty_on_hand * Stock_Unit_Cost_Price)
) > 0.01;

-- Check Inventory Cost for records with stock on hand

SELECT
    COUNT(*) AS Inventory_Cost_Mismatches_With_Stock
FROM dbo.retail_inventory_clean
WHERE Qty_on_hand > 0
  AND ABS(
      Inventory_Cost - (Qty_on_hand * Stock_Unit_Cost_Price)
  ) > 0.01;

-- Check invalid inventory date ranges

SELECT
    COUNT(*) AS Invalid_Date_Ranges
FROM dbo.retail_inventory_clean
WHERE End_Date IS NOT NULL
  AND End_Date < Start_Date;