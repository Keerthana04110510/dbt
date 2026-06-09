{{
    config(
        materialized='view'
    )
}}

with rank_order as (

       select 
       c.id AS customer_id,
       o.id AS order_id,
       o.ordered_at AS ordered_id,
       row_number() over(partition by c.id 
                        order by o.ordered_at desc ) AS latest_order
       from {{ ref('stg_r_customers') }} c
       left join {{ ref('stg_r_orders') }} o 
       on c.id=o.customer
)
select customer_id,
       order_id,
       ordered_id
       from rank_order
       where latest_order=1