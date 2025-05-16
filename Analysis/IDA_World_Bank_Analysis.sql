/*
------------------------------------------------------------------------
DATA ANALYSIS
- Data from April 2011 to April 2025; data as of April 30, 2025
	- Focus time period between 2011 to 2025
- Dataset includes financial instruments: credits, grants, and guarantees
- Funding will be for credits and grants; often excluding guarantees unless specified in question

Project Questions:
1. Which regions or countries received the most credits, grants, and guarantees? 
2. Which regions or countries received the most IDA funding over time?
3. What are the trends in disbursement and repayment over time?
4. How long do projects typically take from approval to closing?
5. What proportion are the Disbursement and Repayment Ratios?
------------------------------------------------------------------------
*/

--------------------------------------------------------------------------------------
/* 1. Which regions or countries received the most credits, grants, and guarantees?  */
--------------------------------------------------------------------------------------
----- OVERALL
-- Total Principal Amount by Financial Instruments
WITH uniqueProjects AS (
	SELECT
		project_id,
		financial_instrument,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id,financial_instrument
),
instrumentTotals AS (
	SELECT 
		financial_instrument,
		ROUND(SUM(total_principal_amount),0) AS total_principal_amount
	FROM uniqueProjects
	GROUP BY financial_instrument
)
SELECT 
	financial_instrument,
	total_principal_amount,
	ROUND(100.0 * total_principal_amount / SUM(total_principal_amount) OVER (), 2) AS percent_of_total
FROM instrumentTotals
ORDER BY total_principal_amount DESC;
-- Avg Principal Amount by Financial Instruments
WITH uniqueProjects AS (
	SELECT
		project_id,
		financial_instrument,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id,financial_instrument
),
instrumentTotals AS (
	SELECT 
		financial_instrument,
		ROUND(AVG(total_principal_amount),0) AS avg_principal_amount
	FROM uniqueProjects
	GROUP BY financial_instrument
)
SELECT 
	financial_instrument,
	avg_principal_amount
FROM instrumentTotals
ORDER BY avg_principal_amount DESC;

----- REGION
-- Most Funded by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id,region
),
regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(total_principal_amount),0) AS total_principal_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	total_principal_amount,
	ROUND(100.0 * total_principal_amount / SUM(total_principal_amount) OVER(),2) AS percent_total
FROM regionTotals
ORDER BY total_principal_amount DESC;
-- Avg Funded by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id,region
), 
regionTotals AS
(
	SELECT 
		region,
		ROUND(AVG(total_principal_amount),0) AS avg_principal_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	avg_principal_amount
FROM regionTotals
ORDER BY avg_principal_amount DESC;

-- Most Credit Funded by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='credit'
	GROUP BY project_id,region
), 
regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(total_principal_amount),0) AS total_principal_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	total_principal_amount,
	ROUND(100.0 * total_principal_amount / SUM(total_principal_amount) OVER(),2) AS percent_total
FROM regionTotals
ORDER BY total_principal_amount DESC;
-- Avg Credit Funded by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='credit'
	GROUP BY project_id,region
),
regionTotals AS
(
	SELECT 
		region,
		ROUND(AVG(total_principal_amount),0) AS avg_principal_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	avg_principal_amount
FROM regionTotals
ORDER BY avg_principal_amount DESC;

-- Most Grant Funded by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='grant'
	GROUP BY project_id,region
), 
regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(total_principal_amount),0) AS total_principal_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	total_principal_amount,
	ROUND(100.0 * total_principal_amount / SUM(total_principal_amount) OVER(),2) AS percent_total
FROM regionTotals
ORDER BY total_principal_amount DESC;
-- Avg Grant Funded by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='grant'
	GROUP BY project_id,region
),  
regionTotals AS
(
	SELECT 
		region,
		ROUND(AVG(total_principal_amount),0) AS avg_principal_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	avg_principal_amount
FROM regionTotals
ORDER BY avg_principal_amount DESC;

-- Most Guarantee Funded by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='guarantee'
	GROUP BY project_id,region
), 
regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(total_principal_amount),0) AS total_principal_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	total_principal_amount,
	ROUND(100.0 * total_principal_amount / SUM(total_principal_amount) OVER(),2) AS percent_total
FROM regionTotals
ORDER BY total_principal_amount DESC;
-- Avg Guarantee Funded by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='guarantee'
	GROUP BY project_id,region
),
regionTotals AS
(
	SELECT 
		region,
		ROUND(AVG(total_principal_amount),0) AS avg_principal_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	avg_principal_amount
FROM regionTotals
ORDER BY avg_principal_amount DESC;

----- COUNTRY
-- Most Funded by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id,country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(total_principal_amount),0) AS total_principal_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	total_principal_amount,
	ROUND(100.0 * total_principal_amount / SUM(total_principal_amount) OVER(),2) AS percent_total
FROM countryTotals
ORDER BY total_principal_amount DESC;
-- Top Avg Funded by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id,country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(AVG(total_principal_amount),0) AS avg_principal_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	avg_principal_amount
FROM countryTotals
ORDER BY avg_principal_amount DESC;

-- Most Credits Funded by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='credit'
	GROUP BY project_id,country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(total_principal_amount),0) AS total_principal_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	total_principal_amount,
	ROUND(100.0 * total_principal_amount / SUM(total_principal_amount) OVER(),2) AS percent_total
FROM countryTotals
ORDER BY total_principal_amount DESC;
-- Top Avg Credits Funded by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='credit'
	GROUP BY project_id,country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(AVG(total_principal_amount),0) AS avg_principal_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	avg_principal_amount
FROM countryTotals
ORDER BY avg_principal_amount DESC;

-- Most Grant Funded by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='grant'
	GROUP BY project_id,country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(total_principal_amount),0) AS total_principal_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	total_principal_amount,
	ROUND(100.0 * total_principal_amount / SUM(total_principal_amount) OVER(),2) AS percent_total
FROM countryTotals
ORDER BY total_principal_amount DESC;
-- Top Avg Grant Funded by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='grant'
	GROUP BY project_id,country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(AVG(total_principal_amount),0) AS avg_principal_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	avg_principal_amount
FROM countryTotals
ORDER BY avg_principal_amount DESC;

-- Most Guarantee Funded by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='guarantee'
	GROUP BY project_id,country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(total_principal_amount),0) AS total_principal_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	total_principal_amount,
	ROUND(100.0 * total_principal_amount / SUM(total_principal_amount) OVER(),2) AS percent_total
FROM countryTotals
ORDER BY total_principal_amount DESC;
-- Top Avg Guarantee Funded by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='guarantee'
	GROUP BY project_id,country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(AVG(total_principal_amount),0) AS avg_principal_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	avg_principal_amount
FROM countryTotals
ORDER BY avg_principal_amount DESC;

----------------------------------------------------------------------------
/* 2. Which regions or countries received the most IDA funding over time? */
----------------------------------------------------------------------------
/* Use board approval date to shown IDA commitment to funding over time */
----- OVERALL -----
-- Overall Funding Commitment Over Time
WITH uniqueProjects AS (
	SELECT
		project_id,
		MIN(board_approval_date) AS board_approval_date,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 and 2025
	GROUP BY project_id,board_approval_date
),
yearlyFunding AS 
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		ROUND(SUM(total_principal_amount),0) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(board_approval_date)
),
final AS (
SELECT 
	funding_year,
	total_funding,
	ISNULL(ROUND(100.0 * (total_funding - LAG(total_funding) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(total_funding) OVER (ORDER BY funding_year),0), 1),0) AS yoy_pct_change,
	ROUND(AVG(total_funding) OVER (ORDER BY funding_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),0) AS moving_avg_3yr
FROM yearlyFunding
)
SELECT 
	*,
	ISNULL(ROUND(100.0 * (moving_avg_3yr - LAG(moving_avg_3yr) OVER (ORDER BY funding_year)) / 
			NULLIF(LAG(moving_avg_3yr) OVER (ORDER BY funding_year), 0),1),0) AS ma_pct_change
FROM final
ORDER BY funding_year ASC;

-- Overall Credit Funding Over Time
WITH uniqueProjects AS (
	SELECT
		project_id,
		MIN(board_approval_date) AS board_approval_date,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument='credit'
	GROUP BY project_id,board_approval_date
),
yearlyFunding AS 
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		ROUND(SUM(total_principal_amount),0) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(board_approval_date)
),
final AS (
SELECT 
	funding_year,
	total_funding,
	ISNULL(ROUND(100.0 * (total_funding - LAG(total_funding) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(total_funding) OVER (ORDER BY funding_year),0), 1),0) AS yoy_pct_change,
	ROUND(AVG(total_funding) OVER (ORDER BY funding_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),0) AS moving_avg_3yr
FROM yearlyFunding
)
SELECT 
	*,
	ISNULL(ROUND(100.0 * (moving_avg_3yr - LAG(moving_avg_3yr) OVER (ORDER BY funding_year)) / 
			NULLIF(LAG(moving_avg_3yr) OVER (ORDER BY funding_year), 0),1),0) AS ma_pct_change
FROM final
ORDER BY funding_year ASC;

-- Overall Grant Funding Over Time
WITH uniqueProjects AS (
	SELECT
		project_id,
		MIN(board_approval_date) AS board_approval_date,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument='grant'
	GROUP BY project_id,board_approval_date
),
yearlyFunding AS 
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		ROUND(SUM(total_principal_amount),0) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(board_approval_date)
),
final AS (
SELECT 
	funding_year,
	total_funding,
	ISNULL(ROUND(100.0 * (total_funding - LAG(total_funding) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(total_funding) OVER (ORDER BY funding_year),0), 1),0) AS yoy_pct_change,
	ROUND(AVG(total_funding) OVER (ORDER BY funding_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),0) AS moving_avg_3yr
FROM yearlyFunding
)
SELECT 
	*,
	ISNULL(ROUND(100.0 * (moving_avg_3yr - LAG(moving_avg_3yr) OVER (ORDER BY funding_year)) / 
			NULLIF(LAG(moving_avg_3yr) OVER (ORDER BY funding_year), 0),1),0) AS ma_pct_change
FROM final
ORDER BY funding_year ASC;

-- Overall Guarantee Funding Over Time
WITH uniqueProjects AS (
	SELECT
		project_id,
		MAX(board_approval_date) AS board_approval_date,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument='guarantee'
	GROUP BY project_id,board_approval_date
),
yearlyFunding AS 
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		ROUND(SUM(total_principal_amount),0) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(board_approval_date)
),
final AS (
SELECT 
	funding_year,
	total_funding,
	ISNULL(ROUND(100.0 * (total_funding - LAG(total_funding) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(total_funding) OVER (ORDER BY funding_year),0), 1),0) AS yoy_pct_change,
	ROUND(AVG(total_funding) OVER (ORDER BY funding_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),0) AS moving_avg_3yr
FROM yearlyFunding
)
SELECT 
	*,
	ISNULL(ROUND(100.0 * (moving_avg_3yr - LAG(moving_avg_3yr) OVER (ORDER BY funding_year)) / 
			NULLIF(LAG(moving_avg_3yr) OVER (ORDER BY funding_year), 0),1),0) AS ma_pct_change
FROM final
ORDER BY funding_year ASC;


----- REGION -----
-- Overall Funding by Region Over Time
----- Year over Year
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		MIN(board_approval_date) AS board_approval_date,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY project_id, region
),
yearlyFunding AS (
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		region,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(board_approval_date), region
),
with_pct_change AS (
	SELECT 
		funding_year,
		region,
		total_funding,
		ISNULL(ROUND(100.0 * (total_funding - LAG(total_funding) OVER (PARTITION BY region ORDER BY funding_year)) /
				NULLIF(LAG(total_funding) OVER (PARTITION BY region ORDER BY funding_year), 0), 1), 0) AS pct_change
	FROM yearlyFunding
)
SELECT 
	funding_year,
	SUM(CASE WHEN region = 'east asia and pacific' THEN total_funding ELSE 0 END) AS east_asia_and_pacific,
	SUM(CASE WHEN region = 'europe and central asia' THEN total_funding ELSE 0 END) AS europe_and_central_asia,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN total_funding ELSE 0 END) AS latin_america_and_caribbean,
	SUM(CASE WHEN region = 'middle east and africa' THEN total_funding ELSE 0 END) AS middle_east_and_africa,
	SUM(CASE WHEN region = 'south asia' THEN total_funding ELSE 0 END) AS south_asia,
	SUM(CASE WHEN region = 'other' THEN total_funding ELSE 0 END) AS other,
	SUM(CASE WHEN region = 'east asia and pacific' THEN pct_change ELSE 0 END) AS eap_pct_chg,
	SUM(CASE WHEN region = 'europe and central asia' THEN pct_change ELSE 0 END) AS eca_pct_chg,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN pct_change ELSE 0 END) AS lac_pct_chg,
	SUM(CASE WHEN region = 'middle east and africa' THEN pct_change ELSE 0 END) AS mea_pct_chg,
	SUM(CASE WHEN region = 'south asia' THEN pct_change ELSE 0 END) AS sa_pct_chg
FROM with_pct_change
GROUP BY funding_year
ORDER BY funding_year;

----- Moving Average 3 Year
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		MIN(board_approval_date) AS board_approval_date,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY project_id, region
),
yearlyfunding AS (
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		region,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(board_approval_date), region
),
with_ma AS (
	SELECT 
		funding_year,
		region,
		total_funding,
		ROUND(
			AVG(total_funding) OVER (
				PARTITION BY region
				ORDER BY funding_year
				ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
			), 0
		) AS ma_3yr
	FROM yearlyfunding
),
with_ma_change AS (
	SELECT 
		funding_year,
		region,
		ma_3yr,
		ISNULL(ROUND(100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY region ORDER BY funding_year)) /
			NULLIF(LAG(ma_3yr) OVER (PARTITION BY region ORDER BY funding_year), 0),1), 0) AS ma_3yr_pct_chg
	FROM with_ma
)
SELECT 
	funding_year,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr ELSE 0 END) AS eap_ma_3yr,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr ELSE 0 END) AS eca_ma_3yr,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr ELSE 0 END) AS lac_ma_3yr,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr ELSE 0 END) AS mea_ma_3yr,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr ELSE 0 END) AS sa_ma_3yr,
	SUM(CASE WHEN region = 'other' THEN ma_3yr ELSE 0 END) AS other_ma_3yr,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr_pct_chg ELSE 0 END) AS eap_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr_pct_chg ELSE 0 END) AS eca_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr_pct_chg ELSE 0 END) AS lac_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr_pct_chg ELSE 0 END) AS mea_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr_pct_chg ELSE 0 END) AS sa_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY funding_year
ORDER BY funding_year;


-- Credit Funding by Region Over Time
----- Year over Year
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		MIN(board_approval_date) AS board_approval_date,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument = 'credit'
	GROUP BY project_id, region
),
yearlyFunding AS (
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		region,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(board_approval_date), region
),
with_pct_change AS (
	SELECT 
		funding_year,
		region,
		total_funding,
		ISNULL(ROUND(100.0 * (total_funding - LAG(total_funding) OVER (PARTITION BY region ORDER BY funding_year)) /
			NULLIF(LAG(total_funding) OVER (PARTITION BY region ORDER BY funding_year), 0), 1), 0) AS pct_change
	FROM yearlyFunding
)
SELECT 
	funding_year,
	SUM(CASE WHEN region = 'east asia and pacific' THEN total_funding ELSE 0 END) AS east_asia_and_pacific,
	SUM(CASE WHEN region = 'europe and central asia' THEN total_funding ELSE 0 END) AS europe_and_central_asia,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN total_funding ELSE 0 END) AS latin_america_and_caribbean,
	SUM(CASE WHEN region = 'middle east and africa' THEN total_funding ELSE 0 END) AS middle_east_and_africa,
	SUM(CASE WHEN region = 'south asia' THEN total_funding ELSE 0 END) AS south_asia,
	SUM(CASE WHEN region = 'other' THEN total_funding ELSE 0 END) AS other,
	SUM(CASE WHEN region = 'east asia and pacific' THEN pct_change ELSE 0 END) AS eap_pct_chg,
	SUM(CASE WHEN region = 'europe and central asia' THEN pct_change ELSE 0 END) AS eca_pct_chg,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN pct_change ELSE 0 END) AS lac_pct_chg,
	SUM(CASE WHEN region = 'middle east and africa' THEN pct_change ELSE 0 END) AS mea_pct_chg,
	SUM(CASE WHEN region = 'south asia' THEN pct_change ELSE 0 END) AS sa_pct_chg
