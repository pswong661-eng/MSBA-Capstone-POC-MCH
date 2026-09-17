-- 14_model_baseline_logreg_thresholds.sql
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

-- 14_model_baseline_logreg_thresholds.sql

WITH predictions AS (

SELECT

readmission_30d_flag AS label,

(SELECT prob FROM UNNEST(predicted_readmission_30d_flag_probs) WHERE
label = 1) AS prob

FROM ML.PREDICT(

MODEL `mimiciv-bq.readmission_data.logistic_baseline`,

(

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

FROM `mimiciv-bq.readmission_data.12_val`

)

)

),

thresholds AS (

SELECT

threshold,

SUM(CASE WHEN prob \>= threshold AND label = 1 THEN 1 ELSE 0 END) AS tp,

SUM(CASE WHEN prob \>= threshold AND label = 0 THEN 1 ELSE 0 END) AS fp,

SUM(CASE WHEN prob \< threshold AND label = 1 THEN 1 ELSE 0 END) AS fn,

SUM(CASE WHEN prob \< threshold AND label = 0 THEN 1 ELSE 0 END) AS tn

FROM predictions,

UNNEST(GENERATE_ARRAY(0.05, 0.50, 0.05)) AS threshold

GROUP BY threshold

)

SELECT

threshold,

tp,

fp,

fn,

tn,

SAFE_DIVIDE(tp, tp + fp) AS precision,

SAFE_DIVIDE(tp, tp + fn) AS recall,

SAFE_DIVIDE(2 * tp, 2 * tp + fp + fn) AS f1_score

FROM thresholds

ORDER BY threshold;

![](media/image19.png){width="6.5in"
height="3.763888888888889in"}![](media/image17.png){width="6.5in"
height="3.763888888888889in"}

Purpose: Evaluate precision--recall trade‑off across thresholds for
logistic regression baseline.

**⭐ What This Query Does**

It evaluates your logistic regression model at thresholds:
