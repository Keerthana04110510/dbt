{% snapshot snap_orders %}
    {{
        config(
            target_schema='snapshot',
            target_database='demo_db',
            unique_key='order_id',
            strategy='check',
            check_cols=['status']
        )
    }}

    select * 
     from {{ source('raw', 'raw_orders') }}
 {% endsnapshot %}