FROM with_pct_change
GROUP BY funding_year
ORDER BY funding_year;

----- Moving Average 3 Year
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		MIN(board_approval_date) AS board_approval_date,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument = 'credit'
	GROUP BY project_id, region
),
yearlyfunding AS (
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		region,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(board_approval_date), region
),
with_ma AS (
	SELECT 
		funding_year,
		region,
		total_funding,
		ROUND(AVG(total_funding) OVER (PARTITION BY region ORDER BY funding_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS ma_3yr
	FROM yearlyfunding
),
with_ma_change AS (
	SELECT 
		funding_year,
		region,
		ma_3yr,
		ISNULL(ROUND(100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY region ORDER BY funding_year)) /
			NULLIF(LAG(ma_3yr) OVER (PARTITION BY region ORDER BY funding_year), 0),1), 0) AS ma_3yr_pct_chg
	FROM with_ma
)
SELECT 
	funding_year,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr ELSE 0 END) AS eap_ma_3yr,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr ELSE 0 END) AS eca_ma_3yr,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr ELSE 0 END) AS lac_ma_3yr,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr ELSE 0 END) AS mea_ma_3yr,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr ELSE 0 END) AS sa_ma_3yr,
	SUM(CASE WHEN region = 'other' THEN ma_3yr ELSE 0 END) AS other_ma_3yr,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr_pct_chg ELSE 0 END) AS eap_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr_pct_chg ELSE 0 END) AS eca_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr_pct_chg ELSE 0 END) AS lac_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr_pct_chg ELSE 0 END) AS mea_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr_pct_chg ELSE 0 END) AS sa_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY funding_year
ORDER BY funding_year;


-- Grant Funding by Region Over Time
----- Year over Year
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		MIN(board_approval_date) AS board_approval_date,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument = 'grant'
	GROUP BY project_id, region
),
yearlyFunding AS (
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		region,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(board_approval_date), region
),
with_pct_change AS (
	SELECT 
		funding_year,
		region,
		total_funding,
		ISNULL(ROUND(100.0 * (total_funding - LAG(total_funding) OVER (PARTITION BY region ORDER BY funding_year)) /
			NULLIF(LAG(total_funding) OVER (PARTITION BY region ORDER BY funding_year), 0),1), 0) AS pct_change
	FROM yearlyFunding
)
SELECT 
	funding_year,
	SUM(CASE WHEN region = 'east asia and pacific' THEN total_funding ELSE 0 END) AS east_asia_and_pacific,
	SUM(CASE WHEN region = 'europe and central asia' THEN total_funding ELSE 0 END) AS europe_and_central_asia,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN total_funding ELSE 0 END) AS latin_america_and_caribbean,
	SUM(CASE WHEN region = 'middle east and africa' THEN total_funding ELSE 0 END) AS middle_east_and_africa,
	SUM(CASE WHEN region = 'south asia' THEN total_funding ELSE 0 END) AS south_asia,
	SUM(CASE WHEN region = 'other' THEN total_funding ELSE 0 END) AS other,
	SUM(CASE WHEN region = 'east asia and pacific' THEN pct_change ELSE 0 END) AS eap_pct_chg,
	SUM(CASE WHEN region = 'europe and central asia' THEN pct_change ELSE 0 END) AS eca_pct_chg,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN pct_change ELSE 0 END) AS lac_pct_chg,
	SUM(CASE WHEN region = 'middle east and africa' THEN pct_change ELSE 0 END) AS mea_pct_chg,
	SUM(CASE WHEN region = 'south asia' THEN pct_change ELSE 0 END) AS sa_pct_chg
FROM with_pct_change
GROUP BY funding_year
ORDER BY funding_year;

----- Moving Average 3 Year
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		MIN(board_approval_date) AS board_approval_date,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument = 'grant'
	GROUP BY project_id, region
),
yearlyFunding AS (
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		region,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(board_approval_date), region
),
with_ma AS (
	SELECT 
		funding_year,
		region,
		total_funding,
		ROUND(AVG(total_funding) OVER (PARTITION BY region ORDER BY funding_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS ma_3yr
	FROM yearlyFunding
),
with_ma_change AS (
	SELECT 
		funding_year,
		region,
		ma_3yr,
		ISNULL(ROUND(100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY region ORDER BY funding_year)) /
			NULLIF(LAG(ma_3yr) OVER (PARTITION BY region ORDER BY funding_year), 0),1), 0) AS ma_3yr_pct_chg
	FROM with_ma
)
SELECT 
	funding_year,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr ELSE 0 END) AS eap_ma_3yr,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr ELSE 0 END) AS eca_ma_3yr,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr ELSE 0 END) AS lac_ma_3yr,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr ELSE 0 END) AS mea_ma_3yr,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr ELSE 0 END) AS sa_ma_3yr,
	SUM(CASE WHEN region = 'other' THEN ma_3yr ELSE 0 END) AS other_ma_3yr,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr_pct_chg ELSE 0 END) AS eap_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr_pct_chg ELSE 0 END) AS eca_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr_pct_chg ELSE 0 END) AS lac_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr_pct_chg ELSE 0 END) AS mea_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr_pct_chg ELSE 0 END) AS sa_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY funding_year
ORDER BY funding_year;


-- Guarantee Funding by Region Over Time
----- Year over Year
WITH year_range AS (
    SELECT DISTINCT YEAR(board_approval_date) AS funding_year
    FROM banking2011to2025
    WHERE board_approval_date IS NOT NULL AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
),
region_list AS (
    SELECT DISTINCT region FROM banking2011to2025
    WHERE board_approval_date IS NOT NULL AND financial_instrument = 'guarantee'
),
calendar AS (
    SELECT y.funding_year, r.region
    FROM year_range y
    CROSS JOIN region_list r
),
uniqueProjects AS (
	SELECT
		project_id,
		region,
		MIN(board_approval_date) AS board_approval_date,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE 
		board_approval_date IS NOT NULL
		AND financial_instrument = 'guarantee'
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY project_id, region
),
yearlyFunding AS (
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		region,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(board_approval_date), region
),
filled_data AS (
	SELECT 
		c.funding_year,
		c.region,
		ISNULL(y.total_funding, 0) AS total_funding
	FROM calendar c
	LEFT JOIN yearlyFunding y
	  ON c.funding_year = y.funding_year AND c.region = y.region
),
with_pct_change AS (
	SELECT 
		funding_year,
		region,
		total_funding,
		ISNULL(ROUND(100.0 * (total_funding - LAG(total_funding) OVER (PARTITION BY region ORDER BY funding_year)) /
			NULLIF(LAG(total_funding) OVER (PARTITION BY region ORDER BY funding_year), 0),1), 0) AS pct_change
	FROM filled_data
)
SELECT 
	funding_year,
	SUM(CASE WHEN region = 'east asia and pacific' THEN total_funding ELSE 0 END) AS east_asia_and_pacific,
	SUM(CASE WHEN region = 'europe and central asia' THEN total_funding ELSE 0 END) AS europe_and_central_asia,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN total_funding ELSE 0 END) AS latin_america_and_caribbean,
	SUM(CASE WHEN region = 'middle east and africa' THEN total_funding ELSE 0 END) AS middle_east_and_africa,
	SUM(CASE WHEN region = 'south asia' THEN total_funding ELSE 0 END) AS south_asia,
	SUM(CASE WHEN region = 'other' THEN total_funding ELSE 0 END) AS other,
	SUM(CASE WHEN region = 'east asia and pacific' THEN pct_change ELSE 0 END) AS eap_pct_chg,
	SUM(CASE WHEN region = 'europe and central asia' THEN pct_change ELSE 0 END) AS eca_pct_chg,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN pct_change ELSE 0 END) AS lac_pct_chg,
	SUM(CASE WHEN region = 'middle east and africa' THEN pct_change ELSE 0 END) AS mea_pct_chg,
	SUM(CASE WHEN region = 'south asia' THEN pct_change ELSE 0 END) AS sa_pct_chg
FROM with_pct_change
GROUP BY funding_year
ORDER BY funding_year;

----- Moving Average 3 Year
WITH year_range AS (
    SELECT DISTINCT YEAR(board_approval_date) AS funding_year
    FROM banking2011to2025
    WHERE board_approval_date IS NOT NULL AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
),
region_list AS (
    SELECT DISTINCT region
    FROM banking2011to2025
    WHERE board_approval_date IS NOT NULL AND financial_instrument = 'guarantee'
),
calendar AS (
    SELECT y.funding_year, r.region
    FROM year_range y
    CROSS JOIN region_list r
),
uniqueProjects AS (
	SELECT
		project_id,
		region,
		MIN(board_approval_date) AS board_approval_date,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE 
		board_approval_date IS NOT NULL
		AND financial_instrument = 'guarantee'
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY project_id, region
),
yearlyfunding AS (
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		region,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(board_approval_date), region
),
filled_funding AS (
	SELECT 
		c.funding_year,
		c.region,
		ISNULL(y.total_funding, 0) AS total_funding
	FROM calendar c
	LEFT JOIN yearlyfunding y
		ON c.funding_year = y.funding_year
		AND c.region = y.region
),
with_ma AS (
	SELECT 
		funding_year,
		region,
		total_funding,
		ROUND(
			AVG(total_funding) OVER (
				PARTITION BY region 
				ORDER BY funding_year 
				ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
			), 0
		) AS ma_3yr
	FROM filled_funding
),
with_ma_change AS (
	SELECT 
		funding_year,
		region,
		ma_3yr,
		ISNULL(ROUND(
			100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY region ORDER BY funding_year)) /
			NULLIF(LAG(ma_3yr) OVER (PARTITION BY region ORDER BY funding_year), 0),
		1), 0) AS ma_3yr_pct_chg
	FROM with_ma
)
SELECT 
	funding_year,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr ELSE 0 END) AS eap_ma_3yr,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr ELSE 0 END) AS eca_ma_3yr,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr ELSE 0 END) AS lac_ma_3yr,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr ELSE 0 END) AS mea_ma_3yr,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr ELSE 0 END) AS sa_ma_3yr,
	SUM(CASE WHEN region = 'other' THEN ma_3yr ELSE 0 END) AS other_ma_3yr,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr_pct_chg ELSE 0 END) AS eap_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr_pct_chg ELSE 0 END) AS eca_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr_pct_chg ELSE 0 END) AS lac_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr_pct_chg ELSE 0 END) AS mea_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr_pct_chg ELSE 0 END) AS sa_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY funding_year
ORDER BY funding_year;


----- COUNTRY -----
-- Overall Funding by Top 5 Countries Over Time
----- Year over Year
WITH uniqueProjects AS (
	SELECT 
		project_id,
		country,
		MIN(board_approval_date) AS funding_year,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND country IN ('kenya','bangladesh','pakistan','nigeria','ethiopia')
	GROUP BY project_id, country
),
yearlyFunding AS (
	SELECT 
		YEAR(funding_year) AS funding_year,
		country,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(funding_year), country
),
with_pct_change AS (
	SELECT 
		funding_year,
		country,
		total_funding,
		ISNULL(ROUND(100.0 * (total_funding - LAG(total_funding) OVER (PARTITION BY country ORDER BY funding_year)) /
			NULLIF(LAG(total_funding) OVER (PARTITION BY country ORDER BY funding_year), 0),1), 0) AS pct_change
	FROM yearlyFunding
)
SELECT 
	funding_year,
	SUM(CASE WHEN country = 'bangladesh' THEN total_funding ELSE 0 END) AS bangladesh,
	SUM(CASE WHEN country = 'nigeria' THEN total_funding ELSE 0 END) AS nigeria,
	SUM(CASE WHEN country = 'ethiopia' THEN total_funding ELSE 0 END) AS ethiopia,
	SUM(CASE WHEN country = 'pakistan' THEN total_funding ELSE 0 END) AS pakistan,
	SUM(CASE WHEN country = 'kenya' THEN total_funding ELSE 0 END) AS kenya,
	SUM(CASE WHEN country = 'bangladesh' THEN pct_change ELSE 0 END) AS bangladesh_pct_chg,
	SUM(CASE WHEN country = 'nigeria' THEN pct_change ELSE 0 END) AS nigeria_pct_chg,
	SUM(CASE WHEN country = 'ethiopia' THEN pct_change ELSE 0 END) AS ethiopia_pct_chg,
	SUM(CASE WHEN country = 'pakistan' THEN pct_change ELSE 0 END) AS pakistan_pct_chg,
	SUM(CASE WHEN country = 'kenya' THEN pct_change ELSE 0 END) AS kenya_pct_chg
FROM with_pct_change
GROUP BY funding_year
ORDER BY funding_year;

----- Moving Average 3 Year
WITH uniqueProjects AS (
	SELECT 
		project_id,
		country,
		MIN(board_approval_date) AS funding_year,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND country IN ('kenya','bangladesh','pakistan','nigeria','ethiopia')
	GROUP BY project_id, country
),
yearlyFunding AS (
	SELECT 
		country,
		YEAR(funding_year) AS funding_year,
		ROUND(SUM(total_principal_amount), 0) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(funding_year), country
),
with_ma AS (
	SELECT 
		funding_year,
		country,
		ROUND(AVG(total_funding) OVER (
			PARTITION BY country 
			ORDER BY funding_year 
			ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
		), 0) AS ma_3yr
	FROM yearlyFunding
),
with_ma_change AS (
	SELECT 
		funding_year,
		country,
		ma_3yr,
		ISNULL(ROUND(
			100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY country ORDER BY funding_year)) /
			NULLIF(LAG(ma_3yr) OVER (PARTITION BY country ORDER BY funding_year), 0),
		1), 0) AS ma_3yr_pct_chg
	FROM with_ma
)
SELECT 
	funding_year,
	SUM(CASE WHEN country = 'bangladesh' THEN ma_3yr ELSE 0 END) AS bangladesh_ma_3yr,
	SUM(CASE WHEN country = 'nigeria' THEN ma_3yr ELSE 0 END) AS nigeria_ma_3yr,
	SUM(CASE WHEN country = 'ethiopia' THEN ma_3yr ELSE 0 END) AS ethiopia_ma_3yr,
	SUM(CASE WHEN country = 'pakistan' THEN ma_3yr ELSE 0 END) AS pakistan_ma_3yr,
	SUM(CASE WHEN country = 'kenya' THEN ma_3yr ELSE 0 END) AS kenya_ma_3yr,
	SUM(CASE WHEN country = 'bangladesh' THEN ma_3yr_pct_chg ELSE 0 END) AS bangladesh_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'nigeria' THEN ma_3yr_pct_chg ELSE 0 END) AS nigeria_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'ethiopia' THEN ma_3yr_pct_chg ELSE 0 END) AS ethiopia_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'pakistan' THEN ma_3yr_pct_chg ELSE 0 END) AS pakistan_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'kenya' THEN ma_3yr_pct_chg ELSE 0 END) AS kenya_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY funding_year
ORDER BY funding_year;


