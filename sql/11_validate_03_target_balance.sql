-- 11_validate_03_target_balance
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- **Purpose** Confirm target distribution and class imbalance.

-- 11_validate_target_balance

SELECT

readmission_30d_flag AS label,

COUNT(*) AS n,

SAFE_DIVIDE(COUNT(*), SUM(COUNT(*)) OVER()) AS pct

FROM `mimiciv-bq.readmission_data.10_final_model_table`

GROUP BY readmission_30d_flag

ORDER BY label;

![](media/image57.png){width="6.5in" height="3.513888888888889in"}

**Check** positive rate \~20% as earlier; note imbalance for modeling
decisions.
