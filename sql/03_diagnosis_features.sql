-- 03_diagnosis_features
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

CREATE OR REPLACE TABLE
`mimiciv-bq.readmission_data.03_diagnosis_features` AS

WITH diagnosis_counts AS (

SELECT

hadm_id,

COUNT(*) AS total_diagnosis_codes,

COUNT(DISTINCT icd_code) AS distinct_diagnosis_codes,

COUNTIF(icd_version = 9) AS icd9_code_count,

COUNTIF(icd_version = 10) AS icd10_code_count

FROM `physionet-data.mimiciv_3_1_hosp.diagnoses_icd`

GROUP BY hadm_id

)

SELECT

a.subject_id,

a.hadm_id,

a.admittime,

a.dischtime,

a.admission_type,

a.admission_location,

a.discharge_location,

a.insurance,

a.language,

a.marital_status,

a.race,

a.hospital_expire_flag,

a.next_admittime,

a.days_to_next_admit,

a.readmission_30d_flag,

COALESCE(d.total_diagnosis_codes, 0) AS total_diagnosis_codes,

COALESCE(d.distinct_diagnosis_codes, 0) AS distinct_diagnosis_codes,

COALESCE(d.icd9_code_count, 0) AS icd9_code_count,

COALESCE(d.icd10_code_count, 0) AS icd10_code_count

FROM `mimiciv-bq.readmission_data.02_readmission_label` a

LEFT JOIN diagnosis_counts d

ON a.hadm_id = d.hadm_id

ORDER BY a.subject_id, a.admittime;
