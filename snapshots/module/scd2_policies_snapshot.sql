{% snapshot snapshot_name %}
    {{
        config(
            target_schema='snashots',
            target_database='demo_db',
            unique_key='policy_id',
            strategy='timestamp',
            updated_at='updated_at'
        )
    }}

    select * from {{ ref('stg_policies') }}
 {% endsnapshot %}