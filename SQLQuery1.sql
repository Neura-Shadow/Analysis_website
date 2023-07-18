Select Location, date, total_cases, new_cases, total_deaths, population
From Protfolio..CovidDeaths
Where continent is not null 
order by 1,2


----SELECT Location,date,population,max(total_cases) as limit 
----from CovidDeaths
----group by location,date,population
----order by limit desc


--select location,MAX(cast(total_deaths as int))as TotalDeathCount
--from CovidDeaths
--where continent is null
--group by location
--order by TotalDeathCount desc




-- Using Temp Table to perform Calculation on Partition By in previous query
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



--perform Calculation on Partition By in previous query
With popasvac(Continent,location,Date,Population,New_Vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location, dea.date ,dea.population,vac.new_vaccinations,
SUM(CONVERT(bigint,new_vaccinations)) over (partition by dea.location 
ORDER BY dea.location,dea.date) as RollingpeopleVaccinated
from CovidDeaths dea 
join CovidVaccinations vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *
from popasvac



-- Creating View to store data for later visualizations

create view pic as
select dea.continent,dea.location, dea.date ,dea.population,vac.new_vaccinations,
SUM(CONVERT(bigint,new_vaccinations)) over (partition by dea.location 
ORDER BY dea.location,dea.date) as RollingpeopleVaccinated
from CovidDeaths dea 
join CovidVaccinations vac
on dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

---------------------------------------------------------------------------------------------------------------------------------------------------




Select *
From PortfolioProject..NashvilleHousing
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



-- Breaking out Address into Individual Columns


Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);
Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);
Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select *
From PortfolioProject.dbo.NashvilleHousing





Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);
Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);
Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);
Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.dbo.NashvilleHousing
