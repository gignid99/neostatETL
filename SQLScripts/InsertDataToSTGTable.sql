SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER     PROCEDURE [dbo].[InsertSalesDataWithEncryptedCreditCard]
    @OrderID VARCHAR(50),
    @CustomerName VARCHAR(100),
    @PhoneNumber VARCHAR(20),
    @Location VARCHAR(100),
    @Country VARCHAR(50),
    @StoreCode VARCHAR(50),
    @Product VARCHAR(100),
    @Quantity FLOAT,
    @Price FLOAT,
    @Date DATETIME,
    @CreditCardNumber VARCHAR(50),
    @ExpiryDate VARCHAR(10)
AS
BEGIN
    -- Open the symmetric key
    OPEN SYMMETRIC KEY CreditCardKey
    DECRYPTION BY CERTIFICATE CreditCardCert;

    -- Insert the data with the encrypted credit card number
    INSERT INTO dbo.SalesData_Encrypted (OrderID, CustomerName, PhoneNumber, Location, Country, 
    StoreCode, Product, Quantity, Price, Date, EncryptedCreditCardNumber, ExpiryDate)
    VALUES (
        @OrderID,
        @CustomerName,
        @PhoneNumber,
        @Location,
        @Country,
        @StoreCode,
        @Product,
        @Quantity,
        @Price,
        @Date,
        ENCRYPTBYKEY(KEY_GUID('CreditCardKey'), @CreditCardNumber),
        @ExpiryDate
    );

    -- Close the symmetric key
    CLOSE SYMMETRIC KEY CreditCardKey;
END;

UPDATE dbo.SalesData_Encrypted  
SET Ingestion_Date = GETDATE()

GO
