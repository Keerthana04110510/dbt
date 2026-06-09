{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='customer_id',
        merge_exclude_columns=[
            'created_at'
        ]
    )
}}
with source_data as (
 
    select
        '2' as customer_id,
        'DHIVYA' as customer_name,
        'POY' as city
),
final as (
    select
        customer_id,
        customer_name,
        city,
        current_timestamp() as created_at,
        case
            when {% if is_incremental() %} customer_id in (
                select customer_id
                from {{ this }}
            )
            {% else %}
                false
            {% endif %}
            then current_timestamp()
            else null
        end as updated_at,
        current_timestamp() as dbt_loaded_at
    from source_data
)

select *
from final