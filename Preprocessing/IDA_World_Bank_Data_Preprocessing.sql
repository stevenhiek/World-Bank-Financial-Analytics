/*
------------------------------------------------------------------------
DATA PREPROCESSING
- Data from April 2011 to April 2025; data as of April 30, 2025

Steps:
1. Create Copy of Raw Table to Staging Table
2. Remove Duplicates
3. Standardize Data
4. Remove Unnecessary Rows & Columns
5. Finalize Data
------------------------------------------------------------------------
*/

-----------------------------
/* 1. Create Staging Table */
-----------------------------
SELECT *
INTO banking
FROM bank;

--------------------------
/* 2. Remove Duplicates */
--------------------------
-- Total Counts
SELECT COUNT(*)
FROM banking;


WITH duplicateRows AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                end_of_period, credit_number, region, country_code, country, borrower, credit_status, 
                service_charge_rate, currency_of_commitment, project_id, project_name, 
                original_principal_amount_us, cancelled_amount_us, undisbursed_amount_us, 
                repaid_to_ida_us, due_to_ida_us, exchange_adjustment_us, borrower_s_obligation_us, 
                sold_3rd_party_us, repaid_3rd_party_us, due_3rd_party_us, credits_held_us, 
                first_repayment_date, last_repayment_date, agreement_signing_date, 
                board_approval_date, effective_date_most_recent, closed_date_most_recent, 
                last_disbursement_date
            ORDER BY (SELECT NULL)
        ) AS rn
    FROM banking
)
DELETE FROM b
FROM banking AS b
JOIN duplicateRows AS d
  ON d.rn > 1
  AND d.end_of_period = b.end_of_period
  AND d.credit_number = b.credit_number
  AND d.region = b.region
  AND d.country_code = b.country_code
  AND d.country = b.country
  AND d.borrower = b.borrower
  AND d.credit_status = b.credit_status
  AND d.service_charge_rate = b.service_charge_rate
  AND d.currency_of_commitment = b.currency_of_commitment
  AND d.project_id = b.project_id
  AND d.project_name = b.project_name
  AND d.original_principal_amount_us = b.original_principal_amount_us
  AND d.cancelled_amount_us = b.cancelled_amount_us
  AND d.undisbursed_amount_us = b.undisbursed_amount_us
  AND d.repaid_to_ida_us = b.repaid_to_ida_us
  AND d.due_to_ida_us = b.due_to_ida_us
  AND d.exchange_adjustment_us = b.exchange_adjustment_us
  AND d.borrower_s_obligation_us = b.borrower_s_obligation_us
  AND d.sold_3rd_party_us = b.sold_3rd_party_us
  AND d.repaid_3rd_party_us = b.repaid_3rd_party_us
  AND d.due_3rd_party_us = b.due_3rd_party_us
  AND d.credits_held_us = b.credits_held_us
  AND d.first_repayment_date = b.first_repayment_date
  AND d.last_repayment_date = b.last_repayment_date
  AND d.agreement_signing_date = b.agreement_signing_date
  AND d.board_approval_date = b.board_approval_date
  AND d.effective_date_most_recent = b.effective_date_most_recent
  AND d.closed_date_most_recent = b.closed_date_most_recent
  AND d.last_disbursement_date = b.last_disbursement_date;

-------------------------
/* 3. Standardize Data */
-------------------------
-- Convert VARCHAR Columns to Float Columns that Should Be
ALTER TABLE banking 
ALTER COLUMN undisbursed_amount_us FLOAT;

ALTER TABLE banking 
ALTER COLUMN due_to_ida_us FLOAT;

ALTER TABLE banking 
ALTER COLUMN exchange_adjustment_us FLOAT;

ALTER TABLE banking 
ALTER COLUMN sold_3rd_party_us FLOAT;

ALTER TABLE banking 
ALTER COLUMN repaid_3rd_party_us FLOAT;

ALTER TABLE banking 
ALTER COLUMN due_3rd_party_us FLOAT;

ALTER TABLE banking 
ALTER COLUMN credits_held_us FLOAT;

-- Trim VARCHAR Columns
UPDATE banking
SET 
	credit_number = NULLIF(TRIM(credit_number), ''),
	region = NULLIF(TRIM(region), ''),
	country_code = NULLIF(TRIM(country_code), ''),
	country = NULLIF(TRIM(country), ''),
	borrower = NULLIF(TRIM(borrower), ''),
	credit_status = NULLIF(TRIM(credit_status), ''),
	currency_of_commitment = NULLIF(TRIM(currency_of_commitment), ''),
	project_id = NULLIF(TRIM(project_id), ''),
	project_name = NULLIF(TRIM(project_name), '');

