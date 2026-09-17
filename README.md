# Reducing 30-Day Hospital Readmissions with Predictive Analytics

**MSBA Capstone — Proof of Concept**
Zoyi Chung Yi Man · Bernadette Tong · Eric Wong Poh Sang

A predictive-analytics proof of concept that estimates each patient's likelihood
of an unplanned 30-day readmission at the point of discharge, built end to end on
the MIMIC-IV v3.1 clinical database in Google BigQuery.

It is designed to augment, not replace, clinical judgement. The model was
evaluated retrospectively on de-identified research data and has **not** been
clinically validated or deployed in patient care.

---

## Headline result

Model: `mimiciv-bq.readmission_data.boosted_trees_model` — BigQuery ML boosted
trees, 100 iterations, subsample 0.8, ten features.

Cohort: 546,028 admissions, 110,218 positive labels (20.19%). Patient-level
splits: 381,888 train · 82,515 validation · 81,625 held-out test, with zero
`subject_id` overlap across all partition pairs.

| Metric (held-out test set, n = 81,625) | Value |
|---|---|
| ROC-AUC | **0.6407** |
| Log loss | 0.4856 |
| Accuracy at default threshold 0.50 | 79.86% |
| Precision at 0.50 | 64.07% |
| Recall at 0.50 | 0.65% |

At the **capacity-oriented scenario threshold of 0.30**:

| Metric | Value |
|---|---|
| Flagged admissions | 8,658 (10.61% flag rate) |
| True positives | 3,303 |
| False positives | 5,355 |
| Precision / PPV | **38.15%** |
| Recall | **20.04%** |
| F1-score | 0.2627 |
| Accuracy | 77.29% |

Observed readmission rate by tier: **High 38.15% · Medium 19.04% · Low 7.67%**

Threshold 0.30 is a retrospective capacity-oriented scenario, **not** a
clinically validated production threshold. A local operating threshold would
require validation, calibration, workload review, fairness assessment and
clinical-governance approval.

---

## Repository structure

```
.
├── README.md
├── sql/          Reproducible BigQuery pipeline (47 scripts, 00 → 16)
├── dashboard/    Four-panel dashboard prototype (self-contained HTML)
├── figures/      Cohort and dashboard figures used in the report
└── docs/         Data dictionary, ethics notes, cohort attrition
```

### `sql/` — the reported pipeline

Authored by **Zoyi Chung Yi Man**. Run in numeric order; each file retains its
original goal, notes and status as header comments.

| Range | Purpose |
|---|---|
| `00*` | Access and readiness checks on the MIMIC source tables |
| `01`–`02` | Base admissions and the 30-day readmission label |
| `03` | Diagnosis-count features |
| `04`–`08` | Duplicate, row-count and summary validation |
| `09*` | Lab feature construction, null/coverage checks, cleaned table |
| `10` | Assembled feature table (`10_final_model_table`) |
| `11*` | Eight validation queries including a leakage check |
| `12` | Deterministic patient-level train / validation / test splits |
| `13*` | Exploratory analysis — target, subgroups, distributions, correlations |
| `14*` | Logistic-regression baseline, evaluation, thresholds, PR curve |
| `15*` | Boosted trees, thresholds, feature importance, model comparison |
| `16` | Model summary |

See [`sql/README.md`](sql/README.md) for the full script-by-script execution order.

---

## Reproducing the pipeline

**Prerequisites**

- A Google Cloud project with BigQuery enabled, used as the billing project
- An **individually approved** PhysioNet credentialed account with Google Cloud
  access to `physionet-data`. This is a separate approval from file-download
  credentialing; uncredentialed users receive an access-denied error at stage `00`
- Completion of the CITI "Data or Specimens Only Research" training

**Steps**

1. Run the scripts in `sql/` in numeric order.
2. Open `dashboard/readmission_dashboard_appendixE.html` in any browser. It is
   self-contained; no server or install required.

Project identifiers are hard-coded (`mimiciv-bq` for the extracted source
tables). Replace with your own project ID.

---

## Dashboard

`dashboard/readmission_dashboard_appendixE.html` implements the four panels
described in Appendix E of the written report:

1. **Risk-Stratification Overview** — discharge queue sorted by risk, tier flags
   at the 0.30 operational threshold, sortable columns, filters
2. **Patient-Level Detail** — probability, tier, an automated plain-English
   summary, ranked Shapley contributors (red = risk increasing, blue = risk
   reducing), clinical summary, case-management checklist
3. **SHAP Explanation** — global feature importance, top-10 per-patient
   contributions with clinical tooltips, and the 22.8% population baseline
4. **Dashboard Notes** — scope, limitations and implementation options

All records shown are **de-identified MIMIC-IV v3.1 research records**. **Not live
MCH patient data.** No PHI is displayed. The prototype carries a visible
"proof of concept — not for clinical use" label.

