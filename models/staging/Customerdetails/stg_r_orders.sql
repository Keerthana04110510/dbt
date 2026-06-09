{{ config(
    materialized='table'
) 
}}

select * from 
{{ source('customers_stage', 'raw_orders')}}