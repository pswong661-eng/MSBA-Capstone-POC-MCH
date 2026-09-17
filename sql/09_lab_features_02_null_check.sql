-- 09_lab_features_02_null_check
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

SELECT

COUNT(*) AS total_rows,

COUNTIF(subject_id IS NULL) AS missing_subject_id,

COUNTIF(hadm_id IS NULL) AS missing_hadm_id,

COUNTIF(admittime IS NULL) AS missing_admittime,

COUNTIF(dischtime IS NULL) AS missing_dischtime,

COUNTIF(readmission_30d_flag IS NULL) AS missing_readmission_30d_flag,

COUNTIF(n_lab_types IS NULL) AS missing_n_lab_types,

COUNTIF(total_lab_measurements IS NULL) AS
missing_total_lab_measurements,

COUNTIF(sodium_mean IS NULL) AS missing_sodium_mean

FROM `mimiciv-bq.readmission_data.09_lab_features`;

![](media/image16.png){width="6.5in" height="3.513888888888889in"}
