-- 14_model_logistic_regression.sql
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

-- 14_model_logistic_regression.sql

CREATE OR REPLACE MODEL
`mimiciv-bq.readmission_data.logistic_regression_model`

OPTIONS(

model_type = 'logistic_reg',

input_label_cols = ['readmission_30d_flag']

) AS

SELECT

readmission_30d_flag,

length_of_stay_days,

COALESCE(sodium_mean, -999) AS sodium_mean_imputed,

COALESCE(creatinine_mean, -999) AS creatinine_mean_imputed,

COALESCE(hemoglobin_mean, -999) AS hemoglobin_mean_imputed,

COALESCE(hematocrit_mean, -999) AS hematocrit_mean_imputed,

COALESCE(platelet_count_mean, -999) AS platelet_count_mean_imputed,

COALESCE(wbc_mean, -999) AS wbc_mean_imputed,

admission_type,

insurance,

race

FROM `mimiciv-bq.readmission_data.12_train`;

![](media/image51.png){width="6.5in" height="3.763888888888889in"}

![](media/image69.png){width="6.5in"
height="3.763888888888889in"}![](media/image10.png){width="6.5in"
height="3.763888888888889in"}![](media/image23.png){width="6.5in"
height="3.763888888888889in"}

![](media/image42.png){width="6.5in"
height="3.763888888888889in"}![](media/image40.png){width="6.5in"
height="3.763888888888889in"}![](media/image25.png){width="6.5in"
height="3.763888888888889in"}

### **✅ Step 2 --- Evaluate the Logistic Regression Model**

After training completes, run this evaluation query:
