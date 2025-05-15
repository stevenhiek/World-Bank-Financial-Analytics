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
WITH instrumentTotals AS (
	SELECT 
		financial_instrument,
		ROUND(SUM(principal_amount),0) AS total_principal_amount
	FROM banking
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
WITH regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(principal_amount),0) AS total_principal_amount
	FROM banking
	GROUP BY 
		region
)
SELECT 
	region,
	total_principal_amount,
	ROUND(100.0 * total_principal_amount / SUM(total_principal_amount) OVER(),2) AS percent_total
FROM regionTotals
ORDER BY total_principal_amount DESC;

-- Most Credit Funded by Region
WITH regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE financial_instrument='credit'
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
WITH regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE 
		financial_instrument='grant'
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
WITH regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE 
		financial_instrument='guarantee'
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
WITH countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(principal_amount),0) AS total_principal_amount
	FROM banking
	GROUP BY 
		country
)
SELECT 
	country,
	total_principal_amount,
	ROUND(100.0 * total_principal_amount / SUM(total_principal_amount) OVER(),2) AS percent_total
FROM countryTotals
ORDER BY total_principal_amount DESC;

-- Most Credits Funded by Country
WITH countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE financial_instrument='credit'
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
WITH countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE financial_instrument='grant'
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
WITH countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(principal_amount),0) AS total_principal_amount
	FROM banking
	WHERE financial_instrument='guarantee'
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
WITH yearlyFunding AS 
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		ROUND(SUM(principal_amount),0) AS total_funding
	FROM banking
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY YEAR(board_approval_date)
)
SELECT 
	funding_year,
	total_funding,
	ISNULL(ROUND(100.0 * (total_funding - LAG(total_funding) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(total_funding) OVER (ORDER BY funding_year),0), 1),0) AS percent_change
FROM yearlyFunding
ORDER BY funding_year ASC;

-- Overall Credit Funding Over Time
WITH yearlyFunding AS 
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		ROUND(SUM(principal_amount),0) AS total_funding
	FROM banking
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument='credit'
	GROUP BY YEAR(board_approval_date)
)
SELECT 
	funding_year,
	total_funding,
	ISNULL(ROUND(100.0 * (total_funding - LAG(total_funding) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(total_funding) OVER (ORDER BY funding_year),0), 1),0) AS percent_change
FROM yearlyFunding
ORDER BY funding_year ASC;

-- Overall Grant Funding Over Time
WITH yearlyFunding AS 
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		ROUND(SUM(principal_amount),0) AS total_funding
	FROM banking
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument='grant'
	GROUP BY YEAR(board_approval_date)
)
SELECT 
	funding_year,
	total_funding,
	ISNULL(ROUND(100.0 * (total_funding - LAG(total_funding) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(total_funding) OVER (ORDER BY funding_year),0), 1),0) AS percent_change
FROM yearlyFunding
ORDER BY funding_year ASC;

-- Overall Guarantee Funding Over Time
WITH yearlyFunding AS 
(
	SELECT 
		YEAR(board_approval_date) AS funding_year,
		ROUND(SUM(principal_amount),0) AS total_funding
	FROM banking
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument='guarantee'
	GROUP BY YEAR(board_approval_date)
)
SELECT 
	funding_year,
	total_funding,
	ISNULL(ROUND(100.0 * (total_funding - LAG(total_funding) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(total_funding) OVER (ORDER BY funding_year),0), 1),0) AS percent_change
FROM yearlyFunding
ORDER BY funding_year ASC;


