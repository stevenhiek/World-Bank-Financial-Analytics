/*
CREATE FINANALIZE TABLES FOR TABLEAU DATA VISUALIZATION

1. Table by Unique Project ID within Board Approval Date 2011 and 2025
2. Table with All Available Data within Board Approval Date 2011 and 2025

*/

/* 1. Table by Unique Project ID within Board Approval Date 2011 and 2025 */
SELECT 
	project_id,
	region,
	country,
	financial_instrument,
	MAX(principal_amount) principal_amount,
	MAX(cancelled_amount) cancelled_amount,
	MAX(disbursed_amount) disbursed_amount,
	MAX(repaid_amount) repaid_amount,
	MAX(due_amount) due_amount,
	MAX(borrower_obligation_amount) borrower_obligation_amount,
	MAX(period_end_date) period_end_date,
	MIN(board_approval_date) board_approval_date,
	MAX(latest_closed_date) latest_closed_date,
	MAX(latest_disbursement_date) latest_disbursement_date,
	MAX(last_repayment_date) last_repayment_date
INTO tableauBankingUnique
FROM banking
GROUP BY 
	project_id,
	region,
	country,
	financial_instrument
;

/* 2. Table with All Available Data within Board Approval Date 2011 and 2025 */
SELECT 
	project_id,
	region,
	country,
	financial_instrument,
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
	YEAR(period_end_date)
;



