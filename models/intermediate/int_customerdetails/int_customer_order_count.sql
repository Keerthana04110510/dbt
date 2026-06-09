{{ config(materialized='view')}}

select distinct(c.id)AS customer_id,
       {{ convert_to_upper('c.name') }} AS customer_name,
       c.name,
       count(o.id) AS total_orders
       from {{ ref('stg_r_customers')}} c
       left join {{ ref('stg_r_orders')}} o
       on c.id=o.customer
       group by c.id, c.name, o.tax_paid