{{
    config(
        materialized='view'
    )
}}
with rank_order as (
       select c.id AS customer_id,
       i.sku,
       count(c.id) AS purchase_count,
       p.name AS product_name,
       row_number() over(partition by c.id order by o.ordered_at desc) as rn
       from {{ ref('stg_r_customers')}} c
       left join {{ ref('stg_r_orders')}} o
       on c.id=o.customer
       left join {{ ref('stg_r_items')}} i
       on o.id=i.order_id
       left join {{ ref('stg_r_products')}} p
       on i.sku=p.sku
       group by c.id,
                i.sku,
                p.name,
                o.ordered_at
)
select customer_id,
       sku,
       purchase_count,
       product_name 
       from rank_order
       where rn=1
