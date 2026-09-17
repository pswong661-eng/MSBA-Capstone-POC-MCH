-- 04_validation_readmission_features_sql
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- **to check that  02_readmission_label  and  03_diagnosis_features  have
-- matching row counts and no duplicate  hadm_id  values**

WITH label_counts AS (

SELECT

COUNT(*) AS row_count,

COUNT(DISTINCT hadm_id) AS distinct_hadm_id_count

FROM `mimiciv-bq.readmission_data.02_readmission_label`

),

feature_counts AS (

SELECT

COUNT(*) AS row_count,

COUNT(DISTINCT hadm_id) AS distinct_hadm_id_count

FROM `mimiciv-bq.readmission_data.03_diagnosis_features`

),

duplicate_labels AS (

SELECT hadm_id, COUNT(*) AS cnt

FROM `mimiciv-bq.readmission_data.02_readmission_label`

GROUP BY hadm_id

HAVING COUNT(*) \> 1

),

duplicate_features AS (

SELECT hadm_id, COUNT(*) AS cnt

FROM `mimiciv-bq.readmission_data.03_diagnosis_features`

GROUP BY hadm_id

HAVING COUNT(*) \> 1

)

SELECT

'02_readmission_label' AS table_name,

row_count,

distinct_hadm_id_count,

row_count - distinct_hadm_id_count AS duplicate_rows

FROM label_counts

UNION ALL

SELECT

'03_diagnosis_features' AS table_name,

row_count,

distinct_hadm_id_count,

row_count - distinct_hadm_id_count AS duplicate_rows

FROM feature_counts;
