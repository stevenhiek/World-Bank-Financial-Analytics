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
5. What proportion of credit is undisbursed vs. repaid?
------------------------------------------------------------------------
*/

--------------------------------------------------------------------------------------
/* 1. Which regions or countries received the most credits, grants, and guarantees?  */
--------------------------------------------------------------------------------------
----- OVERALL
-- Total Principal Amount by Financial Instruments
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		financial_instrument,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		financial_instrument
),
instrumentTotals AS (
	SELECT 
		financial_instrument,
		SUM(total_principal_amount) AS total_principal_amount
	FROM uniqueProjects
	GROUP BY financial_instrument
)
SELECT 
	financial_instrument,
	total_principal_amount,
	ROUND(100.0 * total_principal_amount / SUM(total_principal_amount) OVER (), 2) AS percent_of_total
FROM instrumentTotals
ORDER BY total_principal_amount DESC;

----- REGION
-- Most Funded by Region
WITH uniqueProjects AS
(
	SELECT
		project_id,
		region,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		region
),
regionTotals AS
(
	SELECT 
		region,
		SUM(total_principal_amount) AS total_principal_amount
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

-- Most Funded Region by Financial Instrument
WITH uniqueProjects AS
(
	SELECT
		project_id,
		region,
		financial_instrument,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		region,
		financial_instrument
),
regionTotals AS
(
	SELECT 
		region,
		financial_instrument,
		SUM(total_principal_amount) AS total_principal_amount
	FROM uniqueProjects
	GROUP BY 
		region,
		financial_instrument
)
SELECT 
	region,
	financial_instrument,
	total_principal_amount,
	ROUND(100.0 * total_principal_amount / SUM(total_principal_amount) OVER(),2) AS percent_total
FROM regionTotals
ORDER BY total_principal_amount DESC;

-- Most Credit Funded by Region
WITH uniqueProjects AS
(
	SELECT
		project_id,
		region,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE 
		financial_instrument='credit'
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		region
),
regionTotals AS
(
	SELECT 
		region,
		SUM(total_principal_amount) AS total_principal_amount
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

-- Most Grant Funded by Region
WITH uniqueProjects AS
(
	SELECT
		project_id,
		region,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE 
		financial_instrument='grant'
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		region
),
regionTotals AS
(
	SELECT 
		region,
		SUM(total_principal_amount) AS total_principal_amount
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

-- Most Guarantee Funded by Region
WITH uniqueProjects AS
(
	SELECT
		project_id,
		region,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE 
		financial_instrument='guarantee'
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		region
),
regionTotals AS
(
	SELECT 
		region,
		SUM(total_principal_amount) AS total_principal_amount
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

----- COUNTRY
-- Most Funded by Country
WITH uniqueProjects AS
(
	SELECT
		project_id,
		country,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		country
),
countryTotals AS
(
	SELECT 
		country,
		SUM(total_principal_amount) AS total_principal_amount
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

-- Most Funded Country by Financial Instrument
WITH uniqueProjects AS
(
	SELECT
		project_id,
		country,
		financial_instrument,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		country,
		financial_instrument
),
countryTotals AS
(
	SELECT 
		country,
		financial_instrument,
		SUM(total_principal_amount) AS total_principal_amount
	FROM uniqueProjects
	GROUP BY 
		country,
		financial_instrument
)
SELECT 
	country,
	financial_instrument,
	total_principal_amount,
	ROUND(100.0 * total_principal_amount / SUM(total_principal_amount) OVER(),2) AS percent_total
FROM countryTotals
ORDER BY total_principal_amount DESC;

-- Most Credits Funded by Country
WITH uniqueProjects AS
(
	SELECT
		project_id,
		country,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE 
		financial_instrument='credit'
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		country
),
countryTotals AS
(
	SELECT 
		country,
		SUM(total_principal_amount) AS total_principal_amount
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

-- Most Grant Funded by Country
WITH uniqueProjects AS
(
	SELECT
		project_id,
		country,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE 
		financial_instrument='grant'
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		country
),
countryTotals AS
(
	SELECT 
		country,
		SUM(total_principal_amount) AS total_principal_amount
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

-- Most Guarantee Funded by Country
WITH uniqueProjects AS
(
	SELECT
		project_id,
		country,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE 
		financial_instrument='guarantee'
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		country
),
countryTotals AS
(
	SELECT 
		country,
		SUM(total_principal_amount) AS total_principal_amount
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


----------------------------------------------------------------------------
/* 2. Which regions or countries received the most IDA funding over time? */
----------------------------------------------------------------------------
/* Use board approval date to shown IDA commitment to funding over time */
----- OVERALL
-- Overall Funding Commitment Over Time 
WITH uniqueProjects AS
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		project_id,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		YEAR(board_approval_date),
		project_id
),
yearlyFunding AS 
(
	SELECT 
		funding_year,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY funding_year
)
SELECT 
	funding_year,
	total_funding,
	ROUND(100.0 * (total_funding - LAG(total_funding) OVER (ORDER BY funding_year)) 
        / LAG(total_funding) OVER (ORDER BY funding_year), 1) AS percent_change
FROM yearlyFunding
ORDER BY funding_year ASC;

-- Overall Credit Funding Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		project_id,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument = 'credit'
	GROUP BY 
		YEAR(board_approval_date),
		project_id
),
yearlyFunding AS 
(
	SELECT 
		funding_year,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY funding_year
)
SELECT 
	funding_year,
	total_funding,
	ROUND(100.0 * (total_funding - LAG(total_funding) OVER (ORDER BY funding_year)) 
        / LAG(total_funding) OVER (ORDER BY funding_year), 1) AS percent_change
FROM yearlyFunding
ORDER BY funding_year ASC;

-- Overall Grant Funding Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		project_id,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument = 'grant'
	GROUP BY 
		YEAR(board_approval_date),
		project_id
),
yearlyFunding AS 
(
	SELECT 
		funding_year,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY funding_year
)
SELECT 
	funding_year,
	total_funding,
	ROUND(100.0 * (total_funding - LAG(total_funding) OVER (ORDER BY funding_year)) 
        / LAG(total_funding) OVER (ORDER BY funding_year), 1) AS percent_change
FROM yearlyFunding
ORDER BY funding_year ASC;

-- Overall Guarantee Funding Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		project_id,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument = 'guarantee'
	GROUP BY 
		YEAR(board_approval_date),
		project_id
),
yearlyFunding AS 
(
	SELECT 
		funding_year,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY funding_year
)
SELECT 
	funding_year,
	total_funding,
	ROUND(100.0 * (total_funding - LAG(total_funding) OVER (ORDER BY funding_year)) 
        / LAG(total_funding) OVER (ORDER BY funding_year), 1) AS percent_change
FROM yearlyFunding
ORDER BY funding_year ASC;


----- REGION
-- Overall Funding by Region Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		project_id,
		region,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		YEAR(board_approval_date),
		project_id,
		region
),
yearlyFunding AS 
(
	SELECT 
		funding_year,
		region,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY 
		funding_year,
		region
)
SELECT 
	funding_year,
	SUM(CASE WHEN region='east asia and pacific' THEN total_funding ELSE 0 END) AS east_asia_and_pacific,
	SUM(CASE WHEN region='europe and central asia' THEN total_funding ELSE 0 END) AS europe_and_central_asia,
	SUM(CASE WHEN region='latin america and caribbean' THEN total_funding ELSE 0 END) AS latin_america_and_caribbean,
	SUM(CASE WHEN region='middle east and africa' THEN total_funding ELSE 0 END) AS middle_east_and_africa,
	SUM(CASE WHEN region='south asia' THEN total_funding ELSE 0 END) AS south_asia,
	SUM(CASE WHEN region='other' THEN total_funding ELSE 0 END) AS other,
	ROUND(100.0 * (SUM(CASE WHEN region='east asia and pacific' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS eap_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN region='europe and central asia' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='europe and central asia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN region='europe and central asia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS eca_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN region='latin america and caribbean' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS lac_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN region='middle east and africa' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='middle east and africa' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN region='middle east and africa' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS mea_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN region='south asia' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='south asia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN region='south asia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS sa_pct_chg
FROM yearlyFunding
GROUP BY funding_year
ORDER BY funding_year ASC;

-- Credit Funding by Region Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		project_id,
		region,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument='credit'
	GROUP BY 
		YEAR(board_approval_date),
		project_id,
		region
),
yearlyFunding AS 
(
	SELECT 
		funding_year,
		region,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY 
		funding_year,
		region
)
SELECT 
	funding_year,
	SUM(CASE WHEN region='east asia and pacific' THEN total_funding ELSE 0 END) AS east_asia_and_pacific,
	SUM(CASE WHEN region='europe and central asia' THEN total_funding ELSE 0 END) AS europe_and_central_asia,
	SUM(CASE WHEN region='latin america and caribbean' THEN total_funding ELSE 0 END) AS latin_america_and_caribbean,
	SUM(CASE WHEN region='middle east and africa' THEN total_funding ELSE 0 END) AS middle_east_and_africa,
	SUM(CASE WHEN region='south asia' THEN total_funding ELSE 0 END) AS south_asia,
	SUM(CASE WHEN region='other' THEN total_funding ELSE 0 END) AS other,
	ROUND(100.0 * (SUM(CASE WHEN region='east asia and pacific' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS eap_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN region='europe and central asia' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='europe and central asia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN region='europe and central asia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS eca_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN region='latin america and caribbean' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS lac_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN region='middle east and africa' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='middle east and africa' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN region='middle east and africa' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS mea_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN region='south asia' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='south asia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN region='south asia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS sa_pct_chg
FROM yearlyFunding
GROUP BY funding_year
ORDER BY funding_year ASC;

-- Grant Funding by Region Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		project_id,
		region,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument='grant'
	GROUP BY 
		YEAR(board_approval_date),
		project_id,
		region
),
yearlyFunding AS 
(
	SELECT 
		funding_year,
		region,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY 
		funding_year,
		region
)
SELECT 
	funding_year,
	SUM(CASE WHEN region='east asia and pacific' THEN total_funding ELSE 0 END) AS east_asia_and_pacific,
	SUM(CASE WHEN region='europe and central asia' THEN total_funding ELSE 0 END) AS europe_and_central_asia,
	SUM(CASE WHEN region='latin america and caribbean' THEN total_funding ELSE 0 END) AS latin_america_and_caribbean,
	SUM(CASE WHEN region='middle east and africa' THEN total_funding ELSE 0 END) AS middle_east_and_africa,
	SUM(CASE WHEN region='south asia' THEN total_funding ELSE 0 END) AS south_asia,
	SUM(CASE WHEN region='other' THEN total_funding ELSE 0 END) AS other,
	ROUND(100.0 * (SUM(CASE WHEN region='east asia and pacific' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS eap_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN region='europe and central asia' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='europe and central asia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN region='europe and central asia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS eca_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN region='latin america and caribbean' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS lac_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN region='middle east and africa' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='middle east and africa' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN region='middle east and africa' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS mea_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN region='south asia' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='south asia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN region='south asia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS sa_pct_chg
FROM yearlyFunding
GROUP BY funding_year
ORDER BY funding_year ASC;

-- Guarantee Funding by Region Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		project_id,
		region,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE board_approval_date IS NOT NULL
		AND (YEAR(board_approval_date) BETWEEN 2011 AND 2025)
		AND financial_instrument='guarantee'
	GROUP BY 
		YEAR(board_approval_date),
		project_id,
		region
),
yearlyFunding AS 
(
	SELECT 
		funding_year,
		region,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY 
		funding_year,
		region
)
SELECT 
	funding_year,
	SUM(CASE WHEN region='east asia and pacific' THEN total_funding ELSE 0 END) AS east_asia_and_pacific,
	SUM(CASE WHEN region='europe and central asia' THEN total_funding ELSE 0 END) AS europe_and_central_asia,
	SUM(CASE WHEN region='latin america and caribbean' THEN total_funding ELSE 0 END) AS latin_america_and_caribbean,
	SUM(CASE WHEN region='middle east and africa' THEN total_funding ELSE 0 END) AS middle_east_and_africa,
	SUM(CASE WHEN region='south asia' THEN total_funding ELSE 0 END) AS south_asia,
	SUM(CASE WHEN region='other' THEN total_funding ELSE 0 END) AS other,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='east asia and pacific' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS eap_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='europe and central asia' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='europe and central asia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='europe and central asia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS eca_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='latin america and caribbean' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS lac_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='middle east and africa' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='middle east and africa' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='middle east and africa' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS mea_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='south asia' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN region='south asia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='south asia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS sa_pct_chg
FROM yearlyFunding
GROUP BY funding_year
ORDER BY funding_year ASC;

----- COUNTRY
-- Overall Funding by Top 5 Countries Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		project_id,
		country,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND country in ('bangladesh','nigeria','ethiopia','pakistan','kenya')
	GROUP BY 
		YEAR(board_approval_date),
		project_id,
		country
),
yearlyFunding AS 
(
	SELECT 
		funding_year,
		country,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY 
		funding_year,
		country
)
SELECT 
	funding_year,
	SUM(CASE WHEN country='bangladesh' THEN total_funding ELSE 0 END) AS bangladesh,
	SUM(CASE WHEN country='nigeria' THEN total_funding ELSE 0 END) AS nigeria,
	SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END) AS ethiopia,
	SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END) AS pakistan,
	SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END) AS kenya,
	ROUND(100.0 * (SUM(CASE WHEN country='bangladesh' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='bangladesh' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN country='bangladesh' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS bangladesh_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN country='nigeria' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='nigeria' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN country='nigeria' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS nigeria_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS ethiopia_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS pakistan_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS kenya_pct_chg
FROM yearlyFunding
GROUP BY funding_year
ORDER BY funding_year ASC;

-- Credit Funding by Top 5 Countries Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		project_id,
		country,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE 
		financial_instrument = 'credit'
		AND board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND country in ('bangladesh','nigeria','ethiopia','pakistan','kenya')
	GROUP BY 
		YEAR(board_approval_date),
		project_id,
		country
),
yearlyFunding AS 
(
	SELECT 
		funding_year,
		country,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY 
		funding_year,
		country
)
SELECT 
	funding_year,
	SUM(CASE WHEN country='bangladesh' THEN total_funding ELSE 0 END) AS bangladesh,
	SUM(CASE WHEN country='nigeria' THEN total_funding ELSE 0 END) AS nigeria,
	SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END) AS ethiopia,
	SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END) AS pakistan,
	SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END) AS kenya,
	ROUND(100.0 * (SUM(CASE WHEN country='bangladesh' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='bangladesh' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN country='bangladesh' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS bangladesh_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN country='nigeria' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='nigeria' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN country='nigeria' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS nigeria_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS ethiopia_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS pakistan_pct_chg,
	ROUND(100.0 * (SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / LAG(SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year), 1) AS kenya_pct_chg
FROM yearlyFunding
GROUP BY funding_year
ORDER BY funding_year ASC;

-- Grant Funding by Top 5 Countries Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		project_id,
		country,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE 
		financial_instrument = 'grant'
		AND board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND country in ('ethiopia','mozambique','congo','afghanistan','chad')
	GROUP BY 
		YEAR(board_approval_date),
		project_id,
		country
),
yearlyFunding AS 
(
	SELECT 
		funding_year,
		country,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY 
		funding_year,
		country
)
SELECT      
	funding_year,
	SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END) AS ethiopia,
	SUM(CASE WHEN country='mozambique' THEN total_funding ELSE 0 END) AS mozambique,
	SUM(CASE WHEN country='congo' THEN total_funding ELSE 0 END) AS congo,
	SUM(CASE WHEN country='afghanistan' THEN total_funding ELSE 0 END) AS afghanistan,
	SUM(CASE WHEN country='chad' THEN total_funding ELSE 0 END) AS chad,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS ethiopia_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='mozambique' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='mozambique' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='mozambique' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS mozambique_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='congo' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='congo' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='congo' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS congo_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='afghanistan' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='afghanistan' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='afghanistan' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS afghanistan_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='chad' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='chad' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='chad' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS chad_pct_chg
FROM yearlyFunding
GROUP BY funding_year
ORDER BY funding_year ASC;

-- Guarantee Funding by Top 5 Countries Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		project_id,
		country,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE 
		financial_instrument = 'guarantee'
		AND board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND country in ('pakistan','ghana','kenya','benin','cote d''ivoire')
	GROUP BY 
		YEAR(board_approval_date),
		project_id,
		country
),
yearlyFunding AS 
(
	SELECT 
		funding_year,
		country,
		SUM(total_principal_amount) AS total_funding
	FROM uniqueProjects
	GROUP BY 
		funding_year,
		country
)
SELECT    
	funding_year,
	SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END) AS pakistan,
	SUM(CASE WHEN country='ghana' THEN total_funding ELSE 0 END) AS ghana,
	SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END) AS kenya,
	SUM(CASE WHEN country='benin' THEN total_funding ELSE 0 END) AS benin,
	SUM(CASE WHEN country='cote d''ivoire' THEN total_funding ELSE 0 END) AS cote_divoire,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS pakistan_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='ghana' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='ghana' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='ghana' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS ghana_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS kenya_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='benin' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='benin' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='benin' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS benin_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='cote d''ivoire' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='cote d''ivoire' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='cote d''ivoire' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS cote_divoire_pct_chg
FROM yearlyFunding
GROUP BY funding_year
ORDER BY funding_year ASC;

---------------------------------------------------------------------
/* 3. What are the trends in disbursement and repayment over time? */
---------------------------------------------------------------------
---------- TOTAL COUNTS ----------
/* DISBURSEMENT */
----- OVERALL
-- Total Disbursed Amount by Financial Instruments
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		financial_instrument,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		financial_instrument
),
instrumentTotals AS (
	SELECT 
		financial_instrument,
		SUM(total_disbursed_amount) AS total_disbursed_amount
	FROM uniqueProjects
	GROUP BY financial_instrument
)
SELECT 
	financial_instrument,
	total_disbursed_amount,
	ROUND(100.0 * total_disbursed_amount / SUM(total_disbursed_amount) OVER (), 2) AS percent_of_total
FROM instrumentTotals
ORDER BY total_disbursed_amount DESC;


----- REGION
-- Most Disbursed by Region
WITH uniqueProjects AS
(
	SELECT
		project_id,
		region,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		region
),
regionTotals AS
(
	SELECT 
		region,
		SUM(total_disbursed_amount) AS total_disbursed_amount
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

-- Most Disbursed Region by Financial Instrument
WITH uniqueProjects AS
(
	SELECT
		project_id,
		region,
		financial_instrument,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		region,
		financial_instrument
),
regionTotals AS
(
	SELECT 
		region,
		financial_instrument,
		SUM(total_disbursed_amount) AS total_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		region,
		financial_instrument
)
SELECT 
	region,
	financial_instrument,
	total_disbursed_amount,
	ROUND(100.0 * total_disbursed_amount / SUM(total_disbursed_amount) OVER(),2) AS percent_total
FROM regionTotals
ORDER BY total_disbursed_amount DESC;

-- Most Credit Disbursed by Region
WITH uniqueProjects AS
(
	SELECT
		project_id,
		region,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE 
		financial_instrument='credit'
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		region
),
regionTotals AS
(
	SELECT 
		region,
		SUM(total_disbursed_amount) AS total_disbursed_amount
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

-- Most Grant Disbursed by Region
WITH uniqueProjects AS
(
	SELECT
		project_id,
		region,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE 
		financial_instrument='grant'
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		region
),
regionTotals AS
(
	SELECT 
		region,
		SUM(total_disbursed_amount) AS total_disbursed_amount
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

-- Most Guarantee Disbursed by Region
WITH uniqueProjects AS
(
	SELECT
		project_id,
		region,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE 
		financial_instrument='guarantee'
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		region
),
regionTotals AS
(
	SELECT 
		region,
		SUM(total_disbursed_amount) AS total_disbursed_amount
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

----- COUNTRY
-- Most Disbursed by Country
WITH uniqueProjects AS
(
	SELECT
		project_id,
		country,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		country
),
countryTotals AS
(
	SELECT 
		country,
		SUM(total_disbursed_amount) AS total_disbursed_amount
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

-- Most Disbursed Country by Financial Instrument
WITH uniqueProjects AS
(
	SELECT
		project_id,
		country,
		financial_instrument,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		country,
		financial_instrument
),
countryTotals AS
(
	SELECT 
		country,
		financial_instrument,
		SUM(total_disbursed_amount) AS total_disbursed_amount
	FROM uniqueProjects
	GROUP BY 
		country,
		financial_instrument
)
SELECT 
	country,
	financial_instrument,
	total_disbursed_amount,
	ROUND(100.0 * total_disbursed_amount / SUM(total_disbursed_amount) OVER(),2) AS percent_total
FROM countryTotals
ORDER BY total_disbursed_amount DESC;

-- Most Credits Disbursed by Country
WITH uniqueProjects AS
(
	SELECT
		project_id,
		country,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE 
		financial_instrument='credit'
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		country
),
countryTotals AS
(
	SELECT 
		country,
		SUM(total_disbursed_amount) AS total_disbursed_amount
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

-- Most Grant Disbursed by Country
WITH uniqueProjects AS
(
	SELECT
		project_id,
		country,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE 
		financial_instrument='grant'
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		country
),
countryTotals AS
(
	SELECT 
		country,
		SUM(total_disbursed_amount) AS total_disbursed_amount
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

-- Most Guarantee Disbursed by Country
WITH uniqueProjects AS
(
	SELECT
		project_id,
		country,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE 
		financial_instrument='guarantee'
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		country
),
countryTotals AS
(
	SELECT 
		country,
		SUM(total_disbursed_amount) AS total_disbursed_amount
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

/* REPAYMENT */
----- OVERALL
-- Total Repaid Amount by Financial Instruments
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		financial_instrument,
		ROUND(MAX(repaid_amount),0) AS total_repaid_amount
	FROM banking
	WHERE YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		financial_instrument
),
instrumentTotals AS (
	SELECT 
		financial_instrument,
		SUM(total_repaid_amount) AS total_repaid_amount
	FROM uniqueProjects
	GROUP BY financial_instrument
)
SELECT 
	financial_instrument,
	total_repaid_amount,
	ROUND(100.0 * total_repaid_amount / SUM(total_repaid_amount) OVER (), 2) AS percent_of_total
FROM instrumentTotals
ORDER BY total_repaid_amount DESC;

----- REGION
-- Most Repaid by Region
WITH uniqueProjects AS
(
	SELECT
		project_id,
		region,
		ROUND(MAX(repaid_amount),0) AS total_repaid_amount
	FROM banking
	WHERE YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		region
),
regionTotals AS
(
	SELECT 
		region,
		SUM(total_repaid_amount) AS total_repaid_amount
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

----- COUNTRY
-- Most Repaid by Country
WITH uniqueProjects AS
(
	SELECT
		project_id,
		country,
		ROUND(MAX(repaid_amount),0) AS total_repaid_amount
	FROM banking
	WHERE YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		project_id,
		country
),
countryTotals AS
(
	SELECT 
		country,
		SUM(total_repaid_amount) AS total_repaid_amount
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


---------- TRENDS OVER TIME ----------
/* DISBURSEMENT */
----- OVERALL
-- Overall Disbursement Over Time 
WITH uniqueProjects AS
(
	SELECT 
		YEAR(latest_disbursement_date) AS disbursement_year,
		project_id,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE latest_disbursement_date IS NOT NULL
		AND YEAR(latest_disbursement_date) BETWEEN 2011 AND 2025
	GROUP BY 
		YEAR(latest_disbursement_date),
		project_id
),
yearlyDisbursement AS 
(
	SELECT 
		disbursement_year,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY disbursement_year
)
SELECT 
	disbursement_year,
	total_disbursement,
	ISNULL(ROUND(100.0 * (total_disbursement - LAG(total_disbursement) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(total_disbursement) OVER (ORDER BY disbursement_year),0), 1),0) AS percent_change
FROM yearlyDisbursement
ORDER BY disbursement_year ASC;

-- Overall Credit Disbursement Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(latest_disbursement_date) AS disbursement_year,
		project_id,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE latest_disbursement_date IS NOT NULL
		AND YEAR(latest_disbursement_date) BETWEEN 2011 AND 2025
		AND financial_instrument = 'credit'
	GROUP BY 
		YEAR(latest_disbursement_date),
		project_id
),
yearlyDisbursement AS 
(
	SELECT 
		disbursement_year,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY disbursement_year
)
SELECT 
	disbursement_year,
	total_disbursement,
	ISNULL(ROUND(100.0 * (total_disbursement - LAG(total_disbursement) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(total_disbursement) OVER (ORDER BY disbursement_year),0), 1),0) AS percent_change
FROM yearlyDisbursement
ORDER BY disbursement_year ASC;

-- Overall Grant Disbursement Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(latest_disbursement_date) AS disbursement_year,
		project_id,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE latest_disbursement_date IS NOT NULL
		AND YEAR(latest_disbursement_date) BETWEEN 2011 AND 2025
		AND financial_instrument = 'grant'
	GROUP BY 
		YEAR(latest_disbursement_date),
		project_id
),
yearlyDisbursement AS 
(
	SELECT 
		disbursement_year,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY disbursement_year
)
SELECT 
	disbursement_year,
	total_disbursement,
	ISNULL(ROUND(100.0 * (total_disbursement - LAG(total_disbursement) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(total_disbursement) OVER (ORDER BY disbursement_year),0), 1),0) AS percent_change
FROM yearlyDisbursement
ORDER BY disbursement_year ASC;

-- Overall Guarantee Disbursement Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(latest_disbursement_date) AS disbursement_year,
		project_id,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE latest_disbursement_date IS NOT NULL
		AND YEAR(latest_disbursement_date) BETWEEN 2011 AND 2025
		AND financial_instrument = 'guarantee'
	GROUP BY 
		YEAR(latest_disbursement_date),
		project_id
),
yearlyDisbursement AS 
(
	SELECT 
		disbursement_year,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY disbursement_year
)
SELECT 
	disbursement_year,
	total_disbursement,
	ISNULL(ROUND(100.0 * (total_disbursement - LAG(total_disbursement) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(total_disbursement) OVER (ORDER BY disbursement_year),0), 1),0) AS percent_change
FROM yearlyDisbursement
ORDER BY disbursement_year ASC;


----- REGION
-- Disbursement by Region Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(latest_disbursement_date) AS disbursement_year,
		project_id,
		region,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE latest_disbursement_date IS NOT NULL
		AND YEAR(latest_disbursement_date) BETWEEN 2011 AND 2025
	GROUP BY 
		YEAR(latest_disbursement_date),
		project_id,
		region
),
yearlyDisbursement AS 
(
	SELECT 
		disbursement_year,
		region,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY 
		disbursement_year,
		region
)
SELECT 
	disbursement_year,
	SUM(CASE WHEN region='east asia and pacific' THEN total_disbursement ELSE 0 END) AS east_asia_and_pacific,
	SUM(CASE WHEN region='europe and central asia' THEN total_disbursement ELSE 0 END) AS europe_and_central_asia,
	SUM(CASE WHEN region='latin america and caribbean' THEN total_disbursement ELSE 0 END) AS latin_america_and_caribbean,
	SUM(CASE WHEN region='middle east and africa' THEN total_disbursement ELSE 0 END) AS middle_east_and_africa,
	SUM(CASE WHEN region='south asia' THEN total_disbursement ELSE 0 END) AS south_asia,
	SUM(CASE WHEN region='other' THEN total_disbursement ELSE 0 END) AS other,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='east asia and pacific' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS eap_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='europe and central asia' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='europe and central asia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='europe and central asia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS eca_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='latin america and caribbean' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS lac_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='middle east and africa' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='middle east and africa' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='middle east and africa' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS mea_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='south asia' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='south asia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='south asia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS sa_pct_chg
FROM yearlyDisbursement
GROUP BY disbursement_year
ORDER BY disbursement_year ASC;

-- Credit Disbursement by Region Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(latest_disbursement_date) AS disbursement_year,
		project_id,
		region,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE latest_disbursement_date IS NOT NULL
		AND YEAR(latest_disbursement_date) BETWEEN 2011 AND 2025
		AND financial_instrument='credit'
	GROUP BY 
		YEAR(latest_disbursement_date),
		project_id,
		region
),
yearlyDisbursement AS 
(
	SELECT 
		disbursement_year,
		region,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY 
		disbursement_year,
		region
)
SELECT 
	disbursement_year,
	SUM(CASE WHEN region='east asia and pacific' THEN total_disbursement ELSE 0 END) AS east_asia_and_pacific,
	SUM(CASE WHEN region='europe and central asia' THEN total_disbursement ELSE 0 END) AS europe_and_central_asia,
	SUM(CASE WHEN region='latin america and caribbean' THEN total_disbursement ELSE 0 END) AS latin_america_and_caribbean,
	SUM(CASE WHEN region='middle east and africa' THEN total_disbursement ELSE 0 END) AS middle_east_and_africa,
	SUM(CASE WHEN region='south asia' THEN total_disbursement ELSE 0 END) AS south_asia,
	SUM(CASE WHEN region='other' THEN total_disbursement ELSE 0 END) AS other,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='east asia and pacific' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS eap_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='europe and central asia' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='europe and central asia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='europe and central asia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS eca_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='latin america and caribbean' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS lac_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='middle east and africa' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='middle east and africa' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='middle east and africa' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS mea_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='south asia' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='south asia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='south asia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS sa_pct_chg
FROM yearlyDisbursement
GROUP BY disbursement_year
ORDER BY disbursement_year ASC;

-- Grant Disbursement by Region Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(latest_disbursement_date) AS disbursement_year,
		project_id,
		region,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE latest_disbursement_date IS NOT NULL
		AND YEAR(latest_disbursement_date) BETWEEN 2011 AND 2025
		AND financial_instrument='grant'
	GROUP BY 
		YEAR(latest_disbursement_date),
		project_id,
		region
),
yearlyDisbursement AS 
(
	SELECT 
		disbursement_year,
		region,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY 
		disbursement_year,
		region
)
SELECT 
	disbursement_year,
	SUM(CASE WHEN region='east asia and pacific' THEN total_disbursement ELSE 0 END) AS east_asia_and_pacific,
	SUM(CASE WHEN region='europe and central asia' THEN total_disbursement ELSE 0 END) AS europe_and_central_asia,
	SUM(CASE WHEN region='latin america and caribbean' THEN total_disbursement ELSE 0 END) AS latin_america_and_caribbean,
	SUM(CASE WHEN region='middle east and africa' THEN total_disbursement ELSE 0 END) AS middle_east_and_africa,
	SUM(CASE WHEN region='south asia' THEN total_disbursement ELSE 0 END) AS south_asia,
	SUM(CASE WHEN region='other' THEN total_disbursement ELSE 0 END) AS other,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='east asia and pacific' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS eap_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='europe and central asia' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='europe and central asia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='europe and central asia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS eca_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='latin america and caribbean' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS lac_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='middle east and africa' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='middle east and africa' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='middle east and africa' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS mea_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='south asia' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='south asia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='south asia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS sa_pct_chg
FROM yearlyDisbursement
GROUP BY disbursement_year
ORDER BY disbursement_year ASC;

-- Guarantee Disbursement by Region Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(latest_disbursement_date) AS disbursement_year,
		project_id,
		region,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE latest_disbursement_date IS NOT NULL
		AND (YEAR(latest_disbursement_date) BETWEEN 2011 AND 2025)
		AND financial_instrument='guarantee'
	GROUP BY 
		YEAR(latest_disbursement_date),
		project_id,
		region
),
yearlyDisbursement AS 
(
	SELECT 
		disbursement_year,
		region,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY 
		disbursement_year,
		region
)
SELECT 
	disbursement_year,
	SUM(CASE WHEN region='east asia and pacific' THEN total_disbursement ELSE 0 END) AS east_asia_and_pacific,
	SUM(CASE WHEN region='europe and central asia' THEN total_disbursement ELSE 0 END) AS europe_and_central_asia,
	SUM(CASE WHEN region='latin america and caribbean' THEN total_disbursement ELSE 0 END) AS latin_america_and_caribbean,
	SUM(CASE WHEN region='middle east and africa' THEN total_disbursement ELSE 0 END) AS middle_east_and_africa,
	SUM(CASE WHEN region='south asia' THEN total_disbursement ELSE 0 END) AS south_asia,
	SUM(CASE WHEN region='other' THEN total_disbursement ELSE 0 END) AS other,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='east asia and pacific' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS eap_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='europe and central asia' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='europe and central asia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='europe and central asia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS eca_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='latin america and caribbean' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS lac_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='middle east and africa' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='middle east and africa' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='middle east and africa' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS mea_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='south asia' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN region='south asia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='south asia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS sa_pct_chg
FROM yearlyDisbursement
GROUP BY disbursement_year
ORDER BY disbursement_year ASC;

----- COUNTRY
-- Disbursement by Top 5 Countries Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(latest_disbursement_date) AS disbursement_year,
		project_id,
		country,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE latest_disbursement_date IS NOT NULL
		AND YEAR(latest_disbursement_date) BETWEEN 2011 AND 2025
		AND country in ('bangladesh','nigeria','ethiopia','pakistan','kenya')
	GROUP BY 
		YEAR(latest_disbursement_date),
		project_id,
		country
),
yearlyDisbursement AS 
(
	SELECT 
		disbursement_year,
		country,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY 
		disbursement_year,
		country
)
SELECT 
	disbursement_year,
	SUM(CASE WHEN country='bangladesh' THEN total_disbursement ELSE 0 END) AS bangladesh,
	SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END) AS nigeria,
	SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END) AS ethiopia,
	SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END) AS pakistan,
	SUM(CASE WHEN country='kenya' THEN total_disbursement ELSE 0 END) AS kenya,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='bangladesh' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='bangladesh' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='bangladesh' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS bangladesh_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS nigeria_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS ethiopia_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS pakistan_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='kenya' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='kenya' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='kenya' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS kenya_pct_chg
