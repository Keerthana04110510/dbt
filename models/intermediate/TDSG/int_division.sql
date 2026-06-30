{{
    config(
        materialized='view'
    )
}}
SELECT
    d.divisionkey,
    d.spid,
    d.divisionshortcode,
    d.divisionname,
    d.divisionhead,
    d.deputydivisionhead,
    d.activeflag,
    d.createddate,
    dm.purchaseorganization,
    dm.description
FROM {{ ref('stg_division') }} d
LEFT JOIN {{ ref('stg_divisionmapping') }} dm
    ON d.divisionkey = dm.divisionkey