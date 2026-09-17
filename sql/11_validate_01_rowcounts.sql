-- 11_validate_01_rowcounts
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- **Purpose** Confirm table size and one row per admission.

-- 11_validate_rowcounts

SELECT

COUNT(*) AS total_rows,

COUNT(DISTINCT hadm_id) AS distinct_hadm_ids,

COUNT(DISTINCT subject_id) AS distinct_subject_ids

FROM `mimiciv-bq.readmission_data.10_final_model_table`;

![](media/image22.png){width="6.5in" height="3.513888888888889in"}

**Check** total_rows == distinct_hadm_ids and matches 546,028.
