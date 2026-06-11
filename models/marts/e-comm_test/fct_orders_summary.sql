{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

select order_id,
       price,
       final_price,
       order_sk,
       status
       from {{ ref('int_orders') }}