-- Lowercase Specific VARCHAR Columns
UPDATE banking
SET 
	region = LOWER(region),
	country_code = LOWER(country_code),
	country = LOWER(country),
	borrower = LOWER(borrower),
	credit_status = LOWER(credit_status),
	currency_of_commitment = LOWER(currency_of_commitment),
	project_name = LOWER(project_name);

-- Standardize Column Category Values
----- Credit Number
SELECT DISTINCT credit_number
FROM banking 

SELECT 
	LEN(credit_number),
	COUNT(LEN(credit_number))
FROM banking
GROUP BY LEN(credit_number);

SELECT *
FROM banking
WHERE LEN(credit_number) < 8;

----- Region
SELECT DISTINCT region
FROM banking;

CREATE TABLE region_standardization_mapping (
    region VARCHAR(50) PRIMARY KEY,
    region_new VARCHAR(50)
);

INSERT INTO region_standardization_mapping (region,region_new)
VALUES
	('eastern and southern africa','middle east and africa'),
	('africa west','middle east and africa'),
	('middle east and north africa','middle east and africa'),
	('western and central africa','middle east and africa'),
	('africa','middle east and africa'),
	('africa east','middle east and africa');

UPDATE b
SET b.region = r.region_new
FROM banking b
INNER JOIN region_standardization_mapping r
	ON b.region = r.region

----- Country Code
SELECT DISTINCT country_code
FROM banking; 

SELECT 
	LEN(country_code),
	COUNT(LEN(country_code))
FROM banking
GROUP BY LEN(country_code);

SELECT *
FROM banking
WHERE LEN(country_code) > 2;

----- Country
SELECT DISTINCT country
FROM banking
ORDER BY country;

CREATE TABLE country_standardization_mapping (
    country VARCHAR(50) PRIMARY KEY,
    country_new VARCHAR(50)
);

INSERT INTO country_standardization_mapping (country,country_new)
VALUES
	('central africa','central african republic'),
	('central america','unknown'),
	('central asia','unknown'),
	('congo, democratic republic of','congo'),
	('congo, republic of','congo'),
	('eastern africa','unknown'),
	('eastern and southern africa','unknown'),
	('egypt, arab republic of','egypt'),
	('gambia, the','gambia'),
	('korea, republic of','korea'),
	('kyrgyz republic','kyrgyzstan'),
	('lao people''s democratic republic','laos'),
	('macedonia, former yugoslav republic','north macedonia'),
	('macedonia, former yugoslav republic of','north macedonia'),
	('mekong','unknown'),
	('micronesia, federated states of','micronesia'),
	('middle east and north africa','unknown'),
	('oecs countries','unknown'),
	('pacific islands','unknown'),
	('south asia','unknown'),
	('south east asia','unknown'),
	('st. vincent and the grenadines','st. vincent'),
	('syrian arab republic','syria'),
	('taiwan, china','taiwan'),
	('turkiye','turkey'),
	('viet nam','vietnam'),
	('viet nam, cambodia, laos cmu','unknown'),
	('thailand & myanmar cmu','thailand'),
	('western africa','unknown'),
	('western and central africa','unknown'),
	('world','unknown'),
	('yemen, republic of','yemen');

UPDATE b
SET b.country = m.country_new
FROM banking b
JOIN country_standardization_mapping m
    ON b.country = m.country;


----- Borrower
/* too many issues in inconsistencies; don't use borrower for project */
SELECT DISTINCT borrower
FROM banking
ORDER BY borrower;

----- Credit Status
SELECT DISTINCT credit_status
FROM banking
ORDER BY credit_status;

---------- Create Credit Status Group

ALTER TABLE banking
ADD credit_status_group VARCHAR(50);

UPDATE banking
SET credit_status_group = CASE
    WHEN credit_status LIKE '%cancelled%' THEN 'cancelled'
    WHEN credit_status LIKE '%signed%' THEN 'signed'
    WHEN credit_status LIKE '%negotiated%' THEN 'negotiated'
    WHEN credit_status LIKE '%approved%' THEN 'approved'
    WHEN credit_status LIKE '%disburs%' THEN 'disbursing'
    WHEN credit_status LIKE '%repay%' THEN 'repaying'
    WHEN credit_status LIKE '%repaid%' THEN 'repaid'
    WHEN credit_status LIKE '%terminated%' THEN 'terminated'
    ELSE 'other'
