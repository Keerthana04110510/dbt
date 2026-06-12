{% snapshot snap_customers %}
    {{
        config(
            target_schema='snapshot',
            target_database='demo_db',
            unique_key='customer_id',
            strategy='check',
            check_cols=['customer_status', 'customer_city', 'customer_state']
        )
    }}

    select * from {{ ref('int_sales_enriched') }}
 {% endsnapshot %}