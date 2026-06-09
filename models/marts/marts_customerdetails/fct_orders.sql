{{
    config(
        materialized='incremental',
        unique_key='id',
        incremental_strategy='merge'
    )
}}

with source_data as (
    select * from 
    {{ ref('stg_r_orders')}}
)

, hashed_data as (
    select sr.*, 
    md5(concat(
        sr.subtotal,
        sr.tax_paid,
        sr.order_total
    )) as hash_data
    from source_data sr
)
{% if is_incremental() %}
, final as (
    select s.*,
    coalesce(t.created_at,current_timestamp()) AS created_at,
    case when t.id is null 
         then null
         when s.hash_data <> t.hash_data
         then current_timestamp()
         else t.updated_at 
         end as updated_at
    from hashed_data s
    left join {{this }} t 
    on s.id=t.id
)
{% else %}
, final as (
    select s.*,
    current_timestamp() AS created_at,
    null AS updated_at
    from hashed_data s
)
{% endif %}
select * from final