----- REGION
-- Overall Funding by Region Over Time
WITH yearlyFunding AS 
(
	SELECT 
		region,
		YEAR(board_approval_date) AS funding_year,
		ROUND(SUM(principal_amount),0) AS total_funding
	FROM banking
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		YEAR(board_approval_date),
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

-- Credit Funding by Region Over Time
WITH yearlyFunding AS 
(
	SELECT 
		region,
		YEAR(board_approval_date) AS funding_year,
		ROUND(SUM(principal_amount),0) AS total_funding
	FROM banking
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument='credit'
	GROUP BY 
		YEAR(board_approval_date),
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

-- Grant Funding by Region Over Time
WITH yearlyFunding AS 
(
	SELECT 
		region,
		YEAR(board_approval_date) AS funding_year,
		ROUND(SUM(principal_amount),0) AS total_funding
	FROM banking
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument='grant'
	GROUP BY 
		YEAR(board_approval_date),
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

-- Guarantee Funding by Region Over Time
WITH yearlyFunding AS 
(
	SELECT 
		region,
		YEAR(board_approval_date) AS funding_year,
		ROUND(SUM(principal_amount),0) AS total_funding
	FROM banking
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND financial_instrument='guarantee'
	GROUP BY 
		YEAR(board_approval_date),
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
WITH yearlyFunding AS 
(
	SELECT 
		country,
		YEAR(board_approval_date) AS funding_year,
		ROUND(SUM(principal_amount),0) AS total_funding
	FROM banking
	WHERE 
		board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
	GROUP BY 
		YEAR(board_approval_date),
		country
)
SELECT 
	funding_year,
	SUM(CASE WHEN country='bangladesh' THEN total_funding ELSE 0 END) AS bangladesh,
	SUM(CASE WHEN country='nigeria' THEN total_funding ELSE 0 END) AS nigeria,
	SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END) AS pakistan,
	SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END) AS ethiopia,
	SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END) AS kenya,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='bangladesh' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='bangladesh' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='bangladesh' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS bangladesh_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='nigeria' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='nigeria' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='nigeria' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS nigeria_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS pakistan_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS ethiopia_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS kenya_pct_chg
FROM yearlyFunding
GROUP BY funding_year
ORDER BY funding_year ASC;

-- Credit Funding by Top 5 Countries Over Time
WITH yearlyFunding AS 
(
	SELECT 
		country,
		YEAR(board_approval_date) AS funding_year,
		ROUND(SUM(principal_amount),0) AS total_funding
	FROM banking
	WHERE 
		financial_instrument = 'credit'
		AND board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND country in ('bangladesh','nigeria','ethiopia','pakistan','kenya')
	GROUP BY 
		YEAR(board_approval_date),
		country
)
SELECT 
	funding_year,
	SUM(CASE WHEN country='bangladesh' THEN total_funding ELSE 0 END) AS bangladesh,
	SUM(CASE WHEN country='nigeria' THEN total_funding ELSE 0 END) AS nigeria,
    SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END) AS pakistan,
	SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END) AS ethiopia,
	SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END) AS kenya,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='bangladesh' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='bangladesh' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='bangladesh' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS bangladesh_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='nigeria' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='nigeria' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='nigeria' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS nigeria_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='pakistan' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS pakistan_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS ethiopia_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS kenya_pct_chg
FROM yearlyFunding
GROUP BY funding_year
ORDER BY funding_year ASC;

-- Grant Funding by Top 5 Countries Over Time
WITH yearlyFunding AS 
(
	SELECT 
		country,
		YEAR(board_approval_date) AS funding_year,
		ROUND(SUM(principal_amount),0) AS total_funding
	FROM banking
	WHERE 
		financial_instrument = 'grant'
		AND board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND country in ('mozambique','ethiopia','afghanistan','congo','chad')
	GROUP BY 
		YEAR(board_approval_date),
		country
)
SELECT      
	funding_year,
	SUM(CASE WHEN country='mozambique' THEN total_funding ELSE 0 END) AS mozambique,
	SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END) AS ethiopia,
	SUM(CASE WHEN country='afghanistan' THEN total_funding ELSE 0 END) AS afghanistan,
	SUM(CASE WHEN country='congo' THEN total_funding ELSE 0 END) AS congo,
	SUM(CASE WHEN country='chad' THEN total_funding ELSE 0 END) AS chad,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='mozambique' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='mozambique' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='mozambique' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS mozambique_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='ethiopia' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS ethiopia_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='afghanistan' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='afghanistan' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='afghanistan' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS afghanistan_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='congo' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='congo' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='congo' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS congo_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='chad' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='chad' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='chad' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS chad_pct_chg
FROM yearlyFunding
GROUP BY funding_year
ORDER BY funding_year ASC;

