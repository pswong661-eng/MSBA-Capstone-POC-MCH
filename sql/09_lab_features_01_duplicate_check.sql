-- 09_lab_features_01_duplicate_check
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

SELECT

hadm_id,

COUNT(*) AS cnt

FROM `mimiciv-bq.readmission_data.09_lab_features`

GROUP BY hadm_id

HAVING COUNT(*) \> 1

ORDER BY cnt DESC, hadm_id;

![](media/image68.png){width="6.5in" height="3.513888888888889in"}
