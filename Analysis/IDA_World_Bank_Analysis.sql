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
6. Are there observable trends that align with global events?
------------------------------------------------------------------------
*/

--------------------------------------------------------------------------------------
/* 1. Which regions or countries received the most credits, grants, and guarantees?  */
--------------------------------------------------------------------------------------
-- Total Principal Amount by Financial Instruments
WITH uniqueProjects AS 
(
	SELECT 
		project_id,
		financial_instrument,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
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
	WHERE financial_instrument='credit'
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
	WHERE financial_instrument='grant'
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
	WHERE financial_instrument='guarantee'
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
	WHERE financial_instrument='credit'
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
	WHERE financial_instrument='grant'
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

-- Most Gaurantee Funded by Country
WITH uniqueProjects AS
(
	SELECT
		project_id,
		country,
		ROUND(MAX(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE financial_instrument='guarantee'
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




---------------------------------------------------------------------
/* 3. What are the trends in disbursement and repayment over time? */
---------------------------------------------------------------------





----------------------------------------------------------------------
/* 4. How long do projects typically take from approval to closing? */
----------------------------------------------------------------------





-------------------------------------------------------------
/* 5. What proportion of credit is undisbursed vs. repaid? */
-------------------------------------------------------------




-------------------------------------------------------------------
/* 6. Are there observable trends that align with global events? */
-------------------------------------------------------------------







