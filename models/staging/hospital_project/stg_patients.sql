{{
    config(
        materialized='table'
    )
}}

select patient_id AS patient_id,
       patient_name AS patient_name,
       {{ Standardize_gender('gender') }} AS gender,
       to_timestamp(dob,'dd-mm-yyyy') AS dob,
       city AS city,
       {{ replace_null('insurance_type')}} AS insurance_type,
       to_timestamp(updated_at,'dd-mm-yyyy') AS updated_at
from {{ source('raw_hospital','hp_patients')}}