**The 39 sample admissions in the risk queue use synthetic identifiers and lightly
perturbed clinical values.** They do not correspond to any real MIMIC-IV admission.
This is deliberate: the PhysioNet Data Use Agreement restricts public redistribution
of patient-level data even when de-identified, and this repository is public. Every
*aggregate* statistic shown throughout the dashboard — AUC-ROC, tier distribution,
feature importance, calibration — is measured directly from the real 81,625-admission
held-out test set; only the individual illustrative records are fabricated.

Threshold 0.30 is a retrospective, capacity-oriented scenario, not a clinically
validated production threshold. The Medium/Low boundary at 0.15 is a dashboard
display and triage convention only and was not formally evaluated in the report.

Three distinct baselines appear and should not be conflated: the SHAP explanation
baseline (24.65%), the mean predicted risk across the test cohort (22.81%), and
the observed test-set prevalence (20.19%).

### Automated summary generator

Panel 2 renders a plain-English narrative built by
[`dashboard/narrative_generator.js`](dashboard/narrative_generator.js). It is
**deterministic and rule-based**: it reads the admission's Shapley attributions
and recorded values, describes them using conventional adult reference ranges,
and emits a headline, the leading contributors, any offsetting factors and
suggested actions keyed to the drivers present.

There is **no language model and no network call**. The same admission always
produces identical text, so it cannot hallucinate and needs no API key — which
also means nothing sensitive leaves the browser, consistent with the PhysioNet
data use agreement.

Two conditions raise an inline warning:

- **Governance note** — when `insurance` or `race` appears among the top
  contributors, stating these are non-clinical attributes retained for fairness
  auditing and must not drive care allocation
- **Low confidence** — when no labs are recorded, so all six lab features fall
  back to the −999 sentinel and the score rests on administrative fields

A conversational LLM assistant is deliberately **not** included. It would require
an API key that cannot be safely committed to a public repository, and would mean
transmitting records to a third party. It is proposed instead as later-phase
scale-up work, behind the hospital firewall with human review.

---

## Important caveats

- **Age and Charlson comorbidity index are absent** from the modelling table.
  Both require a join to `physionet-data.mimiciv_3_1_hosp.patients`. This blocks
  age-banded fairness monitoring.
- **Missing labs use a −999 sentinel** rather than being excluded. The model
  treats −999 as a value, so admissions with no labs are scored largely on
  administrative fields. The dashboard flags these as low-confidence.
- **Shapley sign convention.** This model's attributions are oriented toward the
  negative class: a raw *negative* attribution pushes a patient *toward*
  readmission. The dashboard inverts the displayed sign so red consistently means
  "increases risk". Magnitudes and rankings are unmodified.
- **Calibration and subgroup fairness metrics are not yet computed.** Both are
  listed as pending in §8.1 of the report and are required before any production
  recommendation.
- **Single-institution data.** MIMIC-IV reflects one academic medical centre with
  an ED/ICU-weighted population. Performance elsewhere may differ.
- **Same-hospital readmissions only.** Returns to other institutions are not
  observed, so the event rate is under-counted.
- **Source table expiry.** Tables in `mimiciv-bq.readmission_data` carry 60-day
  expiration timestamps. Verify they are still present, or remove the expiry,
  before relying on this repository for reproduction.

---

## Documentation

- [`docs/data_dictionary.md`](docs/data_dictionary.md)
- [`docs/ethical_and_societal_implications.md`](docs/ethical_and_societal_implications.md)
- [`docs/cohort_composition.csv`](docs/cohort_composition.csv) — partition sizes and label rates
- [`docs/split_overlap_verification.csv`](docs/split_overlap_verification.csv) — patient-overlap checks

---

## Data access and citation

MIMIC-IV v3.1 is available via PhysioNet under a credentialed Data Use Agreement.
The dataset is **not** redistributed here, and no patient-level data is committed.

> Johnson, A.E.W., Bulgarelli, L., Shen, L., et al. "MIMIC-IV, a freely
> accessible electronic health record dataset." *Scientific Data* 10, 1 (2023).
> https://doi.org/10.1038/s41597-022-01899-x

Additional references: Johnson et al. (2024), MIMIC-IV v3.1, PhysioNet;
Goldberger et al. (2000); Jencks et al. (2009); Lundberg & Lee (2017);
CMS Hospital Readmissions Reduction Program.

---

## AI assistance disclosure

Consistent with the MSBA Capstone Handbook, large language model assistance
(Claude, Anthropic) was used for prose drafting and editing, SQL and BigQuery ML
syntax support, plotting code, and document assembly. Analytical decisions,
cohort definitions, business-case assumptions and all conclusions are the
authors' own. Every figure reported here was produced by the queries in this
repository and verified against the source tables.
