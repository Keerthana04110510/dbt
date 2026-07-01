{{
    config(
        materialized='incremental',
        unique_key='PORID',
        incremental_strategy='merge'
    )
}}

WITH base AS (

    SELECT *
    FROM {{ ref('int_por_enricheds') }}

),

---------------------------------------------------
-- DATE DIMENSION
---------------------------------------------------

date_dim AS (

    SELECT
        DateKey,
        FullDate,
        IsHoliday,
        IsWeekend,
        IsWorkingDay
    FROM {{ ref('dim_date') }}

),

---------------------------------------------------
-- Holiday Count
---------------------------------------------------

holiday_count AS (

SELECT

    b.PORID,

    COUNT(d.FullDate) AS HolidayCount

FROM base b

LEFT JOIN date_dim d

ON d.FullDate BETWEEN CAST(b.PORDate AS DATE)
                  AND CAST(b.PODate AS DATE)

AND d.IsWorkingDay='N'

GROUP BY b.PORID

),

---------------------------------------------------
-- Final
---------------------------------------------------

final AS (

SELECT

----------------------------------------------------
-- Keys
----------------------------------------------------

    b.PORID,

    dd.DateKey,

----------------------------------------------------
-- Business Columns
----------------------------------------------------

    b.PORStatus,

    b.PORValue,

    b.DepartmentName,

    b.DivisionName,

    b.PurchasingGroup,

    b.RequestorEmployeeID,

    b.RequestorName,

    b.RingiNo,

    b.RingiStatus,

    b.PONumber,

    b.PODate,

    b.POValue                                 AS POValue_INR,

    b.Currency,

    b.VendorName,

    b.PurchaserID,

    b.PurchaserName,

    b.TargetDays,

----------------------------------------------------
-- TAT
----------------------------------------------------

    DATEDIFF(
        DAY,
        CAST(b.PORDate AS DATE),
        CAST(b.PODate AS DATE)
    ) AS TATDays,

----------------------------------------------------
-- Holiday Flag
----------------------------------------------------

    CASE

        WHEN COALESCE(h.HolidayCount,0)>0

        THEN 'Y'

        ELSE 'N'

    END AS HolidayFlag,

----------------------------------------------------
-- Holiday Count
----------------------------------------------------

    COALESCE(h.HolidayCount,0) AS HolidayCount,

----------------------------------------------------
-- Actual TAT
----------------------------------------------------

    DATEDIFF(
        DAY,
        CAST(b.PORDate AS DATE),
        CAST(b.PODate AS DATE)
    )
    -
    COALESCE(h.HolidayCount,0)

    AS ActualTATDays,

----------------------------------------------------
-- Savings
----------------------------------------------------

    COALESCE(b.PORValue,0)

    -

    COALESCE(b.POValue,0)

    AS SavingsAmount,

----------------------------------------------------
-- SLA
----------------------------------------------------

    CASE

        WHEN b.TargetDays IS NULL

        THEN NULL

        WHEN
            (
                DATEDIFF(
                    DAY,
                    CAST(b.PORDate AS DATE),
                    CAST(b.PODate AS DATE)
                )
                -
                COALESCE(h.HolidayCount,0)
            )

            <= b.TargetDays

        THEN 'Within SLA'

        ELSE 'Breach'

    END AS SLAStatus,

----------------------------------------------------
-- Audit
----------------------------------------------------

    {{ audit_columns('SAP_ERP') }}

FROM base b

LEFT JOIN holiday_count h

ON b.PORID=h.PORID

LEFT JOIN date_dim dd

ON CAST(b.PORDate AS DATE)=dd.FullDate

)

SELECT *

FROM final

{% if is_incremental() %}

WHERE NOT EXISTS (

SELECT 1

FROM {{ this }} t

WHERE t.PORID=final.PORID

)

{% endif %}