-- Credit Funding by Top 5 Countries Over Time
WITH uniqueProjects AS (
	SELECT 
		project_id,
		country,
		MIN(board_approval_date) AS funding_year,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND country IN ('bangladesh','nigeria','pakistan','kenya','ethiopia')
		AND financial_instrument = 'credit'
	GROUP BY project_id, country
),
yearlyFunding AS (
	SELECT 
		YEAR(funding_year) AS funding_year,
		country,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(funding_year), country
),
with_pct_change AS (
	SELECT 
		funding_year,
		country,
		total_funding,
		ISNULL(ROUND(100.0 * (total_funding - LAG(total_funding) OVER (PARTITION BY country ORDER BY funding_year)) /
			NULLIF(LAG(total_funding) OVER (PARTITION BY country ORDER BY funding_year), 0), 1), 0) AS pct_chg
	FROM yearlyFunding
)
SELECT 
	funding_year,
	SUM(CASE WHEN country = 'bangladesh' THEN total_funding ELSE 0 END) AS bangladesh,
	SUM(CASE WHEN country = 'nigeria' THEN total_funding ELSE 0 END) AS nigeria,
	SUM(CASE WHEN country = 'pakistan' THEN total_funding ELSE 0 END) AS pakistan,
	SUM(CASE WHEN country = 'kenya' THEN total_funding ELSE 0 END) AS kenya,
	SUM(CASE WHEN country = 'ethiopia' THEN total_funding ELSE 0 END) AS ethiopia,
	SUM(CASE WHEN country = 'bangladesh' THEN pct_chg ELSE 0 END) AS bangladesh_pct_chg,
	SUM(CASE WHEN country = 'nigeria' THEN pct_chg ELSE 0 END) AS nigeria_pct_chg,
	SUM(CASE WHEN country = 'pakistan' THEN pct_chg ELSE 0 END) AS pakistan_pct_chg,
	SUM(CASE WHEN country = 'kenya' THEN pct_chg ELSE 0 END) AS kenya_pct_chg,
	SUM(CASE WHEN country = 'ethiopia' THEN pct_chg ELSE 0 END) AS ethiopia_pct_chg
FROM with_pct_change
GROUP BY funding_year
ORDER BY funding_year;

----- Moving Average 3 Year
WITH uniqueProjects AS (
	SELECT 
		project_id,
		country,
		MIN(board_approval_date) AS funding_year,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND country IN ('bangladesh','nigeria','pakistan','kenya','ethiopia')
		AND financial_instrument = 'credit'
	GROUP BY project_id, country
),
yearlyFunding AS (
	SELECT 
		YEAR(funding_year) AS funding_year,
		country,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(funding_year), country
),
with_ma AS (
	SELECT 
		funding_year,
		country,
		ROUND(AVG(total_funding) OVER (PARTITION BY country ORDER BY funding_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS ma_3yr
	FROM yearlyFunding
),
with_ma_change AS (
	SELECT 
		funding_year,
		country,
		ma_3yr,
		ISNULL(ROUND(100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY country ORDER BY funding_year)) /
			NULLIF(LAG(ma_3yr) OVER (PARTITION BY country ORDER BY funding_year), 0),1), 0) AS ma_3yr_pct_chg
	FROM with_ma
)
SELECT 
	funding_year,
	SUM(CASE WHEN country = 'bangladesh' THEN ma_3yr ELSE 0 END) AS bangladesh_ma_3yr,
	SUM(CASE WHEN country = 'nigeria' THEN ma_3yr ELSE 0 END) AS nigeria_ma_3yr,
	SUM(CASE WHEN country = 'pakistan' THEN ma_3yr ELSE 0 END) AS pakistan_ma_3yr,
	SUM(CASE WHEN country = 'kenya' THEN ma_3yr ELSE 0 END) AS kenya_ma_3yr,
	SUM(CASE WHEN country = 'ethiopia' THEN ma_3yr ELSE 0 END) AS ethiopia_ma_3yr,
	SUM(CASE WHEN country = 'bangladesh' THEN ma_3yr_pct_chg ELSE 0 END) AS bangladesh_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'nigeria' THEN ma_3yr_pct_chg ELSE 0 END) AS nigeria_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'pakistan' THEN ma_3yr_pct_chg ELSE 0 END) AS pakistan_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'kenya' THEN ma_3yr_pct_chg ELSE 0 END) AS kenya_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'ethiopia' THEN ma_3yr_pct_chg ELSE 0 END) AS ethiopia_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY funding_year
ORDER BY funding_year;


-- Grant Funding by Top 5 Countries Over Time
----- Year over Year
WITH uniqueProjects AS (
	SELECT 
		project_id,
		country,
		MIN(board_approval_date) AS funding_year,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND country IN ('ethiopia','mozambique','congo','afghanistan','chad')
		AND financial_instrument = 'grant'
	GROUP BY project_id, country
),
yearlyFunding AS (
	SELECT 
		country,
		YEAR(funding_year) AS funding_year,
		ROUND(SUM(total_principal_amount), 0) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(funding_year), country
),
with_pct_change AS (
	SELECT 
		funding_year,
		country,
		total_funding,
		ISNULL(ROUND(100.0 * (total_funding - LAG(total_funding) OVER (PARTITION BY country ORDER BY funding_year)) /
			NULLIF(LAG(total_funding) OVER (PARTITION BY country ORDER BY funding_year), 0), 1), 0) AS pct_chg
	FROM yearlyFunding
)
SELECT      
	funding_year,
	SUM(CASE WHEN country = 'ethiopia' THEN total_funding ELSE 0 END) AS ethiopia,
	SUM(CASE WHEN country = 'mozambique' THEN total_funding ELSE 0 END) AS mozambique,
	SUM(CASE WHEN country = 'congo' THEN total_funding ELSE 0 END) AS congo,
	SUM(CASE WHEN country = 'afghanistan' THEN total_funding ELSE 0 END) AS afghanistan,
	SUM(CASE WHEN country = 'chad' THEN total_funding ELSE 0 END) AS chad,
	SUM(CASE WHEN country = 'ethiopia' THEN pct_chg ELSE 0 END) AS ethiopia_pct_chg,
	SUM(CASE WHEN country = 'mozambique' THEN pct_chg ELSE 0 END) AS mozambique_pct_chg,
	SUM(CASE WHEN country = 'congo' THEN pct_chg ELSE 0 END) AS congo_pct_chg,
	SUM(CASE WHEN country = 'afghanistan' THEN pct_chg ELSE 0 END) AS afghanistan_pct_chg,
	SUM(CASE WHEN country = 'chad' THEN pct_chg ELSE 0 END) AS chad_pct_chg
FROM with_pct_change
GROUP BY funding_year
ORDER BY funding_year;

----- Moving Average 3 Year
WITH uniqueProjects AS (
	SELECT 
		project_id,
		country,
		MIN(board_approval_date) AS funding_year,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND country IN ('ethiopia','mozambique','congo','afghanistan','chad')
		AND financial_instrument = 'grant'
	GROUP BY project_id, country
),
yearlyFunding AS (
	SELECT 
		YEAR(funding_year) AS funding_year,
		country,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(funding_year), country
),
with_ma AS (
	SELECT 
		funding_year,
		country,
		ROUND(AVG(total_funding) OVER (PARTITION BY country ORDER BY funding_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS ma_3yr
	FROM yearlyFunding
),
with_ma_change AS (
	SELECT 
		funding_year,
		country,
		ma_3yr,
		ISNULL(ROUND(100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY country ORDER BY funding_year)) /
			NULLIF(LAG(ma_3yr) OVER (PARTITION BY country ORDER BY funding_year), 0), 1), 0) AS ma_3yr_pct_chg
	FROM with_ma
)
SELECT 
	funding_year,
	SUM(CASE WHEN country = 'ethiopia' THEN ma_3yr ELSE 0 END) AS ethiopia_ma_3yr,
	SUM(CASE WHEN country = 'mozambique' THEN ma_3yr ELSE 0 END) AS mozambique_ma_3yr,
	SUM(CASE WHEN country = 'congo' THEN ma_3yr ELSE 0 END) AS congo_ma_3yr,
	SUM(CASE WHEN country = 'afghanistan' THEN ma_3yr ELSE 0 END) AS afghanistan_ma_3yr,
	SUM(CASE WHEN country = 'chad' THEN ma_3yr ELSE 0 END) AS chad_ma_3yr,
	SUM(CASE WHEN country = 'ethiopia' THEN ma_3yr_pct_chg ELSE 0 END) AS ethiopia_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'mozambique' THEN ma_3yr_pct_chg ELSE 0 END) AS mozambique_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'congo' THEN ma_3yr_pct_chg ELSE 0 END) AS congo_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'afghanistan' THEN ma_3yr_pct_chg ELSE 0 END) AS afghanistan_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'chad' THEN ma_3yr_pct_chg ELSE 0 END) AS chad_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY funding_year
ORDER BY funding_year;


-- Guarantee Funding by Top 5 Countries Over Time
----- Year over Year
WITH year_range AS (
    SELECT DISTINCT YEAR(board_approval_date) AS funding_year
    FROM banking2011to2025
    WHERE board_approval_date IS NOT NULL AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
),
country_list AS (
    SELECT DISTINCT country
    FROM banking2011to2025
    WHERE board_approval_date IS NOT NULL AND financial_instrument = 'guarantee'
),
calendar AS (
    SELECT y.funding_year, r.country
    FROM year_range y
    CROSS JOIN country_list r
),
uniqueProjects AS (
	SELECT 
		project_id,
		country,
		MIN(board_approval_date) AS funding_year,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND country IN ('pakistan','ghana','kenya','benin','cote d''ivoire')
		AND financial_instrument = 'guarantee'
	GROUP BY project_id, country
),
yearlyFunding AS (
	SELECT 
		YEAR(funding_year) AS funding_year,
		country,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(funding_year), country
),
filled_funding AS (
	SELECT 
		c.funding_year,
		c.country,
		ISNULL(y.total_funding, 0) AS total_funding
	FROM calendar c
	LEFT JOIN yearlyfunding y
		ON c.funding_year = y.funding_year
		AND c.country = y.country
)
SELECT    
	funding_year,
	SUM(CASE WHEN country = 'pakistan' THEN total_funding ELSE 0 END) AS pakistan,
	SUM(CASE WHEN country = 'ghana' THEN total_funding ELSE 0 END) AS ghana,
	SUM(CASE WHEN country = 'kenya' THEN total_funding ELSE 0 END) AS kenya,
	SUM(CASE WHEN country = 'benin' THEN total_funding ELSE 0 END) AS benin,
	SUM(CASE WHEN country = 'cote d''ivoire' THEN total_funding ELSE 0 END) AS cote_divoire,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country = 'pakistan' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country = 'pakistan' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country = 'pakistan' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 0), 1), 0) AS pakistan_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country = 'ghana' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country = 'ghana' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country = 'ghana' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 0), 1), 0) AS ghana_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country = 'kenya' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country = 'kenya' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country = 'kenya' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 0), 1), 0) AS kenya_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country = 'benin' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country = 'benin' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country = 'benin' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 0), 1), 0) AS benin_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country = 'cote d''ivoire' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country = 'cote d''ivoire' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country = 'cote d''ivoire' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 0), 1), 0) AS cote_divoire_pct_chg
FROM filled_funding
GROUP BY funding_year
ORDER BY funding_year ASC;

----- Moving Average 3 Year
WITH year_range AS (
    SELECT DISTINCT YEAR(board_approval_date) AS funding_year
    FROM banking2011to2025
    WHERE board_approval_date IS NOT NULL AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
),
country_list AS (
    SELECT DISTINCT country
    FROM banking2011to2025
    WHERE board_approval_date IS NOT NULL 
      AND financial_instrument = 'guarantee'
      AND country IN ('pakistan','ghana','kenya','benin','cote d''ivoire')
),
calendar AS (
    SELECT y.funding_year, r.country
    FROM year_range y
    CROSS JOIN country_list r
),
uniqueProjects AS (
	SELECT 
		project_id,
		country,
		MIN(board_approval_date) AS funding_year,
		ROUND(MAX(principal_amount), 0) AS total_principal_amount
	FROM banking2011to2025
	WHERE board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND country IN ('pakistan','ghana','kenya','benin','cote d''ivoire')
		AND financial_instrument = 'guarantee'
	GROUP BY project_id, country
),
yearlyFunding AS (
	SELECT 
		YEAR(funding_year) AS funding_year,
		country,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY YEAR(funding_year), country
),
filled_funding AS (
	SELECT 
		c.funding_year,
		c.country,
		ISNULL(y.total_funding, 0) AS total_funding
	FROM calendar c
	LEFT JOIN yearlyfunding y
		ON c.funding_year = y.funding_year
		AND c.country = y.country
),
with_ma AS (
	SELECT 
		funding_year,
		country,
		ROUND(AVG(total_funding) OVER (PARTITION BY country ORDER BY funding_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS ma_3yr
	FROM filled_funding
),
with_ma_change AS (
	SELECT 
		funding_year,
		country,
		ma_3yr,
		ISNULL(ROUND(100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY country ORDER BY funding_year)) /
			NULLIF(LAG(ma_3yr) OVER (PARTITION BY country ORDER BY funding_year), 0), 1), 0) AS ma_3yr_pct_chg
	FROM with_ma
)
SELECT
	funding_year,
	SUM(CASE WHEN country = 'pakistan' THEN ma_3yr ELSE 0 END) AS pakistan_ma_3yr,
	SUM(CASE WHEN country = 'ghana' THEN ma_3yr ELSE 0 END) AS ghana_ma_3yr,
	SUM(CASE WHEN country = 'kenya' THEN ma_3yr ELSE 0 END) AS kenya_ma_3yr,
	SUM(CASE WHEN country = 'benin' THEN ma_3yr ELSE 0 END) AS benin_ma_3yr,
	SUM(CASE WHEN country = 'cote d''ivoire' THEN ma_3yr ELSE 0 END) AS cote_divoire_ma_3yr,
	SUM(CASE WHEN country = 'pakistan' THEN ma_3yr_pct_chg ELSE 0 END) AS pakistan_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'ghana' THEN ma_3yr_pct_chg ELSE 0 END) AS ghana_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'kenya' THEN ma_3yr_pct_chg ELSE 0 END) AS kenya_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'benin' THEN ma_3yr_pct_chg ELSE 0 END) AS benin_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'cote d''ivoire' THEN ma_3yr_pct_chg ELSE 0 END) AS cote_divoire_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY funding_year
ORDER BY funding_year;


---------------------------------------------------------------------
/* 3. What are the trends in disbursement and repayment over time? */
---------------------------------------------------------------------
---------- TOTAL COUNTS ----------
/* DISBURSEMENT */
----- OVERALL -----
-- Total Disbursed Amount by Financial Instruments
WITH uniqueProjects AS (
	SELECT
		project_id,
		financial_instrument,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id,financial_instrument
),
instrumentTotals AS (
	SELECT 
		financial_instrument,
		ROUND(SUM(total_disbursed_amount),0) AS total_disbursed_amount
	FROM uniqueProjects
	GROUP BY financial_instrument
)
SELECT 
	financial_instrument,
	total_disbursed_amount,
	ROUND(100.0 * total_disbursed_amount / SUM(total_disbursed_amount) OVER (), 2) AS percent_of_total
FROM instrumentTotals
ORDER BY total_disbursed_amount DESC;

-- Avg Disbursed Amount by Financial Instruments
WITH uniqueProjects AS (
	SELECT
		project_id,
		financial_instrument,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id,financial_instrument
),
instrumentTotals AS (
	SELECT 
		financial_instrument,
		ROUND(AVG(total_disbursed_amount),0) AS avg_disbursed_amount
	FROM uniqueProjects
	GROUP BY financial_instrument
)
SELECT 
	financial_instrument,
	avg_disbursed_amount
FROM instrumentTotals
ORDER BY avg_disbursed_amount DESC;

----- REGION -----
-- Most Disbursed by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id, region
),
regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(total_disbursed_amount),0) AS total_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	total_disbursed_amount,
	ROUND(100.0 * total_disbursed_amount / SUM(total_disbursed_amount) OVER(),2) AS percent_total
FROM regionTotals
ORDER BY total_disbursed_amount DESC;

-- Avg Disbursed by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id, region
),
regionTotals AS
(
	SELECT 
		region,
		ROUND(AVG(total_disbursed_amount),0) AS avg_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	avg_disbursed_amount
FROM regionTotals
ORDER BY avg_disbursed_amount DESC;

-- Most Credit Disbursed by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='credit'
	GROUP BY project_id, region
),
regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(total_disbursed_amount),0) AS total_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	total_disbursed_amount,
	ROUND(100.0 * total_disbursed_amount / SUM(total_disbursed_amount) OVER(),2) AS percent_total
