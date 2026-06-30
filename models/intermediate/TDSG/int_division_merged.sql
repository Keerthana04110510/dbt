{{ config(materialized='view') }}
WITH division AS (
    SELECT * FROM {{ ref('stg_division') }}
),
division_mapping AS (
    SELECT * FROM {{ ref('stg_divisionmapping') }}
),
merged AS (
    SELECT
        d.DivisionKey,
        d.DivisionShortCode,
        d.DivisionName,
        d.DivisionHead,
        d.ActiveFlag,
        dm.PurchaseOrganization        
    FROM division d
    LEFT JOIN division_mapping dm
        ON d.DivisionKey = dm.DivisionKey
)
SELECT * FROM merged