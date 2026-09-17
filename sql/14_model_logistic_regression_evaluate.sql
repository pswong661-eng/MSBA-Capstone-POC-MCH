-- 14_model_logistic_regression_evaluate.sql
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

-- 14_model_logistic_regression_evaluate.sql

SELECT *

FROM ML.EVALUATE(

MODEL `mimiciv-bq.readmission_data.logistic_regression_model`,

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

![](media/image47.png){width="6.5in" height="3.763888888888889in"}

### **🧠 Purpose**

This query evaluates your logistic regression model on the validation
dataset (12_val) and returns key metrics:

-   **ROC AUC** --- overall discrimination ability

-   **Precision / Recall / F1 score** --- balance between false
    > positives and false negatives

-   **Accuracy / Log loss** --- general performance indicators

Your logistic regression evaluation ran perfectly, and the metrics
confirm that the model trained and validated successfully. Let's
interpret what you've achieved and move forward step by step.

📊 **Findings from Logistic Regression Evaluation**

  -------------------------------------------------------------------------------
  **Metric**      **Value**   **Interpretation**
  --------------- ----------- ---------------------------------------------------
  **Precision**   ≈ 0.45      About 45 % of predicted readmissions are correct
                              --- moderate precision.

  **Recall**      ≈ 0.0009    Very low sensitivity --- the model misses most true
                              readmissions.

  **Accuracy**    ≈ 0.79      High overall correctness, but misleading for
                              imbalanced data.

  **F1 Score**    ≈ 0.0018    Confirms poor balance between precision and recall.

  **Log Loss**    ≈ 0.50      Acceptable calibration; predictions aren't random.

  **ROC AUC**     ≈ 0.60      Baseline discrimination ability --- slightly better
                              than chance.
  -------------------------------------------------------------------------------

🧠 **Interpretation:** This logistic regression model serves as your
**baseline**. It captures linear relationships but struggles with
complex patterns (hence the low recall). That's exactly why we trained
the **boosted trees model** --- to capture non‑linear interactions and
improve recall and ROC AUC.

## **✅ Next Step --- Model Comparison**

Now that both models exist and have been evaluated, we'll compare them
side by side.
