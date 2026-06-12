{{
    config(
        materialized='table'
    )
}}

select
    distinct order_id,
    customer_id,
    product_id,
    cast(order_date as DATE) as order_date,
    quantity,
    discount_pct,
    cast(last_updated_at as DATE) as last_updated_at
from {{ source ('store_stage', 'store_orders') }}
