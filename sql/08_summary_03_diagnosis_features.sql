-- 08_summary_03_diagnosis_features
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- **(This query confirms the size of  03_diagnosis_features  and checks
-- whether each hospital admission appears only once. If  total_rows  and
--  distinct_hadm_id  match, then there are no duplicated admissions in
-- that feature table.[cloud.google])**

SELECT

COUNT(*) AS total_rows,

COUNT(DISTINCT hadm_id) AS distinct_hadm_id

FROM `mimiciv-bq.readmission_data.03_diagnosis_features`;

![](media/image52.png){width="6.5in" height="3.513888888888889in"}

What the results mean

Your summary checks look consistent:

•  02_readmission_label : 546,028 total rows, 110,218 positives,
positive rate about 0.2019.[Attachment]

•  03_diagnosis_features : 546,028 total rows, matching distinct
 hadm_id  count, so the feature table is still one row per
admission.[Attachment]

That means your core readmission cohort and diagnosis feature layer are
both stable and ready for the next feature-building step.
