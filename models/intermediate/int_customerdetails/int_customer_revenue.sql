{{ config(
    materialized='view'
)}}

select c.id AS customer_id,
    count(o.id) AS total_orders,
    sum(o.subtotal) AS total_subtotal,
    sum(o.tax_paid) AS total_tax,
    sum(o.order_total) AS total_revenue
    from {{ ref('stg_r_customers')}} c
    left join {{ ref('stg_r_orders')}} o
    on c.id=o.customer
    group by c.id