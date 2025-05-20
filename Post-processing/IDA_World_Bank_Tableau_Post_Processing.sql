/*
CREATE FINANALIZE TABLES FOR TABLEAU DATA VISUALIZATION

1. Table by Unique Project ID within Board Approval Date 2011 and 2025
2. Table with All Available Data within Board Approval Date 2011 and 2025

*/

/* 1. Table by Unique Project ID within Board Approval Date 2011 and 2025 */
WITH max_disbursement_project AS (
    SELECT 
        project_id,
		financial_instrument,
        MAX(disbursed_amount) disbursed_amount
    FROM banking
	WHERE board_approval_date IS NOT NULL
	GROUP BY project_id,financial_instrument
),
max_principal_project AS (
	SELECT 
        project_id,
		financial_instrument,
        MAX(principal_amount) principal_amount
    FROM banking
	WHERE board_approval_date IS NOT NULL
	GROUP BY project_id,financial_instrument
),
max_repaid_project AS (
	SELECT 
        project_id,
		financial_instrument,
        MAX(repaid_amount) repaid_amount
    FROM banking
	WHERE board_approval_date IS NOT NULL
	GROUP BY project_id,financial_instrument
),
max_cancelled_project AS (
	SELECT 
        project_id,
		financial_instrument,
        MAX(cancelled_amount) cancelled_amount
    FROM banking
	WHERE board_approval_date IS NOT NULL
	GROUP BY project_id,financial_instrument
)
SELECT
	b.project_id,
	b.financial_instrument,
	b.region,
	b.country,
	MAX(p.principal_amount) principal_amount,
	MAX(d.disbursed_amount) disbursed_amount,
	MAX(r.repaid_amount) repaid_amount,
	MAX(c.cancelled_amount) cancelled_amount,
	MAX(b.period_end_date) period_end_date,
	MIN(b.board_approval_date) board_approval_date,
	MAX(b.latest_closed_date) latest_closed_date,
	MAX(b.latest_disbursement_date) latest_disbursement_date,
	MAX(b.last_repayment_date) last_repayment_date
INTO tableauBankingUnique
FROM banking b
JOIN max_principal_project p
	ON b.project_id=p.project_id AND b.financial_instrument=p.financial_instrument
JOIN max_disbursement_project d
	ON b.project_id=d.project_id AND b.financial_instrument=d.financial_instrument
JOIN max_repaid_project r
	ON b.project_id=r.project_id AND b.financial_instrument=r.financial_instrument
JOIN max_cancelled_project c
	ON b.project_id=c.project_id AND b.financial_instrument=c.financial_instrument
WHERE board_approval_date IS NOT NULL
GROUP BY 
	b.project_id,
	b.financial_instrument,
	b.region,
	b.country
ORDER BY project_id;


/* 2. Table with All Available Data within Board Approval Date 2011 and 2025 */
SELECT 
	project_id,
	region,
	country,
	financial_instrument,
	credit_status,
	MAX(principal_amount) principal_amount,
	MAX(cancelled_amount) cancelled_amount,
	MAX(disbursed_amount) disbursed_amount,
	MAX(repaid_amount) repaid_amount,
	MAX(due_amount) due_amount,
	MAX(borrower_obligation_amount) borrower_obligation_amount,
	YEAR(period_end_date) period_end_date,
	MIN(board_approval_date) board_approval_date,
	MAX(latest_closed_date) latest_closed_date,
	MAX(latest_disbursement_date) latest_disbursement_date,
	MAX(last_repayment_date) last_repayment_date
INTO tableauBankingAll
FROM banking
GROUP BY 
	project_id,
	region,
	country,
	financial_instrument,
	credit_status,
	YEAR(period_end_date)
;