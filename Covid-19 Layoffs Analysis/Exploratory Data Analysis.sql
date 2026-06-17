-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging;

SELECT MAX( total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging;

SELECT MIN(date), MAX(date)
FROM layoffs_staging;

SELECT *
FROM layoffs_staging
WHERE percentage_laid_ofF = 1
ORDER BY funds_raised_millions DESC;

-- getting total_laid_off of the grouped category
SELECT company, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company
ORDER BY 2 DESC;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY country
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY stage
ORDER BY 2 DESC;

SELECT date, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY date
ORDER BY 1 DESC;

-- total_laid_off for each year
SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_staging
GROUP BY YEAR(date)
ORDER BY 1 DESC;

-- total_laid_off for each month without considering the year
SELECT SUBSTRING(date, 6, 2) AS month, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY month;

-- total_laid_off for each month while considering the year
SELECT SUBSTRING(date, 1, 7) AS yearmonth, SUM(total_laid_off)
FROM layoffs_staging
WHERE SUBSTRING(date, 1, 7) IS NOT NULL
GROUP BY yearmonth
ORDER BY 1 ASC;


-- rolling total as the months went by to years
WITH Rolling_total AS
(
	SELECT SUBSTRING(date, 1, 7) AS yearmonth, SUM(total_laid_off) AS total_off
	FROM layoffs_staging
	WHERE SUBSTRING(date, 1, 7) IS NOT NULL
	GROUP BY yearmonth
	ORDER BY 1 ASC
)
SELECT yearmonth,total_off,SUM(total_off) OVER(ORDER BY yearmonth) AS rolling_total
FROM Rolling_total;

-- alternative without using cte
SELECT 
    DISTINCT SUBSTRING(date,1,7) as Month, 
    SUM(total_laid_off) OVER(PARTITION BY SUBSTRING(date, 1,7)) as total_layoffs,
	SUM(total_laid_off) OVER(ORDER BY SUBSTRING(date, 1,7)) as layoffs_rolling
FROM 
    layoffs_staging
WHERE 
     SUBSTRING(date,1,7) IS NOT NULL
ORDER BY 1;


-- how many each company was laying off per year
SELECT company, YEAR(date), SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company, YEAR(date)
ORDER BY company ASC;


-- rank of company that laid off the highest each year (top 5)
-- created two cte (common table expression)
WITH Company_year (company, years, total_laid_off) AS 
(
	SELECT company, YEAR(date), SUM(total_laid_off)
	FROM layoffs_staging
	GROUP BY company, YEAR(date)
), Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <=5;

