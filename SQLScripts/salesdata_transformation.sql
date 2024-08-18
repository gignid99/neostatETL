SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER   PROCEDURE [dbo].[salesdata_transformation]
AS

-- Null check/ Data Quality Check
UPDATE STG SET ValidFlag = -1
from [dbo].[SalesData_Encrypted] AS STG where OrderID IS NULL OR PhoneNumber IS NULL

UPDATE STG SET ValidFlag = -1
from [dbo].[SalesData_Encrypted] AS STG where CustomerName IS NULL OR StoreCode IS NULL

UPDATE STG SET ValidFlag = -1
from [dbo].[SalesData_Encrypted] AS STG where [Location] IS NULL OR [Country] IS NULL

UPDATE STG SET ValidFlag = -1
from [dbo].[SalesData_Encrypted] AS STG where Product IS NULL

update  STG SET Quantity = NULL
from [dbo].[SalesData_Encrypted] AS STG where Quantity = 0

update  STG SET Price = NULL
from [dbo].[SalesData_Encrypted] AS STG where Price = 0

update STG set ValidFlag = -1 from [dbo].[SalesData_Encrypted] as stg 
where [Quantity] is not null and [Price] is null

update STG set ValidFlag = -1 from [dbo].[SalesData_Encrypted] as stg 
where [Price] is not null and [Quantity] is null 

update STG set ValidFlag = -1 from [dbo].[SalesData_Encrypted] as stg 
where [Quantity] is  null and [Price] is null 

-- data type check

UPDATE STG SET ValidFlag = -1 from [dbo].[SalesData_Encrypted] AS STG WHERE ISNUMERIC(Price) = 0

UPDATE STG SET ValidFlag = -1 from [dbo].[SalesData_Encrypted] AS STG WHERE ISDATE(Date) = 0


-- Invalid/ Update Check -- Data Governance and integrity -- Enrichment -- Data Cleaning
--- Country Location Enrichment
update STG set STG.Country = LKP.Country 
from [dbo].[SalesData_Encrypted] STG 
JOIN [dbo].[country_lookup] LKP 
ON STG.[Location] = LKP.[Location] 

--CustomerName enrichment

UPDATE STG Set CustomerName  = LEFT(CustomerName, PATINDEX('%[0-9]%', CustomerName) - 1) 
from [dbo].[SalesData_Encrypted] STG
where CustomerName LIKE '%[0-9]%'

--Phone Number Enrichment
UPDATE STG 
SET PhoneNumber =
case when country = 'USA' THEN concat('+1',SUBSTRING(PhoneNumber, LEN('+1 ') + 1, LEN(PhoneNumber) - LEN('+1 ')))
WHEN Country = 'India' THEN concat('+91',SUBSTRING(PhoneNumber, LEN('+1 ') + 1, LEN(PhoneNumber) - LEN('+1 '))) 
WHEN Country = 'UK' THEN concat('+44',SUBSTRING(PhoneNumber, LEN('+1 ') + 1, LEN(PhoneNumber) - LEN('+1 '))) 
WHEN Country = 'Australia' THEN concat('+61',SUBSTRING(PhoneNumber, LEN('+1 ') + 1, LEN(PhoneNumber) - LEN('+1 '))) 
WHEN Country = 'UK' THEN concat('+44',SUBSTRING(PhoneNumber, LEN('+1 ') + 1, LEN(PhoneNumber) - LEN('+1 '))) 
WHEN Country = 'Canada' THEN concat('+1',SUBSTRING(PhoneNumber, LEN('+1 ') + 1, LEN(PhoneNumber) - LEN('+1 '))) 
END
from [dbo].[SalesData_Encrypted] STG

-- duplicate check

-- select orderId, count(*) as countOfDuplicate from [dbo].[SalesData_Encrypted]
-- where ValidFlag IS NULL
--  group by OrderID HAVING Count(*) > 1

-- ;with cte as
--  (select *, ROW_NUMBER() OVER(PARTITION BY OrderID order by Quantity) rn from [dbo].[SalesData_Encrypted])

-- update cte set ValidFlag = -1 where rn > 1

-- Data Cleaning
-- updating qty to rounded off value for deeper data analysis

update STG SET Quantity = ROUND(Quantity,0)
from [dbo].[SalesData_Encrypted] as STG 
where Quantity != CAST(Quantity AS INT);

-- Total Sales per OrderID
update [dbo].[SalesData_Encrypted] set TotalSales = Quantity * Price where ValidFlag IS NULL
GO
