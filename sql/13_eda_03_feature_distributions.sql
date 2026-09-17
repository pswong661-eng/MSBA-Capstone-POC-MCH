-- 13_eda_03_feature_distributions (example for numeric features)
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

-- summary stats for numeric features

SELECT

COUNT(*) AS n,

AVG(length_of_stay_days) AS mean_los,

STDDEV(length_of_stay_days) AS sd_los,

MIN(length_of_stay_days) AS min_los,

MAX(length_of_stay_days) AS max_los,

AVG(sodium_mean) AS mean_sodium,

STDDEV(sodium_mean) AS sd_sodium,

AVG(creatinine_mean) AS mean_creatinine

FROM `mimiciv-bq.readmission_data.10_final_model_table`;

![](media/image35.png){width="6.5in" height="3.513888888888889in"}

[Plot histograms/boxplots for length_of_stay_days, sodium_mean,
creatinine_mean, hemoglobin_mean. (ZC: not yet done)]{.underline}
