{{ config(materialized='view') }}
WITH por AS (
    SELECT *
    FROM {{ ref('stg_stg_pormaster') }}
    WHERE
        NOT UPPER(TRIM(PorNo)) LIKE 'T%'
        AND IsDeleted = 0
),
ringi_map AS (
    SELECT *
    FROM {{ ref('stg_ringipormaster') }}
    WHERE IsDeleted = 0
),
ringi AS (
    SELECT *
    FROM {{ ref('stg_stg_ringimaster') }}
),
department AS (
    SELECT *
    FROM {{ ref('dim_department1') }}
),
division AS (
    SELECT *
    FROM {{ ref('dim_division') }}
),
employee AS (
    SELECT *
    FROM {{ ref('dim_employee') }}
    WHERE IsCurrent='Y'
),
pgroup AS (
    SELECT *
    FROM {{ ref('stg_prd_purchasing_group_master') }}
),
po AS (
    SELECT *
    FROM {{ ref('stg_prd_pomaster') }}
),
base AS (
SELECT
    por.PORID,
    por.PorNo,
    por.DepartmentId,
    department.DepartmentName,
    department.DivisionKey,
    division.DivisionName,
    por.PurchasingGroupId,
    pgroup.GroupName AS PurchasingGroup,
    por.Ringi_CreatedBy,
    employee.EmployeeName AS RequestorName,
    por.BaseCurrency,
    por.TotalAmount_INR AS PORValue,
    por.Status AS PORStatus,
    por.CreatedDate,
    por.Ringi_SubmittedDate AS PORDate,
    por.PONo,
    por.PODate,
    por.Option1,
    por.Option2,
    por.ReviseNo,
    ringi_map.RingiID,
    ringi_map.FinalVendorId,
    ringi.RingiNo,
    ringi.Status AS RingiStatus,
    ringi.TotalAmount_INR AS RingiValue,
    po.VendorCode,
    po.VendorName,
    po.POValue AS POValue,
    po.AdditionalCharge
FROM por
LEFT JOIN department
ON por.DepartmentId = department.DepartmentKey
LEFT JOIN division
ON department.DivisionKey = division.DivisionKey
LEFT JOIN employee
ON por.Ringi_CreatedBy = employee.EmployeeKey
LEFT JOIN pgroup
ON por.PurchasingGroupId = pgroup.PurchasingGroupKey
LEFT JOIN ringi_map
ON por.PORID = ringi_map.PORID
LEFT JOIN ringi
ON ringi_map.RingiID = ringi.RingiKey
LEFT JOIN po
ON por.PONo = po.PONumber
),

purchaser_match AS (
SELECT
    base.*,
    ph.PurchaserID,
    ph.PurchaserName,
    ROW_NUMBER() OVER (
        PARTITION BY base.PORID
        ORDER BY ph.FromDate DESC
    ) rn
FROM base
LEFT JOIN {{ ref('stg_purchaserhandlingdivision_prd') }} ph
ON base.DivisionName = ph.Division
AND base.DepartmentName = ph.Department
AND CAST(base.PORDate AS DATE)
BETWEEN CAST(ph.FromDate AS DATE)
AND COALESCE(
    CAST(ph.ToDate AS DATE),
    DATE '9999-12-31'
)
)
SELECT
PORID,
PorNo,
DepartmentId,
DepartmentName,
DivisionKey,
DivisionName,
PurchasingGroupId,
PurchasingGroup,
Ringi_CreatedBy,
RequestorName,
BaseCurrency,
PORValue,
PORStatus,
CreatedDate,
PORDate,
PONo,
PODate,
Option1,

Option2,

ReviseNo,

RingiID,

FinalVendorId,

RingiNo,

RingiStatus,

RingiValue,

VendorCode,

VendorName,

POValue,

AdditionalCharge,

PurchaserID,

PurchaserName,

CASE

WHEN PODate IS NULL
OR PORDate IS NULL

THEN NULL

ELSE DATEDIFF(

DAY,

PORDate,

PODate

)

END AS TATDays,

CASE

WHEN PODate IS NULL
THEN 'No PO'

WHEN DATEDIFF(DAY,PORDate,PODate)<=3
THEN '0-3 Days'

WHEN DATEDIFF(DAY,PORDate,PODate)<=7
THEN '4-7 Days'

WHEN DATEDIFF(DAY,PORDate,PODate)<=15
THEN '8-15 Days'

ELSE '>15 Days'

END AS TATBucket,

CASE

WHEN PONo IS NULL

THEN 'N'

ELSE 'Y'

END AS IsConvertedToPO

FROM purchaser_match

WHERE rn=1