use classicmodels
#Remove Duplicates
create table layoffs_staging 
like layoffs;

insert layoffs_staging
select * 
from layoffs;

select * from layoffs_staging

with duplicate_cte as
(
select *, 
row_number() over(
partition by `company`, `location`, `industry`, `total_laid_off`, `percentage_laid_off`, `date`, `stage`, `country`, `funds_raised_millions`) as row_num
from layoffs_staging
)
select * 
from duplicate_cte
where row_num >1;

#DELETE
#FROM duplicate_cte
#WHERE row_num>1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert INTO layoffs_staging2
select *,
row_number() OVER(
partition by  `company`, `location`, `industry`, `total_laid_off`, 
`percentage_laid_off`, `date`, `stage`, `country`, `funds_raised_millions`) as row_num
from layoffs_staging;

select * FROM layoffs_staging2
where row_num >1;

delete 
FROM 
layoffs_staging2
WHERE row_num >1;

select *
FROM 
layoffs_staging2
WHERE row_num >1;

#Standarding data
UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT distinct industry
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%'
#order by 1
;
# USING TRAILING get RID OFF '.'
select distinct country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
order by 1;

update layoffs_staging2
set country = TRIM(TRAILING '.' FROM country)
WHERE country like 'United States%'

SELECT distinct country
FROM layoffs_staging2
where country like 'United States%'
#order by 1
;

#convert text to date for date column
select * from layoffs_staging2

select date,
str_to_date(date,'%m/%d/%Y')
from layoffs_staging2

UPDATE layoffs_staging2
set date = str_to_date(date,'%m/%d/%Y')

ALTER TABLE layoffs_staging2
MODIFY COLUMN date DATE;

# HANDLING NULL
select *
from layoffs_staging2
WHERE company = 'Airbnb';

select * 
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null
;

#covert blank to null

update layoffs_staging2 
set industry = NULL
WHERE industry ='';

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null
;

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null)
and t2.industry is not null

#remove records are null
select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null

Delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null

#remove columns

alter table layoffs_staging2
drop column row_num;


