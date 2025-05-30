# IDA World Bank Financial Analytics: Investing in Impact

![IDA_World_Bank_pic](https://github.com/stevenhiek/World-Bank-Financial-Analytics/blob/main/Project%20Pic/ida_world_bank.jpg)

## Executive Summary
**The World Bank’s International Development Association (IDA) has provided over $500 billion in concessional financing to the world’s poorest countries**, making it one of the largest sources of development aid globally.

A replenishment is the periodic process by which donor countries provide new funding to the IDA to finance its operations over a multi-year cycle. The IDA18 Replenishment established higher funding levels and more flexible, accelerated disbursements from 2017 to 2020, with subsequent replenishments further expanding scale of funding and adaptability of disbursements. 

**As a result, 2017 and onwards saw an overall increase in funding by 81%, comprised primarily of credits (71%) and grants (24%).** The Europe and Central Asia region have the best portfolio performance in disbursement (94%), repayment (13%), and cancellation (5%) ratios. **Best practices or operational models from the Europe and Central Asia region can help to inform improvements in underperforming regions and countries.**

The following sections examine financing trends and provide insights to inform future funding strategies and allocation decisions.

Below is the overview page from the Tableau dashboard and more examples are included throughout the report. View the interactive Tableau dashboard here [link](https://public.tableau.com/app/profile/steven.hiek/viz/IDAWorldBankFinancialAnalytics/IDAWorldBankFinancialAnalytics#1).

![IDA_world_bank_tableau_overview](https://github.com/stevenhiek/World-Bank-Financial-Analytics/blob/main/Charts%20%26%20Graphs/world_bank_financial_analytics_overview.png)

## Background
This project leverages monthly historical snapshots, available from April 2011 onward, to examine all credits, grants, and guarantees approved between 2011 and 2025. **The analysis highlights key regions and uncovers trends in funding and disbursements across IDA-supported projects.** These insights aim to support strategic decisions made by stakeholders in the Operations and Finance departments.

Insights and recommendations are provided on the following key areas:

* **Funding** – Evaluation of funding commitments over time, segmenting by financial instruments, year-over-year growth, and 3-year moving average.

* **Disbursements** – An analysis of disbursements over time, focusing on year-over-year growth, 3-year moving average, and financial ratios of disbursement, repayment, and cancellation amount.

* **Project Performance** – A review of performance in regions and countries, highlighting those with highest and lowest levels of funding, disbursements, repayments, and cancellations.

The SQL queries used to inspect and clean the data for this analysis can be found here [link](https://github.com/stevenhiek/World-Bank-Financial-Analytics/tree/main/Preprocessing).

The SQL queries answering various business questions can be found here [link](https://github.com/stevenhiek/World-Bank-Financial-Analytics/tree/main/Analysis).

An interactive Tableau dashboard used to report and explore financial trends can be found here [link](https://public.tableau.com/app/profile/steven.hiek/viz/IDAWorldBankFinancialAnalytics/IDAWorldBankFinancialAnalytics#1).

## Data Processing
The **data includes monthly snapshots of credits, grants, and guarantees of IDA-supported projects.** A total of 1,422,052 rows were uploaded to a SQL database. After preprocessing for duplicates, null values, data types, and corrupted entries, 361,814 rows corresponding to approved projects between 2011 and 2025 were retained for analysis. Final datasets with selected columns were then created to streamline Tableau visualizations.

IDA World Bank historical data can be found here [link](https://financesone.worldbank.org/ida-statement-of-credits-grants-and-guarantees-historical-data/DS00976).

The SQL queries for preprocessing can be found here [link](https://github.com/stevenhiek/World-Bank-Financial-Analytics/tree/main/Preprocessing).

The SQL queries for the post-processing to streamline Tableau visualization can be found here [link](https://github.com/stevenhiek/World-Bank-Financial-Analytics/tree/main/Post-processing).

## Insights Deep Dive
### Funding
* Since 2011, a **total of 2,804 projects have been funded**, with an average project lifecycle of 5.4 years.
* The **projects are primarily financed through credits (74%) and grants (24%)**, totaling $248 billion and $81 billion, respectively.
* The **moving average of annual funding remained relatively stable until 2019, then rose from $18 billion to $34 billion by 2023**, an 89% increase reflecting sustained growth in funding. 
* **Credit and grant funding saw a significant surge between 2020 and 2023 due to the COVID-19 pandemic, with total funding increasing by 107% from 2019 to 2020**, driving all regions to scale up global efforts in strengthening health systems and emergency response.
* **IDA funding grew by 44% in 2014 and 51% in 2017**, driven by health emergencies, armed conflicts, refugee crises, and climate-related disasters.

![IDA_world_bank_tableau_funding](https://github.com/stevenhiek/World-Bank-Financial-Analytics/blob/main/Charts%20%26%20Graphs/world_bank_financial_analytics_funding.png)

### Disbursement
* **Annual disbursement exhibits similar volatility to annual funding**, with a moving average that closely mirrors the stable and then steady increase in funding, and year-over-year growth ranging from -33% to +114%. 
* **Projects have a high overall disbursement ratio of 90% and low overall cancellation rate of 8%**, indicating effective project execution and implementation. 
* With a grace period of 5 to 10 years before credit repayment begins, **only a few projects have entered the repayment phase, resulting in a low overall repayment ratio of 7%.**

![IDA_world_bank_tableau_disbursement](https://github.com/stevenhiek/World-Bank-Financial-Analytics/blob/main/Charts%20%26%20Graphs/world_bank_financial_analytics_disbursement.png)

### Project Performance
* The **Europe and Central Asia region demonstrate the strongest overall portfolio performance with a disbursement ratio of 94%, a repayment ratio of 13%, and a cancellation ratio of 5%**, reflecting a portfolio of low-risk, well-executed, and effectively implemented projects.
* With **1,613 projects and $214 billion in total funding, the Middle East and Africa region holds the largest project portfolio**, primarily composed of credits (74%) and grants (24%).
* The **South Asia region has the lowest disbursement ratio of 84% and highest cancellation ratio of 13%**, suggesting potential issues in local relevance, implementation feasibility, and overestimated funding needs.  
* **Bangladesh recorded the highest funding ($26 billion), disbursement ($23 billion), and cancellation ($3 billion) amounts among all countries**, while maintaining a relatively strong disbursement ratio of 89% and a moderate cancellation ratio of 10% within the South Asia region.

![IDA_world_bank_tableau_top_performance](https://github.com/stevenhiek/World-Bank-Financial-Analytics/blob/main/Charts%20%26%20Graphs/world_bank_financial_analytics_top_performance.png)

## Recommendations
Based on the uncovered insights, the following recommendations have been provided:

* While projects have a high overall disbursement ratio of 90%, there remains a **need to strengthen monitoring efforts to ensure that disbursed funds translate into measurable outcomes and tangible impact.**
* Despite receiving the second highest total funding of $72 billion, the South Asia region exhibits the lowest disbursement ratio (84%) and the highest cancellation ratio (13%) among all regions, highlighting the **need to enhance stakeholder engagement during project planning, strengthen project design and targeting, improve risk assessment, and support capacity building in implementing agencies in the South Asia region.**
* Bangladesh is the top-performing country in the South Asia region, with a disbursement ratio of 89% and a cancellation ratio of 10%, **making Bangladesh a potential model for best practices and locally relevant project implementation to inform improvements across the South Asia region.**
* Since the Europe and Central Asia region have the best portfolio performance in disbursement (94%), repayment (13%), and cancellation (5%) ratios, **IDA can learn best practices or operational models from the Europe and Central Asia region to help inform improvements in underperforming regions and countries.** 

## Assumptions and Caveats
Throughout the analysis, multiple assumptions were made to manage the challenges with the data. These assumptions and caveats are noted below:

* Combined regions in Africa and Middle East to one large region due to inconsistencies in region classification.
* Values in the country variable that denoted a region were converted to unknown.
* Data rows that contained nulls for agreement signing date, board approval date, and last effective date were considered corrupted entries.





