-- 14_model_baseline_logreg_pr_curve.sql
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- Purpose: To **visualize the precision--recall curve** for your logistic
-- regression model.

-- 14_model_baseline_logreg_pr_curve.sql

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

curve AS (

SELECT

threshold,

SUM(CASE WHEN prob \>= threshold AND label = 1 THEN 1 ELSE 0 END) AS tp,

SUM(CASE WHEN prob \>= threshold AND label = 0 THEN 1 ELSE 0 END) AS fp,

SUM(CASE WHEN prob \< threshold AND label = 1 THEN 1 ELSE 0 END) AS fn,

SUM(CASE WHEN prob \< threshold AND label = 0 THEN 1 ELSE 0 END) AS tn

FROM predictions,

UNNEST(GENERATE_ARRAY(0.00, 1.00, 0.01)) AS threshold

GROUP BY threshold

)

SELECT

threshold,

SAFE_DIVIDE(tp, tp + fp) AS precision,

SAFE_DIVIDE(tp, tp + fn) AS recall

FROM curve

ORDER BY threshold;

![](media/image66.png){width="6.5in"
height="3.763888888888889in"}![](media/image5.png){width="6.5in"
height="3.763888888888889in"}

![](media/image13.png){width="6.5in"
height="3.763888888888889in"}![](media/image39.png){width="6.5in"
height="3.763888888888889in"}

Your visualization looks perfect.

The chart confirms what we saw numerically: **recall stays near 1.0** at
low thresholds, while **precision rises steadily** as the threshold
increases.

## **🧩 Interpreting the Curve**

-   The **green line** (recall) starts high and drops sharply
    > after ≈ 0.2 -- 0.3.

-   The **blue line** (precision) climbs gradually as the threshold
    > increases.

-   The intersection or plateau around **threshold ≈ 0.20** is your
    > **sweet spot** --- where precision and recall balance best.

This visually validates your earlier finding that **0.20** is the
optimal threshold for the baseline logistic regression model.

## **What This Means**

-   At **low thresholds**, the model predicts almost everyone as
    > "readmitted," giving high recall but poor precision.

-   At **high thresholds**, it predicts very few positives, improving
    > precision but losing recall.

-   The **curve shape** shows a typical trade‑off for imbalanced
    > healthcare data --- your model behaves as expected.

### **🧠 Step 1 --- Train the Random Forest Model**

Now that your logistic regression baseline and threshold are validated,
it's time to **improve predictive power**.

Random Forest will:

-   Capture non‑linear relationships between lab values and
    > demographics.

-   Handle missing values more robustly.

-   Provide **feature importance** for interpretability.
