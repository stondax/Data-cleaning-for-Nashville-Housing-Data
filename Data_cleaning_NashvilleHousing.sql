Create DATABASE nashville_housing_dataset;

/*

Cleaning Data in SQL Queries

*/


Select *
From nashville_housing_dataset.`nashville housing data for data cleaning`;


-- Standardize Date Format


Select saleDateConverted, CONVERT(Date,SaleDate)
From nashville_housing_dataset.`nashville housing data for data cleaning`


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE nashville_housing_dataset.`nashville housing data for data cleaning`
Add SaleDateConverted Date;

Update nashville_housing_dataset.`nashville housing data for data cleaning`
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- Populate Property Address data

Select *
From nashville_housing_dataset.`nashville housing data for data cleaning`
-- Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From nashville_housing_dataset.`nashville housing data for data cleaning` a
JOIN nashville_housing_dataset.`nashville housing data for data cleaning` b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From nashville_housing_dataset.`nashville housing data for data cleaning` a
JOIN nashville_housing_dataset.`nashville housing data for data cleaning` b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From nashville_housing_dataset.`nashville housing data for data cleaning`
-- Where PropertyAddress is null
-- order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From nashville_housing_dataset.`nashville housing data for data cleaning`


ALTER TABLE nashville_housing_dataset.`nashville housing data for data cleaning`
Add PropertySplitAddress Nvarchar(255);

Update nashville_housing_dataset.`nashville housing data for data cleaning`
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE nashville_housing_dataset.`nashville housing data for data cleaning`
Add PropertySplitCity Nvarchar(255);

Update nashville_housing_dataset.`nashville housing data for data cleaning`
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From nashville_housing_dataset.`nashville housing data for data cleaning`





Select OwnerAddress
From nashville_housing_dataset.`nashville housing data for data cleaning`


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From nashville_housing_dataset.`nashville housing data for data cleaning`



ALTER TABLE nashville_housing_dataset.`nashville housing data for data cleaning`
Add OwnerSplitAddress Nvarchar(255);

Update nashville_housing_dataset.`nashville housing data for data cleaning`
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);


ALTER TABLE nashville_housing_dataset.`nashville housing data for data cleaning`
Add OwnerSplitCity Nvarchar(255);

Update nashville_housing_dataset.`nashville housing data for data cleaning`
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);



ALTER TABLE nashville_housing_dataset.`nashville housing data for data cleaning`
Add OwnerSplitState Nvarchar(255);

Update nashville_housing_dataset.`nashville housing data for data cleaning`
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);



Select *
From nashville_housing_dataset.`nashville housing data for data cleaning`



-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From nashville_housing_dataset.`nashville housing data for data cleaning`
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From nashville_housing_dataset.`nashville housing data for data cleaning`


Update nashville_housing_dataset.`nashville housing data for data cleaning`
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END




-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From nashville_housing_dataset.`nashville housing data for data cleaning`
-- order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From nashville_housing_dataset.`nashville housing data for data cleaning`


-- Delete Unused Columns



Select *
From nashville_housing_dataset.`nashville housing data for data cleaning`


ALTER TABLE nashville_housing_dataset.`nashville housing data for data cleaning`
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate







