-- 09_lab_features_03_date_summary
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

SELECT

COUNT(*) AS total_rows,

MIN(admittime) AS min_admittime,

MAX(admittime) AS max_admittime,

MIN(dischtime) AS min_dischtime,

MAX(dischtime) AS max_dischtime,

COUNTIF(admittime IS NULL) AS missing_admittime,

COUNTIF(dischtime IS NULL) AS missing_dischtime

FROM `mimiciv-bq.readmission_data.09_lab_features`;

![](media/image32.png){width="6.5in" height="3.513888888888889in"}

What the results mean

•  09_lab_features_01_duplicate_check  returning "There is no data to
display" is the correct outcome.

•  09_lab_features_02_null_check  shows zero missing values for
 subject_id ,  hadm_id ,  admittime ,  dischtime , and
 readmission_30d_flag , which is a good sign.

•  09_lab_features_03_date_summary  shows  546,028  rows and no missing
 admittime  or  dischtime , with dates that fit the MIMIC-IV timeline.

[One thing to note]{.underline}

Your null-check screenshot shows  missing_total_lab_measurements =
113,664 , which is not necessarily a problem. That usually means some
admissions do not have lab measurements captured in the feature table,
but you should confirm this is expected for your design before modeling.

[What those labs mean]{.underline}

Sodium, creatinine, hemoglobin, and WBC are clinical lab measurements,
not chemical substances you are modeling directly. They are common
blood-test indicators that help describe a patient's health status
around the time of admission.

• Sodium reflects electrolyte balance and hydration status.

• Creatinine reflects kidney function.

• Hemoglobin reflects blood oxygen-carrying capacity and can indicate
anemia.

• WBC means white blood cell count and is often used as a marker of
infection or inflammation.

[Why they matter for readmission]{.underline}

These lab values can be useful predictors because they capture how sick
the patient was during the admission. If a patient has abnormal sodium,
kidney problems, low hemoglobin, or signs of infection, that can be
associated with a higher chance of returning to the hospital.

So the point of checking them is not to study chemistry, but to see
whether your feature table has enough clinical information to support a
readmission model.
