-- 11_validate_08_subgroup_target
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- **Purpose** Quick check of target by key subgroups.

-- 11_validate_subgroup_target

SELECT

admission_type,

COUNT(*) AS n,

SUM(readmission_30d_flag) AS positives,

SAFE_DIVIDE(SUM(readmission_30d_flag), COUNT(*)) AS positive_rate

FROM `mimiciv-bq.readmission_data.10_final_model_table`

GROUP BY admission_type

ORDER BY positive_rate DESC

LIMIT 20;

![](media/image62.png){width="6.5in" height="3.513888888888889in"}

**Check** large variations in positive_rate across admission types or
insurance that may indicate confounding or subgroup risk.

### **Quick assessment of your validation results**

Your validation show the expected outcomes and are **good to proceed**:

-   **Row counts / uniqueness** --- total_rows = distinct_hadm_ids =
    > 546,028: one row per admission, as required.

-   **Target balance** --- readmission_30d_flag ≈ **20.19% positive**
    > (110,218 / 546,028): class imbalance is present and should guide
    > modeling choices.

-   **Duplicates** --- no duplicates returned by the duplicate check.

-   **Missingness** --- per‑feature null counts (e.g., sodium_nulls ≈
    > 151,471) and **avg_lab_coverage ≈ 0.734**; average lab_null_count
    > ≈ 2.66 (out of 10 lab features). This is moderate missingness and
    > acceptable if handled explicitly.

-   **Date ranges** --- admittime/dischtime are in the MIMIC shifted
    > timeline (expected). Confirm dischtime \>= admittime for all rows.

-   **Leakage check** --- rows_with_next_admit = 110,218 equals the
    > positive label count (expected). rows_with_days_to_next_admit =
    > 322,576 indicates many admissions have a later admission (not all
    > within 30 days). **Important:** next_admittime and
    > days_to_next_admit are label‑creation artifacts and must **not**
    > be used as model inputs.

Everything above is consistent and indicates your 10_final_model_table
is structurally sound. Proceed.

### **Next steps --- prioritized with effort and deliverables**

  ----------------------------------------------------------------------------
  Step                  Priority   Estimated     Deliverable (name)
                                   Effort
  --------------------- ---------- ------------- -----------------------------
  Create reproducible   High       Low           12_create_splits
  splits                                         (train/val/test tables)

  Exploratory Data      High       Medium        13_eda_* queries + notebook
  Analysis (EDA)                                 with plots

  Baseline modeling &   High       Medium        14_model_baseline (notebook /
  evaluation                                     BigQuery ML)

  Explainability &      High       Medium        15_explainability,
  fairness checks                                15_fairness_checks

  Cost analysis &       High       Low--Medium   16_cost_analysis
  business case                                  (spreadsheet + SQL)

  Iteration & scale     Medium     Medium        POC deployment plan section
  recommendations                                in report
  ----------------------------------------------------------------------------

1\. Create reproducible splits (SQL to run now)