FROM yearlyDisbursement
GROUP BY disbursement_year
ORDER BY disbursement_year ASC;

-- Credit Disbursement by Top 5 Countries Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(latest_disbursement_date) AS disbursement_year,
		project_id,
		country,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE 
		financial_instrument = 'credit'
		AND latest_disbursement_date IS NOT NULL
		AND YEAR(latest_disbursement_date) BETWEEN 2011 AND 2025
		AND country in ('bangladesh','nigeria','ethiopia','pakistan','kenya')
	GROUP BY 
		YEAR(latest_disbursement_date),
		project_id,
		country
),
yearlyDisbursement AS 
(
	SELECT 
		disbursement_year,
		country,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY 
		disbursement_year,
		country
)
SELECT 
	disbursement_year,
	SUM(CASE WHEN country='bangladesh' THEN total_disbursement ELSE 0 END) AS bangladesh,
	SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END) AS nigeria,
	SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END) AS ethiopia,
	SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END) AS pakistan,
	SUM(CASE WHEN country='kenya' THEN total_disbursement ELSE 0 END) AS kenya,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='bangladesh' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='bangladesh' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='bangladesh' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS bangladesh_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS nigeria_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS ethiopia_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS pakistan_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='kenya' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='kenya' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='kenya' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS kenya_pct_chg