FROM regionTotals
ORDER BY total_disbursed_amount DESC;

-- Avg Credit Disbursed by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='credit'
	GROUP BY project_id, region
),
regionTotals AS
(
	SELECT 
		region,
		ROUND(AVG(total_disbursed_amount),0) AS avg_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	avg_disbursed_amount
FROM regionTotals
ORDER BY avg_disbursed_amount DESC;

-- Most Grant Disbursed by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='grant'
	GROUP BY project_id, region
),
regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(total_disbursed_amount),0) AS total_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	total_disbursed_amount,
	ROUND(100.0 * total_disbursed_amount / SUM(total_disbursed_amount) OVER(),2) AS percent_total
FROM regionTotals
ORDER BY total_disbursed_amount DESC;

-- Avg Grant Disbursed by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='grant'
	GROUP BY project_id, region
),
regionTotals AS
(
	SELECT 
		region,
		ROUND(AVG(total_disbursed_amount),0) AS avg_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	avg_disbursed_amount
FROM regionTotals
ORDER BY avg_disbursed_amount DESC

-- Most Guarantee Disbursed by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='guarantee'
	GROUP BY project_id, region
),
regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(total_disbursed_amount),0) AS total_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	total_disbursed_amount,
	ROUND(100.0 * total_disbursed_amount / SUM(total_disbursed_amount) OVER(),2) AS percent_total
FROM regionTotals
ORDER BY total_disbursed_amount DESC;

-- Avg Guarantee Disbursed by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='guarantee'
	GROUP BY project_id, region
),
regionTotals AS
(
	SELECT 
		region,
		ROUND(AVG(total_disbursed_amount),0) AS avg_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	avg_disbursed_amount
FROM regionTotals
ORDER BY avg_disbursed_amount DESC;


----- COUNTRY -----
-- Most Disbursed by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id, country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(total_disbursed_amount),0) AS total_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	total_disbursed_amount,
	ROUND(100.0 * total_disbursed_amount / SUM(total_disbursed_amount) OVER(),2) AS percent_total
FROM countryTotals
ORDER BY total_disbursed_amount DESC;

-- Top Avg Disbursed by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id, country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(AVG(total_disbursed_amount),0) AS avg_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	avg_disbursed_amount
FROM countryTotals
ORDER BY avg_disbursed_amount DESC;


-- Most Credits Disbursed by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='credit'
	GROUP BY project_id, country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(total_disbursed_amount),0) AS total_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	total_disbursed_amount,
	ROUND(100.0 * total_disbursed_amount / SUM(total_disbursed_amount) OVER(),2) AS percent_total
FROM countryTotals
ORDER BY total_disbursed_amount DESC;

-- Top Avg Credits Disbursed by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='credit'
	GROUP BY project_id, country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(AVG(total_disbursed_amount),0) AS avg_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	avg_disbursed_amount
FROM countryTotals
ORDER BY avg_disbursed_amount DESC;


-- Most Grant Disbursed by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='grant'
	GROUP BY project_id, country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(total_disbursed_amount),0) AS total_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	total_disbursed_amount,
	ROUND(100.0 * total_disbursed_amount / SUM(total_disbursed_amount) OVER(),2) AS percent_total
FROM countryTotals
ORDER BY total_disbursed_amount DESC;

-- Top Avg Grant Disbursed by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='grant'
	GROUP BY project_id, country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(AVG(total_disbursed_amount),0) AS avg_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	avg_disbursed_amount
FROM countryTotals
ORDER BY avg_disbursed_amount DESC;


-- Most Guarantee Disbursed by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='guarantee'
	GROUP BY project_id, country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(total_disbursed_amount),0) AS total_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	total_disbursed_amount,
	ROUND(100.0 * total_disbursed_amount / SUM(total_disbursed_amount) OVER(),2) AS percent_total
FROM countryTotals
ORDER BY total_disbursed_amount DESC;

-- Top Avg Guarantee Disbursed by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='guarantee'
	GROUP BY project_id, country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(Avg(total_disbursed_amount),0) AS avg_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	avg_disbursed_amount
FROM countryTotals
ORDER BY avg_disbursed_amount DESC;

/* REPAYMENT */
----- OVERALL -----
-- Total Repaid Amount by Financial Instruments
WITH uniqueProjects AS (
	SELECT
		project_id,
		financial_instrument,
		ROUND(MAX(repaid_amount), 0) AS total_repaid_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id, financial_instrument
),
instrumentTotals AS (
	SELECT 
		financial_instrument,
		ROUND(SUM(total_repaid_amount),0) AS total_repaid_amount
	FROM uniqueProjects
	GROUP BY financial_instrument
)
SELECT 
	financial_instrument,
	total_repaid_amount,
	ROUND(100.0 * total_repaid_amount / SUM(total_repaid_amount) OVER (), 2) AS percent_of_total
FROM instrumentTotals
ORDER BY total_repaid_amount DESC;

-- Avg Repaid Amount by Financial Instruments
WITH uniqueProjects AS (
	SELECT
		project_id,
		financial_instrument,
		ROUND(MAX(repaid_amount), 0) AS total_repaid_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id, financial_instrument
),
instrumentTotals AS (
	SELECT 
		financial_instrument,
		ROUND(AVG(total_repaid_amount),0) AS avg_repaid_amount
	FROM uniqueProjects
	GROUP BY financial_instrument
)
SELECT 
	financial_instrument,
	avg_repaid_amount
FROM instrumentTotals
ORDER BY avg_repaid_amount DESC;

----- REGION -----
-- Most Repaid by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(repaid_amount), 0) AS total_repaid_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id, region
),
regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(total_repaid_amount),0) AS total_repaid_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	total_repaid_amount,
	ROUND(100.0 * total_repaid_amount / SUM(total_repaid_amount) OVER(),2) AS percent_total
FROM regionTotals
ORDER BY total_repaid_amount DESC;

-- Avg Repaid by Region
WITH uniqueProjects AS (
	SELECT
		project_id,
		region,
		ROUND(MAX(repaid_amount), 0) AS total_repaid_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id, region
),
regionTotals AS
(
	SELECT 
		region,
		ROUND(AVG(total_repaid_amount),0) AS avg_repaid_amount
	FROM uniqueProjects
	GROUP BY 
		region
)
SELECT 
	region,
	avg_repaid_amount
FROM regionTotals
ORDER BY avg_repaid_amount DESC;

----- COUNTRY -----
-- Most Repaid by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(repaid_amount), 0) AS total_repaid_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id, country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(total_repaid_amount),0) AS total_repaid_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	total_repaid_amount,
	ROUND(100.0 * total_repaid_amount / SUM(total_repaid_amount) OVER(),2) AS percent_total
FROM countryTotals
ORDER BY total_repaid_amount DESC;

-- Top Avg Repaid by Country
WITH uniqueProjects AS (
	SELECT
		project_id,
		country,
		ROUND(MAX(repaid_amount), 0) AS total_repaid_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY project_id, country
),
countryTotals AS
(
	SELECT 
		country,
		ROUND(AVG(total_repaid_amount),0) AS avg_repaid_amount
	FROM uniqueProjects
	GROUP BY 
		country
)
SELECT 
	country,
	avg_repaid_amount
FROM countryTotals
ORDER BY avg_repaid_amount DESC;

---------- TRENDS OVER TIME ----------
/* DISBURSEMENT */
----- OVERALL -----
-- Overall Disbursement Over Time 
WITH uniqueProjects AS (
    SELECT 
        project_id,
        YEAR(period_end_date) AS disbursement_year,
        ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
    FROM banking2011to2025
    WHERE period_end_date IS NOT NULL
    GROUP BY 
		project_id, 
		YEAR(period_end_date)
),
yearlyDisbursement AS (
    SELECT 
        disbursement_year,
        SUM(total_disbursed_amount) AS total_disbursement
    FROM uniqueProjects
    GROUP BY disbursement_year
),
final AS (
    SELECT 
        disbursement_year,
        total_disbursement,
        ISNULL(ROUND(100.0 * (total_disbursement - LAG(total_disbursement) OVER (ORDER BY disbursement_year)) /
                NULLIF(LAG(total_disbursement) OVER (ORDER BY disbursement_year), 0),1),0) AS yoy_pct_change,
        ROUND(AVG(total_disbursement) OVER (ORDER BY disbursement_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),0) AS moving_avg_3yr
    FROM yearlyDisbursement
)
SELECT 
    *,
    ISNULL(ROUND(100.0 * (moving_avg_3yr - LAG(moving_avg_3yr) OVER (ORDER BY disbursement_year)) / 
			NULLIF(LAG(moving_avg_3yr) OVER (ORDER BY disbursement_year), 0),1),0) AS ma_pct_change
FROM final
ORDER BY disbursement_year;

-- Overall Credit Disbursement Over Time
WITH uniqueProjects AS (
    SELECT 
        project_id,
        YEAR(period_end_date) AS disbursement_year,
        ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
    FROM banking2011to2025
    WHERE 
		period_end_date IS NOT NULL
		AND financial_instrument='credit'
    GROUP BY 
		project_id, 
		YEAR(period_end_date)
),
yearlyDisbursement AS (
    SELECT 
        disbursement_year,
        SUM(total_disbursed_amount) AS total_disbursement
    FROM uniqueProjects
    GROUP BY disbursement_year
),
final AS (
    SELECT 
        disbursement_year,
        total_disbursement,
        ISNULL(ROUND(100.0 * (total_disbursement - LAG(total_disbursement) OVER (ORDER BY disbursement_year)) /
                NULLIF(LAG(total_disbursement) OVER (ORDER BY disbursement_year), 0),1),0) AS yoy_pct_change,
        ROUND(AVG(total_disbursement) OVER (ORDER BY disbursement_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),0) AS moving_avg_3yr
    FROM yearlyDisbursement
)
SELECT 
    *,
    ISNULL(ROUND(100.0 * (moving_avg_3yr - LAG(moving_avg_3yr) OVER (ORDER BY disbursement_year)) / 
			NULLIF(LAG(moving_avg_3yr) OVER (ORDER BY disbursement_year), 0),1),0) AS ma_pct_change
FROM final
ORDER BY disbursement_year;

-- Overall Grant Disbursement Over Time
WITH uniqueProjects AS (
    SELECT 
        project_id,
        YEAR(period_end_date) AS disbursement_year,
        ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
    FROM banking2011to2025
    WHERE 
		period_end_date IS NOT NULL
		AND financial_instrument='grant'
    GROUP BY 
		project_id, 
		YEAR(period_end_date)
),
yearlyDisbursement AS (
    SELECT 
        disbursement_year,
        SUM(total_disbursed_amount) AS total_disbursement
    FROM uniqueProjects
    GROUP BY disbursement_year
),
final AS (
    SELECT 
        disbursement_year,
        total_disbursement,
        ISNULL(ROUND(100.0 * (total_disbursement - LAG(total_disbursement) OVER (ORDER BY disbursement_year)) /
                NULLIF(LAG(total_disbursement) OVER (ORDER BY disbursement_year), 0),1),0) AS yoy_pct_change,
        ROUND(AVG(total_disbursement) OVER (ORDER BY disbursement_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),0) AS moving_avg_3yr
    FROM yearlyDisbursement
)
SELECT 
    *,
    ISNULL(ROUND(100.0 * (moving_avg_3yr - LAG(moving_avg_3yr) OVER (ORDER BY disbursement_year)) / 
			NULLIF(LAG(moving_avg_3yr) OVER (ORDER BY disbursement_year), 0),1),0) AS ma_pct_change
FROM final
ORDER BY disbursement_year;

-- Overall Guarantee Disbursement Over Time
WITH uniqueProjects AS (
    SELECT 
        project_id,
        YEAR(period_end_date) AS disbursement_year,
        ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
    FROM banking2011to2025
    WHERE 
		period_end_date IS NOT NULL
		AND financial_instrument='grant'
    GROUP BY 
		project_id, 
		YEAR(period_end_date)
),
yearlyDisbursement AS (
    SELECT 
        disbursement_year,
        SUM(total_disbursed_amount) AS total_disbursement
    FROM uniqueProjects
    GROUP BY disbursement_year
),
final AS (
    SELECT 
        disbursement_year,
        total_disbursement,
        ISNULL(ROUND(100.0 * (total_disbursement - LAG(total_disbursement) OVER (ORDER BY disbursement_year)) /
                NULLIF(LAG(total_disbursement) OVER (ORDER BY disbursement_year), 0),1),0) AS yoy_pct_change,
        ROUND(AVG(total_disbursement) OVER (ORDER BY disbursement_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),0) AS moving_avg_3yr
    FROM yearlyDisbursement
)
SELECT 
    *,
    ISNULL(ROUND(100.0 * (moving_avg_3yr - LAG(moving_avg_3yr) OVER (ORDER BY disbursement_year)) / 
			NULLIF(LAG(moving_avg_3yr) OVER (ORDER BY disbursement_year), 0),1),0) AS ma_pct_change
FROM final
ORDER BY disbursement_year;


----- REGION -----
-- Disbursement by Region Over Time 
----- Year over Year Disbursement
WITH uniqueProjects AS (
    SELECT 
        YEAR(period_end_date) AS disbursement_year,
        project_id,
        region,
        ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
    FROM banking2011to2025
    WHERE period_end_date IS NOT NULL
        AND YEAR(period_end_date) BETWEEN 2011 AND 2025
    GROUP BY 
        YEAR(period_end_date), project_id, region
),
yearlyDisbursement AS (
    SELECT 
        disbursement_year,
        region,
        SUM(total_disbursed_amount) AS total_disbursement
    FROM uniqueProjects
    GROUP BY disbursement_year, region
),
pivoted AS (
    SELECT 
        disbursement_year,
        SUM(CASE WHEN region = 'east asia and pacific' THEN total_disbursement ELSE 0 END) AS east_asia_and_pacific,
        SUM(CASE WHEN region = 'europe and central asia' THEN total_disbursement ELSE 0 END) AS europe_and_central_asia,
        SUM(CASE WHEN region = 'latin america and caribbean' THEN total_disbursement ELSE 0 END) AS latin_america_and_caribbean,
        SUM(CASE WHEN region = 'middle east and africa' THEN total_disbursement ELSE 0 END) AS middle_east_and_africa,
        SUM(CASE WHEN region = 'south asia' THEN total_disbursement ELSE 0 END) AS south_asia,
        SUM(CASE WHEN region = 'other' THEN total_disbursement ELSE 0 END) AS other
    FROM yearlyDisbursement
    GROUP BY disbursement_year
),
final AS (
    SELECT *,
        ISNULL(ROUND(100.0 * (east_asia_and_pacific - LAG(east_asia_and_pacific) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(east_asia_and_pacific) OVER (ORDER BY disbursement_year), 0), 1), 0) AS eap_pct_chg,
        ISNULL(ROUND(100.0 * (europe_and_central_asia - LAG(europe_and_central_asia) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(europe_and_central_asia) OVER (ORDER BY disbursement_year), 0), 1), 0) AS eca_pct_chg,
        ISNULL(ROUND(100.0 * (latin_america_and_caribbean - LAG(latin_america_and_caribbean) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(latin_america_and_caribbean) OVER (ORDER BY disbursement_year), 0), 1), 0) AS lac_pct_chg,
        ISNULL(ROUND(100.0 * (middle_east_and_africa - LAG(middle_east_and_africa) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(middle_east_and_africa) OVER (ORDER BY disbursement_year), 0), 1), 0) AS mea_pct_chg,
        ISNULL(ROUND(100.0 * (south_asia - LAG(south_asia) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(south_asia) OVER (ORDER BY disbursement_year), 0), 1), 0) AS sa_pct_chg
    FROM pivoted
)
SELECT *
FROM final
ORDER BY disbursement_year;