-- Guarantee Funding by Top 5 Countries Over Time
WITH yearlyFunding AS 
(
	SELECT 
		country,
		YEAR(board_approval_date) AS funding_year,
		ROUND(SUM(principal_amount),0) AS total_funding
	FROM banking
	WHERE 
		financial_instrument = 'guarantee'
		AND board_approval_date IS NOT NULL
		AND YEAR(board_approval_date) BETWEEN 2011 AND 2025
		AND country in ('ghana','cote d''ivoire','benin','kenya','cameroon')
	GROUP BY 
		YEAR(board_approval_date),
		country
)
SELECT    
	funding_year,
	SUM(CASE WHEN country='ghana' THEN total_funding ELSE 0 END) AS ghana,
	SUM(CASE WHEN country='cote d''ivoire' THEN total_funding ELSE 0 END) AS cote_divoire,
	SUM(CASE WHEN country='benin' THEN total_funding ELSE 0 END) AS benin,
	SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END) AS kenya,
	SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END) AS kenya,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='ghana' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='ghana' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='ghana' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS ghana_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='cote d''ivoire' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='cote d''ivoire' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='cote d''ivoire' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS cote_divoire_pct_chg,	
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='benin' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='benin' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='benin' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS benin_pct_chg,	
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='kenya' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS kenya_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='cameroon' THEN total_funding ELSE 0 END) - LAG(SUM(CASE WHEN country='cameroon' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='cameroon' THEN total_funding ELSE 0 END)) OVER (ORDER BY funding_year),0), 1),0) AS cameroon_pct_chg
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
WITH instrumentTotals AS (
	SELECT 
		financial_instrument,
		ROUND(SUM(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
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
WITH regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	GROUP BY 
		region
)
SELECT 
	region,
	total_disbursed_amount,
	ROUND(100.0 * total_disbursed_amount / SUM(total_disbursed_amount) OVER(),2) AS percent_total
FROM regionTotals
ORDER BY total_disbursed_amount DESC;

-- Most Credit Disbursed by Region
WITH regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE financial_instrument='credit'
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
WITH regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE financial_instrument='grant'
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
WITH regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE financial_instrument='guarantee'
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
WITH countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	GROUP BY 
		country
)
SELECT 
	country,
	total_disbursed_amount,
	ROUND(100.0 * total_disbursed_amount / SUM(total_disbursed_amount) OVER(),2) AS percent_total
FROM countryTotals
ORDER BY total_disbursed_amount DESC;

-- Most Credits Disbursed by Country
WITH countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE financial_instrument='credit'
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
WITH countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE financial_instrument='grant'
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
WITH countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(disbursed_amount),0) AS total_disbursed_amount
	FROM banking
	WHERE financial_instrument='guarantee'
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
WITH instrumentTotals AS (
	SELECT 
		financial_instrument,
		ROUND(SUM(repaid_amount),0) AS total_repaid_amount
	FROM banking
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
WITH regionTotals AS
(
	SELECT 
		region,
		ROUND(SUM(repaid_amount),0) AS total_repaid_amount
	FROM banking
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
WITH countryTotals AS
(
	SELECT 
		country,
		ROUND(SUM(repaid_amount),0) AS total_repaid_amount
	FROM banking
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
		project_id,
		YEAR(period_end_date) AS disbursement_year,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM bankingall
	GROUP BY 
		project_id,
		YEAR(period_end_date)
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
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM bankingall
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument = 'credit'
	GROUP BY 
		YEAR(period_end_date),
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
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM bankingall
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument = 'grant'
	GROUP BY 
		YEAR(period_end_date),
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
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM bankingall
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument = 'guarantee'
	GROUP BY 
		YEAR(period_end_date),
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
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		region,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM bankingall
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY 
		YEAR(period_end_date),
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
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		region,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM bankingall
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='credit'
	GROUP BY 
		YEAR(period_end_date),
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
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		region,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM bankingall
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument='grant'
	GROUP BY 
		YEAR(period_end_date),
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
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		region,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM bankingall
	WHERE period_end_date IS NOT NULL
		AND (YEAR(period_end_date) BETWEEN 2011 AND 2025)
		AND financial_instrument='guarantee'
	GROUP BY 
		YEAR(period_end_date),
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
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		country,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM bankingall
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND country in ('bangladesh','nigeria','ethiopia','pakistan','tanzania')
	GROUP BY 
		YEAR(period_end_date),
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
	SUM(CASE WHEN country='tanzania' THEN total_disbursement ELSE 0 END) AS tanzania,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='bangladesh' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='bangladesh' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='bangladesh' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS bangladesh_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS nigeria_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS ethiopia_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS pakistan_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='tanzania' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='tanzania' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='tanzania' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS tanzania_pct_chg
FROM yearlyDisbursement
GROUP BY disbursement_year
ORDER BY disbursement_year ASC;

-- Credit Disbursement by Top 5 Countries Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		country,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM bankingall
	WHERE 
		financial_instrument = 'credit'
		AND period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND country in ('bangladesh','nigeria','ethiopia','pakistan','tanzania')
	GROUP BY 
		YEAR(period_end_date),
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
	SUM(CASE WHEN country='tanzania' THEN total_disbursement ELSE 0 END) AS tanzania,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='bangladesh' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='bangladesh' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='bangladesh' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS bangladesh_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS nigeria_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS ethiopia_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS pakistan_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='tanzania' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='tanzania' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='tanzania' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS tanzania_pct_chg
FROM yearlyDisbursement
GROUP BY disbursement_year
ORDER BY disbursement_year ASC;

-- Grant Disbursement by Top 5 Countries Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		country,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM bankingall
	WHERE 
		financial_instrument = 'grant'
		AND period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND country in ('ethiopia','mozambique','chad','burundi','afghanistan')
	GROUP BY 
		YEAR(period_end_date),
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
	SUM(CASE WHEN country='burundi' THEN total_disbursement ELSE 0 END) AS burundi,
	SUM(CASE WHEN country='afghanistan' THEN total_disbursement ELSE 0 END) AS afghanistan,
	SUM(CASE WHEN country='chad' THEN total_disbursement ELSE 0 END) AS chad,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='ethiopia' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS ethiopia_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='mozambique' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='mozambique' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='mozambique' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS mozambique_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='burundi' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='burundi' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='burundi' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS burundi_pct_chg,
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
		YEAR(period_end_date) AS disbursement_year,
		project_id,
		country,
		ROUND(MAX(disbursed_amount),0) AS total_disbursed_amount
	FROM bankingall
	WHERE 
		financial_instrument = 'guarantee'
		AND period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND country in ('pakistan','ghana','nigeria','benin','cote d''ivoire')
	GROUP BY 
		YEAR(period_end_date),
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
	SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END) AS nigeria,
	SUM(CASE WHEN country='benin' THEN total_disbursement ELSE 0 END) AS benin,
	SUM(CASE WHEN country='cote d''ivoire' THEN total_disbursement ELSE 0 END) AS cote_divoire,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='pakistan' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS pakistan_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='ghana' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='ghana' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='ghana' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS ghana_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='nigeria' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS nigeria_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='benin' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='benin' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='benin' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS benin_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='cote d''ivoire' THEN total_disbursement ELSE 0 END) - LAG(SUM(CASE WHEN country='cote d''ivoire' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='cote d''ivoire' THEN total_disbursement ELSE 0 END)) OVER (ORDER BY disbursement_year),0), 1),0) AS cote_divoire_pct_chg
