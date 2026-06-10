{{
    config(
        materialized='incremental'
    )
}}

select {{ surrogate_key(['order_id']) }} AS order_sk,
       order_id,
       {{ surrogate_key(['customer_id']) }} AS customer_sk,
       product_id,
       order_amount,
       order_date
       from {{ ref('int_order_details') }}