FROM yearlyDisbursement
GROUP BY disbursement_year
ORDER BY disbursement_year ASC;

-- Grant Disbursement by Top 5 Countries Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(latest_disbursement_date) AS disbursement_year,
		project_id,
		country,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE 
		financial_instrument = 'grant'
		AND latest_disbursement_date IS NOT NULL
		AND YEAR(latest_disbursement_date) BETWEEN 2011 AND 2025
		AND country in ('ethiopia','mozambique','congo','afghanistan','chad')
	GROUP BY 
		YEAR(latest_disbursement_date),
		project_id,
		country
),
yearlyDisbursement AS 
(
	SELECT 
		disbursement_year,
		country,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY 
		disbursement_year,
		country
)
SELECT      
	disbursement_year,
	SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END) AS ethiopia,
	SUM(CASE WHEN country='mozambique' THEN total_disbursement ELSE 0 END) AS mozambique,
	SUM(CASE WHEN country='congo' THEN total_disbursement ELSE 0 END) AS congo,
	SUM(CASE WHEN country='afghanistan' THEN total_disbursement ELSE 0 END) AS afghanistan,
	SUM(CASE WHEN country='chad' THEN total_disbursement ELSE 0 END) AS chad,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS ethiopia_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='mozambique' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='mozambique' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='mozambique' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS mozambique_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='congo' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='congo' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='congo' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS congo_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='afghanistan' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='afghanistan' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='afghanistan' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS afghanistan_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='chad' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='chad' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='chad' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS chad_pct_chg
