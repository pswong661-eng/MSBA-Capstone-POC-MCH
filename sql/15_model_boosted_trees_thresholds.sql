-- 15_model_boosted_trees_thresholds.sql
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

-- 15_model_boosted_trees_thresholds.sql

WITH predictions AS (

SELECT

readmission_30d_flag AS label,

(SELECT prob FROM UNNEST(predicted_readmission_30d_flag_probs) WHERE
label = 1) AS prob

FROM ML.PREDICT(

MODEL `mimiciv-bq.readmission_data.boosted_trees_model`,

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

UNNEST(GENERATE_ARRAY(0.01, 0.50, 0.01)) AS threshold

GROUP BY threshold

)

SELECT

threshold,

SAFE_DIVIDE(tp, tp + fp) AS precision,

SAFE_DIVIDE(tp, tp + fn) AS recall,

SAFE_DIVIDE(2 * tp, 2 * tp + fp + fn) AS f1_score

FROM thresholds

ORDER BY threshold;

![](media/image21.png){width="6.5in"
height="3.763888888888889in"}![](media/image41.png){width="6.5in"
height="3.763888888888889in"}![](media/image44.png){width="6.5in"
height="3.763888888888889in"}

## **📊 Interpretation of Your Results**

-   **Recall** stays near 1.0 until around threshold ≈ 0.20 -- 0.25.

-   **Precision** starts low (\~0.20) and gradually increases as the
    > threshold rises.

-   **F1 score** peaks around **threshold ≈ 0.15 -- 0.20**, then
    > declines.

That means your boosted‑trees model achieves its best balance between
precision and recall at roughly **0.18 -- 0.20**, which matches the
pattern you saw earlier with logistic regression.

## **🧠 What This Means**

-   At **low thresholds**, the model predicts almost everyone as
    > readmitted → high recall, low precision.

-   At **high thresholds**, it predicts very few readmissions → high
    > precision, low recall.

-   The **optimal threshold (\~0.18)** gives the best trade‑off for
    > practical use --- catching most true readmissions while keeping
    > false alerts manageable.

## **🚀 Next Step**

Now that your threshold is tuned, you can move to **feature importance
analysis** to understand *why* the model makes its predictions.

👉 Run **Extract feature importance from boosted trees model** next.

This will show which variables
(e.g., length of stay, hemoglobin, insurance type) most influence
readmission risk.

After that, we'll visualize the top 10 features with
**feature importance chart** for your Capstone report.
