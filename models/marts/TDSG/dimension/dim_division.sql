{{
    config(
        materialized='table'
    )
}}

SELECT
    divisionkey,
    divisionshortcode,
    divisionname,
    divisionhead,
    purchaseorganization,
    activeflag

FROM {{ ref('int_division') }}