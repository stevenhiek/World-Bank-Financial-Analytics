/*
------------------------------------------------------------------------
DATA ANALYSIS
- Data from April 2011 to April 2025; data as of April 30, 2025
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
		ROUND(SUM(principal_amount),0) AS total_principal_amount
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
-- Most Funded Region by Financial Instrument
WITH uniqueProjects AS
(
	SELECT
		project_id,
		region,
		financial_instrument,
		ROUND(SUM(principal_amount),0) AS total_principal_amount
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
		ROUND(SUM(principal_amount),0) AS total_principal_amount
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
		ROUND(SUM(principal_amount),0) AS total_principal_amount
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
		ROUND(SUM(principal_amount),0) AS total_principal_amount
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
-- Most Funded Country by Financial Instrument
WITH uniqueProjects AS
(
	SELECT
		project_id,
		country,
		financial_instrument,
		ROUND(SUM(principal_amount),0) AS total_principal_amount
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
		ROUND(SUM(principal_amount),0) AS total_principal_amount
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
		ROUND(SUM(principal_amount),0) AS total_principal_amount
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
		ROUND(SUM(principal_amount),0) AS total_principal_amount
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







