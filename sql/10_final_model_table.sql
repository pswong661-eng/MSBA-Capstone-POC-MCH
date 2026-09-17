-- 10_final_model_table
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- You'll create a single, one‑row‑per‑admission table that **joins** the
-- label table, diagnosis features, and cleaned lab features; **adds
-- derived features** (length of stay, time features, lab missingness);
-- **guards against leakage**; and includes simple flags useful for
-- modeling and explainability.
--
-- ### **Final model table design (what to include)**
--
-- **Core joins**
--
-- -   **02_readmission_label** (target + admission metadata) --- primary
--     > source
--
-- -   **03_diagnosis_features** (diagnosis counts) --- left join on
--     > hadm_id
--
-- -   **09_lab_features_cleaned** (lab means/last) --- left join on
--     > hadm_id
--
-- **Essential derived features**
--
-- -   **length_of_stay_days** = DATETIME_DIFF(dischtime, admittime, DAY)
--
-- -   **admission_hour**, **admission_weekday**,
--     > **admission_weekend_flag**
--
-- -   **lab_missing_count** and **lab_coverage_rate** (per row)
--
-- -   **recent_lab_vs_mean_diff** for key labs (e.g., sodium_last -
--     > sodium_mean) --- optional but useful
--
-- **10_final_model_table**  SQL

-- Create final model table: one row per admission, ready for
EDA/modeling

CREATE OR REPLACE TABLE
`mimiciv-bq.readmission_data.10_final_model_table` AS

WITH

-- base label + admission metadata (already contains next_admittime,
readmission_30d_flag)

base AS (

SELECT *

FROM `mimiciv-bq.readmission_data.02_readmission_label`

),

-- diagnosis features (one row per hadm_id)

diag AS (

SELECT

hadm_id,

total_diagnosis_codes,

distinct_diagnosis_codes,

icd9_code_count,

icd10_code_count

FROM `mimiciv-bq.readmission_data.03_diagnosis_features`

),

-- lab features (cleaned)

lab AS (

SELECT

hadm_id,

n_lab_types,

total_lab_measurements,

sodium_mean,

chloride_mean,

bicarbonate_mean,

glucose_mean,

urea_nitrogen_mean,

creatinine_mean,

hemoglobin_mean,

hematocrit_mean,

platelet_count_mean,

wbc_mean,

sodium_last,

chloride_last,

bicarbonate_last,

glucose_last,

urea_nitrogen_last,

creatinine_last,

hemoglobin_last,

hematocrit_last,

platelet_count_last,

wbc_last

FROM `mimiciv-bq.readmission_data.09_lab_features_cleaned`

)

SELECT

b.subject_id,

b.hadm_id,

b.admittime,

b.dischtime,

-- admission metadata

b.admission_type,

b.admission_location,

b.discharge_location,

b.insurance,

b.language,

b.marital_status,

b.race,

b.hospital_expire_flag,

b.next_admittime,

b.days_to_next_admit,

b.readmission_30d_flag,

-- derived time features

DATETIME_DIFF(b.dischtime, b.admittime, DAY) AS length_of_stay_days,

EXTRACT(HOUR FROM b.admittime) AS admission_hour,

EXTRACT(DAYOFWEEK FROM b.admittime) AS admission_dayofweek,

CASE WHEN EXTRACT(DAYOFWEEK FROM b.admittime) IN (1,7) THEN 1 ELSE 0 END
AS admission_weekend_flag,

-- diagnosis features

d.total_diagnosis_codes,

d.distinct_diagnosis_codes,

d.icd9_code_count,

d.icd10_code_count,

-- lab features (raw)

l.n_lab_types,

l.total_lab_measurements,

l.sodium_mean,

l.chloride_mean,

l.bicarbonate_mean,

l.glucose_mean,

l.urea_nitrogen_mean,

l.creatinine_mean,

l.hemoglobin_mean,

l.hematocrit_mean,

l.platelet_count_mean,

l.wbc_mean,

l.sodium_last,

l.chloride_last,

l.bicarbonate_last,

l.glucose_last,

l.urea_nitrogen_last,

l.creatinine_last,

l.hemoglobin_last,

l.hematocrit_last,

l.platelet_count_last,

l.wbc_last,

-- lab missingness diagnostics

( -- count of lab columns that are NULL for this row

(CASE WHEN l.sodium_mean IS NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.chloride_mean IS NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.bicarbonate_mean IS NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.glucose_mean IS NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.urea_nitrogen_mean IS NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.creatinine_mean IS NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.hemoglobin_mean IS NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.hematocrit_mean IS NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.platelet_count_mean IS NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.wbc_mean IS NULL THEN 1 ELSE 0 END)

) AS lab_null_count,

SAFE_DIVIDE(

( -- present count

(CASE WHEN l.sodium_mean IS NOT NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.chloride_mean IS NOT NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.bicarbonate_mean IS NOT NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.glucose_mean IS NOT NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.urea_nitrogen_mean IS NOT NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.creatinine_mean IS NOT NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.hemoglobin_mean IS NOT NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.hematocrit_mean IS NOT NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.platelet_count_mean IS NOT NULL THEN 1 ELSE 0 END) +

(CASE WHEN l.wbc_mean IS NOT NULL THEN 1 ELSE 0 END)

),

10

) AS lab_coverage_rate,

-- simple recent vs mean diffs (example)

SAFE_SUBTRACT(l.sodium_last, l.sodium_mean) AS sodium_last_minus_mean,

SAFE_SUBTRACT(l.creatinine_last, l.creatinine_mean) AS
creatinine_last_minus_mean,

-- metadata

CURRENT_TIMESTAMP() AS created_at,

'v1' AS data_version

FROM base b

LEFT JOIN diag d

ON b.hadm_id = d.hadm_id

LEFT JOIN lab l

ON b.hadm_id = l.hadm_id

ORDER BY b.subject_id, b.admittime;

![](media/image67.png){width="6.5in"
height="3.513888888888889in"}![](media/image59.png){width="6.5in"
height="3.513888888888889in"}

![](media/image46.png){width="6.5in" height="3.513888888888889in"}
