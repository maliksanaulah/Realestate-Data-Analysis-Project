use [House project]
select * from Nashville_Housing

Alter table Nashville_Housing 
add saledateconverted Date;

Update Nashville_Housing
set saledateconverted =CONVERT(date,SaleDate)

Select saledateconverted ,CONVERT(date,SaleDate)
from Nashville_Housing


select ParcelID , PropertyAddress
from Nashville_Housing
--where PropertyAddress is null

select a.ParcelID , a.PropertyAddress ,b.ParcelID ,b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress)
from Nashville_Housing a
join Nashville_Housing b
on a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID

where a.PropertyAddress is null


Update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Nashville_Housing a
join Nashville_Housing b
on a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is Null

------------------------------------------------------------------------------------------


-- Breaking Address into individual columns (Address , City , State)

select *
from Nashville_Housing
select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address

from Nashville_Housing


Alter table Nashville_Housing 
add PropertySplitAddress nvarchar(333), PropertySplitCity nvarchar(400);

update Nashville_Housing 
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
   PropertySplitCity =substring (PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

-----------------------------------------------------------------------------------------------------------


-- For Owner Address use Parsename

 SELECT OwnerAddress from 
 Nashville_Housing


 select 
 PARSENAME(REPLACE( OwnerAddress , ',', '.'),3),
 PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,2),
 PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,1)

from Nashville_Housing

ALTER TABLE nashville_Housing
ADD OwnerSplitAddress nvarchar(300),
OwnerSplitCity nvarchar(300),
OwnerSplitState nvarchar(399)


Update Nashville_Housing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3),
OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress , ',' ,'.'),2),
OwnerSplitState = ParseName(REPLACE(OwnerAddress , ',' ,'.'),1)


select * from Nashville_Housing

--------------------------------------------------------------------------------------------


--Change O and 1 into N and Y in "SoldAsVacant" Field
select Distinct (SoldAsVacant)
from Nashville_Housing

select SoldAsVacant ,
CASE when SoldAsVacant = '0'then 'NO'
else 'Yes'
END
from Nashville_Housing


Alter Table nashville_Housing
Alter Column SoldAsVacant Varchar(3)



Update Nashville_Housing
set SoldAsVacant = Case when SoldAsVacant = '0' Then 'No'
                   else 'Yes'
				   End

Select * from Nashville_Housing

---------------------------------------------------------------------------------------------


--Remove Duplicate
WITH RowNumCTE as(
SELECT * ,
ROW_NUMBER() OVER (
Partition by ParcelID,

PropertyAddress,
SalePrice,
LegalReference
Order by
UniqueID)Row_num

from Nashville_Housing
--ORDER BY ParcelID
)
Delete 
from RowNumCTE
where row_num >1

-------------------------------------------------------------------------------------------------

--Delete Unused Columns

Select * 
from Nashville_Housing

Alter Table Nashville_Housing
Drop Column OwnerAddress , TaxDistrict , PropertyAddress 

Alter Table Nashville_Housing
Drop Column SaleDate