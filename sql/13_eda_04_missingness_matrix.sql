-- 13_eda_04_missingness_matrix
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

-- per-feature missingness percentage

SELECT

'sodium_mean' AS feature, SAFE_DIVIDE(SUM(CASE WHEN sodium_mean IS
NULL THEN 1 ELSE 0 END), COUNT(*)) AS pct_missing FROM
`mimiciv-bq.readmission_data.10_final_model_table`

UNION ALL

SELECT 'creatinine_mean', SAFE_DIVIDE(SUM(CASE WHEN creatinine_mean IS
NULL THEN 1 ELSE 0 END), COUNT(*)) FROM
`mimiciv-bq.readmission_data.10_final_model_table`

-- add other features similarly

;

![](media/image26.png){width="6.5in" height="3.513888888888889in"}

[Visualize as heatmap or bar chart.]{.underline} [(ZC: not yet
done)]{.underline}
