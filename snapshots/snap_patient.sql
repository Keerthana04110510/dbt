{% snapshot snap_patient %}

{{
    config(
        target_schema='snapshots',
        unique_key='unique_field',
        strategy='check',
        check_cols=['medical_condition']
    )
}}

select 
    unique_field,
    DATE_OF_ADMISSION,
    BLOOD_TYPE as blood_group,
    GENDER,
    MEDICAL_CONDITION

from {{ ref('int_health_care') }}

{% endsnapshot %}