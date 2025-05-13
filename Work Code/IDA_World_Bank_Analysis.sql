/*
------------------------------------------------------------------------
DATA ANALYSIS
- Data from April 2011 to April 2025; data as of April 30, 2025

Project Questions:
1. Which regions or countries received the most IDA funding over time?
2. What are the trends in disbursement, repayment, and cancellation over time?
3. How long do projects typically take from approval to closing?
4. What proportion of credit is undisbursed vs. repaid?
5. Are there observable trends that align with global events?
------------------------------------------------------------------------
*/

----------------------------------------------------------------------------
/* 1. Which regions or countries received the most IDA funding over time? */
----------------------------------------------------------------------------


SELECT 
	COUNT(*) AS total_pAmount_all,
	SUM(CASE WHEN principal_amount=0 THEN 1 ELSE 0 END) AS total_pAmount_0
FROM 
	banking;




SELECT * FROM banking

