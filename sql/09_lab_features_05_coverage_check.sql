-- 09_lab_features_05_coverage_check
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

SELECT

'sodium_mean' AS column_name,

COUNT(*) AS total_rows,

COUNTIF(sodium_mean IS NULL) AS missing_count,

COUNTIF(sodium_mean IS NOT NULL) AS present_count,

SAFE_DIVIDE(COUNTIF(sodium_mean IS NOT NULL), COUNT(*)) AS
coverage_rate

FROM `mimiciv-bq.readmission_data.09_lab_features`

UNION ALL

SELECT

'potassium_whole_blood_mean' AS column_name,

COUNT(*) AS total_rows,

COUNTIF(potassium_whole_blood_mean IS NULL) AS missing_count,

COUNTIF(potassium_whole_blood_mean IS NOT NULL) AS present_count,

SAFE_DIVIDE(COUNTIF(potassium_whole_blood_mean IS NOT NULL), COUNT(*))
AS coverage_rate

FROM `mimiciv-bq.readmission_data.09_lab_features`

UNION ALL

SELECT

'chloride_mean' AS column_name,

COUNT(*) AS total_rows,

COUNTIF(chloride_mean IS NULL) AS missing_count,

COUNTIF(chloride_mean IS NOT NULL) AS present_count,

SAFE_DIVIDE(COUNTIF(chloride_mean IS NOT NULL), COUNT(*)) AS
coverage_rate

FROM `mimiciv-bq.readmission_data.09_lab_features`

UNION ALL

SELECT

'bicarbonate_mean' AS column_name,

COUNT(*) AS total_rows,

COUNTIF(bicarbonate_mean IS NULL) AS missing_count,

COUNTIF(bicarbonate_mean IS NOT NULL) AS present_count,

SAFE_DIVIDE(COUNTIF(bicarbonate_mean IS NOT NULL), COUNT(*)) AS
coverage_rate

FROM `mimiciv-bq.readmission_data.09_lab_features`

UNION ALL

SELECT

'glucose_mean' AS column_name,

COUNT(*) AS total_rows,

COUNTIF(glucose_mean IS NULL) AS missing_count,

COUNTIF(glucose_mean IS NOT NULL) AS present_count,

SAFE_DIVIDE(COUNTIF(glucose_mean IS NOT NULL), COUNT(*)) AS
coverage_rate

FROM `mimiciv-bq.readmission_data.09_lab_features`

UNION ALL

SELECT

'urea_nitrogen_mean' AS column_name,

COUNT(*) AS total_rows,

COUNTIF(urea_nitrogen_mean IS NULL) AS missing_count,

COUNTIF(urea_nitrogen_mean IS NOT NULL) AS present_count,

SAFE_DIVIDE(COUNTIF(urea_nitrogen_mean IS NOT NULL), COUNT(*)) AS
coverage_rate

FROM `mimiciv-bq.readmission_data.09_lab_features`

UNION ALL

SELECT

'creatinine_mean' AS column_name,

COUNT(*) AS total_rows,

COUNTIF(creatinine_mean IS NULL) AS missing_count,

COUNTIF(creatinine_mean IS NOT NULL) AS present_count,

SAFE_DIVIDE(COUNTIF(creatinine_mean IS NOT NULL), COUNT(*)) AS
coverage_rate

FROM `mimiciv-bq.readmission_data.09_lab_features`

UNION ALL

SELECT

'hemoglobin_mean' AS column_name,

COUNT(*) AS total_rows,

COUNTIF(hemoglobin_mean IS NULL) AS missing_count,

COUNTIF(hemoglobin_mean IS NOT NULL) AS present_count,

SAFE_DIVIDE(COUNTIF(hemoglobin_mean IS NOT NULL), COUNT(*)) AS
coverage_rate

FROM `mimiciv-bq.readmission_data.09_lab_features`

UNION ALL

SELECT

'hematocrit_mean' AS column_name,

COUNT(*) AS total_rows,

COUNTIF(hematocrit_mean IS NULL) AS missing_count,

COUNTIF(hematocrit_mean IS NOT NULL) AS present_count,

SAFE_DIVIDE(COUNTIF(hematocrit_mean IS NOT NULL), COUNT(*)) AS
coverage_rate

FROM `mimiciv-bq.readmission_data.09_lab_features`

UNION ALL

SELECT

'platelet_count_mean' AS column_name,

COUNT(*) AS total_rows,

COUNTIF(platelet_count_mean IS NULL) AS missing_count,

COUNTIF(platelet_count_mean IS NOT NULL) AS present_count,

SAFE_DIVIDE(COUNTIF(platelet_count_mean IS NOT NULL), COUNT(*)) AS
coverage_rate

FROM `mimiciv-bq.readmission_data.09_lab_features`

UNION ALL

SELECT

'wbc_mean' AS column_name,

COUNT(*) AS total_rows,

COUNTIF(wbc_mean IS NULL) AS missing_count,

COUNTIF(wbc_mean IS NOT NULL) AS present_count,

SAFE_DIVIDE(COUNTIF(wbc_mean IS NOT NULL), COUNT(*)) AS coverage_rate

FROM `mimiciv-bq.readmission_data.09_lab_features`

ORDER BY coverage_rate DESC;

![](media/image72.png){width="6.5in" height="3.513888888888889in"}

![](media/image56.png){width="6.5in" height="3.513888888888889in"}

Yes --- this is the right coverage check, and the result [looks good for
decision-making]{.underline}. Your table shows that most lab features
have usable coverage around 72% to 76%, while
 potassium_whole_blood_mean  has 0% coverage and should be dropped.

[What the result says]{.underline}

•  hematocrit_mean ,  platelet_count_mean ,  hemoglobin_mean , and
 wbc_mean  have the strongest coverage in this set.

•  creatinine_mean ,  urea_nitrogen_mean ,  sodium_mean ,
 chloride_mean ,  bicarbonate_mean , and  glucose_mean  also have
acceptable coverage for a capstone feature table.

•  potassium_whole_blood_mean  is completely missing, so it adds no
usable signal.

[Your evidence supports this simple rule:]{.underline}

• Keep the columns with about 70%+ coverage.

• Drop the column with 0% coverage.

• Revisit any borderline columns later only if the final model
performance suggests they are not helping.
