-- 02_readmission_label
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- #02_readmission_label

#standardSQL

WITH admissions_ordered AS (

SELECT

subject_id,

hadm_id,

admittime,

dischtime,

admission_type,

admission_location,

discharge_location,

marital_status,

race,

hospital_expire_flag,

LEAD(admittime) OVER (

PARTITION BY subject_id

ORDER BY admittime

) AS next_admittime

FROM `physionet-data.mimiciv_3_1_hosp.admissions`

)

SELECT

subject_id,

hadm_id,

admittime,

dischtime,

admission_type,

admission_location,

discharge_location,

marital_status,

race,

hospital_expire_flag,

next_admittime,

CASE

WHEN next_admittime IS NOT NULL

AND DATE_DIFF(DATE(next_admittime), DATE(dischtime), DAY) BETWEEN 0 AND
30

THEN 1

ELSE 0

END AS readmission_30d_flag

FROM admissions_ordered

WHERE hospital_expire_flag = 0

ORDER BY subject_id, admittime;
