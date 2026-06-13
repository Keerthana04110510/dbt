{{
    config(
        materialized='view'
    )
}}

SELECT
    o.order_id,
    c.customer_id,
    c.customer_full_name,
    c.city,
    c.email,
    c.signup_date,
    c.status,
    i.product_name,
    i.category,
    i.price,
    i.product_id,
    o.quantity,
    o.order_date,
    ({{ calculate_order_amount('o.quantity','i.price') }}) AS order_amount
FROM {{ ref('stg_e_orders') }} 
LEFT JOIN {{ ref('stg_e_customers') }} c
    ON o.customer_id = c.customer_id
LEFT JOIN {{ ref('stg_e_products') }} i
    ON o.product_id = i.product_id
