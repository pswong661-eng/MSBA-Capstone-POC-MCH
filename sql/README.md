# Stage 1 — Original BigQuery Pipeline

Authored by **Zoyi Chung Yi Man**. Extracted from the project SQL log and split
into individual files, preserving the original naming and execution order. Each
file retains its original goal, notes and status as header comments.

Run in numeric order. Scripts prefixed `00` will fail immediately if PhysioNet
BigQuery access to `physionet-data` has not been granted — that is a separate
approval from MIMIC file-download credentialing.

## Execution order

| # | Script | Purpose |
|---|---|---|
| 1 | `00_quick_structure_check.sql` | Confirm source tables accessible; expect 364,627 patients / 546,028 admissions / 6,364,488 diagnosis rows |
| 2 | `00A_patients_readiness_check.sql` | Inspect `patients` |
| 3 | `00B_admissions_readiness_check.sql` | Inspect `admissions` |
| 4 | `01_base_admissions.sql` | Base admissions extract |
| 5 | `02_readmission_label.sql` | 30-day readmission label via `LEAD()` |
| 6 | `02_readmission_label_v2.sql` | Revised label build |
| 7 | `03_diagnosis_features.sql` | Diagnosis-count features |
| 8 | `04_validation_readmission_features.sql` | Cross-table row-count and duplicate validation |
| 9 | `05_check_duplicates_02_readmission_label.sql` | Duplicate `hadm_id` check |
| 10 | `06_check_duplicates_03_diagnosis_features.sql` | Duplicate check |
| 11 | `07_summary_02_readmission_label.sql` | Label summary |
| 12 | `08_summary_03_diagnosis_features.sql` | Feature summary |
| 13 | `09_lab_features_part1.sql` | Lab feature scaffold |
| 14 | `09_lab_features_part2.sql` | Lab feature construction (main build) |
| 15 | `09_lab_features_01_duplicate_check.sql` | Duplicate check |
| 16 | `09_lab_features_02_null_check.sql` | Null check |
| 17 | `09_lab_features_03_date_summary.sql` | Date range summary |
| 18 | `09_lab_features_04_schema_safe_null_check.sql` | Schema-safe null audit |
| 19 | `09_lab_features_05_coverage_check.sql` | Lab coverage audit |
| 20 | `09_lab_features_06_create_cleaned_table.sql` | Cleaned lab table |
| 21 | `10_final_model_table.sql` | **Assembled feature table** — 546,028 rows, 49 columns |
| 22 | `11_validate_01_rowcounts.sql` | Row counts |
| 23 | `11_validate_02_duplicates.sql` | Duplicates |
| 24 | `11_validate_03_target_balance.sql` | Target balance |
| 25 | `11_validate_04_missingness_overview.sql` | Missingness overview |
| 26 | `11_validate_05_feature_null_counts.sql` | Per-feature nulls |
| 27 | `11_validate_06_date_ranges.sql` | Date ranges |
| 28 | `11_validate_07_leakage_check.sql` | Leakage check |
| 29 | `11_validate_08_subgroup_target.sql` | Target by subgroup |
| 30 | `12_create_splits.sql` | **Train / validation / test splits** — verified zero patient overlap |
| 31 | `13_eda_01_target_overview.sql` | Target overview |
| 32 | `13_eda_02_target_by_subgroup.sql` | Target by subgroup |
| 33 | `13_eda_03_feature_distributions.sql` | Numeric feature distributions |
| 34 | `13_eda_04_missingness_matrix.sql` | Missingness matrix |
| 35 | `13_eda_05_correlations.sql` | Feature correlations |
| 36 | `14_model_baseline_logreg.sql` | Logistic regression baseline |
| 37 | `14_model_baseline_logreg_evaluate.sql` | Evaluation |
| 38 | `14_model_baseline_logreg_thresholds.sql` | Threshold sweep |
| 39 | `14_model_baseline_logreg_pr_curve.sql` | Precision-recall curve |
| 40 | `14_model_logistic_regression.sql` | Logistic regression (revised) |
| 41 | `14_model_logistic_regression_evaluate.sql` | Evaluation |
| 42 | `15_model_boosted_trees.sql` | Boosted-tree model |
| 43 | `15_model_boosted_trees_thresholds.sql` | Threshold sweep |
| 44 | `15_model_boosted_trees_feature_importance.sql` | Feature importance |
| 45 | `15_model_boosted_trees_feature_importance_chart.sql` | Importance chart query |
| 46 | `15_model_comparison_logistic_vs_boosted.sql` | Model comparison |
| 47 | `16_capstone_model_summary.sql` | Summary |

All reported model results in the written report derive from this pipeline. The
authoritative verification queries are `11_validate_07_leakage_check.sql`,
`12_create_splits.sql`, and the `15*` boosted-tree evaluation scripts.
