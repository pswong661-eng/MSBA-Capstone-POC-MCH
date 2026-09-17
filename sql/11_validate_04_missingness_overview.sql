-- 11_validate_04_missingness_overview
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- **Purpose** Summary of lab missingness and coverage metrics.

-- 11_validate_missingness_overview

SELECT

COUNT(*) AS total_rows,

AVG(lab_null_count) AS avg_lab_nulls,

MIN(lab_null_count) AS min_lab_nulls,

MAX(lab_null_count) AS max_lab_nulls,

AVG(lab_coverage_rate) AS avg_lab_coverage_rate

FROM `mimiciv-bq.readmission_data.10_final_model_table`;

![](media/image33.png){width="6.5in" height="3.513888888888889in"}

**Check** average coverage rate and range of null counts to decide
imputation strategy.
