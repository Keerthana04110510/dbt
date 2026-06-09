{% snapshot snap_customer %}
    {{
        config(
            target_schema='snapshots',
            target_database='demo_db',
            unique_key='id',
            strategy='check',
            check_cols=['name'],
            cluster_by=['id']
        )
    }}

    select * from {{ ref('stg_r_customers') }}  
 {% endsnapshot %}