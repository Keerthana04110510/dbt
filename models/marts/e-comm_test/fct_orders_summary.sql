{{
    config(
        materialized='incremental',
        unique_key='order_id',
        on_schema_change='sync_all_columns'
    )
}}

select order_id,
       price,
       order_sk,
       final_price,
       status
       from {{ ref('int_orders') }}