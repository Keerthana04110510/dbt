{{
    config(
        materialized='incremental',
        unique_key='patient_sk'
    )
}}

select *, {{ surrogate_key(['patient_id'])}} AS patient_sk,
       datediff(year, dob, current_timestamp()) AS patients_age,
       case when dbt_valid_to is null 
            then 'Y'
            else 'N'
    end as cuurent_flag
    from {{ ref('snap_patients')}}
