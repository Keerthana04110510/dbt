{% snapshot snap_doctor %}
    {{
        config(
            target_schema='snapshot',
            target_database='demo_db',
            unique_key='doctor_id',
            strategy='check',
            check_cols=['department','specialization', 'salary']
        )
    }}

    select * from {{ ref('stg_doctors') }}

 {% endsnapshot %}