-- 09_lab_features(1)
-- MSBA Capstone | 30-Day Hospital Readmission Prediction (MIMIC-IV v3.1)
-- Author: Zoyi Chung Yi Man
-- Platform: Google BigQuery (standard SQL)
--
-- Step 1: inspect the most common lab itemids
--
-- Before creating the full table, it helps to see which lab tests are
-- common enough to keep. Save and run this as a small helper query if
-- needed:

SELECT

di.itemid,

di.label,

di.fluid,

di.category,

COUNT(*) AS n

FROM `physionet-data.mimiciv_3_1_hosp.labevents` le

JOIN `physionet-data.mimiciv_3_1_hosp.d_labitems` di

ON le.itemid = di.itemid

GROUP BY di.itemid, di.label, di.fluid, di.category

ORDER BY n DESC

LIMIT 30;

![](media/image43.png){width="6.5in" height="3.513888888888889in"}
