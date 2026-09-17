-- 09_lab_features(2)
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- Step 2: create the lab feature table
--
-- Use this as your main  09_lab_features  query:

CREATE OR REPLACE TABLE `mimiciv-bq.readmission_data.09_lab_features`
AS

WITH admissions_base AS (

SELECT

hadm_id,

subject_id,

admittime,

dischtime

FROM `physionet-data.mimiciv_3_1_hosp.admissions`

),

lab_base AS (

SELECT

le.hadm_id,

le.itemid,

di.label AS lab_label,

CAST(le.valuenum AS FLOAT64) AS valuenum,

le.charttime,

a.subject_id,

a.admittime,

a.dischtime

FROM `physionet-data.mimiciv_3_1_hosp.labevents` le

JOIN `physionet-data.mimiciv_3_1_hosp.d_labitems` di

ON le.itemid = di.itemid

JOIN admissions_base a

ON le.hadm_id = a.hadm_id

WHERE le.valuenum IS NOT NULL

AND le.charttime BETWEEN a.admittime AND a.dischtime

),

ranked_labs AS (

SELECT

hadm_id,

lab_label,

valuenum,

charttime,

ROW_NUMBER() OVER (

PARTITION BY hadm_id, lab_label

ORDER BY charttime DESC

) AS rn_last

FROM lab_base

),

lab_summary AS (

SELECT

hadm_id,

lab_label,

COUNT(*) AS lab_count,

AVG(valuenum) AS lab_mean,

MIN(valuenum) AS lab_min,

MAX(valuenum) AS lab_max,

MAX(IF(rn_last = 1, valuenum, NULL)) AS lab_last

FROM ranked_labs

GROUP BY hadm_id, lab_label

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

COUNT(ls.lab_label) AS n_lab_types,

SUM(ls.lab_count) AS total_lab_measurements,

MAX(IF(ls.lab_label = 'Sodium', ls.lab_mean, NULL)) AS sodium_mean,

MAX(IF(ls.lab_label = 'Potassium, whole blood', ls.lab_mean, NULL)) AS
potassium_whole_blood_mean,

MAX(IF(ls.lab_label = 'Chloride', ls.lab_mean, NULL)) AS
chloride_mean,

MAX(IF(ls.lab_label = 'Bicarbonate', ls.lab_mean, NULL)) AS
bicarbonate_mean,

MAX(IF(ls.lab_label = 'Glucose', ls.lab_mean, NULL)) AS glucose_mean,

MAX(IF(ls.lab_label = 'Urea Nitrogen', ls.lab_mean, NULL)) AS
urea_nitrogen_mean,

MAX(IF(ls.lab_label = 'Creatinine', ls.lab_mean, NULL)) AS
creatinine_mean,

MAX(IF(ls.lab_label = 'Hemoglobin', ls.lab_mean, NULL)) AS
hemoglobin_mean,

MAX(IF(ls.lab_label = 'Hematocrit', ls.lab_mean, NULL)) AS
hematocrit_mean,

MAX(IF(ls.lab_label = 'Platelet Count', ls.lab_mean, NULL)) AS
platelet_count_mean,

MAX(IF(ls.lab_label = 'White Blood Cells', ls.lab_mean, NULL)) AS
wbc_mean,

MAX(IF(ls.lab_label = 'Sodium', ls.lab_last, NULL)) AS sodium_last,

MAX(IF(ls.lab_label = 'Potassium, whole blood', ls.lab_last, NULL)) AS
potassium_whole_blood_last,

MAX(IF(ls.lab_label = 'Chloride', ls.lab_last, NULL)) AS
chloride_last,

MAX(IF(ls.lab_label = 'Bicarbonate', ls.lab_last, NULL)) AS
bicarbonate_last,

MAX(IF(ls.lab_label = 'Glucose', ls.lab_last, NULL)) AS glucose_last,

MAX(IF(ls.lab_label = 'Urea Nitrogen', ls.lab_last, NULL)) AS
urea_nitrogen_last,

MAX(IF(ls.lab_label = 'Creatinine', ls.lab_last, NULL)) AS
creatinine_last,

MAX(IF(ls.lab_label = 'Hemoglobin', ls.lab_last, NULL)) AS
hemoglobin_last,

MAX(IF(ls.lab_label = 'Hematocrit', ls.lab_last, NULL)) AS
hematocrit_last,

MAX(IF(ls.lab_label = 'Platelet Count', ls.lab_last, NULL)) AS
platelet_count_last,

MAX(IF(ls.lab_label = 'White Blood Cells', ls.lab_last, NULL)) AS
wbc_last

FROM `mimiciv-bq.readmission_data.02_readmission_label` a

LEFT JOIN lab_summary ls

ON a.hadm_id = ls.hadm_id

GROUP BY

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

a.readmission_30d_flag

ORDER BY a.subject_id, a.admittime;

![](media/image20.png){width="6.5in" height="3.513888888888889in"}

![](media/image28.png){width="6.5in" height="3.513888888888889in"}

![](media/image34.png){width="6.5in" height="3.513888888888889in"}

**[Rubric-based argument for the capstone project:]{.underline}**

We selected a per-admission summary of common laboratory tests for the
lab feature table because it provides the best balance between
methodological rigor, interpretability, and reproducibility. Unlike a
raw event-level extraction, the summary approach reduces noise, avoids
overly sparse time-series structures, and produces a single observation
per hospital admission, which aligns directly with our
readmission-prediction outcome. It also supports straightforward
validation, easier teammate review, and cleaner integration with
existing diagnosis and demographic features. This choice is appropriate
for a capstone project because it demonstrates thoughtful feature
engineering while keeping the pipeline transparent and feasible within
the project timeline.
