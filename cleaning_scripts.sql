USE nashville_housing;

--Standardize Date Column
ALTER TABLE nash_house
ADD SaleDateConverted DATE;

UPDATE nash_house
SET SaleDateConverted = CONVERT(DATE, SaleDate);


--Populate Property Address Data
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM nash_house a
JOIN nash_house b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;



-- Breaking Address into indiv columns (Address, city, state)

-- PROPERTY ADDRESS
ALTER TABLE nash_house
ADD PropertySplitAddress NVARCHAR(255);

ALTER TABLE nash_house
ADD PropertySplitCity NVARCHAR(255);

UPDATE nash_house
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress, 1) -1);

UPDATE nash_house
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress, 1) +1, LEN(PropertyAddress));



-- OWNER ADDRESS
ALTER TABLE nash_house
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE nash_house
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

ALTER TABLE nash_house
ADD OwnerSplitCity NVARCHAR(255);

UPDATE nash_house
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

ALTER TABLE nash_house
ADD OwnerSplitState NVARCHAR(255);

UPDATE nash_house
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

SELECT * 
FROM nash_house;


--Change Y and N to Yes and No in  `SoldasVacant`
UPDATE nash_house
SET SoldAsVacant = CASE 
						WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
					END


--Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY 
		ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
	ORDER BY 
		UniqueID
	) row_num
FROM nash_house
--ORDER BY ParcelID
)

Select *
FROM RowNumCTE
WHERE row_num > 1


-- Delete Unused Columns
-- (usually to edit a View, NOT RAW DATA)
ALTER TABLE nash_house
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress;

ALTER TABLE nash_house
DROP COLUMN SaleDate;


SELECT *
FROM nash_house