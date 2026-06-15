{{
    config(
        materialized='incremental',
        unique_key='doctor_sk'
    )
}}

select *, {{ surrogate_key(['doctor_id']) }} AS doctor_sk,
       case when dbt_valid_to is null
            then 'Y'
             else 'N'
        end as current_flag
from {{ ref('snap_doctor') }}