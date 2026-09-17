-- 15_model_boosted_trees_feature_importance_chart.sql
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

-- 15_model_boosted_trees_feature_importance_chart.sql

SELECT

feature,

importance_weight

FROM

ML.FEATURE_IMPORTANCE(MODEL
`mimiciv-bq.readmission_data.boosted_trees_model`)

ORDER BY

importance_weight DESC

LIMIT 10;

![](media/image4.png){width="6.5in"
height="3.763888888888889in"}![](media/image7.png){width="6.5in"
height="3.763888888888889in"}

### **🚀 After You Run It**

1.  Run the query and open the **Visualization** tab.

2.  Set:

    -   **Visualization type:** Bar

    -   **Dimension (x‑axis):** feature

    -   **Measure (y‑axis):** importance_weight

![](media/image29.png){width="6.5in" height="3.763888888888889in"}

Your feature importance chart looks perfect, and the results are very
insightful for your Capstone.

📊 **Findings from Feature Importance Chart**

  ----------------------------------------------------------------------------------
  Rank   Feature                         Interpretation
  ------ ------------------------------- -------------------------------------------
  1️⃣     Admission Type                  The strongest predictor --- emergency or
                                         elective admissions heavily influence
                                         readmission risk.

  2️⃣     Length of Stay (Days)           Longer hospital stays often indicate
                                         complex conditions, increasing readmission
                                         likelihood.

  3️⃣     Platelet Count Mean (Imputed)   Reflects patient recovery and inflammation;
                                         abnormal counts may signal complications.

  4️⃣     Creatinine Mean (Imputed)       Kidney function marker --- elevated levels
                                         often correlate with chronic disease
                                         readmissions.

  5️⃣     Race                            Captures demographic disparities in
                                         healthcare outcomes.

  6️⃣     Insurance Type                  Socioeconomic factor affecting access to
                                         follow‑up care.

  7️⃣     WBC Mean (Imputed)              Infection or immune response indicator ---
                                         higher counts may predict relapse.

  8️⃣     Sodium Mean (Imputed)           Electrolyte imbalance can reflect
                                         underlying conditions like heart failure.

  9️⃣     Hematocrit Mean (Imputed)       Blood oxygen capacity --- low values may
                                         indicate anemia or poor recovery.

  🔟     Hemoglobin Mean (Imputed)       Similar to hematocrit; low levels often
                                         accompany chronic illness.
  ----------------------------------------------------------------------------------

🧠 **Interpretation:** Your boosted‑trees model identifies both
**clinical biomarkers** (lab values) and **administrative factors**
(admission type, insurance) as key drivers of readmission. This mix of
medical and socioeconomic predictors aligns well with real‑world
hospital analytics --- a strong validation of your model's relevance.

## **Next Step --- Write the Capstone Report Summary**

Now that you've completed model training, evaluation, comparison, and
interpretation, the next step is to **summarize your findings** for your
report.
