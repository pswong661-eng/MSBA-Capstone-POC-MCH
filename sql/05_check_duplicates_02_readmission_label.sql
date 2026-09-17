-- 05_check_duplicates_02_readmission_label
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- **To list any duplicate  hadm_id  values in  02_readmission_label **

SELECT

hadm_id,

COUNT(*) AS cnt

FROM `mimiciv-bq.readmission_data.02_readmission_label`

GROUP BY hadm_id

HAVING COUNT(*) \> 1

ORDER BY cnt DESC, hadm_id;

![](media/image38.png){width="5.979166666666667in"
height="2.9531255468066493in"}
