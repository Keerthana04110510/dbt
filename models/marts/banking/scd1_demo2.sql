{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='customer_id',
        merge_exclude_columns=['created_at']
    )
}}
with source_data as (
    select
       '1' as customer_id,
        'divi' as customer_name,
       'tiruppur' as city 
),
hashed_data as (
    select
        customer_id,
        customer_name,
        city,
        md5(
            concat(
                coalesce(customer_name, ''),
                '|',
                coalesce(city, '')
            )
        ) as record_hash
    from source_data
)
{% if is_incremental() %}
, final as (
    select
        s.customer_id,
        s.customer_name,
        s.city,
        s.record_hash,
        coalesce(t.created_at, current_timestamp()) as created_at,
        case
            when t.customer_id is null
                then null
            when s.record_hash <> t.record_hash
                then current_timestamp()
            else t.updated_at
        end as updated_at
    from hashed_data s
    left join {{ this }} t
        on s.customer_id = t.customer_id
)
{% else %}
, final as (
    select
        customer_id,
        customer_name,
        city,
        record_hash,
        current_timestamp() as created_at,
        null as updated_at
    from hashed_data
)
{% endif %}
select *
from final