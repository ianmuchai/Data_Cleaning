create table NashvilleHousing(uniqueid numeric, parcelid varchar(250), landuse varchar(250), propertyaddress varchar(250), saledate varchar(250),
							 saleprice varchar(250), legalreference varchar(250), soldasvacant varchar(250), ownername varchar(250),
							 owneraddress varchar(250), acreage numeric, taxdistrict varchar(250), landvalue varchar(250), buildingvalue numeric,
							 totalvalue numeric, yearbuilt numeric, bedrooms numeric, fullbath numeric, halfbath numeric)
								
Select propertyaddress
from public.nashvillehousing
where propertyaddress is null

Select *
from public.nashvillehousing
where propertyaddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from public.nashvillehousing a
join public.nashvillehousing b
on a.parcelID = b.parcelID
and a.uniqueID <> b.uniqueID
where a.PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, COALESCE(a.PropertyAddress,b.PropertyAddress)
from public.nashvillehousing a
join public.nashvillehousing b
on a.parcelID = b.parcelID
and a.uniqueID <> b.uniqueID
where a.PropertyAddress is null


SELECT COALESCE(a.PropertyAddress,b.PropertyAddress) as Property_address
INTO Newest_table 
from public.nashvillehousing a
join public.nashvillehousing b
on a.parcelID = b.parcelID
and a.uniqueID <> b.uniqueID
where a.PropertyAddress is null

select * from Newest_table

update nashvillehousing
SET PropertyAddress = Property_Address
from Mashville
where PropertyAddress is null

Select *
from public.nashvillehousing
where PropertyAddress is null

SELECT SUBSTRING(Propertyaddress, 1, STRPOS(PropertyAddress, ',')) as Address
from Nashvillehousing


SELECT SUBSTRING(Propertyaddress,1, STRPOS(PropertyAddress, ',')) as Address
from Nashvillehousing
-- *function includes commmas, need to remove that. Below Query.


SELECT SUBSTRING(Propertyaddress, 0, STRPOS(PropertyAddress, ',')) as Address
, SUBSTRING(Propertyaddress, STRPOS(PropertyAddress, ',')+1) as Address
from Nashvillehousing

ALTER TABLE nashvillehousing
Add propertysplitaddress varchar (250)

update nashvillehousing
SET PropertysplitAddress = SUBSTRING(Propertyaddress, 0, STRPOS(PropertyAddress, ','))

ALTER TABLE nashvillehousing
Add propertysplitcity varchar (250)

update nashvillehousing
SET Propertysplitcity = SUBSTRING(Propertyaddress, STRPOS(PropertyAddress, ',')+1)

Select * from nashvillehousing

Select OwnerAddress from nashvillehousing

Select OwnerAddress, split_part(OwnerAddress,',', 1)
, split_part(OwnerAddress,',', 2)
, split_part(OwnerAddress,',', 3)
from nashvillehousing

Select split_part(OwnerAddress,',', 1)
, split_part(OwnerAddress,',', 2)
, split_part(OwnerAddress,',', 3)
from nashvillehousing

ALTER TABLE nashvillehousing
Add ownersplitaddress varchar (250)

update nashvillehousing
SET ownersplitAddress = split_part(OwnerAddress,',', 1)

ALTER TABLE nashvillehousing
Add ownersplitcity varchar (250)

update nashvillehousing
SET ownersplitcity = split_part(OwnerAddress,',', 2)

ALTER TABLE nashvillehousing
Add ownersplitstate varchar (250)

update nashvillehousing
SET ownersplitstate = split_part(OwnerAddress,',', 3)

-- Changing Y and N to Yes and No in "sold as vacant" field"
Select Distinct(soldasvacant), count(soldasvacant)
from nashvillehousing
group by soldasvacant
order by 2

select soldasvacant
, case when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end
from nashvillehousing

update Nashvillehousing
set soldasvacant = case when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end

-- Getting rid of Duplicates
WITH RowNumCTE as(
Select uniqueID	,
Row_number() over (
	partition by parcelID, 
	PropertyAddress, 
	SalePrice, 
	SaleDate,
	LegalReference
	order by
	uniqueID) as row_num
	
from nashvillehousing
--order by parcelID
	)
delete
from nashvillehousing
where uniqueID in (select uniqueID from RowNumCTE where row_num > 1)


-- Checking whether any duplicates left
WITH RowNumCTE as(
Select *,
Row_number() over (
	partition by parcelID, 
	PropertyAddress, 
	SalePrice, 
	SaleDate,
	LegalReference
	order by
	uniqueID) row_num
	
from nashvillehousing
--order by parcelID
	)
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress

-- Deleting Unused Columns in Dataset

Select * from nashvillehousing

ALTER TABLE Nashvillehousing
DROP COLUMN OwnerAddress,DROP COLUMN PropertyAddress,DROP COLUMN TaxDistrict
