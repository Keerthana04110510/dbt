{{ config(materialized='view',
         tags= ['fact_tables']) }}
WITH base AS (
SELECT *
FROM {{ ref('int_delivery_base') }}
),
purchaser AS (
SELECT
PurchaserID,
PurchaserName,
Division,
Department,
FromDate,
ToDate
FROM {{ ref('dim_purchaser1') }}
)
SELECT
base.*,
pur.PurchaserID
FROM base
LEFT JOIN purchaser pur
ON UPPER(TRIM(base.DivisionName))
=
UPPER(TRIM(pur.Division))
AND UPPER(TRIM(base.DepartmentName))
=
UPPER(TRIM(pur.Department))
AND base.GRNDate
BETWEEN
pur.FromDate
AND                                  
COALESCE(pur.ToDate,DATE '9999-12-31')