END;

----- Currency of Commitment
SELECT DISTINCT currency_of_commitment
FROM banking
ORDER BY currency_of_commitment;

----- Project ID
SELECT DISTINCT project_id
FROM banking
ORDER BY project_id;

SELECT 
	LEN(project_id),
	COUNT(LEN(project_id))
FROM banking
GROUP BY LEN(project_id);

SELECT *
FROM banking
WHERE LEN(project_id) = 8;

SELECT *
FROM banking
WHERE project_id LIKE '%89101556%';

SELECT *
FROM banking
WHERE project_id IS NULL;

----- Project Name
/* many inconsistencies issues; however, can still use for reference for context understanding */
SELECT DISTINCT project_name
FROM banking
ORDER BY project_name;

-- Check Nulls
SELECT 
	SUM(CASE WHEN end_of_period IS NULL THEN 1 ELSE 0 END) AS end_of_period_null,
	SUM(CASE WHEN credit_number IS NULL THEN 1 ELSE 0 END) AS credit_number_null,
	SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) AS region_null,
	SUM(CASE WHEN country_code IS NULL THEN 1 ELSE 0 END) AS country_code_null,
	SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_null,
	SUM(CASE WHEN borrower IS NULL THEN 1 ELSE 0 END) AS borrower_null,
	SUM(CASE WHEN credit_status IS NULL THEN 1 ELSE 0 END) AS credit_status_null,
	SUM(CASE WHEN service_charge_rate IS NULL THEN 1 ELSE 0 END) AS service_charge_rate_null,
	SUM(CASE WHEN currency_of_commitment IS NULL THEN 1 ELSE 0 END) AS currency_of_commitment_null,
	SUM(CASE WHEN project_id IS NULL THEN 1 ELSE 0 END) AS project_id_null,
	SUM(CASE WHEN project_name IS NULL THEN 1 ELSE 0 END) AS project_name_null,
	SUM(CASE WHEN original_principal_amount_us IS NULL THEN 1 ELSE 0 END) AS original_principal_amount_us_null,
	SUM(CASE WHEN cancelled_amount_us IS NULL THEN 1 ELSE 0 END) AS cancelled_amount_us_null,
	SUM(CASE WHEN undisbursed_amount_us IS NULL THEN 1 ELSE 0 END) AS undisbursed_amount_us_null,
	SUM(CASE WHEN disbursed_amount_us IS NULL THEN 1 ELSE 0 END) AS disbursed_amount_us_null,
	SUM(CASE WHEN repaid_to_ida_us IS NULL THEN 1 ELSE 0 END) AS repaid_to_ida_us_null,
	SUM(CASE WHEN due_to_ida_us IS NULL THEN 1 ELSE 0 END) AS due_to_ida_us_null,
	SUM(CASE WHEN exchange_adjustment_us IS NULL THEN 1 ELSE 0 END) AS exchange_adjustment_us_null,
	SUM(CASE WHEN borrower_s_obligation_us IS NULL THEN 1 ELSE 0 END) AS borrower_s_obligation_us_null,
	SUM(CASE WHEN sold_3rd_party_us IS NULL THEN 1 ELSE 0 END) AS sold_3rd_party_us_null,
	SUM(CASE WHEN repaid_3rd_party_us IS NULL THEN 1 ELSE 0 END) AS repaid_3rd_party_us_null,
	SUM(CASE WHEN due_3rd_party_us IS NULL THEN 1 ELSE 0 END) AS due_3rd_party_us_null,
	SUM(CASE WHEN credits_held_us IS NULL THEN 1 ELSE 0 END) AS credits_held_us_null,
	SUM(CASE WHEN first_repayment_date IS NULL THEN 1 ELSE 0 END) AS first_repayment_date_null,
	SUM(CASE WHEN last_repayment_date IS NULL THEN 1 ELSE 0 END) AS last_repayment_date_null,
	SUM(CASE WHEN agreement_signing_date IS NULL THEN 1 ELSE 0 END) AS agreement_signing_date_null,
	SUM(CASE WHEN board_approval_date IS NULL THEN 1 ELSE 0 END) AS board_approval_date_null,
	SUM(CASE WHEN effective_date_most_recent IS NULL THEN 1 ELSE 0 END) AS effective_date_most_recent_null,
	SUM(CASE WHEN closed_date_most_recent IS NULL THEN 1 ELSE 0 END) AS closed_date_most_recent_null,
	SUM(CASE WHEN last_disbursement_date IS NULL THEN 1 ELSE 0 END) AS last_disbursement_date_null
