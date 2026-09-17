-- 13_eda_05_correlations
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

-- Pearson correlations between numeric features and target

SELECT

CORR(CAST(readmission_30d_flag AS FLOAT64), length_of_stay_days) AS
corr_los,

CORR(CAST(readmission_30d_flag AS FLOAT64), sodium_mean) AS corr_sodium,

CORR(CAST(readmission_30d_flag AS FLOAT64), creatinine_mean) AS
corr_creatinine

FROM `mimiciv-bq.readmission_data.10_final_model_table`;

![](media/image61.png){width="6.5in" height="3.513888888888889in"}

[Create a correlation matrix for numeric predictors. (ZC: not yet
done)]{.underline}

Quick confirmation and verdict

Your EDA query results look **consistent and healthy** --- you can
proceed to modeling. Key checks:

-   **Target distribution:** \~**20.19%** positive (110,218 / 546,028).

-   **Subgroup signal:** admission types vary widely (DIRECT EMER. and
    > ELECTIVE show much higher readmission rates).

-   **Feature summaries:** mean length of stay ≈ **4.69 days**; mean
    > sodium ≈ **138.66**; mean creatinine ≈ **1.26** --- all plausible
    > for MIMIC‑IV.

-   **Correlations:** small but non‑zero correlations with the target
    > (LOS, creatinine, sodium ≈ ±0.05--0.06).

-   **Missingness:** sodium \~**27.7%** missing, creatinine \~**26.7%**
    > missing; average lab coverage ≈ **73%**; average lab_null_count ≈
    > **2.6** out of 10.

-   **Leakage check:** next_admittime / days_to_next_admit are present
    > only for label creation --- do **not** use them as predictors.

All of the above matches expectations from your earlier checks. No red
flags (duplicates, impossible dates, or obvious schema errors) were
found.

### **Next Step: Baseline Modeling & Evaluation**

Let's take this session to focus on **baseline modeling**, keeping it
simple and interpretable before moving to advanced models.

#### **Recommended Baseline Models**

  -----------------------------------------------------------------------------
  Model                 Purpose                Notes
  --------------------- ---------------------- --------------------------------
  Logistic Regression   Establish              Handles imbalance with class
                        interpretable          weights
                        benchmark

  Decision Tree         Non‑linear baseline    Easy to visualize and explain

  Random Forest         Ensemble improvement   Robust to missing values

  XGBoost               Strong predictive      Handles imbalance and
                        baseline               missingness well
  -----------------------------------------------------------------------------

Next Step: Baseline Modeling & Evaluation

  -----------------------------------------------------------------------------------------
  Stage               Goal                   Deliverable
  ------------------- ---------------------- ----------------------------------------------
  1\. Baseline model  Establish              Logistic Regression
                      interpretable
                      benchmark

  2\. Non‑linear      Capture simple         Decision Tree
  baseline            interactions

  3\. Ensemble model  Improve predictive     Random Forest / XGBoost
                      power

  4\. Evaluation      Quantify performance   AUROC, AUPRC, Recall, Precision, F1

  5\. Explainability  Interpret drivers of   SHAP values + feature importance
                      readmission

  6\.                 Assess subgroup bias   Metrics by race / insurance / admission type
  Fairness & Ethics

  7\. Business Value  Translate results into Cost analysis + deployment plan
                      ROI
  -----------------------------------------------------------------------------------------
