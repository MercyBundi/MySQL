-- DATA CLEANING

-- created a database(schema) by pressing the drum plus
-- in the tables under the specific schema, i right clicked and imported data


SELECT *
FROM layoffs;

-- 1.Removing the Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank spaces
-- 4. Remove any columns


-- to create a copy of the data in order to maintain the raw data
CREATE TABLE layoffs_staging
SELECT *
FROM layoffs;


-- 1. REMOVE THE DUPLICATE
-- if there is no primary key column
CREATE TABLE temp_table
SELECT *,ROW_NUMBER() OVER (PARTITION BY 
						company, location, industry, 
                        total_laid_off,percentage_laid_off,
                        date, stage, country, funds_raised_millions)  AS row_num
FROM layoffs_staging;

DELETE
FROM temp_table
WHERE row_num >1;

DROP TABLE layoffs_staging;

RENAME TABLE temp_table TO layoffs_staging;


-- 2. STANDARDIZING DATA
  -- distinct is used to retrieve the values once,
      -- without repetion as it appears in the columns
SELECT DISTINCT company   
FROM layoffs_staging;

UPDATE layoffs_staging
SET company = TRIM(company);

-- checking the column in order to notice any mistakes
SELECT DISTINCT industry   
FROM layoffs_staging
ORDER BY 1;
-- i have noticed mispelling, blank space and null


-- to solve the mispelling issue 
SELECT *  
FROM layoffs_staging
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location  
FROM layoffs_staging
ORDER BY 1;

SELECT DISTINCT country  
FROM layoffs_staging
ORDER BY 1;

-- we are removing a full stop at the end
UPDATE layoffs_staging
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

UPDATE layoffs_staging
SET country = TRIM(country);

-- if tryng to do a time series, changing the date format
  -- the date format is CASE sensitive (m/d/Y)
SELECT date,
STR_TO_DATE (date,'%m/%d/%Y')
FROM layoffs_staging;

UPDATE layoffs_staging
SET date = STR_TO_DATE (date,'%m/%d/%Y');

-- changing value type of a column (date column from text to date)
ALTER TABLE layoffs_staging
MODIFY COLUMN date DATE;
 

-- 3. NULL VALUES OR BLANK SPACES
-- first we change the blankspaces to null
UPDATE layoffs_staging
SET industry = NULL
WHERE industry = '';

-- join the table by itself to use filled-in rows to fill the ones unfilled
SELECT t1.industry, t2.industry
FROM layoffs_staging t1
JOIN layoffs_staging t2
	ON t1.company=t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- then we update and fillin the null values in industry column
UPDATE layoffs_staging t1
JOIN layoffs_staging t2
	ON t1.company=t2.company
SET t1.industry = t2. industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- checking to see if its indeed filled
SELECT *  
FROM layoffs_staging
WHERE company = 'Airbnb';


-- Deleting rows that have null values that cannot be filled
DELETE
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


-- Deleting an unneccesary column
ALTER TABLE layoffs_staging
DROP COLUMN row_num;


SELECT * 
FROM layoffs_staging;