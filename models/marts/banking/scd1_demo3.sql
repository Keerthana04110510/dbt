{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='customer_id'
    )
}}
with source_data as (
    select
        '1' as customer_id,
        'divi' as customer_name,
        'tup' as city
)
{% if is_incremental() %}
, final as (
    select
        s.customer_id,
        s.customer_name,
        s.city,
        t.created_at,
        case
            when t.customer_id is null
                then null
            when
                s.customer_name <> t.customer_name
                or
                s.city <> t.city
                then current_timestamp()
            else t.updated_at
        end as updated_at
    from source_data s
    left join {{ this }} t
        on s.customer_id = t.customer_id
)
{% else %}
, final as (
    select
        customer_id,
        customer_name,
        city,
        current_timestamp() as created_at,
        null as updated_at
    from source_data
)
{% endif %}
select *
from final