FROM yearlyDisbursement
GROUP BY disbursement_year
ORDER BY disbursement_year ASC;

/* REPAYMENT */
----- OVERALL
-- Overall Repayment Over Time 
WITH uniqueProjects AS
(
	SELECT 
		project_id,
		YEAR(period_end_date) AS repayment_year,
		ROUND(MAX(repaid_amount),0) AS total_repaid_amount
	FROM bankingall
	GROUP BY 
		project_id,
		YEAR(period_end_date)
),
yearlyrepayment AS 
(
	SELECT 
		repayment_year,
		SUM(total_repaid_amount) AS total_repayment
	FROM uniqueProjects
	GROUP BY repayment_year
)
SELECT 
	repayment_year,
	total_repayment,
	ISNULL(ROUND(100.0 * (total_repayment - LAG(total_repayment) OVER (ORDER BY repayment_year)) 
        / NULLIF(LAG(total_repayment) OVER (ORDER BY repayment_year),0), 1),0) AS percent_change
FROM yearlyrepayment
ORDER BY repayment_year ASC;

-- Overall Credit Repayment Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(period_end_date) AS repayment_year,
		project_id,
		ROUND(MAX(repaid_amount),0) AS total_repaid_amount
	FROM bankingall
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND financial_instrument = 'credit'
	GROUP BY 
		YEAR(period_end_date),
		project_id
),
yearlyrepayment AS 
(
	SELECT 
		repayment_year,
		SUM(total_repaid_amount) AS total_repayment
	FROM uniqueProjects
	GROUP BY repayment_year
)
SELECT 
	repayment_year,
	total_repayment,
	ISNULL(ROUND(100.0 * (total_repayment - LAG(total_repayment) OVER (ORDER BY repayment_year)) 
        / NULLIF(LAG(total_repayment) OVER (ORDER BY repayment_year),0), 1),0) AS percent_change
FROM yearlyrepayment
ORDER BY repayment_year ASC;

