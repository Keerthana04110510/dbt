{{ config(materialized='view') }}

WITH por AS (
    SELECT *
    FROM {{ ref('stg_stg_pormaster') }}
    WHERE
        IsDeleted = 0
        AND UPPER(TRIM(PorNo)) NOT LIKE 'T%'
),
history AS (
    SELECT
        FormID,
        MIN(ActionTakenDateTime) AS PORDate
    FROM {{ ref('stg_stg_managehistorymaster') }}
    WHERE Status='ReadyforRingiApproval'
    GROUP BY FormID
),
department AS (
    SELECT
        DepartmentKey,
        DepartmentName,
        DivisionKey
    FROM {{ ref('dim_department1') }}
),
division AS (
    SELECT
        DivisionKey,
        DivisionName
    FROM {{ ref('dim_division') }}
),
purchase_group AS (
    SELECT
        PurchasingGroupKey,
        GroupName AS PurchasingGroup
    FROM {{ ref('stg_prd_purchasing_group_master') }}
),
employee_rank AS (
    SELECT
        EmployeeCode,
        EmployeeKey,
        EmployeeName,
        ROW_NUMBER() OVER (
            PARTITION BY EmployeeCode
            ORDER BY EffectiveFrom DESC
        ) AS rn
    FROM {{ ref('dim_employee') }}
    WHERE IsCurrent = 'Y'
),
employee AS (
    SELECT
        EmployeeCode,
        EmployeeKey,
        EmployeeName
    FROM employee_rank
    WHERE rn = 1
),
po_rank AS (
SELECT
*,
ROW_NUMBER() OVER(
PARTITION BY PORNumber
ORDER BY
PODate DESC,
PONumber DESC
) rn
FROM {{ ref('stg_prd_pomaster') }}
),
latest_po AS (
SELECT *
FROM po_rank
WHERE rn=1
)
SELECT
por.PORID,
por.PorNo,
por.Status AS PORStatus,
por.TotalAmount_INR AS PORValue,
por.BaseCurrency,
history.PORDate,
por.DepartmentId,
department.DepartmentName,
department.DivisionKey,
division.DivisionName,
por.PurchasingGroupId,
purchase_group.PurchasingGroup,
employee.EmployeeCode AS RequestorEmployeeID,
employee.EmployeeName AS RequestorName,
latest_po.PONumber,
latest_po.PODate,
latest_po.POValue,
latest_po.VendorName,
latest_po.VendorCode,
latest_po.Currency,
latest_po.PORRequester,
latest_po.AdditionalCharge
FROM por
LEFT JOIN history
ON por.PORID=history.FormID
LEFT JOIN department
ON por.DepartmentId=department.DepartmentKey
LEFT JOIN division
ON department.DivisionKey=division.DivisionKey
LEFT JOIN purchase_group
ON por.PurchasingGroupId=purchase_group.PurchasingGroupKey
LEFT JOIN latest_po
ON por.PorNo=latest_po.PORNumber
LEFT JOIN employee
ON latest_po.PORRequester=employee.EmployeeCode
WHERE history.PORDate IS NOT NULL