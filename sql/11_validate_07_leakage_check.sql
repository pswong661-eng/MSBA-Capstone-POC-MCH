-- 11_validate_07_leakage_check
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- **Purpose** Confirm no columns derived from future events are present as
-- predictors.

-- 11_validate_leakage_check

SELECT

COUNTIF(next_admittime IS NOT NULL AND DATE_DIFF(DATE(next_admittime),
DATE(dischtime), DAY) BETWEEN 0 AND 30) AS rows_with_next_admit,

COUNTIF(days_to_next_admit IS NOT NULL) AS rows_with_days_to_next_admit

FROM `mimiciv-bq.readmission_data.10_final_model_table`;

![](media/image48.png){width="6.5in" height="3.513888888888889in"}

**Check** these columns exist only for label creation and must **not**
be used as model inputs. Keep them for evaluation only.
