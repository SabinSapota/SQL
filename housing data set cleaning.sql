
--protfoliyo project on data cleaning by sql server
--this is housing data set which i clean on sql server

select count(*)from dbo.housing;
--lets clean the saleDate and put it on proper format
select SaleDate,convert(date,SaleDate)as saledate from dbo.housing;

alter table housing
add newsaledate date --creating new column to store date in new format
update housing
set newsaledate=convert(date,SaleDate)


--lets check null value percentage in Propertyaddress column

 SELECT round((cast(SUM(CASE WHEN PropertyAddress IS NULL OR PropertyAddress IN ('') THEN 1 ELSE 0
END) as float)/cast(count(*) as float))*100,2) AS missing_state
FROM housing;

--populate property address data as few are missing
--we will do self join

select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
   from housing as a inner join
   housing as b on
   a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
   where a.PropertyAddress is NULL;
   --------------------------------------------------------
  

--lest update our table after filling null space
update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from housing as a inner join
   housing as b on
   a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
   where a.PropertyAddress is NULL;

--breaking address column into  individual address,city 
select PropertyAddress,SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,CHARINDEX(',',PropertyAddress))
from dbo.housing

alter table housing
add address nvarchar(255);
update housing
set address=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table housing
add city nvarchar(255);
update housing
set city=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,CHARINDEX(',',PropertyAddress))

select* from housing;
--now using same above opeartion using parse name instead of substring
select OwnerAddress,PARSENAME(replace(OwnerAddress,',','.'),1),PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),3)
from housing;
alter table housing
add ownercity nvarchar(255)
update housing
set ownercity=PARSENAME(replace(OwnerAddress,',','.'),2)

alter table housing
add ownerstate nvarchar(255)
update housing
set ownerstate=PARSENAME(replace(OwnerAddress,',','.'),1)

alter table housing
add owneraddres nvarchar(255)
update housing
set owneraddres=PARSENAME(replace(OwnerAddress,',','.'),2)

--
------------------------------------------------------------------------------------------------------
--converting N to NO,Y to Yes present in column SoldAsVacant
select SoldAsVacant,count(SoldAsVacant)
from housing
group by SoldAsVacant;

update housing
set SoldAsVacant=
case
when SoldAsVacant='N' then 'NO'
when SoldAsVacant='Y' then 'Yes'
else SoldAsVacant
end
---------------------------------------------------------------------------------------
--remove duplicates
--there are 104 duplicates row which we need to remove

with cte as
(
select*, row_number() over(partition by ParcelID,PropertyAddress,SaleDate,SalePrice,SoldAsVacant,SaleDate,LegalReference order by UniqueID) as rownum

from housing
)
delete  from cte where rownum>1;

------------------------------------------------------------------------------------------------------------
--delete some unused columns

alter table housing
drop column PropertyAddress,SaleDate,OwnerAddress,OwnerName,TaxDistrict;
-------------------------------------------------------------------------------------------------------



