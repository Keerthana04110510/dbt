{{ config(materialized='table') }}

WITH source AS (
    SELECT * FROM {{ ref('stg_kpiindicator') }}
)

SELECT
    Id,
    KPIYear,
    KPIMonth,
    KPI,
    Target,
    IsActive,
    {{ audit_columns('MANUAL_CONFIG') }}
FROM source