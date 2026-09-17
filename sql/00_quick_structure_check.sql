-- 00_quick_structure_check
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- Goal:
--
-- Check whether the main MIMIC-IV hospital tables are accessible and
-- return expected row counts.
--
-- Main Tables Used:
--
-- - physionet-data.mimiciv_3_1_hosp.patients
--
-- - physionet-data.mimiciv_3_1_hosp.admissions
--
-- - physionet-data.mimiciv_3_1_hosp.diagnoses_icd
--
-- Output:
--
-- - total_patients = 364627
--
-- - total_admissions = 546028
--
-- - total_diagnosis_rows = 6364488
--
-- Notes:
--
-- - Query ran successfully in BigQuery.
--
-- - This is the first validation step before cohort construction.
--
-- Status:
--
-- Completed
--
-- Last Updated:
--
-- 2026-07-28

#standardSQL

SELECT COUNT(*) AS total_patients

FROM `physionet-data.mimiciv_3_1_hosp.patients`;

SELECT COUNT(*) AS total_admissions

FROM `physionet-data.mimiciv_3_1_hosp.admissions`;

SELECT COUNT(*) AS total_diagnosis_rows

FROM `physionet-data.mimiciv_3_1_hosp.diagnoses_icd`;