----- Moving Average 3 Year Disbursement
WITH uniqueProjects AS (
	SELECT 
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		region,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY YEAR(period_end_date), project_id, region
),
yearlyDisbursement AS (
	SELECT 
		disbursement_year,
		region,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY disbursement_year, region
),
with_ma AS (
	SELECT 
		disbursement_year,
		region,
		total_disbursement,
		ROUND(AVG(total_disbursement) OVER (PARTITION BY region ORDER BY disbursement_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS ma_3yr
	FROM yearlyDisbursement
),
with_ma_change AS (
	SELECT 
		disbursement_year,
		region,
		ma_3yr,
		ISNULL(ROUND(100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY region ORDER BY disbursement_year)) /
				NULLIF(LAG(ma_3yr) OVER (PARTITION BY region ORDER BY disbursement_year), 0),1), 0) AS ma_3yr_pct_chg
	FROM with_ma
)
SELECT 
	disbursement_year,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr ELSE 0 END) AS eap_ma_3yr,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr ELSE 0 END) AS eca_ma_3yr,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr ELSE 0 END) AS lac_ma_3yr,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr ELSE 0 END) AS mea_ma_3yr,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr ELSE 0 END) AS sa_ma_3yr,
	SUM(CASE WHEN region = 'other' THEN ma_3yr ELSE 0 END) AS other_ma_3yr,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr_pct_chg ELSE 0 END) AS eap_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr_pct_chg ELSE 0 END) AS eca_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr_pct_chg ELSE 0 END) AS lac_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr_pct_chg ELSE 0 END) AS mea_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr_pct_chg ELSE 0 END) AS sa_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY disbursement_year
ORDER BY disbursement_year;


-- Credit Disbursement by Region Over Time
----- Year over Year Disbursement
WITH uniqueProjects AS (
    SELECT 
        YEAR(period_end_date) AS disbursement_year,
        project_id,
        region,
        ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
    FROM banking2011to2025
    WHERE period_end_date IS NOT NULL
        AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='credit'
    GROUP BY 
        YEAR(period_end_date), project_id, region
),
yearlyDisbursement AS (
    SELECT 
        disbursement_year,
        region,
        SUM(total_disbursed_amount) AS total_disbursement
    FROM uniqueProjects
    GROUP BY disbursement_year, region
),
pivoted AS (
    SELECT 
        disbursement_year,
        SUM(CASE WHEN region = 'east asia and pacific' THEN total_disbursement ELSE 0 END) AS east_asia_and_pacific,
        SUM(CASE WHEN region = 'europe and central asia' THEN total_disbursement ELSE 0 END) AS europe_and_central_asia,
        SUM(CASE WHEN region = 'latin america and caribbean' THEN total_disbursement ELSE 0 END) AS latin_america_and_caribbean,
        SUM(CASE WHEN region = 'middle east and africa' THEN total_disbursement ELSE 0 END) AS middle_east_and_africa,
        SUM(CASE WHEN region = 'south asia' THEN total_disbursement ELSE 0 END) AS south_asia,
        SUM(CASE WHEN region = 'other' THEN total_disbursement ELSE 0 END) AS other
    FROM yearlyDisbursement
    GROUP BY disbursement_year
),
final AS (
    SELECT *,
        ISNULL(ROUND(100.0 * (east_asia_and_pacific - LAG(east_asia_and_pacific) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(east_asia_and_pacific) OVER (ORDER BY disbursement_year), 0), 1), 0) AS eap_pct_chg,
        ISNULL(ROUND(100.0 * (europe_and_central_asia - LAG(europe_and_central_asia) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(europe_and_central_asia) OVER (ORDER BY disbursement_year), 0), 1), 0) AS eca_pct_chg,
        ISNULL(ROUND(100.0 * (latin_america_and_caribbean - LAG(latin_america_and_caribbean) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(latin_america_and_caribbean) OVER (ORDER BY disbursement_year), 0), 1), 0) AS lac_pct_chg,
        ISNULL(ROUND(100.0 * (middle_east_and_africa - LAG(middle_east_and_africa) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(middle_east_and_africa) OVER (ORDER BY disbursement_year), 0), 1), 0) AS mea_pct_chg,
        ISNULL(ROUND(100.0 * (south_asia - LAG(south_asia) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(south_asia) OVER (ORDER BY disbursement_year), 0), 1), 0) AS sa_pct_chg
    FROM pivoted
)
SELECT *
FROM final
ORDER BY disbursement_year;

----- Moving Average 3 Year Disbursement
WITH uniqueProjects AS (
	SELECT 
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		region,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='credit'
	GROUP BY YEAR(period_end_date), project_id, region
),
yearlyDisbursement AS (
	SELECT 
		disbursement_year,
		region,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY disbursement_year, region
),
with_ma AS (
	SELECT 
		disbursement_year,
		region,
		total_disbursement,
		ROUND(AVG(total_disbursement) OVER (PARTITION BY region ORDER BY disbursement_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS ma_3yr
	FROM yearlyDisbursement
),
with_ma_change AS (
	SELECT 
		disbursement_year,
		region,
		ma_3yr,
		ISNULL(ROUND(100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY region ORDER BY disbursement_year)) /
				NULLIF(LAG(ma_3yr) OVER (PARTITION BY region ORDER BY disbursement_year), 0),1), 0) AS ma_3yr_pct_chg
	FROM with_ma
)
SELECT 
	disbursement_year,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr ELSE 0 END) AS eap_ma_3yr,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr ELSE 0 END) AS eca_ma_3yr,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr ELSE 0 END) AS lac_ma_3yr,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr ELSE 0 END) AS mea_ma_3yr,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr ELSE 0 END) AS sa_ma_3yr,
	SUM(CASE WHEN region = 'other' THEN ma_3yr ELSE 0 END) AS other_ma_3yr,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr_pct_chg ELSE 0 END) AS eap_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr_pct_chg ELSE 0 END) AS eca_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr_pct_chg ELSE 0 END) AS lac_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr_pct_chg ELSE 0 END) AS mea_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr_pct_chg ELSE 0 END) AS sa_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY disbursement_year
ORDER BY disbursement_year;


-- Grant Disbursement by Region Over Time
----- Year over Year Disbursement
WITH uniqueProjects AS (
    SELECT 
        YEAR(period_end_date) AS disbursement_year,
        project_id,
        region,
        ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
    FROM banking2011to2025
    WHERE period_end_date IS NOT NULL
        AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='grant'
    GROUP BY 
        YEAR(period_end_date), project_id, region
),
yearlyDisbursement AS (
    SELECT 
        disbursement_year,
        region,
        SUM(total_disbursed_amount) AS total_disbursement
    FROM uniqueProjects
    GROUP BY disbursement_year, region
),
pivoted AS (
    SELECT 
        disbursement_year,
        SUM(CASE WHEN region = 'east asia and pacific' THEN total_disbursement ELSE 0 END) AS east_asia_and_pacific,
        SUM(CASE WHEN region = 'europe and central asia' THEN total_disbursement ELSE 0 END) AS europe_and_central_asia,
        SUM(CASE WHEN region = 'latin america and caribbean' THEN total_disbursement ELSE 0 END) AS latin_america_and_caribbean,
        SUM(CASE WHEN region = 'middle east and africa' THEN total_disbursement ELSE 0 END) AS middle_east_and_africa,
        SUM(CASE WHEN region = 'south asia' THEN total_disbursement ELSE 0 END) AS south_asia,
        SUM(CASE WHEN region = 'other' THEN total_disbursement ELSE 0 END) AS other
    FROM yearlyDisbursement
    GROUP BY disbursement_year
),
final AS (
    SELECT *,
        ISNULL(ROUND(100.0 * (east_asia_and_pacific - LAG(east_asia_and_pacific) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(east_asia_and_pacific) OVER (ORDER BY disbursement_year), 0), 1), 0) AS eap_pct_chg,
        ISNULL(ROUND(100.0 * (europe_and_central_asia - LAG(europe_and_central_asia) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(europe_and_central_asia) OVER (ORDER BY disbursement_year), 0), 1), 0) AS eca_pct_chg,
        ISNULL(ROUND(100.0 * (latin_america_and_caribbean - LAG(latin_america_and_caribbean) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(latin_america_and_caribbean) OVER (ORDER BY disbursement_year), 0), 1), 0) AS lac_pct_chg,
        ISNULL(ROUND(100.0 * (middle_east_and_africa - LAG(middle_east_and_africa) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(middle_east_and_africa) OVER (ORDER BY disbursement_year), 0), 1), 0) AS mea_pct_chg,
        ISNULL(ROUND(100.0 * (south_asia - LAG(south_asia) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(south_asia) OVER (ORDER BY disbursement_year), 0), 1), 0) AS sa_pct_chg
    FROM pivoted
)
SELECT *
FROM final
ORDER BY disbursement_year;

----- Moving Average 3 Year Disbursement
WITH uniqueProjects AS (
	SELECT 
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		region,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='grant'
	GROUP BY YEAR(period_end_date), project_id, region
),
yearlyDisbursement AS (
	SELECT 
		disbursement_year,
		region,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY disbursement_year, region
),
with_ma AS (
	SELECT 
		disbursement_year,
		region,
		total_disbursement,
		ROUND(AVG(total_disbursement) OVER (PARTITION BY region ORDER BY disbursement_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS ma_3yr
	FROM yearlyDisbursement
),
with_ma_change AS (
	SELECT 
		disbursement_year,
		region,
		ma_3yr,
		ISNULL(ROUND(100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY region ORDER BY disbursement_year)) /
				NULLIF(LAG(ma_3yr) OVER (PARTITION BY region ORDER BY disbursement_year), 0),1), 0) AS ma_3yr_pct_chg
	FROM with_ma
)
SELECT 
	disbursement_year,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr ELSE 0 END) AS eap_ma_3yr,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr ELSE 0 END) AS eca_ma_3yr,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr ELSE 0 END) AS lac_ma_3yr,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr ELSE 0 END) AS mea_ma_3yr,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr ELSE 0 END) AS sa_ma_3yr,
	SUM(CASE WHEN region = 'other' THEN ma_3yr ELSE 0 END) AS other_ma_3yr,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr_pct_chg ELSE 0 END) AS eap_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr_pct_chg ELSE 0 END) AS eca_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr_pct_chg ELSE 0 END) AS lac_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr_pct_chg ELSE 0 END) AS mea_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr_pct_chg ELSE 0 END) AS sa_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY disbursement_year
ORDER BY disbursement_year;


-- Guarantee Disbursement by Region Over Time
----- Year over Year Disbursement
WITH uniqueProjects AS (
    SELECT 
        YEAR(period_end_date) AS disbursement_year,
        project_id,
        region,
        ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
    FROM banking2011to2025
    WHERE period_end_date IS NOT NULL
        AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='guarantee'
    GROUP BY 
        YEAR(period_end_date), project_id, region
),
yearlyDisbursement AS (
    SELECT 
        disbursement_year,
        region,
        SUM(total_disbursed_amount) AS total_disbursement
    FROM uniqueProjects
    GROUP BY disbursement_year, region
),
pivoted AS (
    SELECT 
        disbursement_year,
        SUM(CASE WHEN region = 'east asia and pacific' THEN total_disbursement ELSE 0 END) AS east_asia_and_pacific,
        SUM(CASE WHEN region = 'europe and central asia' THEN total_disbursement ELSE 0 END) AS europe_and_central_asia,
        SUM(CASE WHEN region = 'latin america and caribbean' THEN total_disbursement ELSE 0 END) AS latin_america_and_caribbean,
        SUM(CASE WHEN region = 'middle east and africa' THEN total_disbursement ELSE 0 END) AS middle_east_and_africa,
        SUM(CASE WHEN region = 'south asia' THEN total_disbursement ELSE 0 END) AS south_asia,
        SUM(CASE WHEN region = 'other' THEN total_disbursement ELSE 0 END) AS other
    FROM yearlyDisbursement
    GROUP BY disbursement_year
),
final AS (
    SELECT *,
        ISNULL(ROUND(100.0 * (east_asia_and_pacific - LAG(east_asia_and_pacific) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(east_asia_and_pacific) OVER (ORDER BY disbursement_year), 0), 1), 0) AS eap_pct_chg,
        ISNULL(ROUND(100.0 * (europe_and_central_asia - LAG(europe_and_central_asia) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(europe_and_central_asia) OVER (ORDER BY disbursement_year), 0), 1), 0) AS eca_pct_chg,
        ISNULL(ROUND(100.0 * (latin_america_and_caribbean - LAG(latin_america_and_caribbean) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(latin_america_and_caribbean) OVER (ORDER BY disbursement_year), 0), 1), 0) AS lac_pct_chg,
        ISNULL(ROUND(100.0 * (middle_east_and_africa - LAG(middle_east_and_africa) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(middle_east_and_africa) OVER (ORDER BY disbursement_year), 0), 1), 0) AS mea_pct_chg,
        ISNULL(ROUND(100.0 * (south_asia - LAG(south_asia) OVER (ORDER BY disbursement_year)) / NULLIF(LAG(south_asia) OVER (ORDER BY disbursement_year), 0), 1), 0) AS sa_pct_chg
    FROM pivoted
)
SELECT *
FROM final
ORDER BY disbursement_year;

----- Moving Average 3 Year Disbursement
WITH uniqueProjects AS (
	SELECT 
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		region,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='guarantee'
	GROUP BY YEAR(period_end_date), project_id, region
),
yearlyDisbursement AS (
	SELECT 
		disbursement_year,
		region,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY disbursement_year, region
),
with_ma AS (
	SELECT 
		disbursement_year,
		region,
		total_disbursement,
		ROUND(AVG(total_disbursement) OVER (PARTITION BY region ORDER BY disbursement_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS ma_3yr
	FROM yearlyDisbursement
),
with_ma_change AS (
	SELECT 
		disbursement_year,
		region,
		ma_3yr,
		ISNULL(ROUND(100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY region ORDER BY disbursement_year)) /
				NULLIF(LAG(ma_3yr) OVER (PARTITION BY region ORDER BY disbursement_year), 0),1), 0) AS ma_3yr_pct_chg
	FROM with_ma
)
SELECT 
	disbursement_year,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr ELSE 0 END) AS eap_ma_3yr,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr ELSE 0 END) AS eca_ma_3yr,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr ELSE 0 END) AS lac_ma_3yr,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr ELSE 0 END) AS mea_ma_3yr,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr ELSE 0 END) AS sa_ma_3yr,
	SUM(CASE WHEN region = 'other' THEN ma_3yr ELSE 0 END) AS other_ma_3yr,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr_pct_chg ELSE 0 END) AS eap_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr_pct_chg ELSE 0 END) AS eca_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr_pct_chg ELSE 0 END) AS lac_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr_pct_chg ELSE 0 END) AS mea_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr_pct_chg ELSE 0 END) AS sa_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY disbursement_year
ORDER BY disbursement_year;

----- COUNTRY -----
-- Disbursement by Top 5 Countries Over Time
----- Year over Year Disbursement
WITH uniqueProjects AS (
	SELECT 
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		country,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND country IN ('bangladesh', 'nigeria', 'ethiopia', 'pakistan', 'kenya')
	GROUP BY 
		YEAR(period_end_date),
		project_id,
		country
),
yearlyDisbursement AS (
	SELECT 
		disbursement_year,
		country,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY disbursement_year, country
),
with_pct_change AS (
	SELECT 
		disbursement_year,
		country,
		total_disbursement,
		ISNULL(ROUND(
			100.0 * (total_disbursement - LAG(total_disbursement) OVER (PARTITION BY country ORDER BY disbursement_year)) /
			NULLIF(LAG(total_disbursement) OVER (PARTITION BY country ORDER BY disbursement_year), 0), 1), 0
		) AS pct_change
	FROM yearlyDisbursement
)
SELECT 
	disbursement_year,
	SUM(CASE WHEN country = 'bangladesh' THEN total_disbursement ELSE 0 END) AS bangladesh,
	SUM(CASE WHEN country = 'nigeria' THEN total_disbursement ELSE 0 END) AS nigeria,
	SUM(CASE WHEN country = 'ethiopia' THEN total_disbursement ELSE 0 END) AS ethiopia,
	SUM(CASE WHEN country = 'pakistan' THEN total_disbursement ELSE 0 END) AS pakistan,
	SUM(CASE WHEN country = 'kenya' THEN total_disbursement ELSE 0 END) AS kenya,
	SUM(CASE WHEN country = 'bangladesh' THEN pct_change ELSE 0 END) AS bangladesh_pct_chg,
	SUM(CASE WHEN country = 'nigeria' THEN pct_change ELSE 0 END) AS nigeria_pct_chg,
	SUM(CASE WHEN country = 'ethiopia' THEN pct_change ELSE 0 END) AS ethiopia_pct_chg,
	SUM(CASE WHEN country = 'pakistan' THEN pct_change ELSE 0 END) AS pakistan_pct_chg,
	SUM(CASE WHEN country = 'kenya' THEN pct_change ELSE 0 END) AS kenya_pct_chg
