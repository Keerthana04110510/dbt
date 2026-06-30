{{ config(materialized='table') }}

WITH source AS (
    SELECT * FROM {{ ref('stg_purchaserhandlingdivision_prd') }}
),

with_key AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key([
            'PurchaserID', 'Division', 'FromDate'
        ]) }}                       AS purchaser_sk,
        PurchaserName,
        PurchaserID,
        Division,
        Department,
        FromDate,
        ToDate,
        IsActive,
        CASE WHEN ToDate IS NULL THEN 'Y' ELSE 'N' END AS IsCurrent,
        {{ audit_columns('SAP_ERP') }}
    FROM source
)

SELECT * FROM with_key