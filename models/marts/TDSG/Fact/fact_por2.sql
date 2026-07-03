-- ═══════════════════════════════════════════════════════
-- MODEL : fact_por
-- LOAD TYPE: UPSERT (merge on PORID)
-- SOURCE: int_por_enriched + lookups to all dims
-- ═══════════════════════════════════════════════════════
{{ config(
    materialized = 'incremental',
    unique_key   = 'PORID',
    incremental_strategy = 'merge'
) }}

WITH por AS (
    SELECT * FROM {{ ref('int_por_enriched') }}
),

dept AS (
    SELECT DepartmentKey, DivisionKey FROM {{ ref('dim_department') }}
),

final AS (
    SELECT
        por.PORID,
        por.PorNo,
        por.DepartmentId           AS DepartmentKey,
        dept.DivisionKey,
        por.PurchasingGroupId      AS PurchasingGroupKey,
        por.RingiCreatedBy        AS EmployeeKey,
        {{ date_to_key('por.Ringi_SubmittedDate') }} AS DateKey,
        por.TotalAmount_INR        AS PORValue_INR,
        por.Status,
        por.Ringi_SubmittedDate    AS SubmittedDate,
        por.PONo                  AS PONumber,
        por.PODate,
        por.ReviseNo,
        por.Option1                AS Option1EmployeeKey,
        por.Option2                AS Option2EmployeeKey,
        por.RingiID,
        por.FinalVendorId,
        por.RingiNo,
        por.RingiStatus,
        por.RingiValue_INR,
        {{ audit_columns('SAP_ERP') }}
    FROM por
    LEFT JOIN dept
        ON por.DepartmentId = dept.DepartmentKey
)

SELECT * FROM final