FROM with_pct_change
GROUP BY disbursement_year
ORDER BY disbursement_year;

----- Moving Average 3 Year Disbursement
WITH uniqueProjects AS (
	SELECT 
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		country,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND country IN ('bangladesh', 'nigeria', 'ethiopia', 'pakistan', 'kenya')
	GROUP BY YEAR(period_end_date), project_id, country
),
yearlyDisbursement AS (
	SELECT 
		disbursement_year,
		country,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY disbursement_year, country
),
with_ma AS (
	SELECT 
		disbursement_year,
		country,
		ROUND(AVG(total_disbursement) OVER (
			PARTITION BY country 
			ORDER BY disbursement_year 
			ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
		), 0) AS ma_3yr
	FROM yearlyDisbursement
),
with_ma_change AS (
	SELECT 
		disbursement_year,
		country,
		ma_3yr,
		ISNULL(ROUND(
			100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY country ORDER BY disbursement_year)) /
			NULLIF(LAG(ma_3yr) OVER (PARTITION BY country ORDER BY disbursement_year), 0), 1
		), 0) AS ma_3yr_pct_chg
	FROM with_ma
)
SELECT 
	disbursement_year,
	SUM(CASE WHEN country = 'bangladesh' THEN ma_3yr ELSE 0 END) AS bangladesh_ma_3yr,
	SUM(CASE WHEN country = 'nigeria' THEN ma_3yr ELSE 0 END) AS nigeria_ma_3yr,
	SUM(CASE WHEN country = 'ethiopia' THEN ma_3yr ELSE 0 END) AS ethiopia_ma_3yr,
	SUM(CASE WHEN country = 'pakistan' THEN ma_3yr ELSE 0 END) AS pakistan_ma_3yr,
	SUM(CASE WHEN country = 'kenya' THEN ma_3yr ELSE 0 END) AS kenya_ma_3yr,
	SUM(CASE WHEN country = 'bangladesh' THEN ma_3yr_pct_chg ELSE 0 END) AS bangladesh_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'nigeria' THEN ma_3yr_pct_chg ELSE 0 END) AS nigeria_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'ethiopia' THEN ma_3yr_pct_chg ELSE 0 END) AS ethiopia_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'pakistan' THEN ma_3yr_pct_chg ELSE 0 END) AS pakistan_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'kenya' THEN ma_3yr_pct_chg ELSE 0 END) AS kenya_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY disbursement_year
ORDER BY disbursement_year;


-- Credit Disbursement by Top 5 Countries Over Time
----- Year over Year Disbursement
WITH uniqueProjects AS (
	SELECT 
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		country,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE 
		financial_instrument = 'credit'
		AND period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND country IN ('bangladesh', 'nigeria', 'pakistan', 'ethiopia', 'kenya')
	GROUP BY 
		YEAR(period_end_date), project_id, country
),
yearlyDisbursement AS (
	SELECT 
		disbursement_year,
		country,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY disbursement_year, country
),
pivoted AS (
	SELECT 
		disbursement_year,
		SUM(CASE WHEN country = 'bangladesh' THEN total_disbursement ELSE 0 END) AS bangladesh,
		SUM(CASE WHEN country = 'nigeria' THEN total_disbursement ELSE 0 END) AS nigeria,
		SUM(CASE WHEN country = 'pakistan' THEN total_disbursement ELSE 0 END) AS pakistan,
		SUM(CASE WHEN country = 'ethiopia' THEN total_disbursement ELSE 0 END) AS ethiopia,
		SUM(CASE WHEN country = 'kenya' THEN total_disbursement ELSE 0 END) AS kenya
	FROM yearlyDisbursement
	GROUP BY disbursement_year
),
final AS (
	SELECT 
		disbursement_year,
		bangladesh,
		nigeria,
		pakistan,
		ethiopia,
		kenya,
		LAG(bangladesh) OVER (ORDER BY disbursement_year) AS prev_bangladesh,
		LAG(nigeria) OVER (ORDER BY disbursement_year) AS prev_nigeria,
		LAG(pakistan) OVER (ORDER BY disbursement_year) AS prev_pakistan,
		LAG(ethiopia) OVER (ORDER BY disbursement_year) AS prev_ethiopia,
		LAG(kenya) OVER (ORDER BY disbursement_year) AS prev_kenya
	FROM pivoted
)
SELECT 
	disbursement_year,
	bangladesh,
	nigeria,
	pakistan,
	ethiopia,
	kenya,
	ISNULL(ROUND(100.0 * (bangladesh - prev_bangladesh) / NULLIF(prev_bangladesh, 0), 1), 0) AS bangladesh_pct_chg,
	ISNULL(ROUND(100.0 * (nigeria - prev_nigeria) / NULLIF(prev_nigeria, 0), 1), 0) AS nigeria_pct_chg,
	ISNULL(ROUND(100.0 * (pakistan - prev_pakistan) / NULLIF(prev_pakistan, 0), 1), 0) AS pakistan_pct_chg,
	ISNULL(ROUND(100.0 * (ethiopia - prev_ethiopia) / NULLIF(prev_ethiopia, 0), 1), 0) AS ethiopia_pct_chg,
	ISNULL(ROUND(100.0 * (kenya - prev_kenya) / NULLIF(prev_kenya, 0), 1), 0) AS kenya_pct_chg
FROM final
ORDER BY disbursement_year;

----- Moving Average 3 Year Disbursement
WITH uniqueProjects AS (
	SELECT 
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		country,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE 
		period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument = 'credit'
		AND country IN ('bangladesh', 'nigeria', 'pakistan', 'ethiopia', 'kenya')
	GROUP BY 
		YEAR(period_end_date), project_id, country
),
yearlyDisbursement AS (
	SELECT 
		disbursement_year,
		country,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY disbursement_year, country
),
with_ma AS (
	SELECT 
		disbursement_year,
		country,
		ROUND(AVG(total_disbursement) OVER (PARTITION BY country ORDER BY disbursement_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS ma_3yr
	FROM yearlyDisbursement
),
with_ma_change AS (
	SELECT 
		disbursement_year,
		country,
		ma_3yr,
		ISNULL(ROUND(100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY country ORDER BY disbursement_year)) / 
			NULLIF(LAG(ma_3yr) OVER (PARTITION BY country ORDER BY disbursement_year), 0), 1), 0) AS ma_3yr_pct_chg
	FROM with_ma
)
SELECT 
	disbursement_year,
	SUM(CASE WHEN country = 'bangladesh' THEN ma_3yr ELSE 0 END) AS bangladesh_ma_3yr,
	SUM(CASE WHEN country = 'nigeria' THEN ma_3yr ELSE 0 END) AS nigeria_ma_3yr,
	SUM(CASE WHEN country = 'pakistan' THEN ma_3yr ELSE 0 END) AS pakistan_ma_3yr,
	SUM(CASE WHEN country = 'ethiopia' THEN ma_3yr ELSE 0 END) AS ethiopia_ma_3yr,
	SUM(CASE WHEN country = 'kenya' THEN ma_3yr ELSE 0 END) AS kenya_ma_3yr,
	SUM(CASE WHEN country = 'bangladesh' THEN ma_3yr_pct_chg ELSE 0 END) AS bangladesh_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'nigeria' THEN ma_3yr_pct_chg ELSE 0 END) AS nigeria_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'pakistan' THEN ma_3yr_pct_chg ELSE 0 END) AS pakistan_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'ethiopia' THEN ma_3yr_pct_chg ELSE 0 END) AS ethiopia_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'kenya' THEN ma_3yr_pct_chg ELSE 0 END) AS kenya_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY disbursement_year
ORDER BY disbursement_year;


-- Grant Disbursement by Top 5 Countries Over Time
----- Year over Year Disbursement
WITH uniqueProjects AS (
	SELECT 
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		country,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE 
		financial_instrument = 'grant'
		AND period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND country IN ('ethiopia', 'mozambique', 'congo', 'afghanistan', 'chad')
	GROUP BY 
		YEAR(period_end_date), project_id, country
),
yearlyDisbursement AS (
	SELECT 
		disbursement_year,
		country,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY disbursement_year, country
),
pivoted AS (
	SELECT 
		disbursement_year,
		SUM(CASE WHEN country = 'ethiopia' THEN total_disbursement ELSE 0 END) AS ethiopia,
		SUM(CASE WHEN country = 'mozambique' THEN total_disbursement ELSE 0 END) AS mozambique,
		SUM(CASE WHEN country = 'congo' THEN total_disbursement ELSE 0 END) AS congo,
		SUM(CASE WHEN country = 'afghanistan' THEN total_disbursement ELSE 0 END) AS afghanistan,
		SUM(CASE WHEN country = 'chad' THEN total_disbursement ELSE 0 END) AS chad
	FROM yearlyDisbursement
	GROUP BY disbursement_year
),
final AS (
	SELECT 
		disbursement_year,
		ethiopia,
		mozambique,
		congo,
		afghanistan,
		chad,
		LAG(ethiopia) OVER (ORDER BY disbursement_year) AS prev_ethiopia,
		LAG(mozambique) OVER (ORDER BY disbursement_year) AS prev_mozambique,
		LAG(congo) OVER (ORDER BY disbursement_year) AS prev_congo,
		LAG(afghanistan) OVER (ORDER BY disbursement_year) AS prev_afghanistan,
		LAG(chad) OVER (ORDER BY disbursement_year) AS prev_chad
	FROM pivoted
)
SELECT 
	disbursement_year,
	ethiopia,
	mozambique,
	congo,
	afghanistan,
	chad,
	ISNULL(ROUND(100.0 * (ethiopia - prev_ethiopia) / NULLIF(prev_ethiopia, 0), 1), 0) AS ethiopia_pct_chg,
	ISNULL(ROUND(100.0 * (mozambique - prev_mozambique) / NULLIF(prev_mozambique, 0), 1), 0) AS mozambique_pct_chg,
	ISNULL(ROUND(100.0 * (congo - prev_congo) / NULLIF(prev_congo, 0), 1), 0) AS congo_pct_chg,
	ISNULL(ROUND(100.0 * (afghanistan - prev_afghanistan) / NULLIF(prev_afghanistan, 0), 1), 0) AS afghanistan_pct_chg,
	ISNULL(ROUND(100.0 * (chad - prev_chad) / NULLIF(prev_chad, 0), 1), 0) AS chad_pct_chg
FROM final
ORDER BY disbursement_year;

----- Moving Average 3 Year Disbursement
WITH uniqueProjects AS (
	SELECT 
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		country,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE 
		financial_instrument = 'grant'
		AND period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND country IN ('ethiopia', 'mozambique', 'congo', 'afghanistan', 'chad')
	GROUP BY YEAR(period_end_date), project_id, country
),
yearlyDisbursement AS (
	SELECT 
		disbursement_year,
		country,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY disbursement_year, country
),
with_ma AS (
	SELECT 
		disbursement_year,
		country,
		ROUND(AVG(total_disbursement) OVER (PARTITION BY country ORDER BY disbursement_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS ma_3yr
	FROM yearlyDisbursement
),
with_ma_change AS (
	SELECT 
		disbursement_year,
		country,
		ma_3yr,
		ISNULL(ROUND(100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY country ORDER BY disbursement_year)) /
			NULLIF(LAG(ma_3yr) OVER (PARTITION BY country ORDER BY disbursement_year), 0), 1), 0) AS ma_3yr_pct_chg
	FROM with_ma
)
SELECT 
	disbursement_year,
	SUM(CASE WHEN country = 'ethiopia' THEN ma_3yr ELSE 0 END) AS ethiopia_ma_3yr,
	SUM(CASE WHEN country = 'mozambique' THEN ma_3yr ELSE 0 END) AS mozambique_ma_3yr,
	SUM(CASE WHEN country = 'congo' THEN ma_3yr ELSE 0 END) AS congo_ma_3yr,
	SUM(CASE WHEN country = 'afghanistan' THEN ma_3yr ELSE 0 END) AS afghanistan_ma_3yr,
	SUM(CASE WHEN country = 'chad' THEN ma_3yr ELSE 0 END) AS chad_ma_3yr,
	SUM(CASE WHEN country = 'ethiopia' THEN ma_3yr_pct_chg ELSE 0 END) AS ethiopia_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'mozambique' THEN ma_3yr_pct_chg ELSE 0 END) AS mozambique_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'congo' THEN ma_3yr_pct_chg ELSE 0 END) AS congo_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'afghanistan' THEN ma_3yr_pct_chg ELSE 0 END) AS afghanistan_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'chad' THEN ma_3yr_pct_chg ELSE 0 END) AS chad_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY disbursement_year
ORDER BY disbursement_year;


-- Guarantee Disbursement by Top 5 Countries Over Time
----- Year over Year Disbursement
WITH year_range AS (
    SELECT DISTINCT YEAR(board_approval_date) AS funding_year
    FROM banking2011to2025
    WHERE board_approval_date IS NOT NULL
      AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
),
country_list AS (
    SELECT DISTINCT country
    FROM banking2011to2025
    WHERE board_approval_date IS NOT NULL
      AND financial_instrument = 'guarantee'
),
calendar AS (
    SELECT y.funding_year AS disbursement_year, c.country
    FROM year_range y
    CROSS JOIN country_list c
    WHERE c.country IN ('pakistan', 'ghana', 'kenya', 'benin', 'cote d''ivoire')
),
uniqueProjects AS (
	SELECT 
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		country,
		ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
	FROM banking2011to2025
	WHERE financial_instrument = 'guarantee'
	  AND period_end_date IS NOT NULL
	  AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	  AND country IN ('pakistan', 'ghana', 'kenya', 'benin', 'cote d''ivoire')
	GROUP BY YEAR(period_end_date), project_id, country
),
yearlyDisbursement AS (
	SELECT 
		disbursement_year,
		country,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY disbursement_year, country
),
filled_disbursement AS (
	SELECT 
		c.disbursement_year,
		c.country,
		ISNULL(y.total_disbursement, 0) AS total_disbursement
	FROM calendar c
	LEFT JOIN yearlyDisbursement y
		ON c.disbursement_year = y.disbursement_year AND c.country = y.country
),
pivoted AS (
	SELECT
		disbursement_year,
		SUM(CASE WHEN country = 'pakistan' THEN total_disbursement ELSE 0 END) AS pakistan,
		SUM(CASE WHEN country = 'ghana' THEN total_disbursement ELSE 0 END) AS ghana,
		SUM(CASE WHEN country = 'kenya' THEN total_disbursement ELSE 0 END) AS kenya,
		SUM(CASE WHEN country = 'benin' THEN total_disbursement ELSE 0 END) AS benin,
		SUM(CASE WHEN country = 'cote d''ivoire' THEN total_disbursement ELSE 0 END) AS cote_divoire
	FROM filled_disbursement
	GROUP BY disbursement_year
),
final AS (
	SELECT 
		disbursement_year,
		pakistan,
		ghana,
		kenya,
		benin,
		cote_divoire,
		LAG(pakistan) OVER (ORDER BY disbursement_year) AS prev_pakistan,
		LAG(ghana) OVER (ORDER BY disbursement_year) AS prev_ghana,
		LAG(kenya) OVER (ORDER BY disbursement_year) AS prev_kenya,
		LAG(benin) OVER (ORDER BY disbursement_year) AS prev_benin,
		LAG(cote_divoire) OVER (ORDER BY disbursement_year) AS prev_cote_divoire
	FROM pivoted
)
SELECT 
	disbursement_year,
	pakistan,
	ghana,
	kenya,
	benin,
	cote_divoire,
	ISNULL(ROUND(100.0 * (pakistan - prev_pakistan) / NULLIF(prev_pakistan, 0), 1), 0) AS pakistan_pct_chg,
	ISNULL(ROUND(100.0 * (ghana - prev_ghana) / NULLIF(prev_ghana, 0), 1), 0) AS ghana_pct_chg,
	ISNULL(ROUND(100.0 * (kenya - prev_kenya) / NULLIF(prev_kenya, 0), 1), 0) AS kenya_pct_chg,
	ISNULL(ROUND(100.0 * (benin - prev_benin) / NULLIF(prev_benin, 0), 1), 0) AS benin_pct_chg,
	ISNULL(ROUND(100.0 * (cote_divoire - prev_cote_divoire) / NULLIF(prev_cote_divoire, 0), 1), 0) AS cote_divoire_pct_chg
