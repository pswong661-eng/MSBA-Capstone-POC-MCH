-- 09_lab_features_06_create_cleaned_table
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

CREATE OR REPLACE TABLE
`mimiciv-bq.readmission_data.09_lab_features_cleaned` AS

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

days_to_next_admit,

readmission_30d_flag,

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

FROM `mimiciv-bq.readmission_data.09_lab_features`;

[Why this is the right move]{.underline}

This removes  potassium_whole_blood_mean , which had zero coverage,
while keeping the rest of the clinically useful lab features. That makes
your final dataset cleaner and easier to justify in your capstone.

![](media/image15.png){width="6.5in" height="3.513888888888889in"}

![](media/image58.png){width="6.5in"
height="3.513888888888889in"}![](media/image64.png){width="6.5in"
height="3.513888888888889in"}
