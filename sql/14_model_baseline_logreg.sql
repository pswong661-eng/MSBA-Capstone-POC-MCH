-- 14_model_baseline_logreg.sql
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

CREATE OR REPLACE MODEL
`mimiciv-bq.readmission_data.logistic_baseline`

OPTIONS(model_type='logistic_reg',
input_label_cols=['readmission_30d_flag']) AS

SELECT

readmission_30d_flag,

length_of_stay_days,

COALESCE(sodium_mean, -999) AS sodium_mean_imputed,

COALESCE(creatinine_mean, -999) AS creatinine_mean_imputed,

COALESCE(hemoglobin_mean, -999) AS hemoglobin_mean_imputed,

COALESCE(hematocrit_mean, -999) AS hematocrit_mean_imputed,

COALESCE(platelet_count_mean, -999) AS platelet_count_mean_imputed,

COALESCE(wbc_mean, -999) AS wbc_mean_imputed,

admission_type,

insurance,

race

FROM `mimiciv-bq.readmission_data.12_train`;

![](media/image6.png){width="6.5in" height="3.4305555555555554in"}

![](media/image55.png){width="6.5in" height="3.6666666666666665in"}

![](media/image49.png){width="6.5in" height="3.6666666666666665in"}

Purpose: *Train a baseline logistic regression model for 30‑day hospital
readmission prediction using MIMIC‑IV data.*

This query creates your **first predictive model** in the Capstone
pipeline. It's the foundation for evaluating performance, comparing
algorithms, and later explaining results to stakeholders. In your
report, this will appear under *Methods → Baseline Model*.

The **logistic baseline model** was created successfully in BigQuery ML.
The training metrics (loss decreasing, stable duration, and rising
learning rate) show that the model converged properly.
