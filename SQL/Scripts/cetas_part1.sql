--Master Key SERVERLESS POOL
SELECT name, CASE when d.is_master_key_encrypted_by_server = 1 then 'Yes Master key' ELSE 'NO Master Key' END as MasterKey
FROM sys.databases as d
WHERE d.name = 'your serverless pool';

--Credentials for the instance
SELECT * FROM sys.database_credentials

-- Create a db master key if one does not already exist, using your own password.
CREATE MASTER KEY ENCRYPTION BY PASSWORD='YOUR PASSWORD HERE';

--Verify the presence of the new key 
SELECT * FROM sys.symmetric_keys


--Verify Credentials
SELECT * FROM sys.database_credentials

-- Create a database scoped credential.  Remove ?
CREATE DATABASE SCOPED CREDENTIAL DeltaLakeCredential
WITH IDENTITY = 'SHARED ACCESS SIGNATURE', --TYPE of access
SECRET = 'BLOB SAS TOKEN';

DROP EXTERNAL TABLE Customers_cetas
DROP EXTERNAL DATA SOURCE DeltaLakeStorageDS
--Create external data source
CREATE EXTERNAL DATA SOURCE DeltaLakeStorageDS
WITH
  ( LOCATION = 'abfss://AZURE DATA LAKE.dfs.core.windows.net',
    CREDENTIAL = DeltaLakeCredential) ;

--Create External File Format 
CREATE EXTERNAL FILE FORMAT ParquetFormat WITH (  FORMAT_TYPE = PARQUET );



--CETAS Customers
CREATE EXTERNAL TABLE dbo.Customers_cetas(
	[CustomerID] int,
	[CustomerName] nvarchar(4000),
	[BillToCustomerID] int,
	[CustomerCategoryID] int,
	[BuyingGroupID] int,
	[PrimaryContactPersonID] int,
	[AlternateContactPersonID] int,
	[DeliveryMethodID] int,
	[DeliveryCityID] int,
	[PostalCityID] int,
	[CreditLimit] numeric(18,2),
	[AccountOpenedDate] date,
	[StandardDiscountPercentage] numeric(18,3),
	[IsStatementSent] bit,
	[IsOnCreditHold] bit,
	[PaymentDays] int,
	[PhoneNumber] nvarchar(4000),
	[FaxNumber] nvarchar(4000),
	[DeliveryRun] nvarchar(4000),
	[RunPosition] nvarchar(4000),
	[WebsiteURL] nvarchar(4000),
	[DeliveryAddressLine1] nvarchar(4000),
	[DeliveryAddressLine2] nvarchar(4000),
	[DeliveryPostalCode] nvarchar(4000),
	[PostalAddressLine1] nvarchar(4000),
	[PostalAddressLine2] nvarchar(4000),
	[PostalPostalCode] nvarchar(4000),
	[LastEditedBy] int,
	[ValidFrom] datetime2(7),
	[ValidTo] datetime2(7)
) WITH (
        LOCATION = 'bronze/Customers2022-10-07T18:18:27.8653046Z.parquet', 
        -- LOCATION = 'bronze/Customers/*.parquet',              -- SET OF FILES read recursively using (*)
		-- LOCATION = 'bronze/Customers=*/cuMonth=*/*.parquet',  -- Dynamic Pattern read recursively using (*)
        DATA_SOURCE = DeltaLakeStorageDS,
        FILE_FORMAT = ParquetFormat
);

