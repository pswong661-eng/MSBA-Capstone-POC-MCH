-- 11_validate_06_date_ranges
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- **Purpose** Ensure admittime and dischtime ranges and no future leakage.

-- 11_validate_date_ranges

SELECT

MIN(admittime) AS min_admittime,

MAX(admittime) AS max_admittime,

MIN(dischtime) AS min_dischtime,

MAX(dischtime) AS max_dischtime

FROM `mimiciv-bq.readmission_data.10_final_model_table`;

![](media/image70.png){width="6.5in" height="3.513888888888889in"}

**Check** dates are within MIMIC shifted timeline and dischtime \>=
admittime for all rows.