FROM
	banking;

----- Service Charge Rate
/* service charge rate has nulls, only able to insert 0 for guarantee financial instrutment nulls */
SELECT 
	credit_status,
	SUM(CASE WHEN service_charge_rate IS NULL THEN 1 ELSE 0 END) AS total_null
FROM banking
GROUP BY credit_status
ORDER BY credit_status;

SELECT *
FROM banking
WHERE service_charge_rate IS NULL
  AND credit_status IN ('Disbursing', 'Closed');

SELECT *
FROM banking
WHERE service_charge_rate IS NULL
  AND (credit_number LIKE '%IDAG%' OR credit_number LIKE '%IDAB%'); 

UPDATE banking
SET service_charge_rate = 0
WHERE service_charge_rate IS NULL
  AND (credit_number LIKE '%IDAG%' OR credit_number LIKE '%IDAB%');

----- First Repayment Date
WITH firstRepaymentMax AS (
  SELECT 
    project_id,
    MAX(first_repayment_date) AS latest_repayment_date
  FROM banking
  WHERE first_repayment_date IS NOT NULL
  GROUP BY project_id
)
UPDATE b
SET b.first_repayment_date = a.latest_repayment_date
FROM banking b
JOIN firstRepaymentMax a
  ON b.project_id = a.project_id
WHERE b.first_repayment_date IS NULL;


----- Agreement Signing Date
WITH agreementSigningMax AS (
  SELECT 
    project_id,
    MAX(agreement_signing_date) AS latest_signing_date
  FROM banking
  WHERE agreement_signing_date IS NOT NULL
  GROUP BY project_id
)
UPDATE b
SET b.agreement_signing_date = a.latest_signing_date
FROM banking b
JOIN agreementSigningMax a
  ON b.project_id = a.project_id
WHERE b.agreement_signing_date IS NULL;

UPDATE banking
SET agreement_signing_date = board_approval_date
WHERE credit_status = 'signed'
  AND agreement_signing_date IS NULL
  AND board_approval_date IS NOT NULL;

----- Most Recent Effective Date
WITH MostRecentEffective AS (
  SELECT 
    project_id,
    MAX(effective_date_most_recent) AS latest_effective_date
  FROM banking
  WHERE effective_date_most_recent IS NOT NULL
  GROUP BY project_id
)
UPDATE b
SET b.effective_date_most_recent = m.latest_effective_date
FROM banking b
JOIN MostRecentEffective m
  ON b.project_id = m.project_id
WHERE b.effective_date_most_recent IS NULL;

----- Board Approval Date
/* unable to proxy board approval date to agreement signing date */
SELECT
	*
FROM banking
WHERE 
	board_approval_date IS NULL AND
	agreement_signing_date IS NULL;

----- Disbursement Date
WITH LastDisbursementFix AS (
  SELECT project_id, MAX(last_disbursement_date) AS latest_date
  FROM banking
  WHERE last_disbursement_date IS NOT NULL
  GROUP BY project_id
)
UPDATE b
SET last_disbursement_date = f.latest_date
FROM banking b
JOIN LastDisbursementFix f ON b.project_id = f.project_id
WHERE b.last_disbursement_date IS NULL;


------------------------------------------
/* 4. Remove Unnecessary Rows & Columns */
------------------------------------------
-- Drop Columns Not in Project Scope or Unnecessary Do to Lack of Meaningful Information in Data Provided
ALTER TABLE banking
DROP COLUMN 
	country_code,
	borrower,
	exchange_adjustment_us,
    sold_3rd_party_us, 
    repaid_3rd_party_us, 
    due_3rd_party_us, 
    credits_held_us;

-- Check for Anomalies 
SELECT credit_number, project_id, credit_status,
       board_approval_date, agreement_signing_date, effective_date_most_recent
FROM banking
WHERE effective_date_most_recent IS NOT NULL
  AND (board_approval_date IS NULL OR agreement_signing_date IS NULL);


SELECT *
FROM banking
WHERE credit_status IN ('effective', 'disbursing', 'repaid')
  AND effective_date_most_recent IS NOT NULL;

-- Drop Board Approval Date Nulls
/* corrupted data as there is no way to proxy but there is are effective dates with illogical credit status, suggesting corrupted data */
SELECT
	agreement_signing_date,
	board_approval_date,
	credit_status
