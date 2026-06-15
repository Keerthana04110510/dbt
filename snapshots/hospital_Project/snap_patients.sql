{% snapshot snap_patients %}
    {{
        config(
            target_schema='snapshot',
            target_database='demo_db',
            unique_key='patient_id',
            strategy='timestamp',
            updated_at='updated_at'
        )
    }}

    select * from {{ ref('stg_patients')}}
 {% endsnapshot %}