FROM final
ORDER BY disbursement_year;

----- Moving Average 3 Year Disbursement
WITH year_range AS (
    SELECT DISTINCT YEAR(board_approval_date) AS funding_year
    FROM banking2011to2025
    WHERE board_approval_date IS NOT NULL
      AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
),
country_list AS (
    SELECT 'pakistan' AS country UNION ALL
    SELECT 'ghana' UNION ALL
    SELECT 'kenya' UNION ALL
    SELECT 'benin' UNION ALL
    SELECT 'cote d''ivoire'
),
calendar AS (
    SELECT y.funding_year AS disbursement_year, c.country
    FROM year_range y
    CROSS JOIN country_list c
),
uniqueProjects AS (
    SELECT 
        YEAR(period_end_date) AS disbursement_year,
        project_id,
        country,
        ROUND(MAX(disbursed_amount), 0) AS total_disbursed_amount
    FROM banking2011to2025
    WHERE period_end_date IS NOT NULL
      AND financial_instrument = 'guarantee'
      AND YEAR(period_end_date) BETWEEN 2011 AND 2025
      AND country IN ('pakistan', 'ghana', 'kenya', 'benin', 'cote d''ivoire')
    GROUP BY YEAR(period_end_date), project_id, country
),
yearlyDisbursement AS (
    SELECT 
        disbursement_year,
        country,
        SUM(total_disbursed_amount) AS total_disbursement
    FROM uniqueProjects
    GROUP BY disbursement_year, country
),
filled_disbursement AS (
    SELECT 
        c.disbursement_year,
        c.country,
        ISNULL(y.total_disbursement, 0) AS total_disbursement
    FROM calendar c
    LEFT JOIN yearlyDisbursement y
        ON c.disbursement_year = y.disbursement_year
        AND c.country = y.country
),
with_ma AS (
    SELECT 
        disbursement_year,
        country,
        ROUND(AVG(total_disbursement) OVER (
            PARTITION BY country ORDER BY disbursement_year 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS ma_3yr
    FROM filled_disbursement
),
with_ma_change AS (
    SELECT 
        disbursement_year,
        country,
        ma_3yr,
        ISNULL(ROUND(100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY country ORDER BY disbursement_year)) /
            NULLIF(LAG(ma_3yr) OVER (PARTITION BY country ORDER BY disbursement_year), 0), 1), 0) AS ma_3yr_pct_chg
    FROM with_ma
)
SELECT 
    disbursement_year,
    SUM(CASE WHEN country = 'pakistan' THEN ma_3yr ELSE 0 END) AS pakistan_ma_3yr,
    SUM(CASE WHEN country = 'ghana' THEN ma_3yr ELSE 0 END) AS ghana_ma_3yr,
    SUM(CASE WHEN country = 'kenya' THEN ma_3yr ELSE 0 END) AS kenya_ma_3yr,
    SUM(CASE WHEN country = 'benin' THEN ma_3yr ELSE 0 END) AS benin_ma_3yr,
    SUM(CASE WHEN country = 'cote d''ivoire' THEN ma_3yr ELSE 0 END) AS cote_divoire_ma_3yr,
    SUM(CASE WHEN country = 'pakistan' THEN ma_3yr_pct_chg ELSE 0 END) AS pakistan_ma_3yr_pct_chg,
    SUM(CASE WHEN country = 'ghana' THEN ma_3yr_pct_chg ELSE 0 END) AS ghana_ma_3yr_pct_chg,
    SUM(CASE WHEN country = 'kenya' THEN ma_3yr_pct_chg ELSE 0 END) AS kenya_ma_3yr_pct_chg,
    SUM(CASE WHEN country = 'benin' THEN ma_3yr_pct_chg ELSE 0 END) AS benin_ma_3yr_pct_chg,
    SUM(CASE WHEN country = 'cote d''ivoire' THEN ma_3yr_pct_chg ELSE 0 END) AS cote_divoire_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY disbursement_year
ORDER BY disbursement_year;


/* REPAYMENT */
----- OVERALL -----
-- Overall Repayment Over Time 
WITH uniqueProjects AS (
    SELECT 
        project_id,
        YEAR(period_end_date) AS repayment_year,
        ROUND(MAX(repaid_amount), 0) AS total_repaid_amount
    FROM banking2011to2025
    WHERE 
		period_end_date IS NOT NULL
		AND financial_instrument='credit'
    GROUP BY project_id, YEAR(period_end_date)
),
yearlyRepayment AS (
    SELECT 
        repayment_year,
        SUM(total_repaid_amount) AS total_repayment
    FROM uniqueProjects
    GROUP BY repayment_year
),
final AS (
    SELECT 
        repayment_year,
        total_repayment,
        ISNULL(ROUND(100.0 * (total_repayment - LAG(total_repayment) OVER (ORDER BY repayment_year)) /
            NULLIF(LAG(total_repayment) OVER (ORDER BY repayment_year), 0), 1), 0) AS yoy_pct_change,
        ROUND(AVG(total_repayment) OVER (ORDER BY repayment_year ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS moving_avg_3yr
    FROM yearlyRepayment
)
SELECT 
    repayment_year,
    total_repayment,
    yoy_pct_change,
    moving_avg_3yr,
    ISNULL(ROUND(100.0 * (moving_avg_3yr - LAG(moving_avg_3yr) OVER (ORDER BY repayment_year)) /
        NULLIF(LAG(moving_avg_3yr) OVER (ORDER BY repayment_year), 0), 1), 0) AS ma_pct_change
FROM final
ORDER BY repayment_year;


----- REGION -----
-- Repayment by Region Over Time
----- Year over Year Repayment
WITH uniqueProjects AS (
	SELECT 
		YEAR(period_end_date) AS repayment_year,
		project_id,
		region,
		ROUND(MAX(repaid_amount), 0) AS total_repaid_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument = 'credit'
	GROUP BY 
		YEAR(period_end_date), project_id, region
),
yearlyRepayment AS (
	SELECT 
		repayment_year,
		region,
		SUM(total_repaid_amount) AS total_repayment
	FROM uniqueProjects
	GROUP BY repayment_year, region
),
withLag AS (
	SELECT
		repayment_year,
		region,
		total_repayment,
		LAG(total_repayment) OVER (PARTITION BY region ORDER BY repayment_year) AS prev_total_repayment
	FROM yearlyRepayment
),
withChange AS (
	SELECT
		repayment_year,
		region,
		total_repayment,
		ISNULL(ROUND(100.0 * (total_repayment - prev_total_repayment) / NULLIF(prev_total_repayment, 0), 1), 0) AS pct_change
	FROM withLag
),
pivoted AS (
	SELECT
		repayment_year,
		SUM(CASE WHEN region = 'east asia and pacific' THEN total_repayment ELSE 0 END) AS east_asia_and_pacific,
		SUM(CASE WHEN region = 'europe and central asia' THEN total_repayment ELSE 0 END) AS europe_and_central_asia,
		SUM(CASE WHEN region = 'latin america and caribbean' THEN total_repayment ELSE 0 END) AS latin_america_and_caribbean,
		SUM(CASE WHEN region = 'middle east and africa' THEN total_repayment ELSE 0 END) AS middle_east_and_africa,
		SUM(CASE WHEN region = 'south asia' THEN total_repayment ELSE 0 END) AS south_asia,
		SUM(CASE WHEN region = 'other' THEN total_repayment ELSE 0 END) AS other,
		
		SUM(CASE WHEN region = 'east asia and pacific' THEN pct_change ELSE 0 END) AS eap_pct_chg,
		SUM(CASE WHEN region = 'europe and central asia' THEN pct_change ELSE 0 END) AS eca_pct_chg,
		SUM(CASE WHEN region = 'latin america and caribbean' THEN pct_change ELSE 0 END) AS lac_pct_chg,
		SUM(CASE WHEN region = 'middle east and africa' THEN pct_change ELSE 0 END) AS mea_pct_chg,
		SUM(CASE WHEN region = 'south asia' THEN pct_change ELSE 0 END) AS sa_pct_chg
	FROM withChange
	GROUP BY repayment_year
)
SELECT *
FROM pivoted
ORDER BY repayment_year;

----- Moving Average 3 Year Repayment
WITH uniqueProjects AS (
	SELECT 
		YEAR(period_end_date) AS repayment_year,
		project_id,
		region,
		ROUND(MAX(repaid_amount), 0) AS total_repaid_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='credit'
	GROUP BY YEAR(period_end_date), project_id, region
),
yearlyRepayment AS (
	SELECT 
		repayment_year,
		region,
		SUM(total_repaid_amount) AS total_repayment
	FROM uniqueProjects
	GROUP BY repayment_year, region
),
with_ma AS (
	SELECT 
		repayment_year,
		region,
		total_repayment,
		ROUND(AVG(total_repayment) OVER (
			PARTITION BY region ORDER BY repayment_year 
			ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
		), 0) AS ma_3yr
	FROM yearlyRepayment
),
with_ma_change AS (
	SELECT 
		repayment_year,
		region,
		ma_3yr,
		ISNULL(ROUND(
			100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY region ORDER BY repayment_year)) /
			NULLIF(LAG(ma_3yr) OVER (PARTITION BY region ORDER BY repayment_year), 0), 1), 0
		) AS ma_3yr_pct_chg
	FROM with_ma
)
SELECT 
	repayment_year,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr ELSE 0 END) AS eap_ma_3yr,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr ELSE 0 END) AS eca_ma_3yr,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr ELSE 0 END) AS lac_ma_3yr,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr ELSE 0 END) AS mea_ma_3yr,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr ELSE 0 END) AS sa_ma_3yr,
	SUM(CASE WHEN region = 'other' THEN ma_3yr ELSE 0 END) AS other_ma_3yr,
	SUM(CASE WHEN region = 'east asia and pacific' THEN ma_3yr_pct_chg ELSE 0 END) AS eap_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'europe and central asia' THEN ma_3yr_pct_chg ELSE 0 END) AS eca_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'latin america and caribbean' THEN ma_3yr_pct_chg ELSE 0 END) AS lac_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'middle east and africa' THEN ma_3yr_pct_chg ELSE 0 END) AS mea_ma_3yr_pct_chg,
	SUM(CASE WHEN region = 'south asia' THEN ma_3yr_pct_chg ELSE 0 END) AS sa_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY repayment_year
ORDER BY repayment_year;


----- COUNTRY -----
-- Repayment by Top 5 Countries Over Time
----- Year over Year Repayment
WITH uniqueProjects AS (
	SELECT 
		YEAR(period_end_date) AS repayment_year,
		project_id,
		country,
		ROUND(MAX(repaid_amount), 0) AS total_repaid_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument = 'credit'
		AND country IN ('india', 'vietnam', 'pakistan', 'nigeria', 'bangladesh')
	GROUP BY YEAR(period_end_date), project_id, country
),
yearlyRepayment AS (
	SELECT 
		repayment_year,
		country,
		SUM(total_repaid_amount) AS total_repayment
	FROM uniqueProjects
	GROUP BY repayment_year, country
),
pivoted AS (
	SELECT 
		repayment_year,
		SUM(CASE WHEN country = 'india' THEN total_repayment ELSE 0 END) AS india,
		SUM(CASE WHEN country = 'vietnam' THEN total_repayment ELSE 0 END) AS vietnam,
		SUM(CASE WHEN country = 'pakistan' THEN total_repayment ELSE 0 END) AS pakistan,
		SUM(CASE WHEN country = 'nigeria' THEN total_repayment ELSE 0 END) AS nigeria,
		SUM(CASE WHEN country = 'bangladesh' THEN total_repayment ELSE 0 END) AS bangladesh
	FROM yearlyRepayment
	GROUP BY repayment_year
),
final AS (
	SELECT *,
		LAG(india) OVER (ORDER BY repayment_year) AS prev_india,
		LAG(vietnam) OVER (ORDER BY repayment_year) AS prev_vietnam,
		LAG(pakistan) OVER (ORDER BY repayment_year) AS prev_pakistan,
		LAG(nigeria) OVER (ORDER BY repayment_year) AS prev_nigeria,
		LAG(bangladesh) OVER (ORDER BY repayment_year) AS prev_bangladesh
	FROM pivoted
)
SELECT 
	repayment_year,
	india,
	vietnam,
	pakistan,
	nigeria,
	bangladesh,
	ISNULL(ROUND(100.0 * (india - prev_india) / NULLIF(prev_india, 0), 1), 0) AS india_pct_chg,
	ISNULL(ROUND(100.0 * (vietnam - prev_vietnam) / NULLIF(prev_vietnam, 0), 1), 0) AS vietnam_pct_chg,
	ISNULL(ROUND(100.0 * (pakistan - prev_pakistan) / NULLIF(prev_pakistan, 0), 1), 0) AS pakistan_pct_chg,
	ISNULL(ROUND(100.0 * (nigeria - prev_nigeria) / NULLIF(prev_nigeria, 0), 1), 0) AS nigeria_pct_chg,
	ISNULL(ROUND(100.0 * (bangladesh - prev_bangladesh) / NULLIF(prev_bangladesh, 0), 1), 0) AS bangladesh_pct_chg
FROM final
ORDER BY repayment_year;


----- Moving Average 3 Year Repayment
WITH uniqueProjects AS (
	SELECT 
		YEAR(period_end_date) AS repayment_year,
		project_id,
		country,
		ROUND(MAX(repaid_amount), 0) AS total_repaid_amount
	FROM banking2011to2025
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND country IN ('india', 'vietnam', 'pakistan', 'nigeria', 'bangladesh')
	GROUP BY YEAR(period_end_date), project_id, country
),
yearlyRepayment AS (
	SELECT 
		repayment_year,
		country,
		SUM(total_repaid_amount) AS total_repayment
	FROM uniqueProjects
	GROUP BY repayment_year, country
),
with_ma AS (
	SELECT 
		repayment_year,
		country,
		total_repayment,
		ROUND(
			AVG(total_repayment) OVER (
				PARTITION BY country 
				ORDER BY repayment_year 
				ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
			), 0
		) AS ma_3yr
	FROM yearlyRepayment
),
with_ma_change AS (
	SELECT 
		repayment_year,
		country,
		ma_3yr,
		ISNULL(ROUND(
			100.0 * (ma_3yr - LAG(ma_3yr) OVER (PARTITION BY country ORDER BY repayment_year)) / 
			NULLIF(LAG(ma_3yr) OVER (PARTITION BY country ORDER BY repayment_year), 0), 1
		), 0) AS ma_3yr_pct_chg
	FROM with_ma
)
SELECT 
	repayment_year,
	SUM(CASE WHEN country = 'india' THEN ma_3yr ELSE 0 END) AS india_ma_3yr,
	SUM(CASE WHEN country = 'vietnam' THEN ma_3yr ELSE 0 END) AS vietnam_ma_3yr,
	SUM(CASE WHEN country = 'pakistan' THEN ma_3yr ELSE 0 END) AS pakistan_ma_3yr,
	SUM(CASE WHEN country = 'nigeria' THEN ma_3yr ELSE 0 END) AS nigeria_ma_3yr,
	SUM(CASE WHEN country = 'bangladesh' THEN ma_3yr ELSE 0 END) AS bangladesh_ma_3yr,
	SUM(CASE WHEN country = 'india' THEN ma_3yr_pct_chg ELSE 0 END) AS india_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'vietnam' THEN ma_3yr_pct_chg ELSE 0 END) AS vietnam_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'pakistan' THEN ma_3yr_pct_chg ELSE 0 END) AS pakistan_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'nigeria' THEN ma_3yr_pct_chg ELSE 0 END) AS nigeria_ma_3yr_pct_chg,
	SUM(CASE WHEN country = 'bangladesh' THEN ma_3yr_pct_chg ELSE 0 END) AS bangladesh_ma_3yr_pct_chg
