-- 06_check_duplicates_03_diagnosis_features
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- **To check  03_diagnosis_features**

SELECT

hadm_id,

COUNT(*) AS cnt

FROM `mimiciv-bq.readmission_data.03_diagnosis_features`

GROUP BY hadm_id

HAVING COUNT(*) \> 1

ORDER BY cnt DESC, hadm_id;

![](media/image37.png){width="5.526042213473316in"
height="3.232379702537183in"}
