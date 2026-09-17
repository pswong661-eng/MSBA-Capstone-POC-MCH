-- 11_validate_05_feature_null_counts
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- **Purpose** Per-feature null counts for all numeric predictors.

-- 11_validate_feature_null_counts

SELECT

SUM(CASE WHEN sodium_mean IS NULL THEN 1 ELSE 0 END) AS
sodium_mean_nulls,

SUM(CASE WHEN creatinine_mean IS NULL THEN 1 ELSE 0 END) AS
creatinine_mean_nulls,

SUM(CASE WHEN hemoglobin_mean IS NULL THEN 1 ELSE 0 END) AS
hemoglobin_mean_nulls,

SUM(CASE WHEN hematocrit_mean IS NULL THEN 1 ELSE 0 END) AS
hematocrit_mean_nulls,

SUM(CASE WHEN platelet_count_mean IS NULL THEN 1 ELSE 0 END) AS
platelet_count_mean_nulls,

SUM(CASE WHEN wbc_mean IS NULL THEN 1 ELSE 0 END) AS wbc_mean_nulls

FROM `mimiciv-bq.readmission_data.10_final_model_table`;

![](media/image36.png){width="6.5in" height="3.513888888888889in"}

**Check** absolute null counts and compute percent missing by dividing
by total rows.
