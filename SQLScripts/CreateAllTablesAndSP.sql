
--step 1: create master key encryption using master key function
-- Step 1: Open and drop the symmetric key

OPEN SYMMETRIC KEY CreditCardKey
DECRYPTION BY CERTIFICATE CreditCardCert;

CLOSE SYMMETRIC KEY CreditCardKey;
DROP SYMMETRIC KEY CreditCardKey;
-- Step 2: Drop the certificate
DROP CERTIFICATE CreditCardCert;
DROP MASTER KEY;
-- Step 3: Recreate the certificate and symmetric key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Password';

CREATE CERTIFICATE CreditCardCert
WITH SUBJECT = 'Credit Card Encryption Certificate';

CREATE SYMMETRIC KEY CreditCardKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE CreditCardCert;


DROP TABLE IF EXISTS [dbo].[SalesData_Encrypted];
DROP TABLE IF EXISTS [dbo].[Final_Sales_Data];
DROP TABLE IF EXISTS [dbo].[country_lookup];

CREATE TABLE [dbo].[SalesData_Encrypted](
	[OrderID] [varchar](100) NULL,
	[CustomerName] [varchar](100) NULL,
	[PhoneNumber] [varchar](20) NULL,
	[Location] [varchar](100) NULL,
	[Country] [varchar](50) NULL,
	[StoreCode] [varchar](50) NULL,
	[Product] [varchar](100) NULL,
	[Quantity] [float] NULL,
	[Price] [float] NULL,
	[Date] [datetime] NULL,
	[EncryptedCreditCardNumber] [varbinary](256) NULL,
	[ExpiryDate] [varchar](10) NULL,
	[Ingestion_Date] [datetime] NULL,
	[ValidFlag] [varchar](10) NULL,
	[TotalSales] [float] NULL
);

CREATE TABLE [dbo].[Final_Sales_Data](
	[orderID] [varchar](100) NULL,
	[CustomerName] [varchar](100) NULL,
	[PhoneNumber] [varchar](20) NULL,
	[Location] [varchar](100) NULL,
	[Country] [varchar](50) NULL,
	[StoreCode] [varchar](50) NULL,
	[Product] [varchar](100) NULL,
	[Quantity] [float] NULL,
	[Price] [float] NULL,
	[Date] [datetime] NULL,
	[EncryptedCreditCardNumber] [varbinary](256) NULL,
	[ExpiryDate] [varchar](10) NULL,
	[TotalSales] [float] NULL
)

CREATE TABLE [dbo].[country_lookup](
	[Country] [varchar](100) NULL,
	[Location] [varchar](100) NULL
)

INSERT INTO [dbo].[country_lookup] (Country, [Location])
VALUES ('USA','New York'),
('USA', 'Los Angeles'),
('USA','Houston'),
('USA','California'),
('USA','Chicago'),
('UK','London'),
('UK','Newcastle'),
('Australia','Sydney'),
('Australia','Canberra'),
('India','Mumbai'),
('India','New Delhi'),
('Canada','Toronto')




