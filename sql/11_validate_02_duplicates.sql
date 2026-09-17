-- 11_validate_02_duplicates
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- **Purpose** Find any duplicate hadm_id rows.

-- 11_validate_duplicates

SELECT hadm_id, COUNT(*) AS cnt

FROM `mimiciv-bq.readmission_data.10_final_model_table`

GROUP BY hadm_id

HAVING COUNT(*) \> 1

ORDER BY cnt DESC

LIMIT 50;

![](media/image18.png){width="6.5in" height="3.6302088801399823in"}

**Check** zero rows returned. If any, inspect why duplicates exist.
