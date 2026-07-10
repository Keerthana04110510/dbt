{{ config(materialized='view') }}

WITH base AS (
    SELECT *
    FROM {{ ref('int_por_base') }}

),
ringi_rank AS (
    SELECT
        m.PORID,
        r.RingiNo,
        r.Status AS RingiStatus,
        ROW_NUMBER() OVER(
            PARTITION BY m.PORID
            ORDER BY r.SubmittedDate DESC NULLS LAST,
                     r.CreatedDate DESC NULLS LAST,
                     r.RingiKey DESC
        ) rn
    FROM {{ ref('stg_ringipormap') }} m
    INNER JOIN {{ ref('stg_stg_ringimaster') }} r
        ON m.RingiID = r.RingiKey
    WHERE m.IsDeleted = 0
),
latest_ringi AS (
    SELECT
        PORID,
        RingiNo,
        RingiStatus
    FROM ringi_rank
    WHERE rn = 1
),
purchaser_clean AS (
    SELECT *
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER(
                PARTITION BY
                    Division,
                    Department,
                    FromDate,
                    ToDate
                ORDER BY
                    CASE WHEN IsActive='Y' THEN 1 ELSE 2 END,
                    ModifiedDate DESC,
                    CreatedDate DESC,
                    PurchaserID DESC
            ) rn
        FROM {{ ref('stg_purchaserhandlingdivision_prd') }}
    )
    WHERE rn=1
),
purchaser_match AS (
SELECT
    b.*,
    p.PurchaserID,
    p.PurchaserName,
    ROW_NUMBER() OVER(
        PARTITION BY b.PORID
        ORDER BY
            p.FromDate DESC,
            p.ModifiedDate DESC,
            p.CreatedDate DESC,
            p.PurchaserID DESC
    ) rn
FROM base b
LEFT JOIN purchaser_clean p
ON b.DivisionName = p.Division
AND b.DepartmentName = p.Department
AND CAST(b.PODate AS DATE)
BETWEEN CAST(p.FromDate AS DATE)
AND CAST(p.ToDate AS DATE)
),
kpi AS (
SELECT
    KPIYear,
    KPIMonth,
    MAX(Target) AS TargetDays
FROM {{ ref('dim_kpi1') }}
WHERE KPI='POR - PO TAT'
AND IsActive='Y'
GROUP BY KPIYear, KPIMonth
)
SELECT
    pm.PORID,
    pm.PORNo,
    pm.PORDate,
    pm.PODate,
    pm.PORStatus,
    pm.PORValue,
    pm.DepartmentName,
    pm.DivisionName,
    pm.PurchasingGroup,
    pm.RequestorEmployeeID,
    pm.RequestorName,
    lr.RingiNo,
    lr.RingiStatus,
    pm.PONumber,
    pm.POValue,
    pm.Currency,
    pm.VendorName,
    pm.PurchaserID,
    pm.PurchaserName,
    kpi.TargetDays
FROM purchaser_match pm
LEFT JOIN latest_ringi lr
ON pm.PORID = lr.PORID
LEFT JOIN kpi
ON YEAR(pm.PODate)=kpi.KPIYear
AND MONTH(pm.PODate)=kpi.KPIMonth
WHERE pm.rn=1