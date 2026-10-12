USE RetailSalesAnalysis;

SELECT TOP 10 *
FROM dbo.retail_sales_clean;

USE RetailSalesAnalysis;

SELECT TOP 10 *
FROM dbo.retail_inventory_clean;

USE RetailSalesAnalysis;

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'retail_inventory_clean'
ORDER BY ORDINAL_POSITION;