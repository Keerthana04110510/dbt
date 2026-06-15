{{
    config(
        materialized='incremental',
        unique_key='patient_id',
        incremental_strategy='merge'
    )
}}


select
    patient_id,
    patient_name,
    gender,
    dob,
    city,
    insurance_type,
    updated_at

from {{ ref('stg_patients') }}

{% if is_incremental() %}

where updated_at >
(
    select max(updated_at)
    from {{ this }}
)

{% endif %}