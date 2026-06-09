{{ config
    (
        materialized='view'
    )}}

select o.id AS order_id,
       o.customer AS customer_id,
       i.id AS item_id
       from {{ ref('stg_r_orders')}} o
       left join {{ ref('stg_r_items')}} i
       on o.id=i.order_id