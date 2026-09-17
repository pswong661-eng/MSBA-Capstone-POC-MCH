-- 07_summary_02_readmission_label
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- **(This query tells you how many admissions are in
--  02_readmission_label , how many are labeled as 30-day readmissions, and
-- what fraction of the cohort is positive.  SAFE_DIVIDE  is useful here
-- because it returns  NULL  instead of throwing an error if the
-- denominator is zero.)**

SELECT

COUNT(*) AS total_rows,

SUM(readmission_30d_flag) AS positive_readmissions,

SAFE_DIVIDE(SUM(readmission_30d_flag), COUNT(*)) AS positive_rate

FROM `mimiciv-bq.readmission_data.02_readmission_label`;

![](media/image24.png){width="6.5in" height="3.513888888888889in"}
