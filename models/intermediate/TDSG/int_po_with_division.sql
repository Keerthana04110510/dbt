{{ config(materialized='view') }}

WITH po AS (
    SELECT * FROM {{ ref('stg_prd_pomaster') }}
),

division_mapping AS (
    SELECT * FROM {{ ref('stg_divisionmapping') }}
),

purchaser_handling AS (
    SELECT * FROM {{ ref('stg_purchaserhandlingdivision_prd') }}
),

with_division AS (
    SELECT
        po.*,
        dm.divisionkey
    FROM po
    LEFT JOIN division_mapping AS dm
        ON TRIM(po.division) = TRIM(dm.division)
),

with_purchaser AS (
    SELECT
        wd.*,
        ph.purchasername,
        ph.purchaserid
    FROM with_division AS wd
    LEFT JOIN purchaser_handling AS ph
        ON
            TRIM(wd.division) = TRIM(ph.division)
            AND wd.podate >= ph.fromdate
            AND (wd.podate <= ph.todate OR ph.todate IS NULL)
)

SELECT * FROM with_purchaser
