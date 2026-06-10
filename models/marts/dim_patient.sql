{{ config(materialized='table') }}

SELECT *,
    CASE 
        WHEN dbt_valid_to IS NULL THEN 'Y'
        ELSE 'N'
    END AS current_record_flag,
    dbt_valid_from AS created_date,
    dbt_valid_to AS updated_date
FROM {{ ref('snap_patient') }}