FROM banking
WHERE 
	board_approval_date IS NULL AND
	agreement_signing_date IS NULL;

DELETE FROM banking
WHERE 
	board_approval_date IS NULL AND
	agreement_signing_date IS NULL;

-- Keep Only Board Approval Dates Between 2011 and 2025
DELETE FROM banking
WHERE YEAR(board_approval_date) NOT BETWEEN 2011 and 2025;

-- Drop other credit status group
SELECT
	credit_status,
	COUNT(*)
FROM banking
WHERE credit_status_group = 'other'
GROUP BY credit_status

SELECT *
FROM banking
WHERE latest_effective_date IS NULL

------------------------------------------
/* 5. Finalize Data */
------------------------------------------
-- Rename Columns for Analysis 
EXEC sp_rename 'banking.end_of_period','period_end_date','COLUMN';
EXEC sp_rename 'banking.original_principal_amount_us','principal_amount','COLUMN';
EXEC sp_rename 'banking.cancelled_amount_us','cancelled_amount','COLUMN';
EXEC sp_rename 'banking.undisbursed_amount_us','disbursed_amount','COLUMN';
EXEC sp_rename 'banking.repaid_to_ida_us','repaid_amount','COLUMN';
EXEC sp_rename 'banking.due_to_ida_us','due_amount','COLUMN';
EXEC sp_rename 'banking.borrower_s_obligation_us','borrower_obligation_amount','COLUMN';
EXEC sp_rename 'banking.effective_date_most_recent','latest_effective_date','COLUMN';
EXEC sp_rename 'banking.closed_date_most_recent','latest_closed_date','COLUMN';
EXEC sp_rename 'banking.last_disbursement_date','latest_disbursement_date','COLUMN';

-- Create Financial Instrument Category to Denote: guarantee, credit, or grant
SELECT 
	CASE 
	WHEN credit_number LIKE '%IDAE%' OR credit_number LIKE '%IDAH%' OR credit_number LIKE '%IDAD%' THEN 'grant'
	WHEN credit_number LIKE '%IDAB%' OR credit_number LIKE '%IDAG%' THEN 'guarantee'
	ELSE 'credit'
	END AS financial_instrument,
	COUNT(*)
FROM bank
GROUP BY CASE 
	WHEN credit_number LIKE '%IDAE%' OR credit_number LIKE '%IDAH%' OR credit_number LIKE '%IDAD%' THEN 'grant'
	WHEN credit_number LIKE '%IDAB%' OR credit_number LIKE '%IDAG%' THEN 'guarantee'
	ELSE 'credit'
	END;


ALTER TABLE banking
ADD financial_instrument VARCHAR(50);

UPDATE banking
SET financial_instrument = CASE 
	WHEN credit_number LIKE '%IDAE%' OR credit_number LIKE '%IDAH%' OR credit_number LIKE '%IDAD%' THEN 'grant'
	WHEN credit_number LIKE '%IDAB%' OR credit_number LIKE '%IDAG%' THEN 'guarantee'
	ELSE 'credit'
	END;


/* CREATE SAVE STATE TABLE FOR ALL CHANGES UP TO THIS POINT */
SELECT * INTO bankingall
FROM banking

/* CREATE CUMULATIVE TABLE FOR YEARS 2011 to 2025 FOR TREND ANALYSIS */
SELECT * INTO banking2011to2025
FROM banking

/* CREATE UNIQUE PROJECT ID TABLE FOR YEARS 2011 to 2025 BY LATEST END PERIOD DATE */
WITH ranked_projects AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY project_id
            ORDER BY 
                period_end_date DESC,
                board_approval_date DESC,
                latest_disbursement_date DESC,
                last_repayment_date DESC
        ) AS rn
    FROM banking2011to2025nd
)
DELETE FROM ranked_projects
WHERE rn > 1;

/* MAKE BANKING TABLE UNIQUE PROJECT ID BY LATEST END PERIOD DATE */
-- Keep Only Latest End Period of Project ID, sorted by period_end_date DESC,board_approval_date DESC,latest_disbursement_date DESC, last_repayment_date DESC
WITH ranked_projects AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY project_id
            ORDER BY 
                period_end_date DESC,
                board_approval_date DESC,
                latest_disbursement_date DESC,
                last_repayment_date DESC
        ) AS rn
    FROM banking
)
DELETE FROM ranked_projects
WHERE rn > 1;
