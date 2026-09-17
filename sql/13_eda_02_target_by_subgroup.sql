-- 13_eda_02_target_by_subgroup
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

-- target by admission_type, race, insurance

SELECT

admission_type,

COUNT(*) AS n,

SUM(readmission_30d_flag) AS positives,

SAFE_DIVIDE(SUM(readmission_30d_flag), COUNT(*)) AS positive_rate

FROM `mimiciv-bq.readmission_data.10_final_model_table`

GROUP BY admission_type

ORDER BY positive_rate DESC;

![](media/image71.png){width="6.5in" height="3.513888888888889in"}
