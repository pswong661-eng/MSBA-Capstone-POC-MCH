-- 09_lab_features_04_schema_safe_null_check
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- First, check the exact column names in your table schema. From there,
-- use only the columns that actually exist. A safe version might look like
-- this:

SELECT

COUNT(*) AS total_rows,

COUNTIF(sodium_mean IS NULL) AS missing_sodium_mean,

COUNTIF(potassium_whole_blood_mean IS NULL) AS
missing_potassium_whole_blood_mean,

COUNTIF(chloride_mean IS NULL) AS missing_chloride_mean,

COUNTIF(bicarbonate_mean IS NULL) AS missing_bicarbonate_mean,

COUNTIF(glucose_mean IS NULL) AS missing_glucose_mean,

COUNTIF(urea_nitrogen_mean IS NULL) AS missing_urea_nitrogen_mean,

COUNTIF(creatinine_mean IS NULL) AS missing_creatinine_mean,

COUNTIF(hemoglobin_mean IS NULL) AS missing_hemoglobin_mean,

COUNTIF(hematocrit_mean IS NULL) AS missing_hematocrit_mean,

COUNTIF(platelet_count_mean IS NULL) AS missing_platelet_count_mean,

COUNTIF(wbc_mean IS NULL) AS missing_wbc_mean

FROM `mimiciv-bq.readmission_data.09_lab_features`;

![](media/image50.png){width="6.5in"
height="3.513888888888889in"}![](media/image53.png){width="6.5in"
height="3.513888888888889in"}

[What the result means]{.underline}

Your table has  546,028  rows, which matches the size of your feature
table. The null counts show that several lab columns are missing for a
meaningful number of admissions, but that is normal in clinical data and
does not automatically mean something is wrong.

How to judge acceptability

[The check is acceptable if:]{.underline}

• The query ran without error.

• The columns match the schema.

• The null counts make sense clinically.

• You are comfortable keeping admissions with missing labs for modeling
or handling them later.

[What stands out]{.underline}

One important point:  potassium_whole_blood_mean  is missing for all
rows in your result, which suggests that feature may not be useful as
currently built or may need special handling. That does not stop you
from moving forward, but it is a strong signal that you should either
drop that column or rebuild that part of the feature set before the
final model table

*My recommendation for you*

I would drop  potassium_whole_blood_mean  if it is missing for all rows,
and review any other lab columns that are extremely sparse. Then keep
the clinically meaningful columns that have usable coverage, such as
sodium, creatinine, hemoglobin, hematocrit, platelet count, and WBC.

That gives you a better balance of realism and simplicity, which is
usually the safer choice for a capstone.

the quick coverage check shows a clear pattern, and it helps you decide
what to keep. Most of your main lab features have about 24% to 28%
missingness, which is moderate and usually acceptable for a capstone
model if you handle missing values later. The one column that stands out
is  potassium_whole_blood_mean , which is missing 100% of the time and
should be dropped.

How to read the coverage

[The coverage check shows:]{.underline}

•  potassium_whole_blood_mean  is completely missing, so it has no
modeling value.

•  sodium_mean ,  chloride_mean ,  bicarbonate_mean ,  glucose_mean ,
 urea_nitrogen_mean ,  creatinine_mean ,  hemoglobin_mean ,
 hematocrit_mean ,  platelet_count_mean , and  wbc_mean  all have usable
presence rates.

•  hematocrit_mean  [has the best coverage]{.underline} among the listed
columns, but the others are still within a range that is workable.

[Why this is feasible]{.underline}

This is the best balance between simplicity and information retention.
You avoid carrying a completely empty column, but you keep the
clinically useful lab features that may help the readmission model. For
a capstone, this is easier to justify than aggressively deleting
everything with moderate missingness.
