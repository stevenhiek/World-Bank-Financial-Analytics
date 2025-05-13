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

----- Create Credit Status Group

ALTER TABLE ida_data ADD credit_status_group VARCHAR(50);

UPDATE ida_data
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
	bank;

----- Most Recent Effective Date
WITH MostRecentEffective AS (
  SELECT 
    project_id,
    MAX(effectiveness_date) AS latest_effective_date
  FROM banking
  WHERE effectiveness_date IS NOT NULL
  GROUP BY project_id
)
UPDATE b
SET effectiveness_date = m.latest_effective_date
FROM banking b
JOIN MostRecentEffective m
  ON b.project_id = m.project_id
WHERE b.effectiveness_date IS NULL;

UPDATE banking
SET agreement_signing_date = board_approval_date
WHERE credit_status = 'signed'
  AND agreement_signing_date IS NULL
  AND board_approval_date IS NOT NULL;


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

----- Board Approval Date
UPDATE banking
SET agreement_signing_date = board_approval_date,
    agreement_date_estimated = 1
WHERE 
    credit_status IN ('approved', 'cancelled', 'terminated')
    AND agreement_signing_date IS NULL;


------------------------------------------
/* 4. Remove Unnecessary Rows & Columns */
------------------------------------------
-- Drop Columns Not in Project Scope
ALTER TABLE banking
DROP COLUMN 
	country_code,
	borrower,
    sold_3rd_party_us, 
    repaid_3rd_party_us, 
    due_3rd_party_us, 
    credits_held_us;

-- Check for Anomalies 
SELECT credit_number, project_id, credit_status,
       board_approval_date, agreement_signing_date, effectiveness_date
FROM banking
WHERE effectiveness_date IS NOT NULL
  AND (board_approval_date IS NULL OR agreement_signing_date IS NULL);

------------------------------------------
/* 5. Finalize Data */
------------------------------------------

SELECT * FROM banking

