-- 01_base_admissions
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)

#standardSQL

SELECT

subject_id,

hadm_id,

admittime,

dischtime,

deathtime,

admission_type,

admission_location,

discharge_location,

marital_status,

race,

hospital_expire_flag

FROM `physionet-data.mimiciv_3_1_hosp.admissions`

ORDER BY subject_id, admittime;

*** Take note:*

About the 2180 dates

Yes, the year  2180  is normal in MIMIC-IV. The dataset uses date
shifting for privacy, so the calendar dates are intentionally moved into
a synthetic future timeline while preserving the timing relationships
between events.

That means  admittime = 2180-05-06  does not mean the hospital visit
literally happened in the year 2180. It means the patient's admission
happened at a shifted date that should be interpreted relative to other
dates in the same record, not as a real-world calendar year.
