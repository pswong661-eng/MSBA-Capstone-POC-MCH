-- 16_capstone_model_summary.sql
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- # Model Summary: Predicting 30-Day Readmission
--
-- ## Overview
--
-- Two models were trained using BigQuery ML --- Logistic Regression and
-- Boosted Trees --- on the MIMIC-IV readmission dataset.
--
-- ## Model Performance
--
-- - Logistic Regression achieved ROC AUC ≈ 0.60.
--
-- - Boosted Trees achieved ROC AUC ≈ 0.65, with higher precision and
-- F1 score.
--
-- → Boosted Trees selected as the final model.
--
-- ## Key Predictors
--
-- Top 10 features influencing readmission risk:
--
-- 1\. Admission Type
--
-- 2\. Length of Stay (Days)
--
-- 3\. Platelet Count Mean (Imputed)
--
-- 4\. Creatinine Mean (Imputed)
--
-- 5\. Race
--
-- 6\. Insurance
--
-- 7\. WBC Mean (Imputed)
--
-- 8\. Sodium Mean (Imputed)
--
-- 9\. Hematocrit Mean (Imputed)
--
-- 10\. Hemoglobin Mean (Imputed)
--
-- ## Insights
--
-- - Administrative factors (admission type, insurance) highlight systemic
-- influences.
--
-- - Clinical markers (creatinine, hematocrit, hemoglobin) reflect patient
-- health status.
--
-- - Boosted Trees provides a more nuanced understanding of readmission
-- risk.
--
-- ## Next Steps
--
-- - Validate model on unseen test data.
--
-- - Deploy for hospital readmission monitoring.
--
-- - Integrate with dashboards for real‑time prediction.
--
-- **Evaluating Whether Your Model Meets "Score 5" Criteria**

----------------------------------------------------------------------------
  **Rubric          **Your Current Work**                     **Evaluation**
  Dimension**
  ----------------- ----------------------------------------- ----------------
  **Strategic &     You framed a real healthcare problem      ✅ Excellent
  Analytical        (30‑day readmission) and aligned it with  alignment
  Insight**         hospital operational needs.

  **Technical       You trained two models                    ✅ Meets
  Soundness**       (Logistic Regression + Boosted Trees),    advanced method
                    compared metrics, and interpreted         requirement
                    results.

  **Demonstrated    You showed improved ROC AUC (+ 0.05) and  ✅ Demonstrated
  Value**           precision with Boosted Trees, plus        measurable
                    feature importance explaining business    improvement
                    impact.

  **Communication   Your summary and charts clearly explain   ✅ Clear and
  Clarity**         findings and next steps.                  persuasive

  **Ethical &       Not yet included --- you should add a     ⚠️ Needs
  Societal          short paragraph on data privacy,          addition
  Reflection**      fairness, and bias in healthcare ML.

  **Collaboration & If you're working solo, emphasize peer    ⚠️ Add
  Engagement**      feedback or reflection in your statement. reflection
                                                              evidence
  ----------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------
