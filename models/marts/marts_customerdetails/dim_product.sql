{{
    config(
        materialized='incremental',
        unique_key='sku',
        incremental_strategy='merge'
    )
}}

with source_data as (
    select *
    from {{ ref('stg_r_products')}}
)
, hashed_data as (
    select p.*,
    md5(concat(
        coalesce(p.name,' '),'|',
        coalesce(p.type,' '),'|',
        coalesce(p.price,' '),'|',
        coalesce(p.description,' '),'|'
    )) AS record_hash
    from source_data p
)

{% if is_incremental() %}
,final as (
    select s.*,
    coalesce(t.created_at,current_timestamp()) AS created_at,
    case 
      when t.sku is null
      then null
      when s.record_hash <> t.record_hash
      then current_timestamp()
      else t.updated_at
      end as updated_at
    from hashed_data s
    left join {{this}} t
    on s.sku=t.sku
)

{% else %}
, final as(
    select s.*,
    current_timestamp() AS created_at,
    null AS updated_at,
    from hashed_data s
)

{% endif %}

select * from final