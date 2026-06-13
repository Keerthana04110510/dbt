{{
    config(
        materialized='view',
        unique_key=['order_id', 'product_id']
    )
}}

select c.customer_id,
       c.customer_name,
       p.product_id,
       p.product_name,
       o.order_id,
       c.customer_email,
       c.customer_city,
       c.customer_state,
       c.signup_date,
       c.last_updated_at,
       p.product_category,
       p.price,
       c.dbt_loaded_at AS customer_updated_at,
       p.last_updated_at AS product_updated_at,
       o.last_updated_at AS order_updated_at,
       o.order_date,
       o.quantity,
       o.discount_pct,
       c.customer_status,
       p.product_status,
       {{ calculate_net_sales('p.price', 'o.quantity', 'o.discount_pct') }} AS net_sales
       from {{ ref('stg_store_customers')}} c
       left join {{ ref('stg_store_orders') }} o 
       on c.customer_id= o.customer_id
       left join {{ ref('stg_store_products')}} p 
       on o.product_id=p.product_id

