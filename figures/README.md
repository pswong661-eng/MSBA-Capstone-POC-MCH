# Figures

## Dashboard prototype

Screenshots of the four-panel dashboard described in Appendix E of the written
report. Both are generated from `dashboard/readmission_dashboard_appendixE.html`
scoring the held-out test split with `boosted_trees_model`.

| File | Content |
|---|---|
| `appendixE_panel_high_risk.png` | High-risk admission selected — all four panels visible |
| `appendixE_panel_low_risk.png` | Low-risk admission — shows blue risk-reducing Shapley contributions |

The low-risk view is included deliberately: it is the only place the red/blue
sign convention can be seen working in both directions.

## Cohort figures

These describe the 546,028-admission cohort and are independent of which model is
fitted to it.

| File | Content |
|---|---|
| `fig1_outcome_distribution.png` | Class balance |
| `fig3_los_readmission_rate.png` | Readmission rate by length-of-stay band |
| `fig4_correlation_heatmap.png` | Pairwise feature correlation |
| `fig7_cohort_attrition.png` | Cohort attrition |

## Not included

Model-performance figures — ROC curve, risk-score histogram, Shapley importance
chart, operating-characteristic curve — are **not** committed here. Earlier
versions reported metrics from a superseded model and would contradict the
ROC-AUC of 0.6407 stated in the README and the report.

Regenerate them from the `15*` scripts in [`../sql/`](../sql/), which emit every
required input: threshold analysis, feature importance, and per-record
attributions via `ML.EXPLAIN_PREDICT`.
