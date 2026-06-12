{{
    config(
        materialized='incremental',
        on_schema_change='sync_all_columns',
        unique_key = ['order_id', 'order_sk']
    )
}}

select order_id,
       price,
       order_sk,
       final_price,
       status
       from {{ ref('int_orders') }}