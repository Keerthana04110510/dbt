{{
    config(
        materialized='view'
    )
}}

with rank_order as (
      select c.id AS customer_id,
       o.id AS order_id,
       o.ordered_at,
       row_number() over(partition by c.id order by ordered_at asc) as rn
       from {{ ref('stg_r_customers')}} c
       left join {{ ref('stg_r_orders')}} o
       on c.id=o.customer
)
select customer_id,
       order_id,
       ordered_at
       from rank_order
       where rn=1