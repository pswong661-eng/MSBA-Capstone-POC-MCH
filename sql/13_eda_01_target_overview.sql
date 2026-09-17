-- 13_eda_01_target_overview
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

-- target distribution overall and by year (if needed)

SELECT

readmission_30d_flag,

COUNT(*) AS n,

SAFE_DIVIDE(COUNT(*), SUM(COUNT(*)) OVER()) AS pct

FROM `mimiciv-bq.readmission_data.10_final_model_table`

GROUP BY readmission_30d_flag;

![](media/image54.png){width="6.5in" height="3.513888888888889in"}
