{{
    config(
        materialized='table'
    )
}}

select doctor_id AS doctor_id,
       doctor_name AS doctor_name,
       department AS department, 
       specialization AS specialization,
       {{ doctor_salary('salary') }} AS salary,
       try_to_date(updated_at,'DD-MM-YYYY') as updated_at
 from {{ source('raw_hospital','hp_doctors')}}