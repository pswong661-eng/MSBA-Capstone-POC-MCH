-- 12_create_splits
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- It produces **patient‑level** splits (no patient appears in multiple
-- sets). Adjust thresholds if you prefer admission‑level splits.

-- 12_create_splits

CREATE OR REPLACE TABLE `mimiciv-bq.readmission_data.12_train` AS

SELECT * FROM `mimiciv-bq.readmission_data.10_final_model_table`

WHERE ABS(MOD(FARM_FINGERPRINT(CAST(subject_id AS STRING)), 100)) \< 70;

CREATE OR REPLACE TABLE `mimiciv-bq.readmission_data.12_val` AS

SELECT * FROM `mimiciv-bq.readmission_data.10_final_model_table`

WHERE ABS(MOD(FARM_FINGERPRINT(CAST(subject_id AS STRING)), 100))
BETWEEN 70 AND 84;

CREATE OR REPLACE TABLE `mimiciv-bq.readmission_data.12_test` AS

SELECT * FROM `mimiciv-bq.readmission_data.10_final_model_table`

WHERE ABS(MOD(FARM_FINGERPRINT(CAST(subject_id AS STRING)), 100)) \>=
85;

**Why patient-level:** prevents leakage where the same patient's earlier
admission appears in train and later admission in test.

**Validation after split:** run counts per split and ensure label
distribution is similar across sets.

![](media/image9.png){width="6.5in" height="3.513888888888889in"}

![](media/image65.png){width="6.5in" height="3.513888888888889in"}

![](media/image63.png){width="6.5in" height="3.513888888888889in"}

![](media/image12.png){width="6.5in" height="3.513888888888889in"}

Everything looks structurally correct: each table has the expected
columns (subject_id, hadm_id, admittime, dischtime, admission_type,
insurance, etc.), consistent schema, and realistic timestamps. The row
counts (≈ 381 k train, 82 k val, 81 k test) align with the
70 / 15 / 15 split ratio we planned. You're now ready to move into the
**modeling phase**.

2\. Exploratory Data Analysis (queries and notebook outline)
