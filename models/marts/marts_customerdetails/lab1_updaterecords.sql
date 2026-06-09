{{
    config(
        materialized='incremental',
        unique_key='customer_id',
        incremental_strategy='merge'
    )
}}

select * from 
{{ ref('int_customers_orders')}}



