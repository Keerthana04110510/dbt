{{
    config(
        materialized='incremental',
        unique_key='order_id',
        incremental_strategy='merge'
    )
}}

with source_data as (
    select o.id AS order_id,
           o.customer AS customer_id,
           c.name AS customer_name,
           o.order_total,
           count(distinct i.sku) AS product_count
           from {{ ref('stg_r_orders')}} o
           left join {{ ref('stg_r_customers')}} c
           on c.id=o.customer
           left join {{ ref('stg_r_items') }} i
           on o.id=i.order_id
           group by o.id,
                    o.customer,
                    c.name,
                    o.order_total
 )
, hashed_data as (
    select order_id,
           customer_id,
           customer_name,
           order_total,
           product_count,
           md5(concat(
            coalesce(customer_name,''),'|',
            coalesce(order_total,0),'|',
            coalesce(product_count,0)
           )) as hash_data
           from source_data
)

{% if is_incremental() %}
, final as (
    select s.order_id,
           s.customer_id,
           s.customer_name,
           s.order_total,
           s.product_count,
           s.hash_data,
           coalesce(t.created_at, current_timestamp()) as created_at,
           case
               when t.order_id is null
               then null
               when s.hash_data <> t.hash_data
               then current_timestamp()
               else t.updated_at
               end as updated_at
           from hashed_data s
           left join {{this}} t
           on s.order_id=t.order_id
)

{% else %}
, final as (
    select s.order_id,
           s.customer_id,
           s.customer_name,
           s.order_total,
           s.product_count,
           s.hash_data,
           current_timestamp() AS created_at,
           null AS updated_at
    from hashed_data s
)

{% endif %}

select * from final