----- REGION
-- Repayment by Region Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(period_end_date) AS repayment_year,
		project_id,
		region,
		ROUND(MAX(repaid_amount),0) AS total_repaid_amount
	FROM bankingall
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
	GROUP BY 
		YEAR(period_end_date),
		project_id,
		region
),
yearlyrepayment AS 
(
	SELECT 
		repayment_year,
		region,
		SUM(total_repaid_amount) AS total_repayment
	FROM uniqueProjects
	GROUP BY 
		repayment_year,
		region
)
SELECT 
	repayment_year,
	SUM(CASE WHEN region='east asia and pacific' THEN total_repayment ELSE 0 END) AS east_asia_and_pacific,
	SUM(CASE WHEN region='europe and central asia' THEN total_repayment ELSE 0 END) AS europe_and_central_asia,
	SUM(CASE WHEN region='latin america and caribbean' THEN total_repayment ELSE 0 END) AS latin_america_and_caribbean,
	SUM(CASE WHEN region='middle east and africa' THEN total_repayment ELSE 0 END) AS middle_east_and_africa,
	SUM(CASE WHEN region='south asia' THEN total_repayment ELSE 0 END) AS south_asia,
	SUM(CASE WHEN region='other' THEN total_repayment ELSE 0 END) AS other,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='east asia and pacific' THEN total_repayment ELSE 0 END) - LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='east asia and pacific' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year),0), 1),0) AS eap_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='europe and central asia' THEN total_repayment ELSE 0 END) - LAG(SUM(CASE WHEN region='europe and central asia' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='europe and central asia' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year),0), 1),0) AS eca_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='latin america and caribbean' THEN total_repayment ELSE 0 END) - LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='latin america and caribbean' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year),0), 1),0) AS lac_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='middle east and africa' THEN total_repayment ELSE 0 END) - LAG(SUM(CASE WHEN region='middle east and africa' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='middle east and africa' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year),0), 1),0) AS mea_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN region='south asia' THEN total_repayment ELSE 0 END) - LAG(SUM(CASE WHEN region='south asia' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year)) 
        / NULLIF(LAG(SUM(CASE WHEN region='south asia' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year),0), 1),0) AS sa_pct_chg
FROM yearlyrepayment
GROUP BY repayment_year
ORDER BY repayment_year ASC;

----- COUNTRY
-- Repayment by Top 5 Countries Over Time
WITH uniqueProjects AS
(
	SELECT 
		YEAR(period_end_date) AS repayment_year,
		project_id,
		country,
		ROUND(MAX(repaid_amount),0) AS total_repaid_amount
	FROM bankingall
	WHERE period_end_date IS NOT NULL
		AND YEAR(period_end_date) BETWEEN 2011 AND 2025
		AND country in ('bangladesh','india','china','pakistan','vietnam')
	GROUP BY 
		YEAR(period_end_date),
		project_id,
		country
),
yearlyrepayment AS 
(
	SELECT 
		repayment_year,
		country,
		SUM(total_repaid_amount) AS total_repayment
	FROM uniqueProjects
	GROUP BY 
		repayment_year,
		country
)
SELECT 
	repayment_year,
	SUM(CASE WHEN country='bangladesh' THEN total_repayment ELSE 0 END) AS bangladesh,
	SUM(CASE WHEN country='india' THEN total_repayment ELSE 0 END) AS india,
	SUM(CASE WHEN country='china' THEN total_repayment ELSE 0 END) AS china,
	SUM(CASE WHEN country='pakistan' THEN total_repayment ELSE 0 END) AS pakistan,
	SUM(CASE WHEN country='vietnam' THEN total_repayment ELSE 0 END) AS vietnam,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='bangladesh' THEN total_repayment ELSE 0 END) - LAG(SUM(CASE WHEN country='bangladesh' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='bangladesh' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year),0), 1),0) AS bangladesh_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='india' THEN total_repayment ELSE 0 END) - LAG(SUM(CASE WHEN country='india' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='india' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year),0), 1),0) AS india_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='china' THEN total_repayment ELSE 0 END) - LAG(SUM(CASE WHEN country='china' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='china' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year),0), 1),0) AS china_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='pakistan' THEN total_repayment ELSE 0 END) - LAG(SUM(CASE WHEN country='pakistan' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='pakistan' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year),0), 1),0) AS pakistan_pct_chg,
	ISNULL(ROUND(100.0 * (SUM(CASE WHEN country='vietnam' THEN total_repayment ELSE 0 END) - LAG(SUM(CASE WHEN country='vietnam' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year)) 
        / NULLIF(LAG(SUM(CASE WHEN country='vietnam' THEN total_repayment ELSE 0 END)) OVER (ORDER BY repayment_year),0), 1),0) AS vietnam_pct_chg
FROM yearlyrepayment
GROUP BY repayment_year
ORDER BY repayment_year ASC;


----------------------------------------------------------------------
/* 4. How long do projects typically take from approval to closing? */
----------------------------------------------------------------------





-------------------------------------------------------------
/* 5. What proportion of credit is undisbursed vs. repaid? */
-------------------------------------------------------------











