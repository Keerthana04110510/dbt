{{
    config(
        materialized='table'
    )
}}

SELECT
    departmentkey,
    divisionkey,
    departmentname,
    departmenthead,
    CASE
        WHEN departmentname = 'Supply Chain' THEN 'SC'
        WHEN departmentname = 'General Purchase' THEN 'GP'
        WHEN departmentname = 'Accounts Finance' THEN 'AF'
        WHEN departmentname = 'Manufacturing Planning' THEN 'MP'
        ELSE NULL
    END AS departmentcode,
    activeflag
FROM {{ ref('stg_department') }}