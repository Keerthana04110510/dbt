{% snapshot scd2_policies_snapshot %}
    {{
        config(
            target_schema='snapshots',
            target_database='demo_db',
            unique_key='policy_id',
            strategy='timestamp',
            updated_at='updated_at'
        )
    }}

    select * from {{ ref('stg_policies') }}
 {% endsnapshot %}