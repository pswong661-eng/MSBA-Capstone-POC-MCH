-- 15_model_comparison_logistic_vs_boosted.sql
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

-- 15_model_comparison_logistic_vs_boosted.sql

SELECT

'logistic_regression' AS model_name,

roc_auc,

accuracy,

precision,

recall,

f1_score

FROM

ML.EVALUATE(MODEL
`mimiciv-bq.readmission_data.logistic_regression_model`,

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

UNION ALL

SELECT

'boosted_trees' AS model_name,

roc_auc,

accuracy,

precision,

recall,

f1_score

FROM

ML.EVALUATE(MODEL `mimiciv-bq.readmission_data.boosted_trees_model`,

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

### **🧩 Purpose**

This query will produce a simple comparison table showing both models'
metrics side by side --- helping you decide which performs better
overall.

![](media/image2.png){width="6.5in" height="3.763888888888889in"}

Your comparison query ran perfectly, and the results are clear and
meaningful. Let's interpret them carefully and decide the next step.

📊 **Model Comparison Findings**

  ----------------------------------------------------------------------------------------------------
  **Metric**      **Logistic Regression**   **Boosted Trees**   **Interpretation**
  --------------- ------------------------- ------------------- --------------------------------------
  **ROC AUC**     0.595                     0.647               Boosted Trees shows stronger
                                                                discrimination ability --- it better
                                                                separates readmissions from
                                                                non‑readmissions.

  **Accuracy**    0.793                     0.794               Nearly identical --- both models
                                                                predict the majority class well.

  **Precision**   0.455                     0.611               Boosted Trees makes more accurate
                                                                positive predictions.

  **Recall**      0.0009                    0.0065              Still low overall, but Boosted Trees
                                                                detects more true readmissions.

  **F1 Score**    0.0018                    0.0128              Boosted Trees achieves better balance
                                                                between precision and recall.
  ----------------------------------------------------------------------------------------------------

🧠 **Interpretation:** Your **Boosted Trees model outperforms
Logistic Regression** across all key metrics, especially ROC AUC and
precision. This confirms that non‑linear relationships (captured by tree
ensembles) are important for predicting 30‑day readmissions --- a
valuable insight for your Capstone.

✅ **Next Step --- Visualize Top 10 Features**

Yes, now we move to the **feature importance chart**. This visualization
will make your report visually compelling and show which variables drive
predictions most strongly.

### **🧩 Purpose**

This query extracts the top 10 features ranked by their importance
weight --- the higher the value, the more influence that variable has on
the model's predictions.
