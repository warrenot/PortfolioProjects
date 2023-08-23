/*
Cleaning Data in SQL Queries
*/

Select *
From NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------------------------------------
--- Standardized Date Format


Select SaleDateConvered, CONVERT(date, SaleDate)
From NashvilleHousing

Update NashvilleHousing
Set SaleDate = Convert(date, SaleDate)

Alter Table NashvilleHousing
Add SaleDateConvered Date;

Update NashvilleHousing
Set SaleDateConvered = Convert(date, SaleDate)

------------------------------------------------------------------------------------------------------------------------------------------------

----Populate Property Address Data
Select PropertyAddress
from NashvilleHousing
where PropertyAddress is null

Select *
from NashvilleHousing
where PropertyAddress is null


Select *
from NashvilleHousing
order by ParcelID


Select *
from NashvilleHousing a
Join NashvilleHousing b
	on a.ParcelID = b.ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
Join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
Join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]


---	---------------------------------------------------------------------------------------------------------------------------------------------
--- Breaking Out Address into individual Columns (Address, City, State)     


Select PropertyAddress
from NashvilleHousing
order by ParcelID 

Select
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) As Address
, Substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 ,LEN(PropertyAddress)) As City
from NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = Substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 ,LEN(PropertyAddress))

Select *
From NashvilleHousing

Select OwnerAddress
From NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress1 nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress1 = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter Table NashvilleHousing
Add OwnerSplitAddress1 nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress1 = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter Table NashvilleHousing
Add PropertySplitState1 nvarchar(255);

Update NashvilleHousing
Set PropertySplitState1 = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


Select *
From NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------------------------

---Change Y and N to 'Yes' and 'No' in "Sold as Vacant" Field

Select Distinct(SoldAsVacant),Count(SoldAsVacant) as SAV
From NashvilleHousing
Group By SoldAsVacant
Order by SAV desc

Select Distinct(SoldAsVacant),Count(SoldAsVacant) as SAV
From NashvilleHousing
Group By SoldAsVacant
Order by 2

Select SoldAsVacant
,CASE When SoldAsVacant = 'Y' Then 'Yes'
	  When SoldAsVacant = 'N' Then 'No'	
	  Else SoldAsVacant
      End SAV
From NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
	  When SoldAsVacant = 'N' Then 'No'	
	  Else SoldAsVacant
      End 

-------------------------------------------------------------------------------------------------------------------------------------------------
--- Remove Duplicates


With RowNumCTE as(
SELECT *,
	Row_Number() Over (
	Partition By ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order By
					UniqueID
					) row_num
From NashvilleHousing
---Order By ParcelID
)
Select *
From RowNumCTE
Where row_num > 1



With RowNumCTE as(
SELECT *,
	Row_Number() Over (
	Partition By ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order By
					UniqueID
					) row_num
From NashvilleHousing
---Order By ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1

Select *
From NashvilleHousing

-------------------------------------------------------------------------------------------------------------------------------------------------
--- dELETE Unused Column

Select *
From NashvilleHousing

Alter Table  NashvilleHousing
Drop Column OwnerAddress,TaxDistrict,PropertyAddress

Alter Table  NashvilleHousing
Drop Column SaleDate, LandValue, BuildingValue, PropertySplitCity,PropertySplitAddress