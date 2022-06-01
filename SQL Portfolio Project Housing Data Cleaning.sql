--Data Cleaning in SQL

SELECT * FROM HousingProject

Select NewDate, convert(Date,SaleDate) from HousingProject

update HousingProject
set SaleDate = convert(Date, SaleDate)

alter table HousingProject
add NewDate Date;

update HousingProject
set NewDate = convert(Date, SaleDate)

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from HousingProject as a
join HousingProject as b
on a.ParcelID = b.ParcelID 
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from HousingProject as a
join HousingProject as b
on a.ParcelID = b.ParcelID 
and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

Select 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as Address
from HousingProject

alter table HousingProject
add HouseAddress Nvarchar(255);

update HousingProject
set HouseAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

alter table HousingProject
add CityAddress Nvarchar(255);

update HousingProject
set CityAddress = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))


Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from HousingProject


alter table HousingProject
add OwnerHouseAddress Nvarchar(255);

update HousingProject
set OwnerHouseAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

alter table HousingProject
add OwnerCityAddress Nvarchar(255);

update HousingProject
set OwnerCityAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

alter table HousingProject
add OwnerStateAddress Nvarchar(255);

update HousingProject
set OwnerStateAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


Select SoldAsVacant,
Case when SoldAsVacant = 'Y' then 'YES'
	when SoldAsVacant = 'N' then 'NO'
	else SoldAsVacant 
	end
from HousingProject

update HousingProject
set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'YES'
	when SoldAsVacant = 'N' then 'NO'
	else SoldAsVacant 
	end

select * from HousingProject


WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID) row_num
From HousingProject
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From HousingProject 

ALTER TABLE HousingProject
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


Select *
From HousingProject 

