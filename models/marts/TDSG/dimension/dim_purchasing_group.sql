{{ config(
    materialized = 'incremental',
    unique_key   = 'PurchasingGroupKey',
    incremental_strategy = 'merge'
) }}

WITH source AS (
    SELECT * FROM {{ ref('stg_prd_purchasing_group_master') }}
)

SELECT
    PurchasingGroupKey,
    GroupCode,
    GroupName,
    ActiveFlag,
    {{ audit_columns('SAP_ERP') }}
FROM source