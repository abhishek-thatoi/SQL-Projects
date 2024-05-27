/*

Cleaing Data using SQL Queries

*/

SELECT*
FROM PrjSQL..HousingData
ORDER BY 1;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Standardize Data Format
-- Changing data type of Date col
SELECT SaleDate, CONVERT(DATE,SaleDate)  FROM PrjSQL..HousingData;

ALTER TABLE PRJSQL..HousingData 
ALTER COLUMN SALEDATE DATE;

SELECT SaleDate
FROM PrjSQL..HousingData;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- POPULATE Property address data

SELECT PropertyAddress
FROM PrjSQL..HousingData
WHERE PropertyAddress IS NULL -- To find properties with no address 
ORDER BY ParcelID;
-- every property must have a unique address and parcel id

-- TO find if any property with no address may have parcel id to relate
SELECT H1.ParcelID, H1.PropertyAddress,H2.ParcelID, H2.PropertyAddress
FROM PrjSQL..HousingData H1 JOIN PrjSQL..HousingData H2 
ON H1.ParcelID=H2.ParcelID
	 AND H1.[UniqueID ]<>H2.[UniqueID ]
WHERE H1.PropertyAddress IS NULL; -- AFTER updating no null value will be found

-- once we find corresponding addresses for NULL values having same parcelID
--		we populate the NULL address field with the same
 UPDATE H1 SET H1.PropertyAddress= ISNULL(H1.PropertyAddress,H2.PropertyAddress)
 FROM PrjSQL..HousingData H1 JOIN PrjSQL..HousingData H2 
	ON H1.ParcelID=H2.ParcelID
	 AND H1.[UniqueID ]<>H2.[UniqueID ]
WHERE H1.PropertyAddress IS NULL;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- breaking Address into individual columns(Locality/city/state)

SELECT PropertyAddress
FROM PrjSQL..HousingData
WHERE PropertyAddress IS NULL 
ORDER BY ParcelID				