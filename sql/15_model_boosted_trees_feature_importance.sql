-- 15_model_boosted_trees_feature_importance.sql
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

-- 15_model_boosted_trees_feature_importance.sql

SELECT

*

FROM

ML.FEATURE_IMPORTANCE(MODEL
`mimiciv-bq.readmission_data.boosted_trees_model`);

![](media/image8.png){width="6.5in"
height="3.763888888888889in"}![](media/image30.png){width="6.5in"
height="3.763888888888889in"}![](media/image60.png){width="6.5in"
height="3.763888888888889in"}

🧠 Purpose of This SQL

This query tells you **which features most influence your model's
predictions**.

BigQuery ML calculates an *importance score* for each input variable
based on how much it contributes to reducing prediction error across all
trees.

### **🎯 Purpose Recap**

This query extracts the **importance scores** for each feature used by
your boosted‑trees model.

It helps you:

-   Identify which variables most influence readmission predictions.

-   Understand the model's decision logic.

-   Select top features for visualization or future model refinement.

### **What the results are telling you**

From the table and bar chart:

-   **Top drivers of readmission risk** (high importance):

    -   **hematocrit_mean_imputed**

    -   **hemoglobin_mean_imputed**

    -   **length_of_stay_days**

    -   **admission_type**

    -   **sodium_mean_imputed**

    -   **creatinine_mean_imputed**

    -   **insurance**

-   **Moderate contributors:**

    -   **wbc_mean_imputed**

    -   **platelet_count_mean_imputed**

    -   **race**

These are the variables your boosted‑trees model relies on most to
decide whether a patient will be readmitted within 30 days.

This is perfect for your Capstone: you can now say *which* clinical and
administrative factors are most predictive, not just that the model
works.

### **🧠 Purpose of Model Comparison**

Model comparison helps you **quantify improvement** between your
baseline (Logistic Regression) and your advanced model (Boosted Trees).

It's not mandatory for deployment, but it's **essential for your
Capstone report** because it shows:

-   You tested multiple algorithms.

-   You selected the best one based on evidence.

-   You can justify why Boosted Trees is your final choice.

### **📊 Why Boosted Trees Alone Isn't Enough Yet**

Boosted Trees is powerful, but without comparison, reviewers can't see
*how much better* it performs.

So yes --- we should still do **model comparison** before finalizing.
