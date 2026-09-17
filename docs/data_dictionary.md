# Data Dictionary

Fields in `10_final_model_table`, the admission-level table the reported model
trains and scores on. One row per `hadm_id`. All predictors are available at or
before the discharge-planning decision point.

## Identifiers

| Field | Type | Notes |
|---|---|---|
| `subject_id` | INT64 | Patient identifier. **Unit of split integrity** — all admissions for one patient stay in a single partition. Retained for validation, excluded from model predictors. |
| `hadm_id` | INT64 | Hospital admission identifier. Unique per row; verified by duplicate checks. Excluded from predictors. |

## Outcome

| Field | Type | Notes |
|---|---|---|
| `readmission_30d_flag` | INT64 | 1 if a subsequent admission for the same patient began 0–30 days after discharge from the index admission, identified with a `LEAD()` window function. 110,218 positives across 546,028 admissions (20.19%). |

This is a transparent research label, **not** the CMS HRRP measure. CMS applies
additional eligibility, exclusion, planned-readmission, mortality, hospice and
censoring rules. See §10.4 of the written report.

## Model predictors (ten features)

The following are the exact columns passed to BigQuery ML.

| Field | Type | Notes |
|---|---|---|
| `length_of_stay_days` | FLOAT64 | Days between admission and discharge. Mean 4.69, median 3. |
| `sodium_mean_imputed` | FLOAT64 | Mean sodium during the admission; missing → `-999`. |
| `creatinine_mean_imputed` | FLOAT64 | Mean creatinine; missing → `-999`. |
| `hemoglobin_mean_imputed` | FLOAT64 | Mean haemoglobin; missing → `-999`. Strongest Shapley driver. |
| `hematocrit_mean_imputed` | FLOAT64 | Mean haematocrit; missing → `-999`. |
| `platelet_count_mean_imputed` | FLOAT64 | Mean platelet count; missing → `-999`. |
| `wbc_mean_imputed` | FLOAT64 | Mean white cell count; missing → `-999`. |
| `admission_type` | STRING | Administrative category of the index admission. |
| `insurance` | STRING | Payer category. Partial proxy for post-acute access. |
| `race` | STRING | Retained for fairness auditing and monitored for disparate impact. |

## The −999 sentinel

Missing laboratory values are replaced with `-999` via deterministic `COALESCE`
expressions in the model-input query. The sentinel represents an **unmeasured**
result and is not a clinical measurement.

Missingness is informative and deliberately not imputed away — laboratory
testing is clinically selective. Coverage for retained features ranges from
71.71% to 76.08%. Potassium (whole blood) had zero coverage across all 546,028
admissions and was removed before model construction.

Consequence: an admission with no labs recorded has all six lab features set to
`-999`, so its score rests almost entirely on administrative fields. The
dashboard raises an explicit low-confidence warning for these cases.

## Scored output

| Field | Type | Notes |
|---|---|---|
| predicted probability | FLOAT64 | Positive-class probability from `ML.PREDICT`. Observed range across the test split: 0.078 to 0.584, mean 0.228 against a 20.19% event rate. |
| risk tier | STRING | Assigned in the dashboard: `High` ≥ 0.30 · `Medium` 0.15–0.30 · `Low` < 0.15. |

Calibration metrics have **not** been computed (§8.1 of the report lists them as
pending). Predicted probabilities should be treated as a ranking rather than as
validated absolute risks until calibration is assessed locally.

## Fields not available

| Field | Blocked by | Impact |
|---|---|---|
| `age` | Requires join to `physionet-data...patients` | No age-banded fairness; no Charlson index |
| `charlson_comorbidity_index` | Depends on `age` | Cannot benchmark against LACE |
| `service_line` | Requires join to `physionet-data...services` | Appendix E filter unavailable |
| `unit` | Requires live EHR feed | Appendix E filter unavailable |
