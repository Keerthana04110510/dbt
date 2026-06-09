{{
    config(
        materialized='incremental',
        unique_key='id',
        incremental_strategy='merge',
        merge_exclude_columns=['order_total','created_at']
    )
}}

with source_data as(
    select * from
    {{ ref('stg_r_orders')}}
)
, hashed_data as (
    select o.*,
          md5(concat(
              coalesce(o.subtotal,''), '|',
              coalesce(o.tax_paid,''), '|'
          )) as hash_data
    from source_data o
)
{% if is_incremental() %}
, final as (
    select s.*,
    coalesce(t.created_at, current_timestamp()) as created_at,
    case 
        when t.id is null
        then null
        when s.hash_data <> t.hash_data
        then current_timestamp()
        else t.updated_at
        end as updated_at
    from hashed_data s 
    left join {{ this }} t
    on s.id=t.id
)
{% else %}
, final as ( 
    select s.*,
    current_timestamp() as created_at,
    null as updated_at
    from hashed_data s
     )
{% endif %}
select * from final 