FROM yearlyDisbursement
GROUP BY disbursement_year
ORDER BY disbursement_year ASC;

-- Guarantee Disbursement by Top 5 Countries Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(latest_disbursement_date) AS disbursement_year,
		project_id,
		country,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE 
		financial_instrument = 'guarantee'
		AND latest_disbursement_date IS NOT NULL
		AND YEAR(latest_disbursement_date) BETWEEN 2011 AND 2025
		AND country in ('pakistan','ghana','kenya','benin','cote d''ivoire')
	GROUP BY 
		YEAR(latest_disbursement_date),
		project_id,
		country
),
yearlyDisbursement AS 
(
	SELECT 
		disbursement_year,
		country,
		SUM(total_disbursed_amount) AS total_disbursement
	FROM uniqueProjects
	GROUP BY 
		disbursement_year,
		country
)
SELECT    
	disbursement_year,
	SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END) AS pakistan,
	SUM(CASE WHEN country='ghana' THEN total_disbursement ELSE 0 END) AS ghana,
	SUM(CASE WHEN country='kenya' THEN total_disbursement ELSE 0 END) AS kenya,
	SUM(CASE WHEN country='benin' THEN total_disbursement ELSE 0 END) AS benin,
	SUM(CASE WHEN country='cote d''ivoire' THEN total_disbursement ELSE 0 END) AS cote_divoire,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS pakistan_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='ghana' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='ghana' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='ghana' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS ghana_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='kenya' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='kenya' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='kenya' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS kenya_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='benin' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='benin' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='benin' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS benin_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='cote d''ivoire' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='cote d''ivoire' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='cote d''ivoire' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS cote_divoire_pct_chg
FROM yearlyDisbursement
GROUP BY disbursement_year
ORDER BY disbursement_year ASC;


----------------------------------------------------------------------
/* 4. How long do projects typically take from approval to closing? */
----------------------------------------------------------------------





-------------------------------------------------------------
/* 5. What proportion of credit is undisbursed vs. repaid? */
-------------------------------------------------------------











