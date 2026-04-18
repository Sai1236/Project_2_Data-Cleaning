select *
from Project_1.dbo.NashvilleHousing

--standardized date format

select SaleDateConverted , Convert(Date,SaleDate) 
from Project_1.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = Convert(Date,SaleDate)

ALTER TABLE NashvilleHousing 
Add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = Convert(Date,SaleDate)

--Populate property address data
select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
from Project_1.dbo.NashvilleHousing a
join Project_1.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Project_1.dbo.NashvilleHousing a
join Project_1.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Project_1.dbo.NashvilleHousing a
join Project_1.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out Address into Indiviual (Address,City,State)

select *
from Project_1.dbo.NashvilleHousing

select propertyaddress
from Project_1.dbo.NashvilleHousing
order by propertyaddress

select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) As Address
from Project_1.dbo.NashvilleHousing

select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) As Street,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress)) As City
from Project_1.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing 
Add Street Nvarchar(255);

update NashvilleHousing
set Street  = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing 
Add City Nvarchar(255);

update NashvilleHousing
set City  = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress))

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3) As StreetAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) As CityAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) As StateAddress
from Project_1.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing 
Add StreetAddress Nvarchar(255);

update NashvilleHousing
set StreetAddress  = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing 
Add CityAddress Nvarchar(255);

update NashvilleHousing
set CityAddress  = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing 
Add StateAddress Nvarchar(255);

update NashvilleHousing
set StateAddress  = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

-- Change Y/N to Yes and No

Select SoldAsVacant,
Case When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
     Else SoldAsVacant
     END
from Project_1.dbo.NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
     Else SoldAsVacant
     END

Select Count(SoldAsVacant)
from Project_1.dbo.NashvilleHousing
group by  SoldAsVacant


--Remove Duplicates
Select *
from Project_1.dbo.NashvilleHousing

WITH RowNumCTE AS (
Select *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
             PropertyAddress,
             SalePrice,
             SaleDate,
             LegalReference
             ORDER BY
             UniqueID) row_num
from Project_1.dbo.NashvilleHousing
)
Select *
from RowNumCTE
where row_num >1


WITH RowNumCTE AS (
Select *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
             PropertyAddress,
             SalePrice,
             SaleDate,
             LegalReference
             ORDER BY
             UniqueID) row_num
from Project_1.dbo.NashvilleHousing
)
Delete
from RowNumCTE
where row_num>1

--Delete Unused Columns

Alter Table Project_1.dbo.NashvilleHousing
Drop Column OwnerAddress,PropertyAddress,TaxDistrict

Alter Table Project_1.dbo.NashvilleHousing
Drop Column SaleDate

Select *
from Project_1.dbo.NashvilleHousing
