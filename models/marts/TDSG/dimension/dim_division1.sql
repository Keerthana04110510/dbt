{{ config(materialized='table') }}

WITH source AS (
    SELECT * FROM {{ ref('int_division_merged') }}
)

SELECT
    DivisionKey,
    DivisionShortCode,
    DivisionName,
    DivisionHead,
    PurchaseOrganization,
    ActiveFlag,
    {{ audit_columns('HR_SYSTEM') }}
FROM source