-- 02_readmission_label_sql
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

CREATE OR REPLACE TABLE
`mimiciv-bq.readmission_data.02_readmission_label` AS

WITH admissions_base AS (

SELECT

subject_id,

hadm_id,

admittime,

dischtime,

admission_type,

admission_location,

discharge_location,

insurance,

language,

marital_status,

race,

hospital_expire_flag,

LEAD(admittime) OVER (

PARTITION BY subject_id

ORDER BY admittime

) AS next_admittime

FROM `physionet-data.mimiciv_3_1_hosp.admissions`

),

readmission_labeled AS (

SELECT

subject_id,

hadm_id,

admittime,

dischtime,

admission_type,

admission_location,

discharge_location,

insurance,

language,

marital_status,

race,

hospital_expire_flag,

next_admittime,

DATETIME_DIFF(next_admittime, dischtime, DAY) AS days_to_next_admit,

CASE

WHEN next_admittime IS NOT NULL

AND DATETIME_DIFF(next_admittime, dischtime, DAY) BETWEEN 0 AND 30

THEN 1

ELSE 0

END AS readmission_30d_flag

FROM admissions_base

)

SELECT *

FROM readmission_labeled

ORDER BY subject_id, admittime;
