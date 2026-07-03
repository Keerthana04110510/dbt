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
date_dim AS (
    SELECT
        DateKey,
        FullDate,
        IsHoliday,
        IsWeekend,
        IsWorkingDay
    FROM {{ ref('dim_date') }}
),
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

final AS (
SELECT
    b.PORID,
    dd.DateKey,
    b.PORStatus,
    b.PORValue,
    COALESCE(b.PORValue, 0.00) AS PORValue_INR,
    COALESCE(NULLIF(TRIM(b.RequestorEmployeeID), ''), 'NULL') AS RequestorEmployeeID,
    b.RingiNo,
    b.RingiStatus,
    COALESCE(NULLIF(TRIM(b.PONumber), ''), 'UNKNOWN') AS PONumber,
    COALESCE(b.PODate, TO_DATE('1900-01-01')) AS PODate,
    b.POValue                                 AS POValue_INR,
    COALESCE(NULLIF(TRIM(b.Currency), ''), 'UNKNOWN') AS Currency,
    COALESCE(b.PurchaserID, -1) AS PurchaserID,
    b.TargetDays,
    DATEDIFF(
        DAY,
        CAST(b.PORDate AS DATE),
        CAST(b.PODate AS DATE)
    ) AS TATDays,
    CASE
        WHEN COALESCE(h.HolidayCount,0)>0
        THEN 'Y'
        ELSE 'N'
    END AS HolidayFlag,
    COALESCE(h.HolidayCount,0) AS HolidayCount,

    DATEDIFF(
        DAY,
        CAST(b.PORDate AS DATE),
        CAST(b.PODate AS DATE)
    )
    -
    COALESCE(h.HolidayCount,0)
    AS ActualTATDays,
    COALESCE(b.PORValue,0)
    -
    COALESCE(b.POValue,0)
    AS SavingsAmount,
  CASE
    WHEN b.PORDate IS NULL
      OR b.PODate IS NULL
      OR b.TargetDays IS NULL
    THEN NULL
    WHEN (
        DATEDIFF(
            DAY,
            CAST(b.PORDate AS DATE),
            CAST(b.PODate AS DATE)
        ) - COALESCE(h.HolidayCount,0)
    ) <= b.TargetDays
    THEN 'Within SLA'
    ELSE 'Breach'
END AS SLAStatus,
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