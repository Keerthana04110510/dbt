
{{ config(materialized='table') }}

SELECT
    c.customerid
FROM {{ ref('stg_customers') }} c
LEFT JOIN {{ ref('stg_policies') }} p
    ON c.customerid = p.customerid