FROM with_ma_change
GROUP BY repayment_year
ORDER BY repayment_year;


----------------------------------------------------------------------
/* 4. How long do projects typically take from approval to closing? */
----------------------------------------------------------------------
----- OVERALL -----
-- Overall Project Lifecycle
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		MIN(board_approval_date) AS board_approval_date,
		MAX(latest_closed_date) AS latest_closed_date
	FROM banking2011to2025
	WHERE 
	board_approval_date IS NOT NULL 
	AND latest_closed_date IS NOT NULL
	GROUP BY project_id
)
SELECT
	CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1))  AS avg_yr
FROM uniqueProjects;

-- Project Lifecycle by Financial Instrument
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		financial_instrument,
		MIN(board_approval_date) AS board_approval_date,
		MAX(latest_closed_date) AS latest_closed_date
	FROM banking2011to2025
	WHERE 
	board_approval_date IS NOT NULL 
	AND latest_closed_date IS NOT NULL
	GROUP BY project_id,financial_instrument
)
SELECT
	financial_instrument,
	CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1))  AS avg_yr
FROM uniqueProjects
GROUP BY financial_instrument
ORDER BY CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1)) DESC;

----- REGION -----
-- Project Lifecycle by Region
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		region,
		MIN(board_approval_date) AS board_approval_date,
		MAX(latest_closed_date) AS latest_closed_date
	FROM banking2011to2025
	WHERE 
	board_approval_date IS NOT NULL 
	AND latest_closed_date IS NOT NULL
	GROUP BY project_id,region
)
SELECT
	region,
	CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1))  AS avg_yr
FROM uniqueProjects
WHERE 
	board_approval_date IS NOT NULL 
	AND latest_closed_date IS NOT NULL
GROUP BY region
ORDER BY CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1)) DESC;

-- Credit Project Lifecycle by Region
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		region,
		MIN(board_approval_date) AS board_approval_date,
		MAX(latest_closed_date) AS latest_closed_date
	FROM banking2011to2025
	WHERE 
	board_approval_date IS NOT NULL 
	AND latest_closed_date IS NOT NULL
	AND financial_instrument='credit'
	GROUP BY project_id,region
)
SELECT
	region,
	CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1))  AS avg_yr
FROM uniqueProjects
GROUP BY region
ORDER BY CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1)) DESC;

-- Grant Project Lifecycle by Region
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		region,
		MIN(board_approval_date) AS board_approval_date,
		MAX(latest_closed_date) AS latest_closed_date
	FROM banking2011to2025
	WHERE 
	board_approval_date IS NOT NULL 
	AND latest_closed_date IS NOT NULL
	AND financial_instrument='grant'
	GROUP BY project_id,region
)
SELECT
	region,
	CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1))  AS avg_yr
FROM uniqueProjects
GROUP BY region
ORDER BY CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1)) DESC;

-- Guarantee Project Lifecycle by Region
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		region,
		MIN(board_approval_date) AS board_approval_date,
		MAX(latest_closed_date) AS latest_closed_date
	FROM banking2011to2025
	WHERE 
	board_approval_date IS NOT NULL 
	AND latest_closed_date IS NOT NULL
	AND financial_instrument='guarantee'
	GROUP BY project_id,region
)
SELECT
	region,
	CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1))  AS avg_yr
FROM uniqueProjects
GROUP BY region
ORDER BY CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1)) DESC;

----- COUNTRY -----
----- TOP 5
-- Top 5 Project Lifecycle by Country
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		country,
		MIN(board_approval_date) AS board_approval_date,
		MAX(latest_closed_date) AS latest_closed_date
	FROM banking2011to2025
	WHERE 
	board_approval_date IS NOT NULL 
	AND latest_closed_date IS NOT NULL
	GROUP BY project_id,country
)
SELECT
	country,
	CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1))   AS avg_yr
FROM uniqueProjects
GROUP BY country
ORDER BY CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1))  DESC;

-- Top 5 Credit Project Lifecycle by Country
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		country,
		MIN(board_approval_date) AS board_approval_date,
		MAX(latest_closed_date) AS latest_closed_date
	FROM banking2011to2025
	WHERE 
	board_approval_date IS NOT NULL 
	AND latest_closed_date IS NOT NULL
	AND financial_instrument='credit'
	GROUP BY project_id,country
)
SELECT
	country,
	CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1))  AS avg_yr
FROM uniqueProjects
GROUP BY country
ORDER BY CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1)) DESC;

-- Top 5 Grant Project Lifecycle by Country
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		country,
		MIN(board_approval_date) AS board_approval_date,
		MAX(latest_closed_date) AS latest_closed_date
	FROM banking2011to2025
	WHERE 
	board_approval_date IS NOT NULL 
	AND latest_closed_date IS NOT NULL
	AND financial_instrument='grant'
	GROUP BY project_id,country
)
SELECT
	country,
	CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1))  AS avg_yr
FROM uniqueProjects
GROUP BY country
ORDER BY CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1)) DESC;

-- Top 5 Guarantee Project Lifecycle by Country
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		country,
		MIN(board_approval_date) AS board_approval_date,
		MAX(latest_closed_date) AS latest_closed_date
	FROM banking2011to2025
	WHERE 
	board_approval_date IS NOT NULL 
	AND latest_closed_date IS NOT NULL
	AND financial_instrument='guarantee'
	GROUP BY project_id,country
)
SELECT
	country,
	CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1))  AS avg_yr
FROM uniqueProjects
GROUP BY country
ORDER BY CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1)) DESC;

----- BOTTOM 5
-- Bottom 5 Project Lifecycle by Country
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		country,
		MIN(board_approval_date) AS board_approval_date,
		MAX(latest_closed_date) AS latest_closed_date
	FROM banking2011to2025
	WHERE 
	board_approval_date IS NOT NULL 
	AND latest_closed_date IS NOT NULL
	GROUP BY project_id,country
)
SELECT
	country,
	CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1))  AS avg_yr
FROM uniqueProjects
WHERE 
	board_approval_date IS NOT NULL 
	AND latest_closed_date IS NOT NULL
GROUP BY country
ORDER BY CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1));

-- Bottom 5 Credit Project Lifecycle by Country
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		country,
		MIN(board_approval_date) AS board_approval_date,
		MAX(latest_closed_date) AS latest_closed_date
	FROM banking2011to2025
	WHERE 
	board_approval_date IS NOT NULL 
	AND latest_closed_date IS NOT NULL
	AND financial_instrument='credit'
	GROUP BY project_id,country
)
SELECT
	country,
	CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1))  AS avg_yr
FROM uniqueProjects
GROUP BY country
ORDER BY CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1));

-- Bottom 5 Grant Project Lifecycle by Country
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		country,
		MIN(board_approval_date) AS board_approval_date,
		MAX(latest_closed_date) AS latest_closed_date
	FROM banking2011to2025
	WHERE 
	board_approval_date IS NOT NULL 
	AND latest_closed_date IS NOT NULL
	AND financial_instrument='grant'
	GROUP BY project_id,country
)
SELECT
	country,
	CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1))  AS avg_yr
FROM uniqueProjects
GROUP BY country
ORDER BY CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1));

-- Bottom 5 Guarantee Project Lifecycle by Country
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		country,
		MIN(board_approval_date) AS board_approval_date,
		MAX(latest_closed_date) AS latest_closed_date
	FROM banking2011to2025
	WHERE 
	board_approval_date IS NOT NULL 
	AND latest_closed_date IS NOT NULL
	AND financial_instrument='guarantee'
	GROUP BY project_id,country
)
SELECT
	country,
	CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1))  AS avg_yr
FROM uniqueProjects
GROUP BY country
ORDER BY CAST(ROUND(AVG(1.0 * DATEDIFF(DAY, board_approval_date, latest_closed_date) / 365.0), 1) AS DECIMAL(10,1));


-------------------------------------------------------------------
/* 5. What proportion are the Disbursement and Repayment Ratios? */
-------------------------------------------------------------------
/* DISBURSEMENT */
----- OVERALL -----
WITH uniqueProjects AS
(
	SELECT 
		project_id,
		MAX(disbursed_amount) AS disbursed_amount,
		MAX(principal_amount) AS principal_amount
	FROM banking2011to2025
	WHERE 
		disbursed_amount IS NOT NULL
		AND principal_amount IS NOT NULL
	GROUP BY project_id
)
SELECT 
	ROUND(AVG(ISNULL(disbursed_amount / NULLIF(principal_amount ,0),0)),2) AS disbursement_to_commitment_ratio
FROM uniqueProjects;

----- REGION -----
-- Disbursement to Commitment Ratio by Region
WITH uniqueProjects AS
(
	SELECT 
		project_id,
		region,
		MAX(disbursed_amount) AS disbursed_amount,
		MAX(principal_amount) AS principal_amount
	FROM banking2011to2025
	WHERE 
		disbursed_amount IS NOT NULL
		AND principal_amount IS NOT NULL
	GROUP BY project_id,region
)
SELECT
	region,
	ROUND(AVG(ISNULL(disbursed_amount / NULLIF(principal_amount ,0),0)),2) AS disbursement_to_commitment_ratio
FROM uniqueProjects
GROUP BY region;

-- Credits Disbursement to Commitment Ratio by Region
WITH uniqueProjects AS
(
	SELECT 
		project_id,
		region,
		MAX(disbursed_amount) AS disbursed_amount,
		MAX(principal_amount) AS principal_amount
	FROM banking2011to2025
	WHERE 
		disbursed_amount IS NOT NULL
		AND principal_amount IS NOT NULL
		AND financial_instrument='credit'
	GROUP BY project_id,region
)
SELECT
	region,
	ROUND(AVG(ISNULL(disbursed_amount / NULLIF(principal_amount ,0),0)),2) AS disbursement_to_commitment_ratio
FROM uniqueProjects
GROUP BY region;

-- Grants Disbursement to Commitment Ratio by Region
WITH uniqueProjects AS
(
	SELECT 
		project_id,
		region,
		MAX(disbursed_amount) AS disbursed_amount,
		MAX(principal_amount) AS principal_amount
	FROM banking2011to2025
	WHERE 
		disbursed_amount IS NOT NULL
		AND principal_amount IS NOT NULL
		AND financial_instrument='grant'
	GROUP BY project_id,region
)
SELECT
	region,
	ROUND(AVG(ISNULL(disbursed_amount / NULLIF(principal_amount ,0),0)),2) AS disbursement_to_commitment_ratio
FROM uniqueProjects
GROUP BY region;

-- Guarantees Disbursement to Commitment Ratio by Region
WITH uniqueProjects AS
(
	SELECT 
		project_id,
		region,
		MAX(disbursed_amount) AS disbursed_amount,
		MAX(principal_amount) AS principal_amount
	FROM banking2011to2025
	WHERE 
		disbursed_amount IS NOT NULL
		AND principal_amount IS NOT NULL
		AND financial_instrument='guarantee'
	GROUP BY project_id,region
)
SELECT
	region,
	ROUND(AVG(ISNULL(disbursed_amount / NULLIF(principal_amount ,0),0)),2) AS disbursement_to_commitment_ratio
FROM uniqueProjects
GROUP BY region;


----- COUNTRY -----
-- Top Disbursement to Commitment Ratio
WITH uniqueProjects AS
(
	SELECT 
		project_id,
		country,
		MAX(disbursed_amount) AS disbursed_amount,
		MAX(principal_amount) AS principal_amount
	FROM banking2011to2025
	WHERE 
		disbursed_amount IS NOT NULL
		AND principal_amount IS NOT NULL
	GROUP BY project_id,country
)
SELECT
	country,
	ROUND(AVG(ISNULL(disbursed_amount / NULLIF(principal_amount ,0),0)),2) AS disbursement_to_commitment_ratio
FROM uniqueProjects
GROUP BY country
ORDER BY ROUND(AVG(ISNULL(disbursed_amount / NULLIF(principal_amount ,0),0)),2) DESC;

-- Bottom Disbursement to Commitment Ratio
WITH uniqueProjects AS
(
	SELECT 
		project_id,
		country,
		MAX(disbursed_amount) AS disbursed_amount,
		MAX(principal_amount) AS principal_amount
	FROM banking2011to2025
	WHERE 
		disbursed_amount IS NOT NULL
		AND principal_amount IS NOT NULL
	GROUP BY project_id,country
)
SELECT
	country,
	ROUND(AVG(ISNULL(disbursed_amount / NULLIF(principal_amount ,0),0)),2) AS disbursement_to_commitment_ratio
FROM uniqueProjects
GROUP BY country
ORDER BY ROUND(AVG(ISNULL(disbursed_amount / NULLIF(principal_amount ,0),0)),2);

	
/* REPAYMENT */
----- OVERALL -----
WITH uniqueProjects AS
(
	SELECT 
		project_id,
		MAX(repaid_amount) AS repaid_amount,
		MAX(principal_amount) AS principal_amount
	FROM banking2011to2025
	WHERE 
		repaid_amount IS NOT NULL
		AND principal_amount IS NOT NULL
		AND financial_instrument='credit'
	GROUP BY project_id
)
SELECT 
	ROUND(AVG(ISNULL(repaid_amount/NULLIF(principal_amount ,0),0)),2) AS repayment_to_commitment_ratio
FROM uniqueProjects;

----- REGION -----
-- Credits Repayment to Commitment Ratio by Region
WITH uniqueProjects AS
(
	SELECT 
		project_id,
		region,
		MAX(repaid_amount) AS repaid_amount,
		MAX(principal_amount) AS principal_amount
	FROM banking2011to2025
	WHERE 
		repaid_amount IS NOT NULL
		AND principal_amount IS NOT NULL
		AND financial_instrument='credit'
	GROUP BY project_id,region
)
SELECT
	region,
	ROUND(AVG(ISNULL(repaid_amount/NULLIF(principal_amount ,0),0)),2) AS repayment_to_commitment_ratio
FROM uniqueProjects
GROUP BY region;


----- COUNTRY -----
-- Top Repayment to Commitment Ratio
WITH uniqueProjects AS
(
	SELECT 
		project_id,
		country,
		MAX(repaid_amount) AS repaid_amount,
		MAX(principal_amount) AS principal_amount
	FROM banking2011to2025
	WHERE 
		repaid_amount IS NOT NULL
		AND principal_amount IS NOT NULL
		AND financial_instrument='credit'
	GROUP BY project_id,country
)
SELECT
	country,
	ROUND(AVG(ISNULL(repaid_amount/NULLIF(principal_amount ,0),0)),2) AS repayment_to_commitment_ratio
FROM uniqueProjects
GROUP BY country
ORDER BY ROUND(AVG(ISNULL(repaid_amount/NULLIF(principal_amount ,0),0)),2) DESC;

-- Bottom Repayment to Commitment Ratio
WITH uniqueProjects AS
(
	SELECT 
		project_id,
		country,
		MAX(repaid_amount) AS repaid_amount,
		MAX(principal_amount) AS principal_amount
	FROM banking2011to2025
	WHERE 
		repaid_amount IS NOT NULL
		AND principal_amount IS NOT NULL
		AND financial_instrument='credit'
	GROUP BY project_id,country
)
SELECT
	country,
	ROUND(AVG(ISNULL(repaid_amount/NULLIF(principal_amount ,0),0)),2) AS repayment_to_commitment_ratio
FROM uniqueProjects
GROUP BY country
ORDER BY ROUND(AVG(ISNULL(repaid_amount/NULLIF(principal_amount ,0),0)),2);





