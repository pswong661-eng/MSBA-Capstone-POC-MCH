-- 14_model_baseline_logreg_evaluate.sql
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

-- 14_model_baseline_logreg_evaluate.sql

SELECT *

FROM ML.EVALUATE(

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

);

![](media/image45.png){width="6.5in" height="3.6666666666666665in"}

Description: Evaluate logistic regression model performance on
validation data using consistent feature schema.

Purpose: Evaluate baseline logistic regression model performance on
validation data.

our logistic regression model ran perfectly, and now we can interpret
the evaluation metrics you've captured. Let's break down what each
number means and what it tells us about your baseline model's
performance.

**Evaluation Summary**

  ----------------------------------------------------------------------------------
  **Metric**      **Value**   **Interpretation**
  --------------- ----------- ------------------------------------------------------
  **Precision**   0.45        About 45 % of the admissions predicted as "readmitted"
                              were actually true readmissions. This is moderate
                              precision --- the model is cautious but not highly
                              confident.

  **Recall**      0.00088     Extremely low recall (≈ 0.09 %). The model is missing
                              almost all true readmissions --- it's predicting very
                              few positives.

  **Accuracy**    0.79        79 % of predictions are correct overall, but this is
                              misleading because the dataset is imbalanced
                              (only ≈ 20 % positives).

  **F1 Score**    0.0018      Combines precision and recall; the very low value
                              confirms poor balance between false negatives and
                              false positives.

  **Log Loss**    0.5         Moderate; indicates the predicted probabilities are
                              not well calibrated yet.

  **ROC AUC**     0.595       Slightly better than random (0.5 = random). The model
                              has weak discrimination ability between readmitted vs.
                              non‑readmitted patients.
  ----------------------------------------------------------------------------------

## **Interpretation**

-   The model is **biased toward predicting "no readmission"**, which
    > explains the high accuracy but very low recall.

-   **ROC AUC ≈ 0.6** means it's learning *some* signal from the
    > features (not random), but the separation between classes is weak.

-   This is **normal for a baseline logistic regression** --- it gives
    > you a starting point to improve with feature engineering and more
    > expressive models.

## **Capstone Report Insight**

In your report's *Methods → Baseline Model* section, summarize like
this:

> "The baseline logistic regression achieved ROC AUC = 0.595 and
> recall ≈ 0.001, indicating limited predictive power. This result
> establishes a benchmark for subsequent non‑linear models and
> highlights the need for improved feature representation and
> class‑imbalance handling."

# **⭐ Step 1 --- Threshold Tuning in BigQuery ML**

Threshold tuning helps you understand how **precision**, **recall**, and
**F1** change when you adjust the probability cutoff.

Logistic regression defaults to **0.5**, which is too high for
imbalanced medical data.

We will evaluate thresholds from **0.05 → 0.50**.
