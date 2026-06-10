{% snapshot snap_customer_history  %}
    {{
        config(
            target_schema='snapshot',
            target_database='demo_db',
            unique_key='customer_id',
            strategy='check',
            check_cols=['city','status']
        )
    }}

    select * from 
    {{ ref('int_order_details') }}
 {% endsnapshot %}